({
    initializeComponents : function(component, event, helper) {
        let recordId = component.get("v.recordId");
        let objectName = component.get("v.sObjectName");
        //Get the folder/file list for Job/Acc record
        helper.getRecordFolderFilesList(component, objectName, recordId);
        //Get the folder list for Job/Acc record which shall be read only in lightning comp
        //helper.getReadOnlyFolderList(component, objectName);
        let userId = $A.get("$SObjectType.CurrentUser.Id");
        component.set('v.userId', userId);
    },
    loadSubFolderContentsOnFolderClick : function(component, event, helper) {
        component.set('v.spinner', true);
        component.set("v.selectedRowList", []);
        let recordId = component.get("v.recordId");
        let objectName = component.get("v.sObjectName");
        let googleDriveId = event.getParam("folderGDId");
        let folderName = event.getParam("folderName");
        component.set('v.disableNotAvailableButtonsOnRowSelect', false);
        component.set('v.currentFolderGDId', googleDriveId);
        component.set('v.currentFolderName', folderName);
        helper.getFolderFilesListForSubFolder(component, objectName, recordId, googleDriveId);
        helper.addFolderDetailsToNavPathMap(component, googleDriveId, folderName);
    },
    updateSelectedRowsList : function(component, event, helper) {
        let selectedRowList = event.getParam("selectedRowList");
        let selectedRowDetailsMap = event.getParam("selectedRowDetailsMap");
        component.set('v.selectedRowList', selectedRowList);
        component.set('v.selectedRowDetailsMap', selectedRowDetailsMap);
        for(let i=0; i< selectedRowDetailsMap.length; i++){
        }
        if(selectedRowList.length > 0){
            component.set('v.disableNotAvailableButtonsOnRowSelect', true);
        	component.set('v.DisableShare', true);
        }
        else{
            component.set('v.disableNotAvailableButtonsOnRowSelect', false);
        	component.set('v.DisableShare', false);
        }
    },
    loadSubFolderContentsOnNavPathClick : function(component, event, helper) {
        component.set('v.spinner', true);
        component.set("v.selectedRowList", []);
        let recordId = component.get("v.recordId");
        let objectName = component.get("v.sObjectName");
        let googleDriveId = event.getParam("folderGDId");
        let folderName = event.getParam("folderName");
        component.set('v.disableNotAvailableButtonsOnRowSelect', false);
        component.set('v.currentFolderGDId', googleDriveId);
        component.set('v.currentFolderName', folderName);
        helper.getFolderFilesListForSubFolder(component, objectName, recordId, googleDriveId);
        helper.updateNavPathMap(component, googleDriveId, folderName);
    },
    reloadCurrentFolderContentsAfterFolderFileCreation : function(component, event, helper) {
        let recordId = component.get("v.recordId");
        let objectName = component.get("v.sObjectName");
        let googleDriveId = component.get("v.currentFolderGDId");
        component.set('v.selectedRowList', []);
        component.set('v.selectedRowDetailsMap', []);
        component.set('v.DisableShare', false);
        helper.getFolderFilesListForSubFolder(component, objectName, recordId, googleDriveId);
        component.set('v.disableNotAvailableButtonsOnRowSelect', false);
    },
    redirectToGoogleDriveForFileEdit : function(component, event, helper) {
        let recordId = component.get("v.recordId");
        let objectName = component.get("v.sObjectName");
        let googleDriveId = component.get("v.currentFolderGDId");
        let fileEditLink = event.getParam("viewLink");
        helper.getFolderFilesListForSubFolder(component, objectName, recordId, googleDriveId);
    	component.set('v.spinner', true);
        let openFileInDriveEvent = $A.get("e.force:navigateToURL");
        openFileInDriveEvent.setParams({
            "url": fileEditLink
        });
        openFileInDriveEvent.fire();
        component.set('v.spinner', false);
    },
    showSearchScreen : function(component, event, helper) {
        component.set('v.showSearchComp', true);
    },
    /*
    removeDeletedFileFolderFromList : function(component, event, helper) {
        component.set('v.spinner', true);
        let folderFilesList = component.get("v.folderFilesList");
        let selectedRowList = event.getParam("selectedRowList");
        component.set('v.selectedRowList', []);
        component.set('v.selectedRowDetailsMap', []);
        for(let i=0; i< selectedRowList.length; i++){
            let indexForItemToBeRemoved = -1;
            let entryFound = false;
            for(let j=0; j< folderFilesList.length; j++){
                if(folderFilesList[j].googleDriveId == selectedRowList[i]){
                    entryFound = true;
                    indexForItemToBeRemoved = j;
                    break;
                }
            }
            if(entryFound == true && indexForItemToBeRemoved >= 0){
                folderFilesList.splice(indexForItemToBeRemoved, 1);
            }
        }
        component.set('v.folderFilesList', folderFilesList);
        component.set('v.disableNotAvailableButtonsOnRowSelect', false);
        component.set('v.DisableShare', false);
        component.set('v.spinner', false);
    },*/
})