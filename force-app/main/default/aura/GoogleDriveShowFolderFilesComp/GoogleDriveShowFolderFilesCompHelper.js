({
	getSelectedFileDetails : function(component, googleDriveRef) {
        var fileDetails = [];
		
        var folderFilesList = component.get("v.folderFilesList");
        for(var i=0; i< folderFilesList.length; i++){
            if(folderFilesList[i].googleDriveId == googleDriveRef){
                fileDetails.push(folderFilesList[i].name);
                fileDetails.push(folderFilesList[i].mimeType);
                fileDetails.push(folderFilesList[i].isFolder);
            }
        }
        return fileDetails;
	},
})