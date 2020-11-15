import { LightningElement, api, track } from 'lwc';
import TIMEZONE from '@salesforce/i18n/timeZone';

import getSharinPixImageList from '@salesforce/apex/SharinPixMoveImageControllerTest.getSharinPixImageList';
import moveSharinPixImagesToSelJob from '@salesforce/apex/SharinPixMoveImagesController.moveSharinPixImagesToSelJob';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'

//Columns to be shown in 'Detail View'
const columns = [
    {
        label: 'File name',
        fieldName: 'sharinpix__FileName__c',
        type: 'text',
        wrapText:true
    },
    {
        label: 'Date uploaded',
        fieldName: 'sharinpix__DateUploaded__c',
        type: 'date',
        wrapText:true,
        typeAttributes: {  
            day: 'numeric',  
            month: 'short',  
            year: 'numeric',  
            hour: '2-digit',  
            minute: '2-digit',  
            second: '2-digit',
            hour12: true,
            timeZone : TIMEZONE
        }

    },
    { label: 'Pic', fieldName: 'sharinpix__ImageURLFull__c', type: 'image' },
];

export default class MoveImageSharinpix extends LightningElement {
    @track isLoading = false;//Used to display spinner

    //Search criteria fields
    selectedUserId = '';//User selected in Search criteria
    startDate = '';
    endDate = '';
    targetJobId = '';//Sel Job to which all images will be moved to

    //Result related fields
    @track columns = columns; //Columns to be shown in 'Detail View'
    @track sharinPixImageList;// sharinPix Images list to be shown on result screen
    selectedSharinPixImagePublicIds = [];//Sel images which need to be moved to the sel job
    selectedViewType = 'thumbnailView';//Sel view type for display
    displayResult = false;//Display result boolean
    emptyResultMessage;//Message to be shown when search result is empty

    get viewOptions() {
        return [
            { label: 'Detail View', value: 'detailView' },
            { label: 'Thumbnail View', value: 'thumbnailView' }
        ];
    }
    get isThumbnailViewSel() {
        if (this.selectedViewType == 'thumbnailView')
            return true;
        else
            return false;
    }
    get isDetailViewSel() {
        if (this.selectedViewType == 'detailView')
            return true;
        else
            return false;
    }

    //Capture the event fired from the lookup component and store the sel user value.
    handleUserSelection(Event) {
        this.selectedUserId = Event.detail;
        console.log('$$$$$$$$$ Sel User Id' + this.selectedUserId);
    }
    //Store the sel start date value
    handleStartDateChange(event) {
        this.startDate = event.target.value;
        console.log('$$$$$$$$$ Sel start date' + this.startDate);
    }
    //Store the sel end date value
    handleEndDateChange(event) {
        this.endDate = event.target.value;
        console.log('$$$$$$$$$ Sel end date' + this.endDate);
    }
    //Search the SharinPix images for the search criteria
    handleSearch() {
        console.log('Inside Search');
        console.log('selectedUserId - ' + this.selectedUserId) ;
        console.log('startDate - ' + this.startDate) ;
        console.log('endDate - ' + this.endDate) ;
        this.isLoading = true;
        if ( (this.selectedUserId == '' || this.selectedUserId == 'undefined' || this.selectedUserId == undefined) &&  
        (this.startDate == '' || this.startDate == 'undefined' || this.startDate == undefined) && 
        (this.endDate == '' || this.endDate == 'undefined' || this.endDate == undefined)) {
            const event = new ShowToastEvent({
                variant: 'error',
                message: 'Please enter search criteria to move forward.'
            });
            this.dispatchEvent(event);
            this.isLoading = false;
            return;
        }
        this.sharinPixImageList = [];
        this.displayResult = false;

        getSharinPixImageList({
            selectedUserId: this.selectedUserId,
            //fileName: this.fileNameSearchText,
            startDate: this.startDate,
            endDate: this.endDate
        })
            .then(result => {
                console.log('Search done...');
						this.emptyResultMessage = '';
                let resultList = result;
								console.log('resultList -' + resultList.length);
                if (resultList.length != 0) {
										console.log('1');
                    this.sharinPixImageList = result;
										console.log('2');
                    this.displayResult = true;
										console.log('3');
                }
                else {
                    this.sharinPixImageList = [];
                    this.displayResult = false;
                    this.emptyResultMessage = 'No result found.'
                    const event = new ShowToastEvent({
                        title: 'Error',
                        variant: 'error',
                        message: 'No Images match your search criteria.',
                    });
                    this.dispatchEvent(event);
                }
                this.isLoading = false;
                console.log('$$$$$$$$$ Returned Result');
                console.log(this.sharinPixImageList.length);
            })
            .catch(error => {
                console.log('$$$$$$$$$ Errorr');
                // display server exception in toast msg 
                const event = new ShowToastEvent({
                    title: 'Error',
                    variant: 'error',
                    message: error.body.message,
                });
                this.dispatchEvent(event);
                // reset contacts var with null   
                this.sharinPixImageList = [];
                this.isLoading = false;
            });
    }

    //Display result as per the view selected
    handleViewChange(event) {
        this.selectedViewType = event.detail.value;
        console.log('$$$$$$$$$ Sel View Type-' + this.selectedViewType);
        this.selectedSharinPixImagePublicIds = [];
    }

