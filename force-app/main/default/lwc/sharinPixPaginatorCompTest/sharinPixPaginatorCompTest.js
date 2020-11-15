import { LightningElement, api, track } from 'lwc';

const DELAY = 300;
const recordsPerPage = [50,20,10,5];
const pageNumber = 1;
const showIt = 'visibility:visible';
const hideIt = 'visibility:hidden'; //visibility keeps the component space, but display:none doesn't

export default class SharinPixPaginatorComp extends LightningElement {
    @api showSearchBox = false; //Show/hide search box; valid values are true/false
    @api showPagination; //Show/hide pagination; valid values are true/false
    @api pageSizeOptions = recordsPerPage; //Page size options; valid values are array of integers
    @api totalRecords; //Total no.of records; valid type is Integer
    @api records; //All records available in the data table; valid type is Array 
    @track pageSize; //No.of records to be displayed per page
    @track totalPages; //Total no.of pages
    @track pageNumber = pageNumber; //Page number
    @track searchKey; //Search Input
    @track controlPagination = showIt;
    @track controlPrevious = hideIt; //Controls the visibility of Previous page button
    @track controlNext = showIt; //Controls the visibility of Next page button
    recordsToDisplay = []; //Records to be displayed on the page
    @api showSelectAll = false;

    //Called after the component finishes inserting to DOM
    @api
    connectedCallback() {
        if (this.pageSizeOptions && this.pageSizeOptions.length > 0)
            this.pageSize = this.pageSizeOptions[0];
        else {
            this.pageSize = this.totalRecords;
            this.showPagination = false;
        }
        this.controlPagination = this.showPagination === false ? hideIt : showIt;
        this.setRecordsToDisplay();
    }

    handleRecordsPerPage(event) {
        this.pageSize = event.target.value;
        this.setRecordsToDisplay();
    }
    handlePageNumberChange(event) {
        if (event.keyCode === 13) {
            this.pageNumber = event.target.value;
            this.setRecordsToDisplay();
        }
    }
    previousPage() {
        this.pageNumber = this.pageNumber - 1;
        this.setRecordsToDisplay();
    }
    nextPage() {
        this.pageNumber = this.pageNumber + 1;
        this.setRecordsToDisplay();
    }
    setRecordsToDisplay() {
        console.log('$$$$@ Page change');
        //As page is changed, deselect 'Select All' button on new page
        //let selectAllChkbox = this.template.querySelector("lightning-input[data-my-id=selectAllChkBox]");
        
        /*if(null != selectAllChkbox){
            console.log('$$$$$$ selectAllChkbox - ' + selectAllChkbox.checked);
            selectAllChkbox.checked = false;
        }*/
        console.log('$$$$@ 1');
        this.recordsToDisplay = [];
        if (!this.pageSize)
            this.pageSize = this.totalRecords;
				
				console.log('$$$$@ 2');
        this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
				console.log('$$$$@ 3' + this.totalPages);
        this.setPaginationControls();
				console.log('$$$$@ 4');
        // for (let i = (this.pageNumber - 1) * this.pageSize; i < this.pageNumber * this.pageSize; i++) {
        //     console.log('$$$ i - ' + i);
        //     if (i === this.totalRecords) break;
        //     console.log('$$$ Yes add record. ');
        //     this.recordsToDisplay.push(this.records[i]);
        // }
        this.recordsToDisplay = this.records;
        this.dispatchEvent(new CustomEvent('paginatorchange', { detail: this.recordsToDisplay })); //Send records to display on table to the parent component
    }
    setPaginationControls() {
        //Control Pre/Next buttons visibility by Total pages
        if (this.totalPages === 1) {
            this.controlPrevious = hideIt;
            this.controlNext = hideIt;
        } else if (this.totalPages > 1) {
            this.controlPrevious = showIt;
            this.controlNext = showIt;
        }
        //Control Pre/Next buttons visibility by Page number
        if (this.pageNumber <= 1) {
            this.pageNumber = 1;
            this.controlPrevious = hideIt;
        } else if (this.pageNumber >= this.totalPages) {
            this.pageNumber = this.totalPages;
            this.controlNext = hideIt;
        }
        //Control Pre/Next buttons visibility by Pagination visibility
        if (this.controlPagination === hideIt) {
            this.controlPrevious = hideIt;
            this.controlNext = hideIt;
        }
    }
    handleKeyChange(event) {
        window.clearTimeout(this.delayTimeout);
        const searchKey = event.target.value;
        if (searchKey) {
            this.delayTimeout = setTimeout(() => {
                this.controlPagination = hideIt;
                this.setPaginationControls();

                this.searchKey = searchKey;
                //Use other field name here in place of 'Name' field if you want to search by other field
                //this.recordsToDisplay = this.records.filter(rec => rec.includes(searchKey));
                //Search with any column value (Updated as per the feedback)
                this.recordsToDisplay = this.records.filter(rec => JSON.stringify(rec).includes(searchKey));
                if (Array.isArray(this.recordsToDisplay) && this.recordsToDisplay.length > 0)
                    this.dispatchEvent(new CustomEvent('paginatorchange', { detail: this.recordsToDisplay })); //Send records to display on table to the parent component
            }, DELAY);
        } else {
            this.controlPagination = showIt;
            this.setRecordsToDisplay();
        }
    }

    //Fire an event  when Select All button is checked/unchecked, to be captured by thumnail comp
    handleSelectAllChange(event) {
        console.log('************* Inside Paginton comp');
        let selectAll = event.target.checked;
        console.log('$$$$$ selectAll-' + selectAll);

        const selectAllEvent = new CustomEvent('selectallchange', { detail: selectAll });
        this.dispatchEvent(selectAllEvent);
    }
}