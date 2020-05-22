({
	doInit : function(component, event, helper) {
	
    //     var urlEvent = $A.get("e.force:navigateToURL");
    // urlEvent.setParams({
    //     "url":"/apex/NewJobBeta"
    // });
    // urlEvent.fire();
    // }
        var Profile;
        var action = component.get("c.GetUserInfo");
        
        action.setCallback(this, function(response){
        var state = response.getState(); 
        if (state === "SUCCESS") {          
      Profile = response.getReturnValue();
      console.log('Profile is ' + Profile);
      if(Profile != "System Administrator" && Profile !== "Contact Center Rep"){
                alert('Only available for Contact Center Reps');
                $A.get("e.force:closeQuickAction").fire();
            }else{
            var avt = $A.get("e.force:navigateToComponent"); 
            
            avt.setParams({
            componentDef:"c:newJobAura",
                componentAttributes: {
                        jobrecordId : component.get("v.recordId"),
                        TypeOfJobEntry:"AfterHoursJobEntry"
                        
                    }
            });
            avt.fire();
            }
      
        }
    })
    
      $A.enqueueAction(action);
    
      console.log('Profile is ' + Profile);
//       if(Profile != "System Administrator" && Profile !== "Contact Center Rep"){
//         alert('Only available for Contact Center Reps');
//         $A.get("e.force:closeQuickAction").fire();
//     }else{
//     var avt = $A.get("e.force:navigateToComponent"); 
    
//     avt.setParams({
//     componentDef:"c:newJobAura",
//         componentAttributes: {
//                 jobrecordId : component.get("v.recordId"),
//                 TypeOfJobEntry:"AfterHoursJobEntry"
                
//             }
//     });
//     avt.fire();
//     }
// }
    }
})