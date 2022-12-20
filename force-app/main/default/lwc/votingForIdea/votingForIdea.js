import { LightningElement, api, wire } from 'lwc';
import getVotingForIdeaById from '@salesforce/apex/VotingForIdeaController.getVotingForIdeaById';
import createNewVote from '@salesforce/apex/VoteController.createNewVote';
import IsItAlreadyVotedForThisIdea from '@salesforce/apex/VoteController.IsItAlreadyVotedForThisIdea';
import { refreshApex } from '@salesforce/apex';
import userHasPermissionToVote from '@salesforce/customPermission/UserCanVote'
import ANSWER_FIELD from '@salesforce/schema/Vote__c.Answers__c';
import USER_ID from '@salesforce/schema/Vote__c.User__c';
import VOTING_FOR_IDEA_ID from '@salesforce/schema/Vote__c.Voting_for_idea__c';
import uId from '@salesforce/user/Id';
import { dispatchToastMessage } from "c/utils"


export default class VotingForIdea extends LightningElement {

    @api recordId;
    idea;
    isAlreadyVoted;
    radioButtonValue = '';
    dispatchToastMessage = dispatchToastMessage.bind(this);
    showLwcElement;

    get options() {
        return [
            { label: 'Agree', value: 'Agree' },
            { label: 'Disagree', value: 'Disagree' },
        ];
    }

    get userCanVote() {
        return userHasPermissionToVote;
    }

    voteRecord = {
        Answers__c: ANSWER_FIELD,
        User__c: USER_ID,
        Voting_for_idea__c: VOTING_FOR_IDEA_ID
    };

    connectedCallback() {
        getVotingForIdeaById({ campId: this.recordId }).then(result => {
            this.idea = result;
        }).catch(error => {
            this.dispatchToastMessage(error, 'Error');
        });

    }

    @wire(IsItAlreadyVotedForThisIdea, { userId: uId, votingId: '$recordId' }) wiredIsItAlreadyVoted(value) {
        this.wiredAlreadyVoted = value
        const { data, error } = value;
        if (data !== undefined) {
            this.showLwcElement = true;
            this.isAlreadyVoted = data;
        } else if (error) {
            this.dispatchToastMessage(error.body.message, 'Error');
        }
    }

    handleClick() {
        if (!this.radioButtonValue) {
            this.dispatchToastMessage('You can vote without selection an option', 'Warning');
            return;
        }
        this.configVoteRecord();
        this.createNewVoteRecord();
    }

    handleRadioBtnChange(event) {
        this.radioButtonValue = event.currentTarget.value
    }

    configVoteRecord() {
        this.voteRecord.User__c = uId;
        this.voteRecord.Answers__c = this.radioButtonValue;
        this.voteRecord.Voting_for_idea__c = this.recordId;
    }

    createNewVoteRecord() {
        createNewVote({ voteObj: this.voteRecord }).then(() => {
            this.dispatchToastMessage('Successfully voted for this idea', 'Success');
            refreshApex(this.wiredAlreadyVoted);
        }).catch(error => {
            this.dispatchToastMessage(error.body.message, 'Error');
        });

    }

}