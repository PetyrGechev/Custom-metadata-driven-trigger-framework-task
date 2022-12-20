import { LightningElement, api } from 'lwc';
import getAllVotingForIdeasByCampaignId from '@salesforce/apex/VotingForIdeaController.getAllVotingForIdeasByCampaignId';
import { dispatchToastMessage } from "c/utils"

export default class ResultVotingForIdeaList extends LightningElement {

    allVotingForIdeasArray
    @api recordId;

    connectedCallback() {
        getAllVotingForIdeasByCampaignId({ cmpId: this.recordId })
            .then(result => {
                this.allVotingForIdeasArray = result;
            }).catch(error => {
                dispatchToastMessage(error, 'Error');
            });

    }
}