({
    openFolder : function(component, event, helper) {
        component.set("v.spinner", true); 
        
        var sourceField; 
        if(event.getSource){
            sourceField = event.getSource(); 
        }
        var folderName = sourceField.get('v.label');
        var folderRef = sourceField.get('v.value');
        
        var showFolderContentForNavPathClickEvent = component.getEvent("LoadFolderContentForNavPathClickEvent");
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
        var reloadCurrentFolderContentsEvent = component.getEvent("RefreshCurrentFolderContent");
        reloadCurrentFolderContentsEvent.fire();
    },
})