import { LightningElement, wire } from 'lwc';
import getAllPermissionSetAssignmentsRelatedToVotingApp from '@salesforce/apex/PermissionSetsController.getAllPermissionSetAssignmentsRelatedToVotingApp';
import deletePermissionSetAssigmentById from '@salesforce/apex/PermissionSetsController.deletePermissionSetAssigmentById';
import { refreshApex } from '@salesforce/apex';
import { subscribe, createMessageContext, releaseMessageContext, APPLICATION_SCOPE } from 'lightning/messageService';
import PARTICIPANTSMC from "@salesforce/messageChannel/Table_Updated__c";
import { dispatchToastMessage } from "c/utils"


const COLUMNS = [
    { label: 'Campaign role', fieldName: 'PermissionSet' },
    { label: 'User', fieldName: 'Assignee' },
    {
        type: 'button', typeAttributes: {
            label: 'Remove',
            value: 'Remove',
            iconPosition: 'left'
        }
    }
];

export default class RolesDataTable extends LightningElement {

    data = [];
    columns = COLUMNS;
    wiredGetAllPermissionSetAssignmentsResponse;
    context = createMessageContext();
    dispatchToastMessage = dispatchToastMessage.bind(this);

    @wire(getAllPermissionSetAssignmentsRelatedToVotingApp) wiredGetAllPermissionSetAssignments(value) {
        this.wiredGetAllPermissionSetAssignmentsResponse = value;
        const { data, error } = value;
        if (data) {
            this.data = data.map(item => {
                let element = {
                    PermissionSet: item.PermissionSet.Name,
                    Assignee: item.Assignee.Name,
                    Id: item.Id
                };
                return element;
            }
            );
        }
        if (error) {
            this.dispatchToastMessage(error.body.message, 'Error');
        }
    }

    handleDeleteAction(event) {
        deletePermissionSetAssigmentById({ psaId: event.detail.row.Id }).then(() => {
            this.dispatchToastMessage('Successfully removed', 'Success');
            refreshApex(this.wiredGetAllPermissionSetAssignmentsResponse);
        }).catch(error => {
            this.dispatchToastMessage(error, 'Error');
        });
    }

    disconnectedCallback() {
        releaseMessageContext(this.context);
    }


    connectedCallback() {
        if (this.subscription) {
            return;
        }
        this.subscription = subscribe(
            this.context,
            PARTICIPANTSMC, (message) => {
                this.handleNewParticipantChange(message);
            },
            { scope: APPLICATION_SCOPE }
        );
    }

    handleNewParticipantChange(message) {
        console.log(message.newParticipant)
        let newUpdate = message.newParticipant;
        if (newUpdate) {
            refreshApex(this.wiredGetAllPermissionSetAssignmentsResponse);
        }
    }

}
