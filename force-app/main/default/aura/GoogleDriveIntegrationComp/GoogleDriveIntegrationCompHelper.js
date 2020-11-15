({
    getRecordFolderFilesList : function(component, objectName, recordId) {
        component.set("v.spinner", true);
        component.set("v.showSpinnerInFolderListComp", true);
        let action = component.get('c.getFolderFilesList');
        action.setParams({
            "recordId" : recordId,
            "sObjectName" : objectName
        });
        action.setCallback(this,function(response){
            let state = response.getState();
            if(state === 'SUCCESS') {
                let folderFileList = response.getReturnValue();
                component.set('v.folderFilesList', folderFileList);
                component.set('v.DisableShare', false);
                this.getRecordGoogleDriveLink(component, objectName, recordId);
                this.createNavPath(component, objectName, recordId);
                component.set("v.spinner", false);
                window.setTimeout(
                    $A.getCallback(function() {
                        component.set("v.showFolderFileListComp", true);
                        component.set("v.showSpinnerInFolderListComp", false);
                    }), 1000
                );
            }
            else if (response.getState() === "ERROR") {
                let errorMessage='';
                let errors = response.getError();
                if(errors[0].message.includes("uiMessage")){
                    let errorData = JSON.parse(errors[0].message);
                    errorMessage = errorData.uiMessage;
                    console.log(errorData);
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
                component.set("v.spinner", false);
                component.set("v.showFolderFileListComp", true);
                component.set("v.showSpinnerInFolderListComp", false);
            }
        });
        $A.enqueueAction(action);
    },
    getRecordGoogleDriveLink : function(component, objectName, recordId) {
        let action = component.get('c.getGoogleDriveLinkForTheRecord');
        action.setParams({
            "recordId" : recordId,
            "sObjectName" : objectName
        });
        action.setCallback(this,function(response){
            let state = response.getState();
            if(state === 'SUCCESS') {
                let recordLink = response.getReturnValue();
                component.set('v.googleDriveLinkForRec', recordLink);
            }
            else if (response.getState() === "ERROR") {
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
    createNavPath : function(component, objectName, recordId) {
        let action = component.get('c.createNavPathMap');
        action.setParams({
            "recordId" : recordId,
            "sObjectName" : objectName
        });
        action.setCallback(this,function(response){
            let navPathDetailsMap=[];
            let state = response.getState();
            if(state === 'SUCCESS') {
                let navPathResult = response.getReturnValue();
                for(let key in navPathResult){
                    navPathDetailsMap.push({value:navPathResult[key], key:key});
                }
                component.set('v.navPathDetailsMap', navPathDetailsMap);
                component.set('v.currentFolderGDId', navPathDetailsMap[0].key);//Current open folder GD Id(This will change as and when user clicks on subfolders)
                component.set('v.currentFolderName', navPathDetailsMap[0].value);//Current open folder Name(This will change as and when user clicks on subfolders)
                component.set('v.parentRecFolderGDId', navPathDetailsMap[0].key);//Main Job/Account folder GD Id
            }
            else if (response.getState() === "ERROR") {
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
    getFolderFilesListForSubFolder : function(component, objectName, recordId, googleDriveId) {
        component.set("v.spinner", true);
        component.set('v.folderFilesList', ['Wait']);
        let action = component.get('c.getSubFolderFilesList');
        action.setParams({
            "recordId" : recordId,
            "sObjectName" : objectName,
            "googleDriveId" : googleDriveId
        });
        action.setCallback(this,function(response){
            let state = response.getState();
            if(state === 'SUCCESS') {
                let folderFileList = response.getReturnValue();
                component.set('v.folderFilesList', folderFileList);
                component.set('v.DisableShare', false);
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
            component.set("v.spinner", false);
        });
        $A.enqueueAction(action);
    },
    addFolderDetailsToNavPathMap : function(component, googleDriveId, folderName){
        component.set("v.spinner", true);
        let navPathDetailsMap = component.get('v.navPathDetailsMap');
        navPathDetailsMap.push({value:folderName, key:googleDriveId});
        component.set('v.navPathDetailsMap', navPathDetailsMap);
        component.set("v.spinner", false);
    },
    updateNavPathMap : function(component, googleDriveId, folderName){
        component.set("v.spinner", true);
        let navPathDetailsMap = component.get('v.navPathDetailsMap');
        let updatedNavPathDetailsMap = [];
        for(let i=0; i< navPathDetailsMap.length; i++){
            if(navPathDetailsMap[i].key === googleDriveId){
                updatedNavPathDetailsMap.push({value:navPathDetailsMap[i].value, key:navPathDetailsMap[i].key});
                break;
            }
            updatedNavPathDetailsMap.push({value:navPathDetailsMap[i].value, key:navPathDetailsMap[i].key});
        }
        component.set('v.navPathDetailsMap', updatedNavPathDetailsMap);
        component.set("v.spinner", false);
    },
    addErrorLogInAPILogObject : function(component, apiLogData) {
        let action = component.get('c.addAPILogInDB');
        action.setParams({
            "apiLogData" : JSON.stringify(apiLogData)
        });
        action.setCallback(this,function(response){
            let state = response.getState();
            if(state === 'SUCCESS') {
            }
            else if (response.getState() === "ERROR") {
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
    }
})