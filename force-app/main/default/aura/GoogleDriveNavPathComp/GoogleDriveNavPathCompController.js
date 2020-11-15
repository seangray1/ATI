({
    openFolder : function(component, event, helper) {
        component.set("v.spinner", true);
        let sourceField;
        if(event.getSource){
            sourceField = event.getSource();
        }
        let folderName;
        let folderRef;
        if(sourceField.get('v.label') !== null){
           folderName = sourceField.get('v.label');
        }
        if(sourceField.get('v.value') !== null){
           folderRef = sourceField.get('v.value');
        }
        let showFolderContentForNavPathClickEvent = component.getEvent("LoadFolderContentForNavPathClickEvent");
        showFolderContentForNavPathClickEvent.setParams({
            "folderGDId" : folderRef,
            "folderName" : folderName
        });
        showFolderContentForNavPathClickEvent.fire();
        window.setTimeout(
            $A.getCallback(function() {
                component.set("v.spinner", false);
            }), 1000
        );
    },
    reloadCurrentFolderContents : function(component) {
        let reloadCurrentFolderContentsEvent = component.getEvent("RefreshCurrentFolderContent");
        reloadCurrentFolderContentsEvent.fire();
    },
    openJobInGoogleDrive : function(component, event, helper) {
        let googleDriveLink = component.get("v.googleDriveLinkForRec");
        let urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": googleDriveLink
        });
        urlEvent.fire();
    },
})