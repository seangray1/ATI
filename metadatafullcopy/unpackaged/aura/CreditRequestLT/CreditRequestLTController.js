({
	myAction : function(component, event, helper) {
        debugger;
	},
    refreshView: function(component, event) {
        // refresh the view
        $A.get("e.force:refreshView").fire();
        $A.get("e.force:closeQuickAction").fire();
    },
    closeForm: function(component, event, helper) {
        
        $A.get("e.force:closeQuickAction").fire();
            },

    // confirm : function(component, event) {
    //     debugger;
	// 	// var action = component.get("c.getsObject");
        
    //     // action.setParams({"ObjectId": component.get("v.recordId")});
      
    //     // action.setCallback(this, function(response){
    //     //     var state = response.getState();
            
    //     //     if(component.isValid() && state == "SUCCESS"){
                
    //     //         var elem = response.getReturnValue();
    //     //         var redirectURL = "/apex/SubmitForApproval?id=" + component.get("v.recordId");  //elem.Id
    //     //         redirectURL += "&lock=0";
                
    //     //         var urlEvent = $A.get("e.force:navigateToURL");
    //     //         urlEvent.setParams({
    //     //           "url": redirectURL
    //     //         });
    //     //         urlEvent.fire();
    //     //     } else {
    //     //         component.set("v.hasErrors", true);
                
    //     //     }
    //     // });
    //     // $A.enqueueAction(action);  
    //     var action = component.get("c.submitForApproval");
        
    //     action.setParams({"recordId": component.get("v.recordId")});
      
    //     action.setCallback(this, function(response){
    //         var state = response.getState();
            
    //         if(component.isValid() && state == "SUCCESS"){
                
    //             var elem = response.getReturnValue();
    //             if(elem === 'Success'){
    //                 $A.get('e.force:refreshView').fire();
    //                 $A.get("e.force:closeQuickAction").fire(); 
    //             }
    //             if(elem === 'User does not have Access'){
    //                 alert(elem);
    //             }
    //             if(elem !== 'Success' && elem !== 'User does not have Access'){
    //                 alert(elem);
    //             }
    //             // var redirectURL = "/apex/SubmitForApproval?id=" + component.get("v.recordId");  //elem.Id
    //             // redirectURL += "&lock=0";
                
    //             // var urlEvent = $A.get("e.force:navigateToURL");
    //             // urlEvent.setParams({
    //             //   "url": redirectURL
    //             // });
    //             // urlEvent.fire();
    //         } else {
    //             component.set("v.hasErrors", true);
                
    //         }
    //     });
    //     $A.enqueueAction(action);  
	// },

})