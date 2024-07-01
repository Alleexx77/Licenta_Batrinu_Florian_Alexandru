({
    fetchQualifications: function(component) {
        var action = component.get("c.getQualifications");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.qualifications", response.getReturnValue());
            } else {
                console.log('Error in fetching qualifications: ' + response.getError());
            }
        });
        $A.enqueueAction(action);
    },

    fetchAccountAndContact: function(component) {
        var action = component.get("c.getAccountAndContact");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.accountId", result.accountId);
                component.set("v.contactId", result.contactId);
            } else {
                console.log('Error in fetching account and contact: ' + response.getError());
            }
        });
        $A.enqueueAction(action);
    },

    createQualification: function(component, qualification) {
        var action = component.get("c.createQualification");
        action.setParams({
            qualification: qualification,
            accountId: component.get("v.accountId"),
            contactId: component.get("v.contactId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var qualificationId = response.getReturnValue().Id;
                alert('Qualification request submitted successfully.');
                // Redirecționare la pagina de detalii calificare
                var navService = component.find("navService");
                var pageReference = {
                    type: "standard__recordPage",
                    attributes: {
                        recordId: qualificationId,
                        objectApiName: "Qualification__c",
                        actionName: "view"
                    }
                };
                navService.navigate(pageReference);
            } else {
                console.log('Error in submitting qualification request: ' + response.getError());
            }
        });
        $A.enqueueAction(action);
    }
})
