({
    deleteSelFolderFiles : function(component, event, helper, selectedRowList){
        component.set("v.spinner", true); 
        let action = component.get('c.deleteSelectedFolderFiles');
        action.setParams({
            "googleDriveRefListString" : JSON.stringify(selectedRowList),
            "recordId" : component.get("v.recordId")
        });
        action.setCallback(this,function(response){
            let state = response.getState();
            if(state === 'SUCCESS') {
            }
            else if (response.getState() === "ERROR") {
                let errorMessage='';
                let errors = response.getError();
                if(errors[0].message.includes("uiMessage")){
                    let errorData = JSON.parse(errors[0].message);
                    errorMessage = errorData.uiMessage;
                    this.addErrorLogInAPILogObject(component, errorData);
                }
                else {
                    errorMessage = errors[0].message;
                }
                let toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"error",
                    "title": "Error!",
                    "message": errorMessage
                });
                toastEvent.fire();
            }
            this.reloadCurrentFolderContents(component);
            component.set("v.spinner", false);
        });
        $A.enqueueAction(action);
    },
    addErrorLogInAPILogObject : function(component, apiLogData) {
        let action = component.get('c.addAPILogInDB');
        action.setParams({
            "apiLogData" : JSON.stringify(apiLogData) 
        });
        action.setCallback(this,function(response){
            let state = response.getState();
			if (response.getState() === "ERROR") {
                let errors = response.getError();
                let toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"error",
                    "title": "Error!",
                    "message": errors[0].message
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    reloadCurrentFolderContents : function(component) {
        let reloadCurrentFolderContentsEvent = component.getEvent("ReloadCurrentFolderContents");
        reloadCurrentFolderContentsEvent.fire();
    }
})