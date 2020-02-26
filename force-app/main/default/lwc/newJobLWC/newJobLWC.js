/* eslint-disable vars-on-top */
/* eslint-disable no-console */
/* eslint-disable no-alert */
/**
 * @File Name          : newJobLWC.js
 * @Description        : 
 * @Author             : Sean Gray
 * @Group              : 
 * @Last Modified By   : Sean Gray
 * @Last Modified On   : 2/4/2020, 8:12:03 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    1/23/2020   Sean Gray     Initial Version
**/
import { LightningElement, track, wire } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
//import SearchAccountRoles from '@salesforce/apex/NewJobController.GetAccountRoles';
import InsertContact from '@salesforce/apex/NewJobController.InsertContact';
import InsertAccount from '@salesforce/apex/NewJobController.InsertAccount';
import InsertPersonAccount from '@salesforce/apex/NewJobController.InsertPersonAccount';
import SearchProperties from '@salesforce/apex/NewJobController.GetProperties';
import GetAccountRolesPicklist from '@salesforce/apex/NewJobController.getPickListValuesIntoList';
import GetDivisionPicklist from '@salesforce/apex/NewJobController.GetDivisionPicklist';
import GetJobClassPicklist from '@salesforce/apex/NewJobController.GetJobClassPicklist';
import GetEsJobTypePicklist from '@salesforce/apex/NewJobController.GetEsJobTypePicklist';
import GetLeadSourcePicklist from '@salesforce/apex/NewJobController.GetLeadSourcePicklist';
import GetMultipleDivisionPicklist from '@salesforce/apex/NewJobController.GetLeadSourcePicklist';
import SearchCustomers from '@salesforce/apex/NewJobController.GetCustomers';
import SearchContactAccounts from '@salesforce/apex/NewJobController.GetContactAccounts';
import SearchOffices from '@salesforce/apex/NewJobController.GetOffices';
import GetMasterJobs from '@salesforce/apex/NewJobController.GetMasterJobs';
import checkId from '@salesforce/apex/NewJobController.CheckId';
import CreateNewJob from '@salesforce/apex/NewJobController.CreateNewJob';
import { NavigationMixin } from 'lightning/navigation';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import ATIJOB_OBJECT from '@salesforce/schema/ATI_Job__c';
import MASTERJOB_OBJECT from '@salesforce/schema/Master_Job__c';
import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import CONTACT_OBJECT from '@salesforce/schema/Contact';
import PROPERTY_OBJECT from '@salesforce/schema/Property__c';
import ACCOUNTROLES_OBJECT from '@salesforce/schema/Account_Roles__c';
import ROLE_FIELD from '@salesforce/schema/Account_Roles__c.Roles__c';
import MULTIPLEDIVISION_FIELD from '@salesforce/schema/Master_Job__c.Multiple_Divisions__c';
import DIVISION_FIELD from '@salesforce/schema/ATI_Job__c.Division__c';
import JOBCLASS_FIELD from '@salesforce/schema/ATI_Job__c.Job_Class__c';
import ESTIMATETYPE_FIELD from '@salesforce/schema/ATI_Job__c.Estimate_Type__c';
import PROPERTYTYPE_FIELD from '@salesforce/schema/Property__c.Property_Type__c';
import CONTACTTYPE_FIELD from '@salesforce/schema/Contact.Contact_Type__c';
import TYPE_FIELD from '@salesforce/schema/Account.Type';
var ContactJSON;
var AccountJSON;
var PropertyJSON;
var JobJSON;
var AccountRolesPassed = false;
const DELAY = 600;
export default class NewJobLWC extends NavigationMixin(LightningElement) {
    @track activeSections = ['Customer Search', 'Additional Information', 'Account Roles', 'Property Information'];
@track PersonAccount = false;
@track jobLoading = false;
@track testingProperty;
@track ARContacts;
@track Properties;
@track Offices;
@track OfficeId;
@track OfficeValue;
@track ContactAccountRole; 
@track Customers;
@track CustomerValue;
@track CustomerPicked = false;
@track CustomerId; 
@track CustomerSelectedField;
@track ContactAccounts;
@track ContactAccountValue;
@track ContactAccountPicked = false;
@track ContactAccountSelected= false;
@track ContactAccountId;
@track ContactAccountName;
@track searchKey;
@track NewCaller = false;
@track NewAccount = false;
@track NewProperty = false;
@track PropertyID = "";
@track PropertyPicked = false;
@track AccountRoles = [{}];
@track AccountRolesSelected = false;
@track AccountRolesRecieved ='';
@track inputDisabled = true;
@track PropertySelected = false;
@track PropertySelectedField;
@track PropertyValue;
@track bShowModal = false;
@track MasterJobDetails;
@track MasterJobId;
@track ContactId;
@track ContactType;
@track FirstName;
@track LastName;
@track MailingStreet;
@track MailingCity;
@track MailingState;
@track MailingCounty;
@track AccountId = "";
@track MailingPostalCode;
@track Phone;
@track Email;
@track PhoneExt;
@track AccountName;
@track BillingStreet;
@track BillingCity;
@track BillingState;
@track BillingPostalCode;
@track Type;
@track BillingCountry;
@track AccountPhone;
@track AccountPhoneExt;
@track City;
@track Country;
@track State;
@track AddressLine1;
@track PropertyType = "";
@track Zip;
@track Description = "";
@track Division;
@track Office;
@track JobClass;
@track EstimateType;
@track Claim = "";
@track Deductible = "";
@track AccountRoleLineItems = [{}];
@track loading = false;
@track data;
@track ContactSelected = false;
@track AccountRole;
@track ContactRole;
@track CustomerAccountId;
@track CustomerAccountName;
@track AccountRolePicklistValuesContainer =[{}];
@track DivisionPicklistValues =[{}];
@track JobClassPicklistValues =[{}];
@track EsJobTypePicklistValues =[{}];
@track LeadSourcePicklistValues =[{}];
@track MultipleDivisionPicklistValues =[{}];
@track ARReady = false;
@track AccountRoles = [{}];
@track CreateContact = false;
@track AccountEmpty = true;
@track CreateNewContact = false;
@track PersonAccountModal = false;
@track AccountQuestion = false;
@track AccountLastName;
@track AccountFirstName;
@track newAccountRoles = false;
@track loadingContact = false;
@track loadingPersonAccount = false;
@track MultipleRoles;
@track MultRoleInd;
@track CompanyAccountRoles = "";
@track PersonAccountRoles = "";
@track TypeOfInsert = '';
@track JobName;
@track Division;
@track ARDivision = false;
@track EsJobType;
@track JobClass;
@track LeadSource;
@track DivisionEs = false;
@track MultipleDivision;
@track NotNewProperty = true;
@track AutoComplete = false;

@wire(getObjectInfo, { objectApiName: ACCOUNTROLES_OBJECT })
    objectInfo;
@wire(getObjectInfo, { objectApiName: ACCOUNT_OBJECT })
    accountInfo;
@wire(getObjectInfo, { objectApiName: CONTACT_OBJECT })
    contactInfo;
@wire(getObjectInfo, { objectApiName: PROPERTY_OBJECT })
    propertyInfo;
@wire(getObjectInfo, { objectApiName: MASTERJOB_OBJECT })
    masterjobInfo;
@wire(getObjectInfo, { objectApiName: ATIJOB_OBJECT })
    atijobInfo;
@wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: ROLE_FIELD})
AccountRolesValues;
@wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: ROLE_FIELD})
AccountRoleValues;
@wire(getPicklistValues, { recordTypeId: '0120g000000l3yMAAQ', fieldApiName: DIVISION_FIELD})
AtiJobDivisionValues;
@wire(getPicklistValues, { recordTypeId: '0120g000000l3yMAAQ', fieldApiName: JOBCLASS_FIELD})
AtiJobJobClassValues;
@wire(getPicklistValues, { recordTypeId: '0120g000000l3yM', fieldApiName: ESTIMATETYPE_FIELD})
AtiJobEstimateTypeValues;
@wire(getPicklistValues, { recordTypeId: '$accountInfo.data.defaultRecordTypeId', fieldApiName: TYPE_FIELD})
AccountTypeValues;
@wire(getPicklistValues, { recordTypeId: '$contactInfo.data.defaultRecordTypeId', fieldApiName: CONTACTTYPE_FIELD})
ContactTypeValues;
@wire(getPicklistValues, { recordTypeId: '$propertyInfo.data.defaultRecordTypeId', fieldApiName: PROPERTYTYPE_FIELD})
PropertyTypeValues;
@wire(getPicklistValues, { recordTypeId: '$masterjobInfo.data.defaultRecordTypeId', fieldApiName: MULTIPLEDIVISION_FIELD})
MultipleDivisionPicklistValues;


