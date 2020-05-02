({
    doInit : function(component, event, helper) {

        
    },

    refreshView: function(component, event) {
        // refresh the view
        $A.get("e.force:refreshView").fire();
        $A.get("e.force:closeQuickAction").fire();
    },
    closeForm: function(component, event, helper) {
        
        $A.get("e.force:closeQuickAction").fire();
            },



})