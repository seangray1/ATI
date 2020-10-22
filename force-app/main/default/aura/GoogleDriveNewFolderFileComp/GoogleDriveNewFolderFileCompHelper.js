({
    createFolderInGoogleDrive : function(component, currentFolderGDId, folderName, recordId, objectName){
        component.set("v.spinner", true); 
        var action = component.get('c.createNewFolderInGoogleDrive');
        action.setParams({
            "sObjectName" : objectName,
            "recordId" : recordId,
            "googleDriveId" : currentFolderGDId,
            "newFolderName" : folderName,
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state == 'SUCCESS') {
                var result = response.getReturnValue();
                console.log(result);
                
                component.set("v.newFolderName", "New Folder");//Remove old name 
                if(result != null && result != undefined)
                    this.reloadCurrentFolderContents(component);
                else//Show error message
                    console.log('Folder could not be created!!');
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
                component.set("v.spinner", false);
                this.reloadCurrentFolderContents(component);
            }
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
    createFileInGoogleDrive : function(component, currentFolderGDId, recordId, objectName, fileType, fileName){
        component.set("v.spinner", true); 
        var action = component.get('c.createNewFileInGoogleDrive');
        action.setParams({
            "sObjectName" : objectName,
            "recordId" : recordId,
            "googleDriveId" : currentFolderGDId,
            "fileType" : fileType,
            "fileName" : fileName
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state == 'SUCCESS') {
                var result = response.getReturnValue();
                console.log(result);
                
                component.set("v.newFileName", "Untitled File");//Remove old name 
                component.set("v.newFileType", "");//Remove old type 
                
                if(result != null && result != undefined)
                    this.openFileInGoogleDrive(component, result);
                else//Show error message
                    console.log('File could not be created!!');
                
            }
            else if (response.getState() === "ERROR") {
                /*  var errors = response.getError();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"error",
                    "title": "Error!",
                    "message": errors[0].message
                });*/
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
                component.set("v.spinner", false);
                this.reloadCurrentFolderContents(component);
            }
            component.set("v.spinner", false);
        });
        $A.enqueueAction(action);
    },
    
    reloadCurrentFolderContents : function(component) {
        var reloadCurrentFolderContentsEvent = component.getEvent("ReloadCurrentFolderContents");
        reloadCurrentFolderContentsEvent.fire();
    },
    
    openFileInGoogleDrive : function(component, result) {
        var openNewFileInGoogleDriveEvent = component.getEvent("OpenNewFileInGoogleDrive");
        openNewFileInGoogleDriveEvent.setParams({
            "viewLink" : result.viewLink
        });
        openNewFileInGoogleDriveEvent.fire();
    },
})