// get options() {
//     return [{ 
//         AccountRolesValues.data.values}];
// }
get options() {
    
    return this.DivisionPicklistValues;
}
ResetPropertyForm(){
    this.NotNewProperty = true;
    this.Street = '';
    this.City = '';
    this.State = '';
    this.Zip = '';
    this.Country = '';
    this.PropertyType = '';
}
closeProperty(){
    
        const input = [...this.template.querySelectorAll('.propertyFormControl')]
        .reduce((validSoFar, inputCmp) => {
                    inputCmp.reportValidity();
                    return validSoFar && inputCmp.checkValidity();
        }, true);
    if(!input){
        alert('Fill in all required fields before saving');
    }else{
    const address = this.template.querySelector('[data-id="AddressLookup"]');
            const isValid = address.checkValidity();
             if(isValid) {
                this.Street = address.street;
                this.City = address.city;
                this.State = address.province;
                this.Zip = address.postalCode;
                this.Country = address.country;
                this.NewProperty = false;
                this.NotNewProperty = false;
                const event = new ShowToastEvent({
                    title:'Success',
                    message: 'Saved',
                    variant: 'success',
                });
                this.dispatchEvent(event);
             }

            }
}

AccountPhoneChange(e){
    this.AccountPhone  = e.detail.value;
}
AccountPhoneExtChange(e){
    this.AccountPhoneExt  = e.detail.value;
}
AccountFirstNameChange(e){
    this.AccountFirstName  = e.detail.value;
}
AccountLastNameChange(e){
    this.AccountLastName  = e.detail.value;
}
MultipleDivisionChange(e){
    this.MultipleDivision = e.detail.value;
}
JobNameChange(e){
    this.JobName = e.detail.value;
}
closePropertyModal(){
    this.NewProperty = false;
}
NewAccountRoleSelected(event){
    var rowInd = event.target.parentNode.parentNode.parentNode.rowIndex;
    rowInd = rowInd - 1;
    this.MultRoleInd = rowInd;
    this.MultipleRoles = this.AccountRoles[this.MultRoleInd].Text__c;
    this.newAccountRoles = true;
}
CloseAccountRole(){
    this.newAccountRoles = false;
    this.MultRoleInd = '';
    this.MultipleRoles = '';
}
connectedCallback(){
    GetAccountRolesPicklist({}).then(result =>{
        var AccountRolePicklistValues = result;
        for(var i = 0; i<AccountRolePicklistValues.length;i++){
        
            this.AccountRolePicklistValuesContainer.push({label : AccountRolePicklistValues[i], value : AccountRolePicklistValues[i], });
        }   
        this.AccountRolePicklistValuesContainer.shift();
        this.ARReady = true;
        this.AccountRoles.push({Contact_ID__c : '', Account_ID__c :'', Text__c : ''});
        this.AccountRoles.shift();
    })
    GetDivisionPicklist({}).then(result =>{
        var AccountRolePicklistValues = result;
        for(var i = 0; i<AccountRolePicklistValues.length;i++){
            
            this.DivisionPicklistValues.push({label : AccountRolePicklistValues[i], value : AccountRolePicklistValues[i], });
        }
        
        this.DivisionPicklistValues.shift();
        this.ARDivision = true;
       
       
    })
    GetJobClassPicklist({}).then(result =>{
        var AccountRolePicklistValues = result;
        for(var i = 0; i<AccountRolePicklistValues.length;i++){
            
            this.JobClassPicklistValues.push({label : AccountRolePicklistValues[i], value : AccountRolePicklistValues[i], });
        }
        
        this.JobClassPicklistValues.shift();
    })
    GetEsJobTypePicklist({}).then(result =>{
        var AccountRolePicklistValues = result;
        for(var i = 0; i<AccountRolePicklistValues.length;i++){
            
            this.EsJobTypePicklistValues.push({label : AccountRolePicklistValues[i], value : AccountRolePicklistValues[i], });
        }
        
        this.EsJobTypePicklistValues.shift();
    })
    GetLeadSourcePicklist({}).then(result =>{
        var AccountRolePicklistValues = result;
        for(var i = 0; i<AccountRolePicklistValues.length;i++){
            
            this.LeadSourcePicklistValues.push({label : AccountRolePicklistValues[i], value : AccountRolePicklistValues[i], });
        }
        
        this.LeadSourcePicklistValues.shift();
    })
    
    // GetMultipleDivisionPicklist({}).then(result =>{
    //     var AccountRolePicklistValues = result;
    //     for(var i = 0; i<AccountRolePicklistValues.length;i++){
    //         console.log('Lenght is '+ AccountRolePicklistValues.length + '    values are ' + AccountRolePicklistValues[i] );
    //         this.MultipleDivisionPicklistValues.push({label : AccountRolePicklistValues[i], value : AccountRolePicklistValues[i], });
    //     }
        
    //     this.MultipleDivisionPicklistValues.shift();
    // })
}
closeAccountQuestion(){
    this.AccountQuestion = false;
}
saveMultipleRoles(){
    this.AccountRoles[this.MultRoleInd].Text__c = this.MultipleRoles;
    this.newAccountRoles = false;
    this.MultRoleInd = '';
    this.MultipleRoles = '';
}
AccountMultipleRoles(e){
    this.MultipleRoles = e.detail.value;
   
    
}
PersonAccountRolesChange(e){
    this.PersonAccountRoles = e.detail.value;
}
addAccountQuestion(){
    this.AccountQuestion = true;
}
PersonAccountClicked(){
    this.AccountQuestion = false;
    this.PersonAccountModal = true;
}
BusinessAccountClicked(){
    this.AccountQuestion = false;
    this.addAccount();
}
closePersonAccountModal(){
    this.PersonAccountModal = false;
    this.AccountId = "";
    this.AccountName = "";
    this.AccountLastName = "";
    this.AccountFirstName = "";
    this.AccountPhone = "";
    this.Type = "";
    this.AccountPhoneExt = "";
    this.PersonAccountRoles = "";
    this.BillingStreet = "";
    this.BillingCity = "";
    this.BillingState = "";
    this.BillingPostalCode = "";
    this.ContactAccountRole = "";
}
SaveContact(){
    const input = [...this.template.querySelectorAll('.contactFormControl')]
        .reduce((validSoFar, inputCmp) => {
                    inputCmp.reportValidity();
                    return validSoFar && inputCmp.checkValidity();
        }, true);
    if(!input){
        alert('Fill in all required fields before saving');
    }else{
        if(this.AccountId === null || this.AccountId === ""){
            alert('Select or Create an Account before saving');
        }else{
            if(this.CompanyAccountRoles === null || this.CompanyAccountRoles === ""){
                alert('Select a Role before saving');
            }else{

    var ACCOUNTJSON = {'AccountId': this.ContactAccountValue};
    
    var PackagedString = JSON.stringify(ACCOUNTJSON);
    
    // var cavalue = JSON.stringify(this.ContactAccountValue);
    // var cavalueid = JSON.parse(cavalue);
    // console.log('Cavalueid ' + cavalueid);

    
            const address = this.template.querySelector('[data-id="ContactAddressLookup"]');
            
             
                this.MailingStreet = address.street;
                this.MailingCity = address.city;
                this.MailingState = address.province;
                this.MailingPostalCode = address.postalCode;
                this.MailingCountry = address.country;
                this.loadingContact = true;

                InsertContact({FirstName:this.FirstName, LastName:this.LastName, Email:this.Email, Phone:this.Phone, Type:this.ContactType, PhoneExt:this.PhoneExt,
                    MailingStreet:this.MailingStreet, MailingCity:this.MailingCity, 
                   MailingState:this.MailingState, MailingPostalCode:this.MailingPostalCode, MailingCountry:this.MailingCountry, AccountId:PackagedString, AccountList:this.CreateNewContact})
                   .then(result =>{ 
                       let Message = result;
                    if(Message.length >18){
                        this.loadingContact = false;
                        alert(Message);
                    }else{
                    
                       this.ContactId = result;
                       this.TypeOfInsert = 'BusinessAccount';
                           this.AccountRoles = this.ReplaceEmptyAccountRoleRows();
                           const event = new ShowToastEvent({
                            title:'Success',
                            message: 'Saved',
                            variant: 'success',
                        });
                        this.dispatchEvent(event);
                           this.loadingContact = false;
                           //now Reset the form
                           this.Email = "";
                           this.ContactId = "";
                           this.AccountId = "";
                           this.Type = "";
                           this.ContactAccountRole = "";
                           this.AccountPhoneExt = "";
                           this.AccountPhone = "";
                           this.AccountName = "";
                           this.MailingStreet = "";
                            this.MailingCity = "";
                            this.MailingState = "";
                            this.MailingPostalCode = "";
                            this.MailingCountry = "";
                            this.FirstName = "";
                            this.LastName = "";
                            this.Phone = "";
                            this.ContactType = "";
                            this.PhoneExt = "";
                            this.CreateContact = false;
                            this.CreateNewContact = false;
                            this.ContactAccountValue = "";
                            this.PersonAccountRoles = "";
                            this.CompanyAccountRoles = "";
                }
                        //    this.AccountLastName = null;
                        //    this.AccountFirstName = null;
                        //    this.AccountPhone = null;
                        //    this.Type = null;
                        //    this.AccountPhoneExt = null;
                          
                        //    this.BillingStreet = null;
                        //    this.BillingCity = null;
                        //    this.BillingState = null;
                        //    this.BillingPostalCode = null;
                        //    this.ContactAccountRole = null;
                   })
            }}}
        }

