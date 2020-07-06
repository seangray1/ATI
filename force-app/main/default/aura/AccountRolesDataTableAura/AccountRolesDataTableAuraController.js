({
    EditAccountRoles : function(component, event, helper) {
        component.set("v.EditAccountRoles", true);
    },
    EditAccountRolesSubmitted: function(component, event) {
        // refresh the view
       component.find('accountRolesDataTable').refreshApex();
        component.set("v.EditAccountRoles", false);
        $A.get('e.force:refreshView').fire();
        $A.get("e.force:closeQuickAction").fire();
    },
    CloseEditAccountRoles: function(component, event, helper) {
        // component.find('accountRolesDataTable').refreshApex();
        component.set("v.EditAccountRoles", false);
        $A.get('e.force:refreshView').fire();
        $A.get("e.force:closeQuickAction").fire();
            },

            
})