    //Capture the event fired from the datatable component and store all selected images public id on Detail View
    handleRowSelectionOnDetailView(Event) {
        let selectedRows = Event.detail;
        console.log('$$$$$$$$$ Sel rows' + selectedRows.length);
        
        this.selectedSharinPixImagePublicIds=[];
        for (let i = 0; i < selectedRows.length; i++) {
            console.log(selectedRows[i].sharinpix__FileName__c);
            this.selectedSharinPixImagePublicIds.push(selectedRows[i].sharinpix__ImagePublicId__c);
        }
        console.log('$$$$$$$$$ selectedSharinPixImages-' + this.selectedSharinPixImagePublicIds);
    }

    //Capture the event fired from the thumnail component and store all selected images public id on Thumnail View
    handleImageSelectionOnThumbnailView(Event) {
        console.log('Inside Parent comp1');
        let selectedSharinPixImageId = Event.detail.publicImageId;
        console.log('$$$$$ variable1-' + selectedSharinPixImageId);
        console.log('$$$$$ variable2-' + Event.detail.checked);

        if (Event.detail.checked == true) {
            console.log('$$$$$ Checked');
            this.selectedSharinPixImagePublicIds.push(selectedSharinPixImageId);
        }
        else {
            console.log('$$$$$ Unchecked');
            console.log('$$$$$ this.selectedSharinPixImagePublicIds.length-' + this.selectedSharinPixImagePublicIds.length);
            for (let i = 0; i < this.selectedSharinPixImagePublicIds.length; i++) {
                if (this.selectedSharinPixImagePublicIds[i] == selectedSharinPixImageId) {
                    var indexForItemToBeRemoved = this.selectedSharinPixImagePublicIds.indexOf(selectedSharinPixImageId);
                    this.selectedSharinPixImagePublicIds.splice(indexForItemToBeRemoved, 1);
                    console.log('$$$$$ this.selectedSharinPixImagePublicIds.length-' + this.selectedSharinPixImagePublicIds.length);
                    break;
                }
            }
        }
        console.log('$$$$$$$$$ selectedSharinPixImages-' + this.selectedSharinPixImagePublicIds);
    }

    //Capture the event fired from the thumnail component and store all selected images public id on Thumnail View for "Select All" button
    handleSelectAllOnThumbnailView(Event) {
        console.log('Inside Parent comp2');
        let selectedSharinPixImageList = Event.detail.imageList;
        console.log('$$$$$ variable1-' + selectedSharinPixImageList.length);
        console.log('$$$$$ variable1-' + selectedSharinPixImageList[0].sharinpix__ImagePublicId__c);
        console.log('$$$$$ variable2-' + Event.detail.checked);

        this.selectedSharinPixImagePublicIds = [];
        if(Event.detail.checked ==  false)
            return;
            
        for (let i = 0; i < selectedSharinPixImageList.length; i++) {
            this.selectedSharinPixImagePublicIds.push(selectedSharinPixImageList[0].sharinpix__ImagePublicId__c);
        }
        console.log('$$$$$$$$$ selectedSharinPixImages-' + this.selectedSharinPixImagePublicIds);
        console.log('$$$$$$$$$ selectedSharinPixImages size-' + this.selectedSharinPixImagePublicIds.length);
    }

    //Capture the event fired from the thumnail component and empty selected images list
    handlePageChangeOnView(Event) {
        console.log('Inside Parent comp Page changed');
        this.selectedSharinPixImagePublicIds = [];
        console.log('$$$$$$$$$ selectedSharinPixImages-' + this.selectedSharinPixImagePublicIds);
    }

    //Capture the event fired from lookup component and store the Job selected
    handleTargetJobSelection(Event) {
        this.targetJobId = Event.detail;
        console.log('$$$$$$$$$ Sel Traget Job Id-' + this.targetJobId);
    }
    //Move the selected images to the selected Job
    handleImagesMove() {
        this.isLoading = true;
        if (this.selectedSharinPixImagePublicIds == '' || this.selectedSharinPixImagePublicIds == 'undefined' || this.selectedSharinPixImagePublicIds == undefined) {
            const event = new ShowToastEvent({
                variant: 'error',
                message: 'Please select atleast one image for move.',
            });
            this.dispatchEvent(event);
            this.isLoading = false;
            return;
        }
        if (this.targetJobId == '' || this.targetJobId == 'undefined' || this.targetJobId == undefined) {
            const event = new ShowToastEvent({
                variant: 'error',
                message: 'Please select Job to which image(s) need to be moved.',
            });
            this.dispatchEvent(event);
            this.isLoading = false;
            return;
        }

        moveSharinPixImagesToSelJob({
            selectedSharinPixImagePublicIds: JSON.stringify(this.selectedSharinPixImagePublicIds),
            targetJobId: this.targetJobId
        })
            .then(result => {
                this.displayResult = false;// To hide the search results once move is done.
                console.log('$$$$$$$$$ Inside Result');
                const event = new ShowToastEvent({
                    title: 'Success',
                    variant: 'success',
                    message: 'The images have been successfully moved to the selected Job',
                });
                this.dispatchEvent(event);
                this.selectedSharinPixImagePublicIds = [];
                //this.handleSearch(event);
                this.isLoading = false;
            })
            .catch(error => {
                // display server exception in toast msg 
                const event = new ShowToastEvent({
                    title: 'Error',
                    variant: 'error',
                    message: error.body.message,
                });
                this.dispatchEvent(event);
                this.isLoading = false;
                // reset contacts var with null   
            });
    }
}