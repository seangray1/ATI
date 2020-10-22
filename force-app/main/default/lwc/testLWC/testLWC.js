import { LightningElement,track } from 'lwc';

export default class TestLWC extends LightningElement {
    MAX_FILE_SIZE = 5000000; //Max file size 5.0 MB
    filesUploaded = [];
    file;
    fileContents;
    fileReader;
    content;
    FilesChanged = false;
    @track Files = [];

    handleRemove(e){
        console.log('Handle remove ' + e);
    }
    handleClick(e){
        console.log('Handle remove ' + JSON.stringify(e));
    }
    handleFilesChange(event){
        if (event.target.files.length > 0) {
            let files = [];
            for(var i=0; i< event.target.files.length; i++){
                let file = event.target.files[i];
                let reader = new FileReader();
                reader.onload = e => {
                    let base64 = 'base64,';
                    let content = reader.result.indexOf(base64) + base64.length;
                    let fileContents = reader.result.substring(content);
                    console.log('Files before ',this.Files);
                    this.Files.push({PathOnClient: file.name, Title: file.name, VersionData: fileContents});
                    console.log('Files after ',this.Files);
                    this.FilesChanged = true;
                };
                reader.readAsDataURL(file);
            }
        }
    }
}