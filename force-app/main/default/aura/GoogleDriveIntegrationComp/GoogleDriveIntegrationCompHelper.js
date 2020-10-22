({
    getRecordFolderFilesList : function(component, objectName, recordId) {
        component.set("v.spinner", true); 
        component.set("v.showSpinnerInFolderListComp", true);
        
        var action = component.get('c.getFolderFilesList');
        action.setParams({
            "recordId" : recordId,
            "sObjectName" : objectName
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state == 'SUCCESS') {
                var folderFileList = response.getReturnValue();
                console.log(folderFileList);
                component.set('v.folderFilesList', folderFileList);
                component.set('v.DisableShare', false);
                
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
                component.set("v.showFolderFileListComp", true);
                component.set("v.showSpinnerInFolderListComp", false); 
            }
        });
        $A.enqueueAction(action);
    },
    
    createNavPath : function(component, objectName, recordId) {
        //component.set("v.spinner", true); 
        var action = component.get('c.createNavPathMap');
        action.setParams({
            "recordId" : recordId,
            "sObjectName" : objectName
        });
        action.setCallback(this,function(response){
            var navPathDetailsMap=[];
            var state = response.getState();
            if(state == 'SUCCESS') {
                var navPathResult = response.getReturnValue();
                console.log(navPathResult);
                for(var key in navPathResult){
                    navPathDetailsMap.push({value:navPathResult[key], key:key});
                }
                component.set('v.navPathDetailsMap', navPathDetailsMap);
                component.set('v.currentFolderGDId', navPathDetailsMap[0].key);//Current open folder GD Id(This will change as and when user clicks on subfolders)
                component.set('v.currentFolderName', navPathDetailsMap[0].value);//Current open folder Name(This will change as and when user clicks on subfolders)
                component.set('v.parentRecFolderGDId', navPathDetailsMap[0].key);//Main Job/Account folder GD Id
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
            //component.set("v.spinner", false);
        });
        $A.enqueueAction(action);
    },
    
    getFolderFilesListForSubFolder : function(component, objectName, recordId, googleDriveId) {
        component.set("v.spinner", true); 
        //component.set("v.showFolderFileListComp", false);
        //component.set("v.showSpinnerInFolderListComp", true);
        component.set('v.folderFilesList', ['Wait']);
        
        var action = component.get('c.getSubFolderFilesList');
        action.setParams({
            "recordId" : recordId,
            "sObjectName" : objectName,
            "googleDriveId" : googleDriveId
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state == 'SUCCESS') {
                var folderFileList = response.getReturnValue();
                component.set('v.folderFilesList', folderFileList);
                component.set('v.DisableShare', false);
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
            component.set("v.spinner", false);
            
            /*window.setTimeout(
                $A.getCallback(function() {
                    component.set("v.showFolderFileListComp", true);
                    component.set("v.showSpinnerInFolderListComp", false); 
                }), 1000
            );*/
        });
        $A.enqueueAction(action);
    },
    
    addFolderDetailsToNavPathMap : function(component, googleDriveId, folderName){
        component.set("v.spinner", true); 
        
        var navPathDetailsMap = component.get('v.navPathDetailsMap');
        
        navPathDetailsMap.push({value:folderName, key:googleDriveId});
        component.set('v.navPathDetailsMap', navPathDetailsMap);
        
        component.set("v.spinner", false); 
    },
    
    updateNavPathMap : function(component, googleDriveId, folderName){
        component.set("v.spinner", true); 
        
        var navPathDetailsMap = component.get('v.navPathDetailsMap');
        var updatedNavPathDetailsMap = [];
        
        for(var i=0; i< navPathDetailsMap.length; i++){
            if(new String(navPathDetailsMap[i].key).valueOf() == new String(googleDriveId).valueOf()){
                updatedNavPathDetailsMap.push({value:navPathDetailsMap[i].value, key:navPathDetailsMap[i].key});
                break;
            }
            updatedNavPathDetailsMap.push({value:navPathDetailsMap[i].value, key:navPathDetailsMap[i].key});
        }
        
        component.set('v.navPathDetailsMap', updatedNavPathDetailsMap);
        
        component.set("v.spinner", false); 
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
    getReadOnlyFolderList : function(component, objectName) {
        //component.set("v.spinner", true); 
        var action = component.get('c.getReadOnlyFolderListFromMetadataConfig');
        action.setParams({
            "sObjectName" : objectName
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state == 'SUCCESS') {
                var readOnlyFolderList = response.getReturnValue();
                console.log(readOnlyFolderList);
                component.set('v.readOnlyFolderList', readOnlyFolderList);
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
            
            //component.set("v.spinner", false);
        });
        $A.enqueueAction(action);
    },*/
    /*
    checkIfFolderIsReadOnly : function(component, folderName){
        var readOnlyFolderList = component.get('v.readOnlyFolderList');
        var isFolderReadOnly = readOnlyFolderList.includes(folderName.trim());
        
        if(isFolderReadOnly == false){
            this.checkIfParentFolderIsReadOnly(component, folderName);
        }
        else{
            component.set("v.isCurrentFolderReadOnly", isFolderReadOnly); 
            console.log('Folder readOnly - ' + isFolderReadOnly);
        }
    },*/
    /*
    checkIfParentFolderIsReadOnly : function(component, folderName){
        var readOnlyFolderList = component.get('v.readOnlyFolderList');
        var navPathDetailsMap = component.get('v.navPathDetailsMap');
        var isFolderReadOnly = false;
		console.log('$$$$$$');
		console.log(navPathDetailsMap);        
        for(var i=0; i< navPathDetailsMap.length; i++){
            if(readOnlyFolderList.includes(navPathDetailsMap[i].value)){
                isFolderReadOnly = true; 
                break;
            }
        }
        console.log('Parent is read only - ' + isFolderReadOnly);
        component.set("v.isCurrentFolderReadOnly", isFolderReadOnly); 
    },*/
})