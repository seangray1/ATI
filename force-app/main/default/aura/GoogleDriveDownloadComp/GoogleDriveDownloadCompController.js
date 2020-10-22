({
    openConfirmationPopUp : function(component, event, helper) {
        var selectedRowDetailsMap = component.get("v.selectedRowDetailsMap");
        var downloadFolderName = component.get("v.currentFolderName");
        var mapToSend = {};
        //Parse selectedRowDetailsMap and add to mapToSend
        for(var i=0; i< selectedRowDetailsMap.length; i++){
            mapToSend[selectedRowDetailsMap[i].key] = selectedRowDetailsMap[i].value;
        }
        
        helper.redirectUserToDownloadPage(component, downloadFolderName, mapToSend, component.get("v.includeSubFolders"));
        component.set("v.isConfirmModalOpen", false);
        
    },
    
    /*
    openConfirmationPopUp : function(component, event, helper) {
        var selectedRowDetailsMap = component.get("v.selectedRowDetailsMap");
        var downloadFolderName = component.get("v.currentFolderName");
        console.log(selectedRowDetailsMap[0].value);
        
        if(selectedRowDetailsMap.length == 1 && selectedRowDetailsMap[0].value[2] == false){
            console.log('Only 1 file selected for download.');
            //Parse selectedRowDetailsMap and add to mapToSend
            var mapToSend = {};
            for(var i=0; i< selectedRowDetailsMap.length; i++){
                mapToSend[selectedRowDetailsMap[i].key] = selectedRowDetailsMap[i].value;
            }
            helper.redirectUserToDownloadPage(component, downloadFolderName, mapToSend, false);
            
        }
        else{
            console.log('Multiple files/folders selected for download');
            
            helper.getTotalSizeAndNoOfFilesToBeDownloaded(component);
            
            var allFilesSelected = helper.checkIfOnlyFilesSelectedForDownlaod(component, selectedRowDetailsMap);
            console.log('Are allFilesSelected -' + allFilesSelected);
            component.set("v.allFilesSelected", allFilesSelected);
            if(allFilesSelected == true)
                return;
            
            var allFoldersSelected = helper.checkIfOnlyFoldersSelectedForDownlaod(component, selectedRowDetailsMap);
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
        var selectedRowDetailsMap = component.get("v.selectedRowDetailsMap");
        var downloadFolderName = component.get("v.currentFolderName");
        var mapToSend = {};
        //Parse selectedRowDetailsMap and add to mapToSend
        for(var i=0; i< selectedRowDetailsMap.length; i++){
            mapToSend[selectedRowDetailsMap[i].key] = selectedRowDetailsMap[i].value;
        }
        console.log('***' + component.get("v.includeSubFolders"));
        helper.redirectUserToDownloadPage(component, downloadFolderName, mapToSend, component.get("v.includeSubFolders"));
        //helper.downloadTest(component, downloadFolderName, mapToSend, component.get("v.includeSubFolders"));
        component.set("v.isConfirmModalOpen", false);
    }*/
})