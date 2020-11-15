import lookUp from '@salesforce/apex/CustomLookupController.search';
import { api, LightningElement, track, wire } from 'lwc';

export default class customLookUp extends LightningElement {

    @api isLoading = false;
    @api objName;//Lookup obj name
    @api iconName;
    @api fieldLabel;
    @api searchPlaceholder = 'Search';

    @track selectedName;
    @track records;
    @track isValueSelected;
    @track blurTimeout;

    searchTerm;//
    //css
    @track boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus';
    @track inputClass = '';

    @wire(lookUp, { searchTerm: '$searchTerm', objToBeSearched: '$objName' })
    wiredRecords({ error, data }) {
        this.isLoading = true;
        if (data) {
            this.error = undefined;
            this.isLoading = false;
            this.records = data;
        } else if (error) {
            this.error = error;
            this.records = undefined;
        }
    }

    handleClick() {
        this.searchTerm = '';
        this.selectedName = '';
        this.inputClass = 'slds-has-focus';
        this.boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus slds-is-open';
    }

    onBlur() {
        this.blurTimeout = setTimeout(() => { this.boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus' }, 300);
    }

    onSelect(event) {
        let selectedId = event.currentTarget.dataset.id;
        let selectedName = event.currentTarget.dataset.name;
        const valueSelectedEvent = new CustomEvent('lookupselected', { detail: selectedId });
        this.dispatchEvent(valueSelectedEvent);
        this.isValueSelected = true;
        this.selectedName = selectedName;
        this.searchTerm = this.selectedName;
        if (this.blurTimeout) {
            clearTimeout(this.blurTimeout);
        }
        this.boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus';
    }

    onChange(event) {
        console.log('Lookup changed');
        this.searchTerm = event.target.value;
        console.log('Lookup changed - ' + this.searchTerm);

        const valueSelectedEvent = new CustomEvent('lookupselected', { detail: '' });
        this.dispatchEvent(valueSelectedEvent);
    }

}