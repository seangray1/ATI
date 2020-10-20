import { LightningElement, track, api, wire } from 'lwc';
import SearchOffices from '@salesforce/apex/NewJobController.GetOffices';
import AfterHoursJobCreation from '@salesforce/apex/NewJobController.AfterHoursJobCreation';
import GetEsJobTypePicklist from '@salesforce/apex/NewJobController.GetEsJobTypePicklist';
import GetDivisionPicklist from '@salesforce/apex/NewJobController.GetDivisionPicklist';
import GetMajorEvents from '@salesforce/apex/NewJobController.GetMajorEvents';
import GetJobInfo from '@salesforce/apex/NewJobController.GetJobInfo';
import FORM_FACTOR from '@salesforce/client/formFactor';
import { NavigationMixin } from 'lightning/navigation';
import GetUsers from '@salesforce/apex/NewJobController.GetUsers';
import { getPicklistValues } from "lightning/uiObjectInfoApi";
import DIVISION_FIELD from "@salesforce/schema/ATI_Job__c.Division__c";

import LEADSOURCE_FIELD from "@salesforce/schema/ATI_Job__c.Lead_Source__c";
import ESJOBTYPE_FIELD from "@salesforce/schema/ATI_Job__c.ES_Job_Type__c";

const DELAY = 600;
var Street, City, State, ZipCode, Country;
export default class AfterHoursJobLWC extends NavigationMixin(LightningElement) {
    LeadSourcePicklistValues;
    EsJobTypePicklistValues;
    DivisionPicklistValues;
    @wire(getPicklistValues, {
        recordTypeId: "0120g000000l3yMAAQ",
        fieldApiName: DIVISION_FIELD
      })
      AtiJobDivisionValues({ data }) {
        if (data) {
          this.DivisionPicklistValues = data.values;
          console.log(this.DivisionPicklistValues);
        }
      }
      @wire(getPicklistValues, {
        recordTypeId: "0120g000000l3yMAAQ",
        fieldApiName: LEADSOURCE_FIELD
      })
      AtiJobLeadSourceValues({error, data }) {
        if (data) {
          this.LeadSourcePicklistValues = data.values;
          console.log(this.LeadSourcePicklistValues);
        }
        else{
          this.error = error;
          // console.error(this.error);
          console.log(this.error);
        }
      }
     
      @wire(getPicklistValues, {
        recordTypeId: "0120g000000l3yMAAQ",
        fieldApiName: ESJOBTYPE_FIELD
      })
      AtiJobJobClassValues({ data }) {
        if (data) {
          this.EsJobTypePicklistValues = data.values;
          console.log(this.EsJobTypePicklistValues);
        }
      }
 //   = "Name:"+  '\n' + "Company:" + '\n' + 'Email:' + '\n' + 'Phone Number:' + '\n' + 'Additional Information:';Description of Loss:"+  '\n' + "Insurance Provider:" + '\n' + 'Claim #:' + '\n' + 'Policy #:'+
//'\n' + 'Lead Source:' + '\n' + 'Additional Information:'
JobName; Office; Offices; Division; AddressLine2;loading = false; Comments;Description;OfficeValue;OfficeId;
DivisionEs = false; EsJobType; PageStateReady = false; ContactInfo;@track MajorEvents;@track MajorEventValue; @track MajorEventId; @track MajorEventSelected = false;
ProjectDirectorValue = "";ProjectDirectors;ProjectDirectorId; ProjectDirectorSelected = false;
ContactName='';Email='';PhoneNumber='';Company='';AdditionalInformation='';@track newDescription = false;@track Street = '';@track City = '';@track State = '';@track Zipcode = '';@track Country = '';
DescriptionOfLoss='';InsuranceProvider='';Claim='';Policy='';LeadSource='';AdditionalInformationTwo='';@track newDescriptionTwo = false;@track ModalScreen = true;
@track Desktop = false; @track Mobile = false;@track OfficeOptions=[{}];FieldsDisabled = false;
@api recordId;
value = 'inProgress';
      @track state = {
          progress: this.value,
          progressRequired: '',
          progressDisabled: ''
      };
  
  
  
