({
    doInit: function(component, event, helper) {
        helper.fetchQualifications(component);
        helper.fetchAccountAndContact(component);
    },

    handleNext: function(component, event, helper) {
        var selectedQualification = component.get("v.selectedQualification");
        if (selectedQualification) {
            helper.createQualification(component, selectedQualification);
        } else {
            alert('Please select a qualification.');
        }
    }
})
