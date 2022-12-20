import { LightningElement, api, wire } from 'lwc';
import getQuestionById from '@salesforce/apex/QuestionController.getQuestionById';
import createNewResult from '@salesforce/apex/QuestionController.createNewResult';
import itIsAlreadyProvidedFeedback from '@salesforce/apex/QuestionController.itIsAlreadyProvidedFeedback';
import ANSWER from '@salesforce/schema/Result__c.Answer__c';
import QUESTION_Id from '@salesforce/schema/Result__c.Question__c';
import USER_Id from '@salesforce/schema/Result__c.User__c';
import userId from '@salesforce/user/Id';
import userHasPermissionToVote from '@salesforce/customPermission/UserCanVote'
import { refreshApex } from '@salesforce/apex';
import { dispatchToastMessage } from "c/utils"

export default class FeedbackGathering extends LightningElement {



    questionName;
    textAreaValue = '';
    @api recordId;
    isAlreadyVoted = false;
    showLwcElement = false;
    resultRecord = {
        Question__c: QUESTION_Id,
        Answer__c: ANSWER,
        User__c: USER_Id
    };

    dispatchToastMessage = dispatchToastMessage.bind(this);

    get userCanVote() {
        return userHasPermissionToVote;
    }

    connectedCallback() {
        getQuestionById({ questionId: this.recordId }).then(result => {
            this.questionName = result.Name;
        })
            .catch(error => {
                this.dispatchToastMessage(error, 'Error');
            });
    }

    handleSubmit() {
        this.assignRecordParameters()
        if (this.checkForEmptyInputTextArea()) {
            return;
        }
        this.addNewResultToVoting();
        this.resetTextAreaValue();
    }

    addNewResultToVoting() {
        createNewResult({ resultObj: this.resultRecord }).then(() => {
            refreshApex(this.wiredAlreadyVoted);
            this.dispatchToastMessage('Feedback successfully submitted!', 'Success');

        })
            .catch(error => {
                this.dispatchToastMessage(error, 'Error');
            });
    }

    assignRecordParameters() {
        this.textAreaValue = this.template.querySelector("lightning-textarea").value;
        this.resultRecord.Question__c = this.recordId;
        this.resultRecord.Answer__c = this.textAreaValue;
        this.resultRecord.User__c = userId;
    }

    resetTextAreaValue() {
        const inputFields = this.template.querySelectorAll('lightning-textarea');
        if (inputFields) {
            inputFields.forEach(field => {
                field.value = '';
            });
        }
        this.textAreaValue = '';
    }

    @wire(itIsAlreadyProvidedFeedback, { userId: userId, votingId: '$recordId' }) WiredItIsAlreadyProvidedFeedback(value) {
        this.wiredAlreadyVoted = value
        const { data, error } = value;
        if (data !== undefined) {
            this.showLwcElement = true;
            this.isAlreadyVoted = data;
        } else if (error) {
            this.dispatchToastMessage(error, 'Error');
        }

    }
    checkForEmptyInputTextArea() {
        if (this.textAreaValue === '' || this.textAreaValue === null) {
            this.dispatchToastMessage('Please provide feedback before submit', 'Warning');
            return true;
        }
        return false;
    }

}