savePersonAccount(){
    console.log('Starting Person Account ' );
    
            const input = [...this.template.querySelectorAll('.personAccountFormControl')]
            .reduce((validSoFar, inputCmp) => {
                        inputCmp.reportValidity();
                        console.log('inside the return' );
                        return validSoFar && inputCmp.checkValidity();
            }, true);
            console.log('Valid input ' + input);
            if(!input){
            alert('Fill in all required fields before saving');
            }else{
                    if(this.PersonAccountRoles === null || this.PersonAccountRoles === ""){
                        alert('Select a Role before Saving');
                    }else{
                console.log('Inside the else statement ');  
                const address = this.template.querySelector('[data-id="PersonAccountAddressLookup"]');
                this.BillingStreet = address.street;
                this.BillingCity = address.city;
                this.BillingState = address.province;
                this.BillingPostalCode = address.postalCode;
                this.BillingCountry = address.country;
                console.log('Inside the else statement 2'); 
                this.loadingPersonAccount = true;
                InsertPersonAccount({FirstName:this.AccountFirstName, LastName:this.AccountLastName, Phone:this.AccountPhone, Type:this.Type, PhoneExt:this.AccountPhoneExt,
                 BillingStreet:this.BillingStreet, BillingCity:this.BillingCity, 
                BillingState:this.BillingState, BillingPostalCode:this.BillingPostalCode, BillingCountry:this.BillingCountry})
                .then(result =>{ 
                    this.AccountId = result;
                   
                    if(this.AccountId.length >18){
                        this.loadingPersonAccount = false;
                        alert(this.AccountId);
                        
                    }else{
                        
                        this.PersonAccountModal = false;
                        this.loadingPersonAccount = false;
                        this.TypeOfInsert = 'PersonAccount';
                        this.ContactAccountValue = this.AccountId;
                        this.AccountRoles = this.ReplaceEmptyAccountRoleRows();
                        const event = new ShowToastEvent({
                            title:'Success',
                            message: 'Saved',
                            variant: 'success',
                        });
                        this.dispatchEvent(event);
                        //now Reset the form
                        this.AccountId = "";
                        this.ContactAccountValue = "";
                        this.AccountName = "";
                        
                        this.AccountLastName = "";
                        this.AccountFirstName = "";
                        this.AccountPhone = "";
                        this.Type = "";
                        this.AccountPhoneExt = "";
                        this.BillingStreet = "";
                        this.BillingCity = "";
                        this.BillingState = "";
                        this.BillingPostalCode = "";
                        this.ContactAccountRole = "";
                    }
                })
             }}
        
    }

