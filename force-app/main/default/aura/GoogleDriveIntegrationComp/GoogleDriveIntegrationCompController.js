({
    initializeComponents : function(component, event, helper) {
        var recordId = component.get("v.recordId");
        var objectName = component.get("v.sObjectName");
        
        //Get the folder/file list for Job/Acc record
        helper.getRecordFolderFilesList(component, objectName, recordId);
        //Get the folder list for Job/Acc record which shall be read only in lightning comp
        //helper.getReadOnlyFolderList(component, objectName);
        
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        component.set('v.userId', userId);
    },
    
    loadSubFolderContentsOnFolderClick : function(component, event, helper) {
        component.set('v.spinner', true);
        
        component.set("v.selectedRowList", []); 
        var recordId = component.get("v.recordId");
        var objectName = component.get("v.sObjectName");
        var googleDriveId = event.getParam("folderGDId");
        var folderName = event.getParam("folderName");
        
        component.set('v.disableNotAvailableButtonsOnRowSelect', false);
        component.set('v.currentFolderGDId', googleDriveId);
        component.set('v.currentFolderName', folderName);
        //component.set('v.spinner', false);
        
        helper.getFolderFilesListForSubFolder(component, objectName, recordId, googleDriveId);
        helper.addFolderDetailsToNavPathMap(component, googleDriveId, folderName);
        //helper.checkIfFolderIsReadOnly(component,folderName);
    },
    
    updateSelectedRowsList : function(component, event, helper) {
        console.log('Inside updateSelectedRowsList() ');
        
        var selectedRowList = event.getParam("selectedRowList");
        var selectedRowDetailsMap = event.getParam("selectedRowDetailsMap");
        component.set('v.selectedRowList', selectedRowList);
        component.set('v.selectedRowDetailsMap', selectedRowDetailsMap);
        
        for(var i=0; i< selectedRowDetailsMap.length; i++){
            console.log(selectedRowDetailsMap[i].key + ':');
            console.log(selectedRowDetailsMap[i].value);
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
        var recordId = component.get("v.recordId");
        var objectName = component.get("v.sObjectName");
        var googleDriveId = event.getParam("folderGDId");
        var folderName = event.getParam("folderName");
        
        component.set('v.disableNotAvailableButtonsOnRowSelect', false);
        component.set('v.currentFolderGDId', googleDriveId);
        component.set('v.currentFolderName', folderName);
        //component.set('v.spinner', false);
        
        helper.getFolderFilesListForSubFolder(component, objectName, recordId, googleDriveId);
        helper.updateNavPathMap(component, googleDriveId, folderName);
        //helper.checkIfFolderIsReadOnly(component,folderName);
    },
    
    reloadCurrentFolderContentsAfterFolderFileCreation : function(component, event, helper) {
        var recordId = component.get("v.recordId");
        var objectName = component.get("v.sObjectName");
        var googleDriveId = component.get("v.currentFolderGDId");
        console.log('In reloadCurrentFolderContentsAfterFolderFileCreation() ' + googleDriveId);
        
        component.set('v.selectedRowList', []);
        component.set('v.selectedRowDetailsMap', []);
        component.set('v.DisableShare', false);
        
        helper.getFolderFilesListForSubFolder(component, objectName, recordId, googleDriveId);
        
        component.set('v.disableNotAvailableButtonsOnRowSelect', false);
    },
    
    redirectToGoogleDriveForFileEdit : function(component, event, helper) {
        var recordId = component.get("v.recordId");
        var objectName = component.get("v.sObjectName");
        var googleDriveId = component.get("v.currentFolderGDId");
        var fileEditLink = event.getParam("viewLink");
        
        helper.getFolderFilesListForSubFolder(component, objectName, recordId, googleDriveId);
        
    	component.set('v.spinner', true);
        var openFileInDriveEvent = $A.get("e.force:navigateToURL");
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
        console.log('In removeDeletedFileFolderFromList() ');
        
        var folderFilesList = component.get("v.folderFilesList");
        var selectedRowList = event.getParam("selectedRowList");
        
        component.set('v.selectedRowList', []);
        component.set('v.selectedRowDetailsMap', []);
        
        console.log('FolderFile list size - ' + folderFilesList.length);
        for(var i=0; i< selectedRowList.length; i++){
            var indexForItemToBeRemoved = -1;
            var entryFound = false;
            for(var j=0; j< folderFilesList.length; j++){
                if(folderFilesList[j].googleDriveId == selectedRowList[i]){
                    console.log('Yes found-' + folderFilesList[j].name)
                    entryFound = true;
                    indexForItemToBeRemoved = j;
                    break;
                }
            }
            if(entryFound == true && indexForItemToBeRemoved >= 0){
                folderFilesList.splice(indexForItemToBeRemoved, 1);
            }
            console.log('FolderFile list size after delete- ' + folderFilesList.length);
        }
        
        component.set('v.folderFilesList', folderFilesList);
        component.set('v.disableNotAvailableButtonsOnRowSelect', false);
        component.set('v.DisableShare', false);
        
        component.set('v.spinner', false);
    },*/
    
    
})