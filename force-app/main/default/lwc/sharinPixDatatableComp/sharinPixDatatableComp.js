import { LightningElement, track, api } from 'lwc';

export default class SharinPixDatatableComp extends LightningElement {
    @api columns;//Columns to be displayed in datatable
    @api recordList = [];//Total records
    
    //Pagnitor related fields
    @track recordsToDisplay = []; //Records to be displayed on the page
    @track rowNumberOffset; //Row number
    @track preSelectedRows=[];// selected rows in datatable

    @track isLoading = false;//Used to display spinner
    //Capture the event fired from the paginator component when page is changed
    handlePaginatorChange(event) {
        this.isLoading = false;
        this.recordsToDisplay = event.detail;
        this.rowNumberOffset = this.recordsToDisplay[0].rowNumber - 1;
        
        this.preSelectedRows = [];//On page change, make selection empty
        //On page change, dispatch event to parent comp so that selection list can be set to empty there as well
        const pageChangedEvent = new CustomEvent('pagechange', { detail: '' });
        this.dispatchEvent(pageChangedEvent);
    }
    //For selected rows, fire the event to be captured by parent comp
    handleRowSelection(event) {
        console.log('Inside handleRowSelection');
        let selectedRows = event.detail.selectedRows;
        console.log('$$$$$$$$$' + selectedRows);
        const rowsSelectedEvent = new CustomEvent('rowsselectedformove', { detail: selectedRows });
        this.dispatchEvent(rowsSelectedEvent);
    }
}