import { LightningElement, api } from 'lwc';
import getAllVotingForIdeasByCampaignId from '@salesforce/apex/VotingForIdeaController.getAllVotingForIdeasByCampaignId';
import { dispatchToastMessage } from "c/utils"

export default class ResultVotingForIdeaList extends LightningElement {

    allVotingForIdeasArray
    @api recordId;
    dispatchToastMessage = dispatchToastMessage.bind(this);

    connectedCallback() {
        getAllVotingForIdeasByCampaignId({ cmpId: this.recordId })
            .then(result => {
                this.allVotingForIdeasArray = result;
            }).catch(error => {
                this.dispatchToastMessage(error, 'Error');
            });

    }
}