({
    handleShare: function(component, event, helper) {
        var SharingGLink = event.getSource().get('v.name');
        var SharingGLinkFileName = event.getSource().get('v.value');
        component.set("v.GDriveLink", SharingGLink);
        component.set("v.SharingGLinkFileName", SharingGLinkFileName);
        if(SharingGLink!=''){
            component.set('v.ShareOptions', true);
        }
    },
    
    //When sub-folder is clicked, fire an event with sub-folder GD id.
    openSubFolder : function(component, event, helper) {
        component.set("v.spinner", true); 
        console.log('Inside Opensub in js sff');
        var folderName = event.currentTarget.getAttribute("title");
        var googleDriveId = event.currentTarget.getAttribute("id");
        
        var showSubFolderContentEvent = component.getEvent("LoadSubFolderContentEvent");
        showSubFolderContentEvent.setParams({
            "folderGDId" : googleDriveId,
            "folderName" : folderName
        });
        
        component.set("v.selectedRowList", []); 
        showSubFolderContentEvent.fire();
        window.setTimeout(
            $A.getCallback(function() {
                component.set("v.spinner", false); 
            }), 1000
        );
    },
    
    //When a file is clicked, fire an event and open the file in Google drive.
    openFile : function(component, event, helper) {
        component.set("v.spinner", true); 
        var urlAddress = event.currentTarget.getAttribute("id");
        console.log('URL- ' + urlAddress);
        
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": urlAddress
        });
        urlEvent.fire();
        
        window.setTimeout(
            $A.getCallback(function() {
                component.set("v.spinner", false); 
            }), 1000
        );
    },
    
    updateSelectedRowsList : function(component, event, helper) {
        component.set("v.spinner", true); 
        
        var sourceField = event.getSource(); ; 
        var googleDriveRef = sourceField.get('v.name');
        var checkBoxValue = sourceField.get('v.checked');
        
        var fileDetails = [];
        fileDetails = helper.getSelectedFileDetails(component, googleDriveRef);
        console.log('*****' + fileDetails);
        
        //Update the lists for use in other comps
        var selectedRowList = component.get("v.selectedRowList");
        var selectedRowDetailsMap = component.get("v.selectedRowDetailsMap");
        //console.log(selectedRowList);
        //console.log(selectedRowList.length);
        console.log(selectedRowDetailsMap);
        if(selectedRowList.length == 0){
            console.log('----- No recs-----');
            //component.set("v.DisableShare", true);
            selectedRowList = [];
            selectedRowDetailsMap = [];
            if(checkBoxValue == true){
                selectedRowList.push(googleDriveRef);
                selectedRowDetailsMap.push({value:fileDetails, key:googleDriveRef});
            }
                
        }
        else{
            console.log('----------');
            if(checkBoxValue == true){
                console.log('----Last1-----');
                selectedRowList.push(googleDriveRef);
                selectedRowDetailsMap.push({value:fileDetails, key:googleDriveRef});
            }
            else{
                console.log('----'+selectedRowList.length+'-----');
                var indexForItemToBeRemoved = -1;
                for(var i=0; i< selectedRowList.length; i++){
                    if(selectedRowList[i] == googleDriveRef){
                        indexForItemToBeRemoved = i;
                        break;
                    }
                }
                
                if(indexForItemToBeRemoved >= 0){
                    selectedRowList.splice(indexForItemToBeRemoved, 1);
                    selectedRowDetailsMap.splice(indexForItemToBeRemoved, 1);
                }
                if(selectedRowList.length == 0){
                    component.set("v.DisableShare", false);
                }
            }
        }
        
        component.set("v.selectedRowList", selectedRowList); 
        component.set("v.selectedRowDetailsMap", selectedRowDetailsMap); 
        //console.log('******');
        //console.log(selectedRowList);
        
        /*for(var i=0; i< selectedRowDetailsMap.length; i++){
            console.log(selectedRowDetailsMap[i].value);
        }*/
        var updateSelRowListEvent = component.getEvent("UpdateSelectedRowListEvent");
        updateSelRowListEvent.setParams({
            "selectedRowList" : selectedRowList,
            "selectedRowDetailsMap" : selectedRowDetailsMap
        });
        updateSelRowListEvent.fire();
        
        component.set("v.spinner", false); 
    },
    
     /*
    updateSelectedRowsList : function(component, event, helper) {
        component.set("v.spinner", true); 
        
        var sourceField = event.getSource(); ; 
        var googleDriveRef = sourceField.get('v.name');
        var checkBoxValue = sourceField.get('v.checked');
        
        //Check if the selected row is for folder or file
        var isFolder = false;
        var folderFilesList = component.get("v.folderFilesList");
        for(var i=0; i< folderFilesList.length; i++){
            if(folderFilesList[i].googleDriveId == googleDriveRef){
                if(folderFilesList[i].isFolder == true)
                    isFolder = true;
            }
        }
        //console.log('*****' + isFolder);
        
        //Update the lists for use in other comps
        var selectedRowList = component.get("v.selectedRowList");
        var selectedRowDetailsMap = component.get("v.selectedRowDetailsMap");
        //console.log(selectedRowList);
        //console.log(selectedRowList.length);
        //console.log(selectedRowDetailsMap);
        if(selectedRowList.length == 0){
            console.log('----- No recs-----');
            selectedRowList = [];
            selectedRowDetailsMap = [];
            if(checkBoxValue == true){
                selectedRowList.push(googleDriveRef);
                selectedRowDetailsMap.push({value:isFolder, key:googleDriveRef});
            }
                
        }
        else{
            console.log('----------');
            if(checkBoxValue == true){
                selectedRowList.push(googleDriveRef);
                selectedRowDetailsMap.push({value:isFolder, key:googleDriveRef});
            }
            else{
                var indexForItemToBeRemoved = -1;
                for(var i=0; i< selectedRowList.length; i++){
                    if(selectedRowList[i] == googleDriveRef){
                        indexForItemToBeRemoved = i;
                        break;
                    }
                }
                
                if(indexForItemToBeRemoved >= 0){
                    selectedRowList.splice(indexForItemToBeRemoved, 1);
                    selectedRowDetailsMap.splice(indexForItemToBeRemoved, 1);
                }
            }
        }
        
        component.set("v.selectedRowList", selectedRowList); 
        component.set("v.selectedRowDetailsMap", selectedRowDetailsMap); 
        //console.log('******');
        //console.log(selectedRowList);
        
        
        var updateSelRowListEvent = component.getEvent("UpdateSelectedRowListEvent");
        updateSelRowListEvent.setParams({
            "selectedRowList" : selectedRowList,
            "selectedRowDetailsMap" : selectedRowDetailsMap
        });
        updateSelRowListEvent.fire();
        
        component.set("v.spinner", false); 
    },*/
    
})