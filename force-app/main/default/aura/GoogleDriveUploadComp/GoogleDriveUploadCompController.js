({
    openUploadModalPopup: function (component, event) {
        component.set("v.isUploadModalOpen", true);//Open the modal pop up
    },
    closeUploadModalPopup: function(component, event, helper) {
        component.set("v.isUploadModalOpen", false);
    },
    handleUploadFinished: function (component, event, helper) {
        // Get the list of uploaded files
        let uploadedFiles = event.getParam("files");
        let uploadedFileList =[];
        uploadedFiles.forEach(function (file) {
            uploadedFileList.push(file.documentId);
        });
        helper.uploadFile(component, uploadedFileList);
        window.setTimeout(
            $A.getCallback(function() {
                component.set("v.isUploadModalOpen", false);
                
            }), 10000
       );
        
    },
})