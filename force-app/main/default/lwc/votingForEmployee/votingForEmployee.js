import { LightningElement, wire, track, api } from 'lwc';
import getAllUsers from '@salesforce/apex/UserController.getAllUsers';
import IsItAlreadyVotedForThisEmployee from '@salesforce/apex/VotingForEmployeeController.IsItAlreadyVotedForThisEmployee';
import createNewNominee from '@salesforce/apex/NomineeController.createNewNominee';
import userHasPermissionToVote from '@salesforce/customPermission/UserCanVote'
import uId from '@salesforce/user/Id';
import { refreshApex } from '@salesforce/apex';
import NAME_FIELD from '@salesforce/schema/Nominee__c.Name';
import VOTING_ID from '@salesforce/schema/Nominee__c.Voting_for_employee__c';
import USER_ID from '@salesforce/schema/Nominee__c.User__c';
import { dispatchToastMessage } from "c/utils"

export default class VotingForEmployee extends LightningElement {

    @api recordId;
    @track employeeOptionsArr = [];
    selectedEmployeeName;
    wiredAllEmployees;
    wiredALlNominees;
    isAlreadyVoted;
    wiredAlreadyVoted;
    showLwcElement;

    nomineeRecord = {
        Name: NAME_FIELD,
        Voting_for_employee__c: VOTING_ID,
        User__c: USER_ID
    };

    dispatchToastMessage = dispatchToastMessage.bind(this);

    get userCanVote() {
        return userHasPermissionToVote;
    }

    @wire(IsItAlreadyVotedForThisEmployee, { userId: uId, votingId: '$recordId' }) wiredIsItAlreadyVoted(value) {
        this.wiredAlreadyVoted = value
        const { data, error } = value;
        if (data !== undefined) {
            this.showLwcElement = true;
            this.isAlreadyVoted = data;
        } else if (error) {
            this.dispatchToastMessage(error.body.message, 'Error');
        }
    }

    @wire(getAllUsers) wiredGetAllUsers(value) {
        this.wiredAllEmployees = value;
        const { data, error } = value;
        if (data) {
            this.employeeOptionsArr = this.setOptionValues(data);
        } else if (error) {
            this.dispatchToastMessage(error.body.message, 'Error');
            this.employeeOptionsArr = undefined;
        }
    }

    handleEmployeePick(event) {
        this.selectedEmployeeName = this.getNameFromEvent(event);
    }

    handleSubmitClick() {
        if (!this.selectedEmployeeName) {
            this.dispatchToastMessage('You can vote without selection an option', 'Warning');
            return;
        }

        this.configNomineeRecord();
        this.createNomineeRecord();
    }

    setOptionValues(data) {
        let tempEmployeesArr = [];
        for (let i = 0; i < data.length; i++) {
            tempEmployeesArr.push({ label: data[i].Name, value: data[i].Id })
        }
        return tempEmployeesArr;
    }

    getNameFromEvent(event) {
        return event.target.options.find(opt => opt.value === event.detail.value).label;
    }

    configNomineeRecord() {
        this.nomineeRecord.Name = this.selectedEmployeeName;
        this.nomineeRecord.Voting_for_employee__c = this.recordId;
        this.nomineeRecord.User__c = uId;
    }

    createNomineeRecord() {
        createNewNominee({ nomineeObj: this.nomineeRecord }).then(() => {
            refreshApex(this.wiredAlreadyVoted);
            this.dispatchToastMessage('Nomination created successfully', 'Success');
        }).catch(error => {
            this.dispatchToastMessage(error.body.message, 'Error');
        });
    }

}