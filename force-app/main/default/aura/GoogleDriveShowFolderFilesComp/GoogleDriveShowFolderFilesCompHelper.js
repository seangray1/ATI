({
	getSelectedFileDetails : function(component, googleDriveRef) {
        let fileDetails = [];
        let folderFilesList = component.get("v.folderFilesList");
        for(let i=0; i< folderFilesList.length; i++){
            if(folderFilesList[i].googleDriveId === googleDriveRef){
                fileDetails.push(folderFilesList[i].name);
                fileDetails.push(folderFilesList[i].mimeType);
                fileDetails.push(folderFilesList[i].isFolder);
            }
        }
        return fileDetails;
	},
})