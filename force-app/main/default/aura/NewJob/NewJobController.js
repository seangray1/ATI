/**
 * @File Name          : NewJobController.js
 * @Description        : 
 * @Author             : Sean Gray
 * @Group              : 
 * @Last Modified By   : Sean Gray
 * @Last Modified On   : 1/23/2020, 2:32:23 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    1/23/2020   Sean Gray     Initial Version
**/
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
                recordId : component.get("v.recordId")
                
            }
    });
		//$A.enqueueAction(avt);

avt.fire();
    }
})