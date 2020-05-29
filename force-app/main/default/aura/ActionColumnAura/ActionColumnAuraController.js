({
    OpenProjectNote : function(component, event, helper) {
        component.set("v.ProjectNoteClicked", true);
    },
    ProjectNoteSubmitted: function(component, event) {
        // refresh the view
        component.set("v.ProjectNoteClicked", false);
        $A.get('e.force:refreshView').fire();
        $A.get("e.force:closeQuickAction").fire();
    },
    Close: function(component, event, helper) {
        component.set("v.ProjectNoteClicked", false);
        $A.get("e.force:closeQuickAction").fire();
            },
    CloneJob : function(component, event, helper) {
        component.set("v.CloneJob", true);
    },
    CloneJobSubmitted: function(component, event) {
        // refresh the view
        component.set("v.CloneJob", false);
        $A.get('e.force:refreshView').fire();
        $A.get("e.force:closeQuickAction").fire();
    },
    CloseCloneJob: function(component, event, helper) {
        component.set("v.CloneJob", false);
        $A.get("e.force:closeQuickAction").fire();
            },
    EditAccountRoles : function(component, event, helper) {
        component.set("v.EditAccountRoles", true);
    },
    EditAccountRolesSubmitted: function(component, event) {
        // refresh the view
        component.set("v.EditAccountRoles", false);
        $A.get('e.force:refreshView').fire();
        $A.get("e.force:closeQuickAction").fire();
    },
    CloseEditAccountRoles: function(component, event, helper) {
        component.set("v.EditAccountRoles", false);
        $A.get("e.force:closeQuickAction").fire();
            },

            
})