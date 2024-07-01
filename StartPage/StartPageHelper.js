({
    checkAuthentication : function(component) {
        var action = component.get("c.isAuthenticated");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.isAuthenticated", response.getReturnValue());
            } else {
                console.error("Failed with state:");
            }
        });
        $A.enqueueAction(action);
    }
})
