({
    // doInit : function(component, event, helper) 
    // {
	
    //     var recordId = component.get("v.recordId");
    //     var action = component.get("c.RefreshLargeLoss");
    //     action.setParams({recordId:recordId})
        
    //     action.setCallback(this, function(response){
    //     var state = response.getState(); 
    //     if (state === "SUCCESS") 
    //     {          
    //         let infoReturned = response.getReturnValue();
    //         if(infoReturned === 'success')
    //         {
    //             $A.get('e.force:refreshView').fire();
    //             $A.get("e.force:closeQuickAction").fire();
    //         }else{
    //             alert(infoReturned);
    //         }
    //     }
    // })
    // $A.enqueueAction(action);
    // }
    refreshView: function(component, event) {
        // refresh the view
        $A.get("e.force:refreshView").fire();
        $A.get("e.force:closeQuickAction").fire();
    },
    closeForm: function(component, event, helper) {
        
        $A.get("e.force:closeQuickAction").fire();
            },
})