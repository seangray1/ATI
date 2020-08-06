({

    refreshView: function(component, event) {
        // refresh the view
        $A.get('e.force:refreshView').fire();
        $A.get("e.force:closeQuickAction").fire();
    },
})