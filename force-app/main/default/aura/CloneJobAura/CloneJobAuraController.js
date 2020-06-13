({
	doInit : function(component, event, helper) {
        //var infoReturned;
        //var recordId = component.get("v.recordId");

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





        var device = $A.get("$Browser.formFactor");
//         var jobId = component.get("v.recordId");
//         //alert('Device is ' + device);
        if(device === 'PHONE' || device === 'TABLET'){
            console.log('Device is ' + device);
        }else{
            var avt = $A.get("e.force:navigateToComponent"); 
            
            avt.setParams({
            componentDef:"c:JobRequestFormAura",
                componentAttributes: {
                        recordId : component.get("v.recordId")
                    }
            });
            avt.fire();
            }
        },
    
    
    
        closeForm : function(component, event, helper) {
        $A.get('e.force:refreshView').fire();
        $A.get("e.force:closeQuickAction").fire();
    }
})




















// ({
    
//    gotoCloneLT:function(component,event,helper){
//     var avt = $A.get("e.force:navigateToComponent"); 
    
//     avt.setParams({
//     componentDef:"c:CloneATIJob",
//         componentAttributes: {
//                 recordId : component.get("v.recordId"),
//                 cloneRelatedJobs : 'false'
//             }
//     });
// 		//$A.enqueueAction(avt);

// avt.fire();
       

// },


//     gotoCloneATILT:function(component,event,helper){
//     var evt = $A.get("e.force:navigateToComponent"); 
    
//     evt.setParams({
//     componentDef:"c:CloneATIJob",
//         componentAttributes: {
//                 recordId : component.get("v.recordId"),
//                 cloneRelatedJobs : 'true'
//             }
//     });
// 		//$A.enqueueAction(evt);
// evt.fire();
        
// }
// })