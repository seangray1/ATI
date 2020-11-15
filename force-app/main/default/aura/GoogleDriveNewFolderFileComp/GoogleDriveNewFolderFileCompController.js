({
    handleFolderFileCreation : function(component, event, helper) {
        let fileType = event.detail.menuItem.get("v.value");
        if(fileType === 'folder'){
            component.set("v.isCreateFolderModalOpen", true);//Open the modal pop up
        }else{
           component.set("v.isCreateFileModalOpen", true);//Open the modal pop up
           component.set("v.newFileType", fileType); 
        }  
    },
    createNewFolder: function(component, event, helper) {
        let folderName = component.get("v.newFolderName");
        let currentFolderGDId = component.get("v.currentFolderGDId");
        let recordId = component.get("v.recordId");
        let objectName = component.get("v.sObjectName");
        if(folderName === undefined || folderName === null || folderName === ''){
            component.set("v.showError",true);
            component.set("v.errorMessage", "Please fill \"Folder Name\" before clicking on \"Create\".");
            return;
        }
        component.set("v.isCreateFolderModalOpen", false);
        helper.createFolderInGoogleDrive(component, currentFolderGDId, folderName, recordId, objectName);
    },
    createNewFile: function(component, event, helper) {
        let fileName = component.get("v.newFileName");
        let fileType = component.get("v.newFileType");
        let currentFolderGDId = component.get("v.currentFolderGDId");
        let recordId = component.get("v.recordId");
        let objectName = component.get("v.sObjectName");
        if(fileName === undefined || fileName === null || fileName === ''){
            component.set("v.showError",true);
            component.set("v.errorMessage", "Please fill \"File Name\" before clicking on \"Create\".");
            return;
        }
        component.set("v.isCreateFileModalOpen", false);
        helper.createFileInGoogleDrive(component, currentFolderGDId, recordId, objectName, fileType, fileName);
    },
    closeCreateFolderModal: function(component, event, helper) {
        component.set("v.isCreateFolderModalOpen", false);
        component.set("v.newFileName", 'Untitled File');
        component.set("v.newFolderName", 'Untitled Folder');
    },
    closeCreateFileModal: function(component, event, helper) {
        component.set("v.isCreateFileModalOpen", false);
        component.set("v.newFileName", 'Untitled File');
        component.set("v.newFolderName", 'Untitled Folder');
    },
})