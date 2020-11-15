import { LightningElement, wire, api,track } from 'lwc';
import updateOpportunityAddress from '@salesforce/apex/LeadOppConversion.updateOpportunityAddress';
import getBDRecordTypeId from '@salesforce/apex/LeadOppConversion.GetBDRecordTypeId';
import { NavigationMixin } from "lightning/navigation";
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import ACCOUNT_OBJECT from '@salesforce/schema/Opportunity';
export default class NewOpportunityLWC extends NavigationMixin(LightningElement) {
    PageStateReady = false;
    opportunityId;
    Street;
    Zipcode;
    State;
    Country;
    City;
    AddressLine2;
    recordtypeid;
    loading = false;
    @api objectApiName;

    @track objectInfo;

    @wire(getObjectInfo, { objectApiName: ACCOUNT_OBJECT })
    objectInfo;

    
    connectedCallback()
    {
        getBDRecordTypeId({}).then(result =>{
            this.recordtypeid = result;
        })
        this.PageStateReady = true;
    }
    HandleOpportunitySuccess(event)
    {
        this.opportunityId = event.detail.id;
        
        const address = this.template.querySelector('[data-id="AddressLookup"]');
            const isValid = address.checkValidity();
             if(isValid) {
                this.Street = address.street;
                this.City = address.city;
                this.State = address.province;
                this.Zipcode = address.postalCode;
                this.Country = address.country;
                
             }
             updateOpportunityAddress({recordId : this.opportunityId, Street:this.Street, City:this.City, State:this.State, Zipcode:this.Zipcode, AddressLine2:this.AddressLine2 });
             this[NavigationMixin.Navigate]({
                type: "standard__recordPage",
                attributes: {
                  recordId: this.opportunityId,
                  objectApiName: "Opportunity",
                  actionName: "view"
                }
              });
             
    }
    HandleOnSubmit(event)
    {
        this.loading = true;
        console.log('Sending data');
        event.preventDefault(); 
        let fields = event.detail.fields;
        
        console.log('FIelds ' + JSON.stringify(fields));
        console.log('FIelds ',fields);

        const address = this.template.querySelector('[data-id="AddressLookup"]');
            const isValid = address.checkValidity();
             if(isValid) {
                fields.Lead_Converted_Opportunity__c = true;
                console.log('fields name is ' + JSON.stringify(fields.Name));
               
                fields.Job_Name__c = fields.Name;
                console.log('fields Job Name is ' + JSON.stringify(fields.Job_Name__c));
                this.template.querySelector('lightning-record-edit-form').submit(fields);
                
             }
             else{
                console.log('Not valid');
                 this.loading = false;
                 alert('Address must be filled out');
             }
             
    }
    HandleOpportunityError(e){
        window.console.log('Not working ' + e);
    }
}