({
    handleShare: function(component, event, helper) {
        let SharingGLink = event.getSource().get('v.name');
        let SharingGLinkFileName = event.getSource().get('v.value');
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
        let folderName = event.currentTarget.getAttribute("title");
        let googleDriveId = event.currentTarget.getAttribute("id");
        let showSubFolderContentEvent = component.getEvent("LoadSubFolderContentEvent");
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
        let urlAddress = event.currentTarget.getAttribute("id");
        console.log('URL- ' + urlAddress);
        let urlEvent = $A.get("e.force:navigateToURL");
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
        let sourceField = event.getSource();
        let googleDriveRef = sourceField.get('v.name');
        let checkBoxValue = sourceField.get('v.checked');
        let fileDetails = [];
        fileDetails = helper.getSelectedFileDetails(component, googleDriveRef);
        console.log('*****' + fileDetails);
        //Update the lists for use in other comps
        let selectedRowList = component.get("v.selectedRowList");
        let selectedRowDetailsMap = component.get("v.selectedRowDetailsMap");
        console.log(selectedRowDetailsMap);
        if(selectedRowList.length === 0){
            selectedRowList = [];
            selectedRowDetailsMap = [];
            if(checkBoxValue){
                selectedRowList.push(googleDriveRef);
                selectedRowDetailsMap.push({value:fileDetails, key:googleDriveRef});
            }
        }
        else{
            console.log('----------');
            if(checkBoxValue){
                selectedRowList.push(googleDriveRef);
                selectedRowDetailsMap.push({value:fileDetails, key:googleDriveRef});
            }
            else{
                let indexForItemToBeRemoved = -1;
                for(let i=0; i< selectedRowList.length; i++){
                    if(selectedRowList[i] === googleDriveRef){
                        indexForItemToBeRemoved = i;
                        break;
                    }
                }
                if(indexForItemToBeRemoved >= 0){
                    selectedRowList.splice(indexForItemToBeRemoved, 1);
                    selectedRowDetailsMap.splice(indexForItemToBeRemoved, 1);
                }
                if(selectedRowList.length === 0){
                    component.set("v.DisableShare", false);
                }
            }
        }
        component.set("v.selectedRowList", selectedRowList);
        component.set("v.selectedRowDetailsMap", selectedRowDetailsMap);
        let updateSelRowListEvent = component.getEvent("UpdateSelectedRowListEvent");
        updateSelRowListEvent.setParams({
            "selectedRowList" : selectedRowList,
            "selectedRowDetailsMap" : selectedRowDetailsMap
        });
        updateSelRowListEvent.fire();
        component.set("v.spinner", false);
    },
})