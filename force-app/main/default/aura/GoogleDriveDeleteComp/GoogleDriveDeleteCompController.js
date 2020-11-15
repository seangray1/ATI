({
	openConfirmationPopUp : function(component, event, helper) {
		component.set("v.isConfirmModalOpen", true);
	},
    closeConfirmationPopUp: function(component, event, helper) {
        component.set("v.isConfirmModalOpen", false);
    },
    handleDelete: function(component, event, helper) {
        let selectedRowList = component.get("v.selectedRowList"); 
        helper.deleteSelFolderFiles(component, event, helper, selectedRowList);
        component.set("v.isConfirmModalOpen", false);
    },
})