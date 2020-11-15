({
	doInit : function(component, event, helper) {

            var action = component.get("c.executeJob");
            action.setParams({"JobId": component.get("v.recordId")});
            // Configure response handler
            action.setCallback(this, function(response) {
                var state = response.getState();
                debugger;
                if(component.isValid() && state === "SUCCESS") {
                    if(response.getReturnValue() == "Success"){
                        component.set("v.returnMsg", "SharinPix images sync has been initiated successfully."); 
                    }
                    else {
                        component.set("v.returnMsg", "There was an error while syncing. Pls retry again or contact your Administrator.");
                    }
                } 
            });

        
        $A.enqueueAction(action);
   	},

})