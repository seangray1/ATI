import { LightningElement, api, track } from 'lwc';

export default class SharinPixThumbnailViewComp extends LightningElement {
    @api sharinPixImageList;

    @track recordsToDisplay = []; //Records to be displayed on the page
    @track rowNumberOffset; //Row number

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
        
        let allImages = this.template.querySelectorAll("lightning-input[data-my-id=rowChkBox]");
        console.log('Page change 3');
        for (let i = 0; i < allImages.length; i++) {
            allImages[i].checked = false;
        }
        console.log('Page change');
    }

    //Fire an event  when image is selected, to be captured by parent comp
    handleImageSelChange(event) {
        let selectedSharinPixImageId = event.target.name;
        console.log('$$$$$ selectedSharinPixImageId-' + selectedSharinPixImageId);
        let imageSelected = event.target.checked;
        console.log('$$$$$ imageSelected-' + imageSelected);

        var detailToBePassed = { publicImageId: selectedSharinPixImageId, checked: imageSelected };
        const imageSelectEvent = new CustomEvent('imageselectedformove', { detail: detailToBePassed });
        this.dispatchEvent(imageSelectEvent);
    }
    
    //Fire an event  when all images on the current page are selected, to be captured by parent comp
    handleSelectAllChange(Event) {
        let selectAll = Event.detail;
        console.log('$$$$$ selectAll-' + selectAll);

        if (selectAll) {
            let allImages = this.template.querySelectorAll("lightning-input[data-my-id=rowChkBox]");
            console.log('$$$$$ allImages-' + allImages.length);
            for (let i = 0; i < allImages.length; i++) {
                allImages[i].checked = true;
            }
        }
        else {
            let allImages = this.template.querySelectorAll("lightning-input[data-my-id=rowChkBox]");
            for (let i = 0; i < allImages.length; i++) {
                allImages[i].checked = false;
            }
        }
        var detailToBePassed = { imageList: this.recordsToDisplay, checked: selectAll };
        const imageSelectAllEvent = new CustomEvent('allimageselectedformove', { detail: detailToBePassed });
        this.dispatchEvent(imageSelectAllEvent);
    }
}