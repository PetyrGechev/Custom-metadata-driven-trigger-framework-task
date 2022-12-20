import { LightningElement, api } from 'lwc';
import { dispatchToastMessage } from "c/utils"
import getAllResultsFromFeedbackGaderingsByCampaignId from '@salesforce/apex/FeedbackGaderingController.getAllResultsFromFeedbackGaderingsByCampaignId';

const COLUMNS = [
    { label: 'Feedback gathering', fieldName: 'Feedback_gathering_Name' },
    { label: 'Question', fieldName: 'Question_Name' },
    { label: 'User', fieldName: 'User_Name' },
    { label: 'Answer', fieldName: 'Answer' }

];

export default class ResultFeedbackGaderingList extends LightningElement {
    data = [];
    columns = COLUMNS;
    @api recordId;

    connectedCallback() {
        getAllResultsFromFeedbackGaderingsByCampaignId({ cmpId: this.recordId }).then(result => {
            this.data = result.map(item => {
                let element = {
                    Feedback_gathering_Name: item.Question__r.Feedback_gathering__r.Name,
                    User_Name: item.User__r.Name,
                    Question_Name: item.Question__r.Name,
                    Answer: item.Answer__c
                };
                return element;
            }
            );
        }).catch(error => {
            dispatchToastMessage(error, 'Error');
        });
    }

}