saveAccount(){
            const input = [...this.template.querySelectorAll('.companyAccountFormControl')]
            .reduce((validSoFar, inputCmp) => {
                        inputCmp.reportValidity();
                        return validSoFar && inputCmp.checkValidity();
            }, true);
             if(!input){
            alert('Fill in all required fields before saving');
            }else{  
                console.log('Company Account Roles ' + this.CompanyAccountRoles); 
                if(this.CompanyAccountRoles === null || this.CompanyAccountRoles === ""){
                    console.log('Company Account Roles ' + this.CompanyAccountRoles);
                    alert('Select a Role before saving');
                }else{
                    console.log('Everything Passed ');
                const address = this.template.querySelector('[data-id="AccountAddressLookup"]');
                this.BillingStreet = address.street;
                this.BillingCity = address.city;
                this.BillingState = address.province;
                this.BillingPostalCode = address.postalCode;
                this.BillingCountry = address.country;
                this.loading = true;
                
                InsertAccount({Name:this.AccountName, Phone:this.AccountPhone, Type:this.Type, PhoneExt:this.AccountPhoneExt,
                 BillingStreet:this.BillingStreet, BillingCity:this.BillingCity, 
                BillingState:this.BillingState, BillingPostalCode:this.BillingPostalCode, BillingCountry:this.BillingCountry})
                .then(result =>{ 
                    this.AccountId = result;
                    if(this.AccountId.length >18){
                        this.loading = false;
                        alert(this.AccountId);
                        
                    }else{
                    const event = new ShowToastEvent({
                        title:'Success',
                        message: 'Saved',
                        variant: 'success',
                    });
                    this.dispatchEvent(event);
                    if(this.CreateNewContact){
                        this.ContactAccountValue = this.AccountId;
                        this.NewAccount = false;
                        this.CreateContact = true;
                        this.AccountEmpty = false;
                    }
                    if(!this.CreateNewContact){
                        this.ContactAccountValue = this.AccountId;
                        this.TypeOfInsert = 'BusinessAccount';
                        this.AccountRoles = this.ReplaceEmptyAccountRoleRows();
                        
                        //now Reset the form
                        this.AccountId = "";
                        this.ContactAccountValue = "";
                        this.AccountName = "";
                        this.AccountPhone = "";
                        this.Type = "";
                        this.AccountPhoneExt = "";
                        this.PersonAccount = "";
                        this.BillingStreet = "";
                        this.BillingCity = "";
                        this.BillingState = "";
                        this.BillingPostalCode = "";
                        this.ContactAccountRole = "";
                        this.loading = false;
                        this.NewAccount = false;
                        
                    }
                }
                })
            }}
            }
        
        

