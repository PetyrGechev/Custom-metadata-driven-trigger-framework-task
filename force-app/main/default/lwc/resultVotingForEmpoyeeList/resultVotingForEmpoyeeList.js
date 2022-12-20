/* eslint-disable no-empty */
import { LightningElement, api } from 'lwc';
import getAllVotingForEmployeesByCampaignId from '@salesforce/apex/VotingForEmployeeController.getAllVotingForEmployeesByCampaignId';
import { dispatchToastMessage } from "c/utils"

export default class ResultVotingForEmployList extends LightningElement {
  @api recordId;

  votingResult;

  connectedCallback() {
    getAllVotingForEmployeesByCampaignId({ cmpId: this.recordId }).then(result => {
      this.votingResult = result;
      console.log(result);
    }).catch(error => {
      dispatchToastMessage(error, 'Error');
    });
  }

}