      handleChange12(event) {
          this.state[event.target.name] = event.detail.value;
      }
DescriptionOfLossChange(e){
    this.DescriptionOfLoss = e.detail.value;
}
InsuranceProviderChange(e){
    this.InsuranceProvider = e.detail.value;
}
ClaimChange(e){
    this.Claim = e.detail.value;
}
PolicyChange(e){
    this.Policy = e.detail.value;
}
LeadSourceChange(e){
    this.LeadSource = e.detail.value;
}
AdditionalInformationTwoChange(e){
    this.AdditionalInformationTwo = e.detail.value;
}
ContactNameChange(e){
    this.ContactName = e.detail.value;
}
EmailChange(e){
    this.Email = e.detail.value;
}
PhoneNumberChange(e){
    this.PhoneNumber = e.detail.value;
}
CompanyChange(e){
    this.Company = e.detail.value;
}
AdditionalInformationChange(e){
    this.AdditionalInformation = e.detail.value;
}
closeDescriptionModal(){
    this.newDescription = false;
}
closeDescriptionModalTwo(){
    this.newDescriptionTwo = false;
}
SaveDescription(){
    this.ContactInfo = "Name: "+ this.ContactName +  '\n' + "Company: "+ this.Company + '\n' + 'Email: '+ this.Email + '\n' + 'Phone Number: ' + this.PhoneNumber + '\n' + 'Additional Information: '+ this.AdditionalInformation;
    this.newDescription= false;
}
SaveDescriptionTwo(){
    this.Description = "Description of Loss: "+ this.DescriptionOfLoss +  '\n' + "Insurance Provider: "+ this.InsuranceProvider + '\n' + 'Claim #: '+ this.Claim + '\n' + 'Policy #: ' + this.Policy + '\n' + 'Lead Source: ' + this.LeadSource + '\n' + 'Additional Information: '+ this.AdditionalInformationTwo;
    this.newDescriptionTwo= false;
}
openDescriptionModal(){
    this.newDescriptionTwo = true;
}
openContactInfoModal(){
    this.newDescription = true;
}


closeDescriptionModal1(){
    this.newDescription = false;
    this.ModalScreen = true;
}
closeDescriptionModalTwo1(){
    this.newDescriptionTwo = false;
    this.ModalScreen = true;
}
SaveDescription1(){
    this.ContactInfo = "Name: "+ this.ContactName +  '\n' + "Company: "+ this.Company + '\n' + 'Email: '+ this.Email + '\n' + 'Phone Number: ' + this.PhoneNumber + '\n' + 'Additional Information: '+ this.AdditionalInformation;
    this.newDescription= false;
    this.ModalScreen = true;
}
SaveDescriptionTwo1(){
    this.Description = "Description of Loss: "+ this.DescriptionOfLoss +  '\n' + "Insurance Provider: "+ this.InsuranceProvider + '\n' + 'Claim #: '+ this.Claim + '\n' + 'Policy #: ' + this.Policy + '\n' + 'Lead Source: ' + this.LeadSource + '\n' + 'Additional Information: '+ this.AdditionalInformationTwo;
    this.newDescriptionTwo= false;
    this.ModalScreen = true;
}
openDescriptionModal1(){
    const address = this.template.querySelector('[data-id="AddressLookup"]');
            // const isValid = address.checkValidity();
            //  if(isValid) {
                this.Street = address.street;
                this.City = address.city;
                this.State = address.province;
                this.Zipcode = address.postalCode;
                this.Country = address.country;
            // }
    this.ModalScreen = false;
    this.newDescriptionTwo = true;
}
openContactInfoModal1(){
    const address = this.template.querySelector('[data-id="AddressLookup"]');
            // const isValid = address.checkValidity();
            //  if(isValid) {
                this.Street = address.street;
                this.City = address.city;
                this.State = address.province;
                this.Zipcode = address.postalCode;
                this.Country = address.country;
            //  }
    this.ModalScreen = false;
    this.newDescription = true;
}

connectedCallback(){
    console.log('Browser is ' + FORM_FACTOR);
    console.log('before form factor');
    if(FORM_FACTOR === 'Large'){
            this.Desktop = true; 
            console.log('inside Desktop one');  
    }
    if(FORM_FACTOR === 'Medium' || FORM_FACTOR === 'Small'){
        this.Mobile = true;
    }
    if(this.recordId !== null)
        {
            
            this.FieldsDisabled = true;
            // this.Mobile = true;
            GetJobInfo({recordId : this.recordId}).then(result =>{
                
                console.log('what is being returned ' + result);
                this.OfficeId = result.Office2__c;
                this.OfficeValue = result.Office2__r.Name;
                this.JobName = result.Job_Name__c;
                this.MajorEventId = result.Major_Event__c;
                if(this.MajorEventId !== undefined &&
                    this.MajorEventId !== null &&
                    this.MajorEventId !== ""){
                this.MajorEventValue = result.Major_Event__r.Name;
                }
                this.Description = result.Description__c;
                this.ContactInfo = result.Contact_Info__c;
                this.Street = result.Project_Site_Address__c;
                this.City = result.Project_Site_City__c;
                this.Zipcode = result.Project_Site_Zipcode__c;
                this.State = result.Project_Site_State__c;
                
            })
        }
        
    console.log('record Id is ' + this.recordId);
    this.PageStateReady = true;  
    // GetDivisionPicklist({}).then(result =>{
    //     var AccountRolePicklistValues = result;
    //     for(var i = 0; i<AccountRolePicklistValues.length;i++){
            
    //         this.DivisionPicklistValues.push({label : AccountRolePicklistValues[i], value : AccountRolePicklistValues[i], });
    //     }
        
    //     this.DivisionPicklistValues.shift();   
    //     this.PageStateReady = true;    
    // })
    // GetEsJobTypePicklist({}).then(result =>{
    //     var AccountRolePicklistValues = result;
    //     for(var i = 0; i<AccountRolePicklistValues.length;i++){
            
    //         this.EsJobTypePicklistValues.push({label : AccountRolePicklistValues[i], value : AccountRolePicklistValues[i], });
    //     }
        
    //     this.EsJobTypePicklistValues.shift();
    // })
}
searchAgain(){
    this.ProjectDirectorSelected = false;
    this.ProjectDirectorValue = "";
    this.ProjectDirectorId = "";
}
ClearProjectDirector(event){
   
    this.ProjectDirectorValue = event.detail.value;
    let searchKey = event.detail.value;
    if(searchKey.length === 0){
    this.ProjectDirectors = "";
    this.ProjectDirectorValue = "";
    this.ProjectDirectorId = "";
    console.log('Clear PD in PDCCC');
    }
    }
ClearMajorEvent(event){
    let searchKey = event.detail.value;
    if(searchKey.length === 0){
    this.MajorEvents = "";
    
    }
    }

MajorEventChange(event){
    window.clearTimeout(this.delayTimeout);
       var searchKey = event.target.value;
       if(searchKey.length === 0){this.MajorEvents = null;}
       if(searchKey.length >= 1){
           
        // eslint-disable-next-line @lwc/lwc/no-async-operation
        //this.delayTimeout = setTimeout(() => {
            // eslint-disable-next-line @lwc/lwc/no-async-operation
            this.delayTimeout = setTimeout(() => {
                GetMajorEvents({searchKey : searchKey})
                .then(result => {
                    this.MajorEvents = result;
                   
                })
                
                .catch(error => {
                    this.error = error;
                });
            }, DELAY);
        }
}
populateMajorEventField(event){
    
    this.MajorEvents = '';
    let MajorEvent = event.target.value;
    this.MajorEventValue = MajorEvent.Name;
    this.MajorEventId = MajorEvent.Id;
    this.MajorEventSelected = true;
    
}
ProjectDirectorChange(event){
    window.clearTimeout(this.delayTimeout);
       var searchKey = event.target.value;
       if(searchKey.length === 0){this.ProjectDirectors = null;}
       if(searchKey.length >= 1){
           console.log('Clear PD in PDC');
           
        // eslint-disable-next-line @lwc/lwc/no-async-operation
        //this.delayTimeout = setTimeout(() => {
            // eslint-disable-next-line @lwc/lwc/no-async-operation
            this.delayTimeout = setTimeout(() => {
                GetUsers({searchKey : searchKey})
                .then(result => {
                    this.ProjectDirectors = result;
                   
                })
                
                .catch(error => {
                    this.error = error;
                });
            }, DELAY);
        }
}
populateProjectDirectorField(event){
    
    this.ProjectDirectors = '';
    let ProjectDirector = event.target.value;
    this.ProjectDirectorValue = ProjectDirector.Name;
    this.ProjectDirectorId = ProjectDirector.Id;
    this.ProjectDirectorSelected = true;
    
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
populateOfficeField(event){
    
    this.Offices = '';
    var OfficeField = event.target.value;
    this.OfficeValue = OfficeField.Name;
    this.OfficeId = OfficeField.Id;
    
}
CommentsChange(e){
    this.Comments = e.detail.value;
}
ContactInfoChange(e){
    this.ContactInfo = e.detail.value;
}
DescriptionChange(e){
    this.Description = e.detail.value;
}
AddressLine2Change(e){
    this.AddressLine2 = e.detail.value;
}
ClearOffice(event){
   
    let searchKey = event.detail.value;
    if(searchKey.length === 0){
    this.Offices = "";
    }
    }
    JobNameChange(e){
        this.JobName = e.detail.value;
    }
DivisionChange(e){
    this.Division = e.detail.value;
    if(this.Division === 'Emergency Svces'){
        this.DivisionEs = true;
    }else{
        this.DivisionEs = false;
    }
}
EsJobTypeChange(e){
    this.EsJobType = e.detail.value;
}
Save(){
    
    const input = [...this.template.querySelectorAll('.jobFormControl')]
        .reduce((validSoFar, inputCmp) => {
                    inputCmp.reportValidity();
                    return validSoFar && inputCmp.checkValidity();
        }, true);
    if(!input){
        alert('Fill in all required fields before saving');
    }else{
        if(this.OfficeId === null || this.OfficeId === undefined || this.OfficeId === ""){
            alert('Please make a selection from the Office list');
        }else{
            
        if(this.ProjectDirectorValue.length > 1 && (this.ProjectDirectorId === null || this.ProjectDirectorId === undefined || this.ProjectDirectorId === "")){
            alert('Please make a selection from the Project Director list')
        }else{
        if((this.recordId !== null) && (this.ProjectDirectorId === null || this.ProjectDirectorId === undefined || this.ProjectDirectorId === ""))
        {
            alert('Cloned Jobs must have a Project Director');
        }
        else
        {
        
    const address = this.template.querySelector('[data-id="AddressLookup"]');
            // const isValid = address.checkValidity();
            //   if(isValid) {
                
                if(address.street !== null && address.street !== undefined && address.street !== ""){
                Street = address.street;
                City = address.city;
                State = address.province;
                ZipCode = address.postalCode;
                Country = address.country;
                this.loading = true;
                AfterHoursJobCreation({JobName:this.JobName, Division:this.Division, EsJobType:this.EsJobType, Office:this.OfficeId, Street:Street, State:State, City:City, 
                ZipCode:ZipCode, Country:Country, AddressLine2:this.AddressLine2, ContactInfo:this.ContactInfo, Description:this.Description, MajorEvent:this.MajorEventId, ProjectDirector:this.ProjectDirectorId, recordId:this.recordId}).then(result => {
                let data = result;
                
        if(data.length > 18){
            this.loading = false;
            alert(data);
        }else
        {
            //ClearForm();
            this.Division = '--None--';this.JobName = ''; this.EsJobType = ''; this.Office = ''; this.Street = ''; this.State = ''; this.City = ''; this.Zipcode = '';
            this.Country = '';this.AddressLine2 = '';this.ContactInfo = '';this.Description = '';this.MajorEventId = ''; this.ProjectDirectorId = '';
            this.ProjectDirectorValue = '';this.OfficeValue = '';this.OfficeId = ''; this.DivisionEs = false;
            this.EsJobType = '';this.PageStateReady = false;this.MajorEventValue = '';this.MajorEventSelected = false;this.ProjectDirectorSelected = false;
            this.ContactName = '';this.Email = '';this.PhoneNumber = '';this.Company= '';this.AdditionalInformation = '';this.newDescription = false;
            this.DescriptionOfLoss = '';this.InsuranceProvider = '';this.Claim = '';this.Policy = '';this.LeadSource = '';this.AdditionalInformationTwo = '';
            //this.loading = false;
            this.newDescriptionTwo = false;
            // if(this.recordId === null || this.recordId === undefined || this.recordId === "")
            // {
                this.dispatchEvent(new CustomEvent('closeform'));
                this[NavigationMixin.Navigate]
                ({
                    type: 'standard__recordPage',
                    attributes: 
                    {
                    recordId: data,
                    objectApiName: 'ATI_Job__c',
                    actionName: 'view',
                    },
                });
            // }
            // else
            // {
            //     this.dispatchEvent(new CustomEvent('CloseJobRequest'));
            // }
        }
    }) 
//}
                
                }else{
                    alert('Search For an Address');
                }
    }
}
}
}
}
Cancel(event) {
    if(this.recordId === null || this.recordId === undefined || this.recordId === "")
    {
    location.href =
      "https://" +
      window.location.hostname +
      "/lightning/o/ATI_Job__c/list?filterName=Recent";
    event.action = this.location;
    }
    else if(this.Mobile === true)
    {
        this.dispatchEvent(new CustomEvent('closeForm'));
    }else{
        location.href =
      "https://" +
      window.location.hostname +
      "/lightning/o/ATI_Job__c/list?filterName=Recent";
    event.action = this.location;
    }
  }
ClearForm(){
    this.Division = '';this.JobName = ''; this.EsJobType = ''; this.Office = ''; this.Street = ''; this.State = ''; this.City = ''; this.ZipCode = '';
    this.Country = '';this.AddressLine2 = '';this.ContactInfo = '';this.Description = '';this.MajorEventId = ''; this.ProjectDirectorId = '';
    this.ProjectDirectorValue = '';this.loading = false; this.OfficeValue = '';this.OfficeId = ''; this.DivisionEs = false;
    this.EsJobType = '';this.PageStateReady = false;this.MajorEventValue = '';this.MajorEventSelected = false;this.ProjectDirectorSelected = false;
    this.ContactName = '';this.Email = '';this.PhoneNumber = '';this.Company= '';this.AdditionalInformation = '';this.newDescription = false;
    this.DescriptionOfLoss = '';this.InsuranceProvider = '';this.Claim = '';this.Policy = '';this.LeadSource = '';this.AdditionalInformationTwo = '';
    this.newDescriptionTwo = false;
}
}