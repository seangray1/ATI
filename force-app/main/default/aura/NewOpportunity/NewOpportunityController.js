({
    init : function(component, event, helper) {
        var avt = $A.get("e.force:navigateToComponent"); 
        console.log('Test');
    
    avt.setParams({
    componentDef:"c:CreateBDOpportunity"
    });
		//$A.enqueueAction(avt);

avt.fire();
    },
    
})
