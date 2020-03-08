({
	doInit : function(component, event, helper) {
	
    //     var urlEvent = $A.get("e.force:navigateToURL");
    // urlEvent.setParams({
    //     "url":"/apex/NewJobBeta"
    // });
    // urlEvent.fire();
    // }
    var avt = $A.get("e.force:navigateToComponent"); 
    
    avt.setParams({
    componentDef:"c:newJobAura",
        componentAttributes: {
                jobrecordId : component.get("v.recordId"),
                TypeOfJobEntry:"AfterHoursJobEntry"
                
            }
    });
		//$A.enqueueAction(avt);

avt.fire();
    }
})