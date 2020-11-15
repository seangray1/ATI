({
    /*
	redirectUserToDownloadPage : function(component, downloadFolderName, mapToSend, includeSubFolders) {
        component.set("v.spinner", true);
        let action = component.get('c.getDownloadPageLink');
        action.setParams({
            "sObjectName" : component.get("v.sObjectName"),
            "recordId" : component.get("v.recordId"),
            "downloadFolderName" : downloadFolderName,
            "selectedFolderFiles" : mapToSend,
            "includeSubFolders" : includeSubFolders
        });
        action.setCallback(this,function(response){
            let state = response.getState();
            if(state === 'SUCCESS') {
                let downloadLink = response.getReturnValue();
                this.openDownloadPage(component, downloadLink);
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
                component.set("v.spinner", false);
                this.reloadCurrentFolderContents(component);
            }
            component.set("v.includeSubFolders", false); 
            component.set("v.spinner", false);
            
        });
        $A.enqueueAction(action);
    },*/
    /*
    addErrorLogInAPILogObject : function(component, apiLogData) {
        let action = component.get('c.addAPILogInDB');
        action.setParams({
            "apiLogData" : JSON.stringify(apiLogData) 
        });
        action.setCallback(this,function(response){
            let state = response.getState();
            if(state === 'SUCCESS') {
                let result = response.getReturnValue();
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
    },*/
    /*
    openDownloadPage : function(component, downloadLink) {
        if(downloadLink != undefined && downloadLink !=''){
            let openDownloadPageEvent = $A.get("e.force:navigateToURL");
            openDownloadPageEvent.setParams({
                "url": downloadLink
            });
            openDownloadPageEvent.fire();
            this.reloadCurrentFolderContents(component);
        }
        else{
            let toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type":"error",
                "title": "Error!",
                "message": 'Download link is Empty for this request.'
            });
            toastEvent.fire();
        }
    },*/
    /*
    reloadCurrentFolderContents : function(component) {
        let reloadCurrentFolderContentsEvent = component.getEvent("ReloadCurrentFolderContents");
        reloadCurrentFolderContentsEvent.fire();
    },*/
    
    /*
    checkIfOnlyFilesSelectedForDownlaod : function(component, selectedRowDetailsMap){
        //component.set("v.spinner", true);
        for(let i=0; i< selectedRowDetailsMap.length; i++){
            if(selectedRowDetailsMap[i].value[2] === true){
                //component.set("v.spinner", false);
                return false;
            }
        }
        //component.set("v.spinner", false);
        return true;
    },*/
    /*
    checkIfOnlyFoldersSelectedForDownlaod : function(component, selectedRowDetailsMap){
        //component.set("v.spinner", true);
        for(let i=0; i< selectedRowDetailsMap.length; i++){
            if(selectedRowDetailsMap[i].value[2] === false){
                //component.set("v.spinner", false);
                return false;
            }
        }
        //component.set("v.spinner", false);
        return true;
    },*/
    /*
    getTotalSizeAndNoOfFilesToBeDownloaded : function(component){
        //component.set("v.spinner", true); 
        let selectedRowDetailsMap = component.get("v.selectedRowDetailsMap");
        let mapToSend = {};
        //Parse selectedRowDetailsMap and add to mapToSend
        for(let i=0; i< selectedRowDetailsMap.length; i++){
            mapToSend[selectedRowDetailsMap[i].key] = selectedRowDetailsMap[i].value;
        }
        
        this.getSizeAndNoOfFilesToBeDownloadedFromGoogleDrive(component, mapToSend);
        
        //component.set("v.spinner", false); 
    },*/
    /*
    getSizeAndNoOfFilesToBeDownloadedFromGoogleDrive : function(component, mapToSend) {
        component.set("v.spinner", true); 
        let action = component.get('c.getNoOfFilesAndTotalSizeForDownload');
        action.setParams({
            "sObjectName" : component.get("v.sObjectName"),
            "recordId" : component.get("v.recordId"),
            "selectedFolderFiles" : mapToSend
        });
        action.setCallback(this,function(response){
            let state = response.getState();
            if(state === 'SUCCESS') {
                component.set("v.totalFilesToBeDownloaded", result[0]);
                component.set("v.totalFileSizeToBeDownloaded", result[1]);
                
                component.set("v.isConfirmModalOpen", true);
            }
            else if (response.getState() === "ERROR") {
                let errors = response.getError();
                let toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"error",
                    "title": "Error!",
                    "message": errors[0].message
                });
            }
            component.set("v.spinner", false);
        });
        $A.enqueueAction(action);
    },*/
})