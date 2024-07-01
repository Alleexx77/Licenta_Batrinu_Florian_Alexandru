import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class BecomeSupplier extends LightningElement {
    @track organizationName = '';
    @track street = '';
    @track city = '';
    @track stateProvince = '';
    @track country = '';
    @track zipCode = '';
    @track vatRegNo = '';
    @track officeEmail = '';
    @track orgPhone = '';
    @track firstName = '';
    @track lastName = '';
    @track userEmail = '';
    @track userPhone = '';

    handleInputChange(event) {
        const field = event.target.dataset.id;
        this[field] = event.target.value;
    }

    handleNext() {
        const supplierData = {
            organizationName: this.organizationName,
            street: this.street,
            city: this.city,
            stateProvince: this.stateProvince,
            country: this.country,
            zipCode: this.zipCode,
            vatRegNo: this.vatRegNo,
            officeEmail: this.officeEmail,
            orgPhone: this.orgPhone,
            firstName: this.firstName,
            lastName: this.lastName,
            userEmail: this.userEmail,
            userPhone: this.userPhone
        };

        fetch('/services/apexrest/suppliers', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(supplierData)
        })
        .then(response => response.json())
        .then(data => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Supplier created successfully!',
                    variant: 'success'
                })
            );
        })
        .catch(error => {
            // Handle error
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error creating supplier',
                    message: error.message,
                    variant: 'error'
                })
            );
        });
    }
}