ReplaceEmptyAccountRoleRows(){
    var AccountRoles = [];
//var AccountRoless
    //Get Value from HTML
    if(this.TypeOfInsert === 'PersonAccount'){
        this.ContactAccountRole = this.PersonAccountRoles;
      
    }
    if(this.TypeOfInsert === 'BusinessAccount'){
        this.ContactAccountRole = this.CompanyAccountRoles;
     
    } 
    let TblRow =  Array.from(this.template.querySelectorAll('table.ActRoles tbody tr'));
 
    let RowCount = TblRow.length;
   
    var Inserted = false;
    for(let k=0; k<RowCount; k++){
        // let ARName = TblRow[k].querySelector('.ARName').value;
        let ARRoles = TblRow[k].querySelector('.ARRoles').value;
        //let ARAddress = TblRow[k].querySelector('.ARAddress').value;
        let ARContact = TblRow[k].querySelector('.ARContact').value;
        let ARAccount = TblRow[k].querySelector('.ARAccount').value;
      
        if((ARContact !== "" && ARContact !== null) || (ARAccount !== "" && ARAccount !== null)){
        AccountRoles.push({
            Text__c: ARRoles,  Contact_ID__c: ARContact, Account_ID__c: ARAccount
        });
        
    }else if((ARContact === "" || ARContact === null) && (ARRoles === "" || ARRoles === null) && (ARAccount === "" || ARAccount === null)){
       
        AccountRoles.push({
            
            Text__c: this.ContactAccountRole,  Contact_ID__c: this.ContactId, Account_ID__c: this.ContactAccountValue
       });
       Inserted = true;
    }
}
    if(!Inserted){
    
        AccountRoles.push({Text__c : this.ContactAccountRole,  Contact_ID__c: this.ContactId, Account_ID__c: this.ContactAccountValue});
    }
   

    
    return AccountRoles;
}

CompanyAccountRolesChange(e){
    this.CompanyAccountRoles = e.detail.value;
}
handleSectionToggle(event) {
    const openSections = event.detail.openSections;
}
addContact(){
    this.CreateContact = true;
    // this.CreateNewContact = true;
}
addAccount(){

    this.NewAccount = true;
    this.CreateContact = false; 
}
closeAccountModal(){
    this.NewAccount = false;
    this.AccountId = "";
    this.AccountName = "";
    this.AccountLastName = "";
    this.AccountFirstName = "";
    this.AccountPhone = "";
    this.Type = "";
    this.AccountPhoneExt = "";
    this.CompanyAccountRoles = "";

    this.BillingStreet = "";
    this.BillingCity = "";
    this.BillingState = "";
    this.BillingPostalCode = "";
    this.ContactAccountRole = "";
    // remember to reset all the values for contact. 
}
closeContact(){
    this.CreateContact = false;
    this.CreateNewContact = false;
    this.AccountId = "";
    this.AccountName = "";
    this.AccountLastName = "";
    this.AccountFirstName = "";
    this.AccountPhone = "";
    this.Type = "";
    this.AccountPhoneExt = "";
    this.Phone = "";
    this.BillingStreet = "";
    this.BillingCity = "";
    this.BillingState = "";
    this.BillingPostalCode = "";
    this.ContactAccountRole = "";
    this.FirstName = "";
    this.LastName = "";
    this.Email = "";
    this.ContactType = "";
    this.PhoneExt = "";
    this.ContactAccountValue = "";
    this.AccountId = "";
    this.CompanyAccountRoles = "";
    // remember to reset all the values for contact. 
}
CustomerSelectedFalse(event){
    event.preventDefault();
    this.CustomerSelected = !this.CustomerSelected;
}

setAddressFields(){
        const address =
            this.template.querySelector('[data-id="AddressLookup"]');
        const isValid = address.checkValidity();
        if(!isValid) {
            console.log('Address street '  + address.street);
        }
        
        if(!isValid) {
            alert("Not a Valid Address");
    }
}
PropertyEmpty(){
    this.ClearSearch();
    this.Customers = "";
}
ClearProperty(event){
    var searchKey = event.detail.value;
    if(searchKey.length === 0){
    this.ClearSearch();
    }
    
}
ClearOffice(event){
    var searchKey = event.detail.value;
    if(searchKey.length === 0){
    this.Office = "";
    }
    }
