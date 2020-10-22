({
    
    handleFolderFileCreation : function(component, event, helper) {
        var fileType = event.detail.menuItem.get("v.value");
        console.log('fileType-' + fileType);
        switch(fileType) {
            case "folder":
                component.set("v.isCreateFolderModalOpen", true);//Open the modal pop up
                break;
            default:
                component.set("v.isCreateFileModalOpen", true);//Open the modal pop up
                component.set("v.newFileType", fileType);
        }
    },
    
    createNewFolder: function(component, event, helper) {
        var folderName = component.get("v.newFolderName");
        var currentFolderGDId = component.get("v.currentFolderGDId");
        var recordId = component.get("v.recordId");
        var objectName = component.get("v.sObjectName");
        console.log('folderName - '+ folderName)
        if(folderName == undefined || folderName == null || folderName == ''){
            component.set("v.showError",true);
            component.set("v.errorMessage", "Please fill \"Folder Name\" before clicking on \"Create\".");
            return;
        }
        
        component.set("v.isCreateFolderModalOpen", false);
        helper.createFolderInGoogleDrive(component, currentFolderGDId, folderName, recordId, objectName);
    },
    
    createNewFile: function(component, event, helper) {
        var fileName = component.get("v.newFileName");
        var fileType = component.get("v.newFileType");
        var currentFolderGDId = component.get("v.currentFolderGDId");
        var recordId = component.get("v.recordId");
        var objectName = component.get("v.sObjectName");
        console.log('fileName - '+ fileName)
        if(fileName == undefined || fileName == null || fileName == ''){
            component.set("v.showError",true);
            component.set("v.errorMessage", "Please fill \"File Name\" before clicking on \"Create\".");
            return;
        }
        
        component.set("v.isCreateFileModalOpen", false);
        helper.createFileInGoogleDrive(component, currentFolderGDId, recordId, objectName, fileType, fileName);
    },
    
    closeCreateFolderModal: function(component, event, helper) {
        component.set("v.isCreateFolderModalOpen", false);
    },
    
    closeCreateFileModal: function(component, event, helper) {
        component.set("v.isCreateFileModalOpen", false);
    },
})