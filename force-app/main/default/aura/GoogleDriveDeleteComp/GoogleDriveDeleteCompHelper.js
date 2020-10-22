({
    deleteSelFolderFiles : function(component, event, helper, selectedRowList){
        console.log('Inside deleteSelFolderFiles()');
        component.set("v.spinner", true); 
        var action = component.get('c.deleteSelectedFolderFiles');
        action.setParams({
            "googleDriveRefListString" : JSON.stringify(selectedRowList),
            "recordId" : component.get("v.recordId")
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state == 'SUCCESS') {
                var result = response.getReturnValue();
                console.log('Delete result');
                console.log(result);
                //this.updateCurrentFolderContentsAfterDelete(component);
            }
            else if (response.getState() === "ERROR") {
                var errorMessage='';
                var errors = response.getError();
                if(errors[0].message.includes("uiMessage")){
                    let errorData = JSON.parse(errors[0].message);
                    errorMessage = errorData.uiMessage;
                    this.addErrorLogInAPILogObject(component, errorData);
                }
                else {
                    errorMessage = errors[0].message;
                }
                
                var toastEvent = $A.get("e.force:showToast");
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
        var action = component.get('c.addAPILogInDB');
        action.setParams({
            "apiLogData" : JSON.stringify(apiLogData) 
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state == 'SUCCESS') {
                var result = response.getReturnValue();
                console.log('API log added.');
            }
            else if (response.getState() === "ERROR") {
                var errors = response.getError();
                var toastEvent = $A.get("e.force:showToast");
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
    /*
    updateCurrentFolderContentsAfterDelete : function(component) {
        var updateFolderContentsAfterDelete = component.getEvent("UpdateCurrentFolderContentsAfterDelete");
        var selectedRowList = component.get("v.selectedRowList"); 
        updateFolderContentsAfterDelete.setParams({
            "selectedRowList" : selectedRowList
        });
        updateFolderContentsAfterDelete.fire();
    },*/
    
    reloadCurrentFolderContents : function(component) {
        var reloadCurrentFolderContentsEvent = component.getEvent("ReloadCurrentFolderContents");
        reloadCurrentFolderContentsEvent.fire();
    },
})