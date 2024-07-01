import { LightningElement, wire, track } from 'lwc';
import getOffers from '@salesforce/apex/OfferController.getOffers';
import { getRecord } from 'lightning/uiRecordApi';
import USER_ID from '@salesforce/user/Id';
import QUALIFICATIONS_FIELD from '@salesforce/schema/User.Qualifications__c';
import { NavigationMixin } from 'lightning/navigation';

const COLUMNS = [
    { label: 'Name', fieldName: 'Name' },
    { label: 'Type', fieldName: 'Type__c' },
    { label: 'Merchandise Group', fieldName: 'MerchandiseGroup__c' },
    { label: 'Status', fieldName: 'Status__c' },
    {
        type: 'button',
        typeAttributes: {
            label: 'View More',
            name: 'viewMore',
            variant: 'base'
        }
    }
];

export default class LwcRFP extends NavigationMixin(LightningElement) {
    @track offerList;
    @track error;
    columns = COLUMNS;
    selectedOffers = [];
    userQualifications;

    @wire(getRecord, { recordId: USER_ID, fields: [QUALIFICATIONS_FIELD] })
    wiredUser({ error, data }) {
        if (data) {
            this.userQualifications = data.fields.Qualifications__c.value;
            this.fetchOffers();
        } else if (error) {
            this.error = error;
            this.offerList = undefined;
        }
    }

    fetchOffers() {
        getOffers({ merchandiseGroups: new Set(this.userQualifications.split(';')) })
            .then(result => {
                this.offerList = result;
                this.error = undefined;
            })
            .catch(error => {
                this.error = error;
                this.offerList = undefined;
            });
    }

    handleRowSelection(event) {
        const selectedRows = event.detail.selectedRows;
        this.selectedOffers = selectedRows.map(row => row.Id);
    }

    handleRespondToRFP() {
        if (this.selectedOffers.length > 0) {
            // Logică pentru a iniția procesul de propunere de ofertă
            alert('Process initiated for selected RFPs: ' + this.selectedOffers.join(', '));
        } else {
            alert('Please select at least one RFP to respond.');
        }
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        switch (actionName) {
            case 'viewMore':
                this.navigateToRFPDetail(row.Id);
                break;
            default:
        }
    }

    navigateToRFPDetail(rfpId) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: rfpId,
                objectApiName: 'RFP__c',
                actionName: 'view'
            }
        });
    }
}