ClearSearch(){
    this.Properties = "";
}
ContactIdChangeNew(){
this.CustomerSelected = true;
}
ClearCustomer(){
    this.Customers = "";
}
ContactIdChange(e){
    this.ContactId = e.detail.value;
    if(this.ContactId > 0){
    this.ContactSelected = true;
    }else{
        this.ContactSelected = false;
        this.ContactRole = '';
        this.AccountRole = '';
    }
}
ContactRoleChanged(e){
    this.ContactRole = e.detail.value;
}
ContactAccountRoleChanged(e){
    this.ContactAccountRole = e.detail.value;
}
ContactTypeChange(e){
    this.ContactType = e.detail.value;
}
FirstNameChange(e){
    this.FirstName = e.detail.value;
}
LastNameChange(e){
    this.LastName = e.detail.value;
}
MailingStreetChange(e){
    this.MailingStreet = e.detail.value;
}
MailingCityChange(e){
    this.MailingCity = e.detail.value;
}
MailingStateChange(e){
    this.MailingState = e.detail.value;
}
MailingCountyChange(e){
    this.MailingCounty = e.detail.value;
}
AccountIdChange(e){
    this.AccountId = e.detail.value;
}
MailingPostalCodeChange(e){
    this.MailingPostalCode = e.detail.value;
}
PhoneChange(e){
    this.Phone = e.detail.value;
}
EmailChange(e){
    this.Email = e.detail.value;
}
PhoneExtChange(e){
    this.PhoneExt = e.detail.value;
}
AccountNameChange(e){
    this.AccountName = e.detail.value;
}
BillingStreetChange(e){
    this.BillingStreet = e.detail.value;
}
BillingCityChange(e){
    this.BillingCity = e.detail.value;
}
BillingStateChange(e){
    this.BillingState = e.detail.value;
}
BillingPostalCodeChange(e){
    this.BillingPostalCode = e.detail.value;
}
TypeChange(e){
    this.Type = e.detail.value;
}
BillingCountryChange(e){
    this.BillingCountry = e.detail.value;
}

PropertyNameChange(e){
    this.PropertyName = e.detail.value;
}
CityChange(e){
    this.City = e.detail.value;
}
CountryChange(e){
    this.Country = e.detail.value;
}
StateChange(e){
    this.State = e.detail.value;
}
AddressLine1Change(e){
    this.AddressLine1 = e.detail.value;
}
PropertyTypeChange(e){
    this.PropertyType = e.detail.value;
}
ZipChange(e){
    this.Zip = e.detail.value;
}
DescriptionChange(e){
    this.Description = e.detail.value;
}
DivisionChange(e){
    this.Division = e.detail.value;
    if(this.Division === 'Emergency Svces'){
        this.DivisionEs = true;
    }else{
        this.DivisionEs = false;
    }
}
LeadSourceChange(e){
    this.LeadSource = e.detail.value;
}
JobClassChange(e){
    this.JobClass = e.detail.value;
}
EsJobTypeChange(e){
    this.EsJobType = e.detail.value;
}
ClaimChange(e){
    this.Claim = e.detail.value;
}
DeductibleChange(e){
    this.Deductible = e.detail.value;
}
 //connectedCallback(){
//     this.AccountRoles.push({Name : '',})
 //}
 AccountSelectionChange(e){
     this.ContactAccountSelected = true;
     this.ContactAccountValue = e.detail.value;
    
 }
ToggleNewCaller(){
    this.NewAccount = false;
    if(!this.NewCaller){
        this.NewCaller = true;
    }else{
        this.NewCaller = false;
    }
}
ClearAccount(event){
    var searchKey = event.detail.value;
    if(searchKey.length === 0){
        this.ContactAccounts = "";
        this.AccountEmpty = true;
    }
}
ToggleNewAccount(){
    this.CreateContact = false;
    this.CreateNewContact = true;
    this.NewAccount = true;
}
ToggleNewProperty(){
    if(!this.NewProperty){
        this.NewProperty = true;
    }else{
        this.NewProperty = false;
    }
}
AddNewRow(){
    //this.AccountRoleNew(Name ='test');
    this.AccountRoles.push({Type : '', Contact : '', Account: ''});
}
showModal(){
    this.bShowModal = true;
}
closeModal(){
    this.bShowModal = false;
}
// PropertyChange(event){
//     this.PropertyID = event.detail.value;
//     console.log(this.PropertyID.length);
//     if(this.PropertyID.length > 17){
//     this.PropertyPicked = true;
    
//     var PropertyJSON = {'PropertyId': this.PropertyID};
//     var PackagedJSON = JSON.stringify(PropertyJSON);
    
//     SearchAccountRoles({PropertyId:PackagedJSON})
//     .then(result => {
//         this.AccountRolesRecieved = result;
//         for (var i = 0; i < this.AccountRolesRecieved.length; i++){
//                 this.AccountRoles.push({name: this.AccountRolesRecieved[i],}) 
//             }
//         console.log('records' + this.records);
//         this.error = undefined;
//         //console.log(' records ', this.records);
//     })
//     .catch(error => {
//         this.error = error;
//         this.records = undefined;
//     });

// }
// }
// ARContactChangeNew(event){
//     var rowInd = event.target.parentNode.parentNode.rowIndex;
                  
// }

ARContactChange(event){


    window.clearTimeout(this.delayTimeout);
       var searchKey = event.target.value;
       if(searchKey.length === 0){this.ARContacts = null;}
       if(searchKey.length >= 1){
          
        // eslint-disable-next-line @lwc/lwc/no-async-operation
        //this.delayTimeout = setTimeout(() => {
            // eslint-disable-next-line @lwc/lwc/no-async-operation
            this.delayTimeout = setTimeout(() => {
                SearchCustomers({searchKey : searchKey})
                .then(result => {
                    this.ARContacts = result;
                  
                   var rowInd = event.target.parentNode.parentNode.rowIndex;
                  
                   
                   this.AccountRoles = this.getAllAccountRoleObjects();
                //    this.AccountRoles[rowInd].ContactSearch = 't';
                })
                
                .catch(error => {
                    this.error = error;
                 
                });
            }, DELAY);
           
        }
       



}
OfficeChange(event){
    window.clearTimeout(this.delayTimeout);
       var searchKey = event.target.value;
       if(searchKey.length === 0){this.Offices = null;}
       if(searchKey.length >= 1){
           
        // eslint-disable-next-line @lwc/lwc/no-async-operation
        //this.delayTimeout = setTimeout(() => {
            // eslint-disable-next-line @lwc/lwc/no-async-operation
            this.delayTimeout = setTimeout(() => {
                SearchOffices({searchKey : searchKey})
                .then(result => {
                    this.Offices = result;
                   
                })
                
                .catch(error => {
                    this.error = error;
                });
            }, DELAY);
        }
}


