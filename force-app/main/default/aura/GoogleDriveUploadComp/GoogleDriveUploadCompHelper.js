({
    uploadFile: function(component, uploadedFileList) {
        component.set('v.spinner', true);
        let action = component.get('c.uploadFilesToGoogleDrive');
        action.setParams({
            "recordId" : component.get('v.recordId'),
            "googleDriveId" : component.get('v.currentFolderGDId'),
            "fileList" : JSON.stringify(uploadedFileList)
        });
        action.setCallback(this,function(response){
            let state = response.getState(); // get the response state
            if(state === 'SUCCESS') {
                this.showUploadInProgressMessage(component);
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
            component.set('v.spinner', false);
        });
        $A.enqueueAction(action);
    },
    reloadCurrentFolderContents : function(component) {
        let reloadCurrentFolderContentsEvent = component.getEvent("RefreshCurrentFolderContent");
        reloadCurrentFolderContentsEvent.fire();
    },
    showUploadInProgressMessage : function(component) {
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type":"success",
            "title": "Upload In Progress",
            "message": "The files are being uploaded. Files will be visible in Google Drive and here once upload is finished."
        });
        toastEvent.fire();
    },
})