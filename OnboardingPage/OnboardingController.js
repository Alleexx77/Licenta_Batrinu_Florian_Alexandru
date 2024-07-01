({
    doInit : function(component, event, helper) {
        var action = component.get("c.getActivityTypeOptions");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.activityTypes", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
    handleSubmit : function(component, event, helper) {
        var action = component.get("c.submit");
        action.setParams({
            office: component.get("v.office"),
            selectedActivityTypes: component.get("v.selectedActivityTypes")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Onboarding data submitted successfully.",
                    "type": "success"
                });
                toastEvent.fire();
            } else {
                var errors = response.getError();
                var message = 'Error submitting onboarding data';
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message += ': ' + errors[0].message;
                }
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error",
                    "message": message,
                    "type": "error"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    }
})
