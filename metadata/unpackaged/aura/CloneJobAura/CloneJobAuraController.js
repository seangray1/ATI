({
	doInit : function(component, event, helper) {
        //var infoReturned;
        var infoReturned;
        var recordId = component.get("v.recordId");
        var action = component.get("c.GetUserInfoAndIntakeStatus");
        action.setParams({recordId:recordId})
        
        action.setCallback(this, function(response){
        var state = response.getState(); 
        if (state === "SUCCESS") {          
      infoReturned = response.getReturnValue();
      console.log('Profile is ' + infoReturned.MarketClass);
      if(infoReturned.MarketClass === null || infoReturned.MarketClass === undefined){
                alert('Market Class must be filled out');
                $A.get("e.force:closeQuickAction").fire();
            }else{
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
        }
        }
    })
    
      $A.enqueueAction(action);




        //var recordId = component.get("v.recordId");
//         var device = $A.get("$Browser.formFactor");
// //         var jobId = component.get("v.recordId");
// //         //alert('Device is ' + device);
//         if(device === 'PHONE' || device === 'TABLET'){
//             console.log('Device is ' + device);
//         }else{
//             var avt = $A.get("e.force:navigateToComponent"); 
            
//             avt.setParams({
//             componentDef:"c:JobRequestFormAura",
//                 componentAttributes: {
//                         recordId : component.get("v.recordId")
//                     }
//             });
//             avt.fire();
//             }
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