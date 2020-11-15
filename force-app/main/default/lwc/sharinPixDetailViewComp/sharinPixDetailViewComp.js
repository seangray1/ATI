import { LightningElement, api, track } from 'lwc';

export default class SharinPixDetailViewComp extends LightningElement {
    @api sharinPixImageList;

    @track recordsToDisplay = []; //Records to be displayed on the page
    @track rowNumberOffset; //Row number
    @track SelectedImage = [];
    

    //Capture the event fired from the paginator component
    handlePaginatorChange(event) {
        console.log('Page change');
        this.recordsToDisplay = event.detail;
        this.rowNumberOffset = this.recordsToDisplay[0].rowNumber - 1;
        console.log('Page change 1');
        //As page is changed, refresh the selected images list in parent comp
        const pageChanged = new CustomEvent('pagechange', { detail: '' });
        this.dispatchEvent(pageChanged);
        console.log('Page change 2');
        
        // let allImages = this.template.querySelectorAll("lightning-input[data-my-id=rowChkBox]");
        // console.log('Page change 3' );
        // for (let i = 0; i < allImages.length; i++) {
        //     allImages[i].checked = false;
        // }


        //Code Change RP
        var AllRecord = JSON.parse(JSON.stringify(this.recordsToDisplay));
        AllRecord.map((obj) => {
            if(this.SelectedImage.includes(obj.sharinpix__ImagePublicId__c)){
                obj.checked=true;
            } else {
                obj.checked=false;
            }
            return obj;
        });
        this.recordsToDisplay = AllRecord;
        //this.sharinPixImageList = AllRecord;

        
        console.log('Page change'+JSON.stringify(this.recordsToDisplay));
    }

    //Fire an event  when image is selected, to be captured by parent comp
    handleImageSelChange(event) {
        let selectedSharinPixImageId = event.target.name;
        console.log('$$$$$ selectedSharinPixImageId-' + selectedSharinPixImageId);
        let imageSelected = event.target.checked;
        console.log('$$$$$ imageSelected-' + imageSelected);
        
        //Code Change RP
        if(imageSelected){
            this.SelectedImage.push(selectedSharinPixImageId);
        } else {
            var index = this.SelectedImage.indexOf(selectedSharinPixImageId);
            this.SelectedImage.splice(index, 1);
        }
        console.log('!Slected val: '+this.SelectedImage);
        //Code Change RP
        var AllRecord = JSON.parse(JSON.stringify(this.recordsToDisplay));
        AllRecord.map((obj) => {
            if(this.SelectedImage.includes(obj.sharinpix__ImagePublicId__c)){
                obj.checked=true;
            } else {
                obj.checked=false;
            }
            return obj;
        });
        this.recordsToDisplay = AllRecord;
        //Code Change RP

        //var detailToBePassed = { publicImageId: selectedSharinPixImageId, checked: imageSelected };
        var detailToBePassed = { publicImageId: this.SelectedImage, checked: imageSelected };
        const imageSelectEvent = new CustomEvent('imageselectedformove', { detail: detailToBePassed });
        this.dispatchEvent(imageSelectEvent);
    }
    
    //Fire an event  when all images on the current page are selected, to be captured by parent comp
    handleSelectAllChange(Event) {
        let selectAll = Event.detail;
        console.log('$$$$$ selectAll-' + selectAll);

        if (selectAll) {
            //this.SelectedImage=[];
            let allImages = this.template.querySelectorAll("lightning-input[data-my-id=rowChkBox]");
            console.log('$$$$$ allImages-' + allImages.length);
            for (let i = 0; i < allImages.length; i++) {
                this.SelectedImage.push(allImages[i].name);
                allImages[i].checked = true;
            }
        }
        else {
            //this.SelectedImage=[];
            let allImages = this.template.querySelectorAll("lightning-input[data-my-id=rowChkBox]");
            for (let i = 0; i < allImages.length; i++) {
                //this.SelectedImage.push(allImages[i].name);
                allImages[i].checked = false;
            }
        }
        //Code Change RP
        var AllRecord = JSON.parse(JSON.stringify(this.recordsToDisplay));
        AllRecord.map((obj) => {
            if(this.SelectedImage.includes(obj.sharinpix__ImagePublicId__c)){
                obj.checked=true;
            } else {
                obj.checked=false;
            }
            return obj;
        });
        this.recordsToDisplay = AllRecord;

        var detailToBePassed = { imageList: this.recordsToDisplay, checked: selectAll };
        const imageSelectAllEvent = new CustomEvent('allimageselectedformove', { detail: detailToBePassed });
        this.dispatchEvent(imageSelectAllEvent);
    }
}