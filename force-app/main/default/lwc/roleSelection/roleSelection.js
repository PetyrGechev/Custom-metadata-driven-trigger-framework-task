import { LightningElement, wire } from 'lwc';
import getAllUsers from '@salesforce/apex/UserController.getAllUsers';
import getAllPermissionSets from '@salesforce/apex/PermissionSetsController.getAllPermissionSets';
import isAlreadyAssigned from '@salesforce/apex/PermissionSetsController.isAlreadyAssigned';
import createNewPermissionSetAssignment from '@salesforce/apex/PermissionSetsController.createNewPermissionSetAssignment';
import { publish, createMessageContext } from 'lightning/messageService';
import PARTICIPANTSMC from "@salesforce/messageChannel/Table_Updated__c";
import { dispatchToastMessage } from "c/utils"

export default class RoleSelection extends LightningElement {

    usersOptions = [];
    rolesOptions = [];
    selectedUserId;
    selectedPermissionSetId;
    selectedUser;
    context = createMessageContext();
    dispatchToastMessage = dispatchToastMessage.bind(this);

    @wire(getAllUsers) wiredGeAllUsers({ data, error }) {
        if (data) {
            this.usersOptions = this.setOptionValues(data);
        } else if (error) {
            this.dispatchToastMessage(error.body.message, 'Error');
            this.usersOptions = undefined;
        }
    }

    @wire(getAllPermissionSets) wiredGetAllPermissionSets({ data, error }) {
        if (data) {
            this.rolesOptions = this.setOptionValues(data);
        } else if (error) {
            this.dispatchToastMessage(error.body.message, 'Error');
            this.rolesOptions = undefined;
        }
    }

    handleAddButtonClick() {
        if (this.checkFields()) {
            return;
        }

        isAlreadyAssigned({ psaId: this.selectedPermissionSetId, userId: this.selectedUserId })
            .then((result) => {
                if (result) {
                    this.dispatchToastMessage('User is already assigned for this role', 'Warning');
                    return;
                }
                this.selectedUser=null;
                this.AssigneePermissionSet()
                this.resetFields();
            })
            .catch(error => {
                this.dispatchErrorToastWithErrorMessage(error);
            });
    }

    fireNewParticipantChangeEvent() {
        publish(this.context, PARTICIPANTSMC, {
            'newParticipant': true
        });
    }

    handleUserSelection(event) {
        this.selectedUserId = event.target.value;
    }

    handleRoleSelection(event) {
        this.selectedPermissionSetId = event.target.value;
    }

    setOptionValues(data) {
        let tempEmployeesArr = [];
        for (let i = 0; i < data.length; i++) {
            tempEmployeesArr.push({ label: data[i].Name, value: data[i].Id })
        }
        return tempEmployeesArr;
    }

    resetFields() {
        this.selectedUser = '';
        this.selectedPermissionSetId = null;
        this.selectedUserId=null;
    }

    checkFields() {
        if (this.selectedUserId === undefined || this.selectedPermissionSetId === undefined ||
            this.selectedUserId === null || this.selectedPermissionSetId === null) {
            this.dispatchToastMessage('Please select role and user!', 'Warning');
            return true;
        }
        return false;
    }

    AssigneePermissionSet() {
        createNewPermissionSetAssignment({ psaId: this.selectedPermissionSetId, userId: this.selectedUserId })
            .then(() => {
                this.fireNewParticipantChangeEvent();
                this.dispatchToastMessage('One more participant was created', 'Success');
            })
    }
}