ContactAccountChanged(event){
    window.clearTimeout(this.delayTimeout);
       var searchKey = event.target.value;
       if(searchKey.length === 0){this.ContactAccounts = null;}
       if(searchKey.length >= 1){
           
        // eslint-disable-next-line @lwc/lwc/no-async-operation
        //this.delayTimeout = setTimeout(() => {
            // eslint-disable-next-line @lwc/lwc/no-async-operation
            this.delayTimeout = setTimeout(() => {
                SearchContactAccounts({searchKey : searchKey})
                .then(result => {
                    this.ContactAccounts = result;
                 
                })
                
                .catch(error => {
                    this.error = error;
                });
            }, DELAY);
        }
        // });

}
CustomerChanged(event){
    window.clearTimeout(this.delayTimeout);
       var searchKey = event.target.value;
       if(searchKey.length === 0){this.Customers = null;}
       if(searchKey.length >= 1){
           
        // eslint-disable-next-line @lwc/lwc/no-async-operation
        //this.delayTimeout = setTimeout(() => {
            // eslint-disable-next-line @lwc/lwc/no-async-operation
            this.delayTimeout = setTimeout(() => {
                SearchCustomers({searchKey : searchKey})
                .then(result => {
                    this.Customers = result;
                
                })
                
                .catch(error => {
                    this.error = error;
                });
            }, DELAY);
        }
        // });

}
populateOfficeField(event){
    
     this.Offices = '';
     var OfficeField = event.target.value;
     this.OfficeValue = OfficeField.Name;
     this.OfficeId = OfficeField.Id;
     
}
populateContactAccountField(event){
    
    // console.log('Property Id first is + ' + this.Property.Id);
     //console.log('Property Id first is + ' + this.testingProperty);
     //this.PropertyID = event.detail.value;
     this.ContactAccounts = '';
     this.ContactAccountSelected = true;
     this.AccountEmpty = false;
     var ContactAccountField = event.target.value;
     this.ContactAccountValue = ContactAccountField.Name;
     this.ContactAccountId = ContactAccountField.Id;
     this.ContactAccountName = ContactAccountField.Name;
}
populateCustomerField(event){
    
    // console.log('Property Id first is + ' + this.Property.Id);
     //console.log('Property Id first is + ' + this.testingProperty);
     //this.PropertyID = event.detail.value;
     this.Customers = '';
     this.CustomerSelected = true;
     this.CustomerSelectedField = event.target.value;
     this.CustomerValue = this.CustomerSelectedField.Name;
     this.CustomerId = this.CustomerSelectedField.Id;
     this.CustomerAccountId = this.CustomerSelectedField.Account.Id;
     this.CustomerAccountName = this.CustomerSelectedField.Account.Name;
}
populatePropertyField(event){
    
   // console.log('Property Id first is + ' + this.Property.Id);
    //console.log('Property Id first is + ' + this.testingProperty);
    //this.PropertyID = event.detail.value;
    this.Properties = '';
    this.PropertySelected = true;
    this.testingProperty = event.target.value;
    this.PropertySelectedField = event.target.value;
    this.PropertyValue = this.PropertySelectedField.Name;
    this.PropertyID = this.PropertySelectedField.Id;
  

    checkId({propId:this.testingProperty.Id}).then(result => {
        this.AccountRoles = result;
        this.AccountRolesSelected = true;
    
    })
    GetMasterJobs({propId:this.testingProperty.Id}).then(result => {
        this.MasterJobs = result;
        if(this.MasterJobs !== null){
            this.bShowModal = true;
        }
    })
}
PropertyChanged(event){
    
    // window.clearTimeout(this.delayTimeout);
  
    
    window.clearTimeout(this.delayTimeout);
       var searchKey = event.target.value;
       if(searchKey.length === 0){this.Properties = null;}
       if(searchKey.length >= 1){
           
        // eslint-disable-next-line @lwc/lwc/no-async-operation
        //this.delayTimeout = setTimeout(() => {
            // eslint-disable-next-line @lwc/lwc/no-async-operation
            this.delayTimeout = setTimeout(() => {
                SearchProperties({searchKey : searchKey})
                .then(result => {
                    this.Properties = result;
                  
                })
                
                .catch(error => {
                    this.error = error;
                });
            }, DELAY);
        }
        // });

}

getAllAccountRoleObjects() {
    var AccountRoles = [];
//var AccountRoless
    //Get Value from HTML 
    let TblRow =  Array.from(this.template.querySelectorAll('table.ActRoles tbody tr'));
    
    let RowCount = TblRow.length;
  
    for(let k=0; k<RowCount; k++){
        // let ARName = TblRow[k].querySelector('.ARName').value;
        
        //let ARAddress = TblRow[k].querySelector('.ARAddress').value;
        let ARContact = TblRow[k].querySelector('.ARContact').value;
        let ARAccount = TblRow[k].querySelector('.ARAccount').value;
        let ARRoles = TblRow[k].querySelector('.ARRoles').value;
        AccountRoles.push({
             Contact_ID__c: ARContact, Account_ID__c: ARAccount, Text__c: ARRoles
        });
 

    }
    return AccountRoles;
}

