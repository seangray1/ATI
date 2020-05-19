/**
 * @File Name          : AllocationsAppAuraController.js
 * @Description        : 
 * @Author             : Sean Gray
 * @Group              : 
 * @Last Modified By   : Sean Gray
 * @Last Modified On   : 2/2/2020, 9:33:38 AM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    2/2/2020   Sean Gray     Initial Version
**/
({
    refreshView: function(component, event) {
        // refresh the view
        $A.get('e.force:refreshView').fire();
        $A.get("e.force:closeQuickAction").fire();
    },
    closeForm: function(component, event, helper) {
        
        $A.get("e.force:closeQuickAction").fire();
            },
})