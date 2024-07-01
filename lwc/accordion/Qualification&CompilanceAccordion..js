import { LightningElement, track } from 'lwc';

export default class MenuAccordion extends LightningElement {
    @track activeSectionMessage = '';
    
    handleToggleSection(event) {
        this.activeSectionMessage = 'Open section name: ' + event.detail.openSections;
    }

    handleSetActiveSectionC() {
        const accordion = this.template.querySelector('.example-accordion');
        accordion.activeSectionName = 'C';
    }

    handleMenuSelect(event) {
        const selectedItemValue = event.detail.value;
        this.activeSectionMessage = 'Selected menu item: ' + selectedItemValue;

        const accordion = this.template.querySelector('.example-accordion');
        accordion.activeSectionName = selectedItemValue.charAt(0);
    }
}
