import { LightningElement, track, wire } from 'lwc';
import processCsvAndCreateContacts from '@salesforce/apex/ContactUploaderController.processCsvAndCreateContacts';
import getAccountOptions from '@salesforce/apex/ContactUploaderController.getAccountOptions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ContactUploader extends LightningElement {
    @track selectedAccountId;
    @track accountOptions = [];
    @track selectedFile;

    @wire(getAccountOptions)
    wiredAccountOptions({ data, error }) {
        if (data) {
            this.accountOptions = data;
        } else if (error) {
            // Handle error fetching account options
            console.error('Error fetching account options:', error);
        }
    }

    handleAccountChange(event) {
        this.selectedAccountId = event.detail.value;
    }

    handleFileChange(event) {
        // Handle file change logic
        const file = event.target.files[0];
        
        if (file) {
            // Check if the selected file has a CSV extension
            const allowedExtensions = ['csv'];
            const fileExtension = file.name.split('.').pop().toLowerCase();

            if (!allowedExtensions.includes(fileExtension)) {
                // Display an error message to the user
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: 'Please select a valid CSV file.',
                        variant: 'error',
                    })
                );

                // Clear the selected file
                this.selectedFile = null;
                return;
            }

            this.selectedFile = file;
        }
    }


    handleUpload() {
        if (!this.selectedAccountId || !this.selectedFile) {
            // Display an error message to the user
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Please select a target Account and a CSV file.',
                    variant: 'error',
                })
            );
            return;
        }
    
        // Check if the selected Account is "Onboarding Manager"
        const selectedAccount = this.accountOptions.find(option => option.value === this.selectedAccountId);
        if (!selectedAccount || selectedAccount.label !== 'Onboarding Manager') {
            // Display an error message to the user
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'This functionality is only available for the "Onboarding Manager" Account.',
                    variant: 'error',
                })
            );
            return;
        }
    
        const reader = new FileReader();
    
        reader.onloadend = () => {
            const csvContent = reader.result;
            
            // Call the Apex method to process the CSV and create contacts
            processCsvAndCreateContacts({ accountId: this.selectedAccountId, csvContent })
                .then(() => {
                    // Display a success message to the user
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Contacts created successfully.',
                            variant: 'success',
                        })
                    );
                })
                .catch(error => {
                    // Display an error message to the user
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error',
                            message: 'An error occurred while processing the CSV file.',
                            variant: 'error',
                        })
                    );
                    console.error('Error processing CSV:', error);
                });
        };
    
        // Read the contents of the selected CSV file
        reader.readAsText(this.selectedFile);
    }
    
}
