({
    openJobInGoogleDrive : function(component, event, helper) {
        let googleDriveLink = component.get("v.googleDriveLinkForRec");
        let urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": googleDriveLink
        });
        urlEvent.fire();
    },
    /*
    openConfirmationPopUp : function(component, event, helper) {
        let selectedRowDetailsMap = component.get("v.selectedRowDetailsMap");
        let downloadFolderName = component.get("v.currentFolderName");
        let mapToSend = {};
        //Parse selectedRowDetailsMap and add to mapToSend
        for(let i=0; i< selectedRowDetailsMap.length; i++){
            mapToSend[selectedRowDetailsMap[i].key] = selectedRowDetailsMap[i].value;
        }
        
        helper.redirectUserToDownloadPage(component, downloadFolderName, mapToSend, component.get("v.includeSubFolders"));
        component.set("v.isConfirmModalOpen", false);
    },*/
    /*
    openConfirmationPopUp : function(component, event, helper) {
        let selectedRowDetailsMap = component.get("v.selectedRowDetailsMap");
        let downloadFolderName = component.get("v.currentFolderName");
        console.log(selectedRowDetailsMap[0].value);
        if(selectedRowDetailsMap.length == 1 && selectedRowDetailsMap[0].value[2] == false){
            console.log('Only 1 file selected for download.');
            //Parse selectedRowDetailsMap and add to mapToSend
            let mapToSend = {};
            for(let i=0; i< selectedRowDetailsMap.length; i++){
                mapToSend[selectedRowDetailsMap[i].key] = selectedRowDetailsMap[i].value;
            }
            helper.redirectUserToDownloadPage(component, downloadFolderName, mapToSend, false);
        }
        else{
            console.log('Multiple files/folders selected for download');
            helper.getTotalSizeAndNoOfFilesToBeDownloaded(component);
            let allFilesSelected = helper.checkIfOnlyFilesSelectedForDownlaod(component, selectedRowDetailsMap);
            console.log('Are allFilesSelected -' + allFilesSelected);
            component.set("v.allFilesSelected", allFilesSelected);
            if(allFilesSelected == true)
                return;
            let allFoldersSelected = helper.checkIfOnlyFoldersSelectedForDownlaod(component, selectedRowDetailsMap);
            console.log('Are allFoldersSelected -' + allFoldersSelected);
            component.set("v.allFoldersSelected", allFoldersSelected);
        }
    },*/
    /*
    closeConfirmationPopUp : function(component, event, helper){
        component.set("v.isConfirmModalOpen", false);
    },*/
    /*
    handleDownload : function(component, event, helper){
        let selectedRowDetailsMap = component.get("v.selectedRowDetailsMap");
        let downloadFolderName = component.get("v.currentFolderName");
        let mapToSend = {};
        //Parse selectedRowDetailsMap and add to mapToSend
        for(let i=0; i< selectedRowDetailsMap.length; i++){
            mapToSend[selectedRowDetailsMap[i].key] = selectedRowDetailsMap[i].value;
        }
        console.log('***' + component.get("v.includeSubFolders"));
        helper.redirectUserToDownloadPage(component, downloadFolderName, mapToSend, component.get("v.includeSubFolders"));
        //helper.downloadTest(component, downloadFolderName, mapToSend, component.get("v.includeSubFolders"));
        component.set("v.isConfirmModalOpen", false);
    }*/
})