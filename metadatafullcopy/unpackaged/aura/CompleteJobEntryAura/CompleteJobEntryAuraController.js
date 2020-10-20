({
	doInit : function(component, event, helper) {
	
    //     var urlEvent = $A.get("e.force:navigateToURL");
    // urlEvent.setParams({
    //     "url":"/apex/NewJobBeta"
    // });
    // urlEvent.fire();
    // }
        var infoReturned;
        var recordId = component.get("v.recordId");
        var action = component.get("c.GetUserInfoAndIntakeStatus");
        action.setParams({recordId:recordId})
        
        action.setCallback(this, function(response){
        var state = response.getState(); 
        if (state === "SUCCESS") {          
      infoReturned = response.getReturnValue();
      console.log('Profile is ' + infoReturned.ProfileName);
      if(infoReturned.ProfileName !== "System Administrator" && infoReturned.ProfileName !== "Contact Center Rep"){
                alert('Only available for Contact Center Reps');
                $A.get("e.force:closeQuickAction").fire();
            }else{
                if(infoReturned.IntakeStatus !== 'Business Requested'){
                    alert('Only Jobs requested from the Job Request Form can be completed through the Job Form');
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
        }
    })
    
      $A.enqueueAction(action);
    
      
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