populateMasterJobField(event){
    this.MasterJobDetails = event.target.value;
    this.MasterJobId = this.MasterJobDetails.Id;
    this.Claim = this.MasterJobDetails.Claim__c;
    this.Description = this.MasterJobDetails.Description_of_Loss__c;
    this.Deductible = this.MasterJobDetails.Deductible__c;
    this.bShowModal = false;
}
DeleteARRow(e){
    var DeleteRowIndex = e.target.parentNode.parentNode.parentNode.rowIndex;
 
    this.AccountRoles = this.getAllAccountRoleObjects();
    this.AccountRoles.splice(DeleteRowIndex-1,1);
}

CreateNewJob(){
            // if(((!this.ContactId ) && (!this.LastName)) || ((!this.ContactId) && (!this.AccountId && (!this.AccountName || !this.AccountPhone)))){
            //     this.error = true;
            // }else{
            // this.loading = true;
            let AccountRoleInfo = this.GenerateAccountRoleJSON();
            console.log('Property Id is ' + this.PropertyID + '   PropertyType is ' + this.PropertyType);
            if(!AccountRolesPassed){
                alert('Account Roles must have a Project Site Contact and Bill To selected');
            }else{
                if(this.PropertyID === "" && this.PropertyType === ""){
                    console.log('Property Id is ' + this.PropertyID + '   PropertyType is ' + this.PropertyType);
                    alert('Either Select a Property or Create a New Property');
                }else{
                    console.log('Description ' + this.Description);
                    if(this.Description === "" || this.Description === undefined || this.JobName === "" || this.JobName === undefined || this.Claim === "" || this.Claim === undefined || this.Deductible === "" || this.Deductible === undefined){
                        alert('Fill in all required Job Fields');
                    }else{
                
            //Account Roles is good to go.
            
            //Property Data
            PropertyJSON = JSON.stringify({'PropertyId': this.PropertyID, 'City': this.City, 'Country': this.Country, 'State': this.State,
            'Street': this.Street,'PropertyType': this.PropertyType, 'Zip': this.Zip});
            //Job Fields
            JobJSON = JSON.stringify({'Description': this.Description, 'Division': this.Division, 'Office': this.OfficeId, JobClass: this.JobClass,
            'EstimateType': this.EstimateType,'Claim': this.Claim, 'Deductible': this.Deductible, JobName : this.JobName, LeadSource: this.LeadSource,
            MultipleDivisions: this.MultipleDivision, EsJobType:this.EsJobType });
            //Master Job is just MasterJobId, if null then need to create a new one.
            this.jobLoading = true;
            CreateNewJob({AccountRoleInfo : AccountRoleInfo, PropertyInfo : PropertyJSON,
                JobInfo : JobJSON, MasterJobId:this.MasterJobId})
                .then(result => {
                                var data = result;
                                if(data.length > 18){
                                    this.jobLoading = false;
                                    alert(data);
                                }else{
                                this[NavigationMixin.Navigate]({
                                    type: 'standard__recordPage',
                                    attributes: {
                                        recordId: data,
                                        objectApiName: 'ATI_Job__c',
                                        actionName: 'view',
                                    },
                                });
                            }
                            })
                        }
                    }
                    }
    }

   
Cancel(event){
    location.href='https://' + window.location.hostname + '/lightning/o/ATI_Job__c/list?filterName=Recent';
        event.action= this.location;
}
GenerateAccountRoleJSON(){
    var AccountRoleObject = {AccountRoleLineItems : this.GetAccountRolesObjects()
    };
        return JSON.stringify(AccountRoleObject);
}

GetAccountRolesObjects() {
        var projectSiteContact = false;
        var billTo = false;
        var AccountRoles = [];
        let ActTblRow =  Array.from(this.template.querySelectorAll('table.ActRoles tbody tr'));
        console.log('Get Account Roles has been called ' );
        let ActRowCount = ActTblRow.length;
        for(let Actindex=0; Actindex<ActRowCount; Actindex++){
            // let ARName = ActTblRow[Actindex].querySelector('.ARName').value;
            let ARRoles = ActTblRow[Actindex].querySelector('.ARRoles').value;
            let ARContact = ActTblRow[Actindex].querySelector('.ARContact').value;
            let ARAccount = ActTblRow[Actindex].querySelector('.ARAccount').value;
            console.log('Inside for loop :     AR Roles is ' + ARRoles + '    ARCONTACT :  ' + ARContact + '    ARAccount + ' + ARAccount );
            if(ARRoles.includes('Project Site Contact')){
                projectSiteContact = true;
                console.log('ARRoles Contains inside');
            }
            console.log('contains AR');
            if(ARRoles.includes('Bill To')){
                billTo = true;
            }
            if((ARContact === "" || ARContact === null) && (ARRoles === "" || ARRoles === null) && (ARAccount === "" || ARAccount === null)){
                console.log('Removing row' );
            }else{
                if(ARRoles === "" || ARRoles === null){
                    alert('A Role MUST be selected for each row');
                    break;
                }else{
            AccountRoles.push({
                    //name: ARName,
                    Text: ARRoles,
                    Contact: ARContact,
                    Account: ARAccount
                });
            }
        }
        }
            if(projectSiteContact === false || billTo === false){
                AccountRolesPassed = false;
            }else{
                AccountRolesPassed = true;
            }
            console.log('AccountRolesPassed ' + AccountRolesPassed);
            return AccountRoles;
        }  
    }