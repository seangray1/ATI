({
    openUploadModalPopup: function (component, event) {
        component.set("v.isUploadModalOpen", true);//Open the modal pop up
    },
    closeUploadModalPopup: function(component, event, helper) {
        component.set("v.isUploadModalOpen", false);
    },
    
    handleUploadFinished: function (component, event, helper) {
        // Get the list of uploaded files
        var uploadedFiles = event.getParam("files");
        var uploadedFileList =[];
        uploadedFiles.forEach(function (file) { 
            console.log(file.documentId) 
            uploadedFileList.push(file.documentId);
        }); 
        component.set("v.isUploadModalOpen", false);
        
        helper.uploadFile(component, uploadedFileList);
        
    },
    
})