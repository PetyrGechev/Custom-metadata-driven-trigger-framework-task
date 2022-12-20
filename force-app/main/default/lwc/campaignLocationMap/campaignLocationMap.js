import { LightningElement, wire, api } from 'lwc';
import getCampaignLocationById from '@salesforce/apex/CampaignLocationController.getCampaignLocationById';
import { dispatchToastMessage } from "c/utils"

export default class CampaingLocationMap extends LightningElement {
    mapMarkers;
    zoomLevel;
    listView;
    @api recordId;

    @wire(getCampaignLocationById, { cmpId: '$recordId' }) wiredGetCampaignLocationById({ data, error }) {
        if (data) {
            this.mapMarkers = [
                {
                    location: {
                        City: data.City__c,
                        Country: data.Country__c,
                        PostalCode: data.Zip_Code__c,
                        Street: data.Street__c
                    },
                    title: data.Name
                }
            ];
            this.setLocationParameters();
        }
        if (error) {
            dispatchToastMessage(error.body.message, 'Error');
        }
    }
    setLocationParameters() {
        this.zoomLevel = 16;
        this.listView = "visible";
    }

}