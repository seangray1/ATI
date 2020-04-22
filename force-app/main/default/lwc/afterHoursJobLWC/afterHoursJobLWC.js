import { LightningElement, track } from 'lwc';
import SearchOffices from '@salesforce/apex/NewJobController.GetOffices';
import AfterHoursJobCreation from '@salesforce/apex/NewJobController.AfterHoursJobCreation';
import GetEsJobTypePicklist from '@salesforce/apex/NewJobController.GetEsJobTypePicklist';
import GetDivisionPicklist from '@salesforce/apex/NewJobController.GetDivisionPicklist';
import GetMajorEvents from '@salesforce/apex/NewJobController.GetMajorEvents';
import { NavigationMixin } from 'lightning/navigation';
import GetUsers from '@salesforce/apex/NewJobController.GetUsers';
const DELAY = 600;
var Street, City, State, ZipCode, Country;
export default class AfterHoursJobLWC extends NavigationMixin(LightningElement) {

JobName; Office; Offices; Division; AddressLine2;loading = false; Comments;Description="Description of Loss:"+  '\n' + "Insurance Provider:" + '\n' + 'Claim #:' + '\n' + 'Policy #:'+
'\n' + 'Lead Source:' + '\n' + 'Additional Information:';OfficeValue;OfficeId;DivisionPicklistValues =[{}];EsJobTypePicklistValues=[{}];
DivisionEs = false; EsJobType; PageStateReady = false; ContactInfo = "Name:"+  '\n' + "Company:" + '\n' + 'Email:' + '\n' + 'Phone Number:' + '\n' + 'Additional Information:';@track MajorEvents;@track MajorEventValue; @track MajorEventId; @track MajorEventSelected = false;
ProjectDirectorValue = "";ProjectDirectors;ProjectDirectorId; ProjectDirectorSelected = false;
connectedCallback(){
    GetDivisionPicklist({}).then(result =>{
        var AccountRolePicklistValues = result;
        for(var i = 0; i<AccountRolePicklistValues.length;i++){
            
            this.DivisionPicklistValues.push({label : AccountRolePicklistValues[i], value : AccountRolePicklistValues[i], });
        }
        
        this.DivisionPicklistValues.shift();   
        this.PageStateReady = true;    
    })
    GetEsJobTypePicklist({}).then(result =>{
        var AccountRolePicklistValues = result;
        for(var i = 0; i<AccountRolePicklistValues.length;i++){
            
            this.EsJobTypePicklistValues.push({label : AccountRolePicklistValues[i], value : AccountRolePicklistValues[i], });
        }
        
        this.EsJobTypePicklistValues.shift();
    })
}
searchAgain(){
    this.ProjectDirectorSelected = false;
    this.ProjectDirectorValue = "";
    this.ProjectDirectorId = "";
}
ClearProjectDirector(event){
    let searchKey = event.detail.value;
    if(searchKey.length === 0){
    this.ProjectDirectors = "";
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
    const address = this.template.querySelector('[data-id="AddressLookup"]');
            const isValid = address.checkValidity();
             if(isValid) {
                Street = address.street;
                City = address.city;
                State = address.province;
                ZipCode = address.postalCode;
                Country = address.country;
                this.loading = true;
                AfterHoursJobCreation({JobName:this.JobName, Division:this.Division, EsJobType:this.EsJobType, Office:this.OfficeId, Street:Street, State:State, City:City, 
                ZipCode:ZipCode, Country:Country, AddressLine2:this.AddressLine2, ContactInfo:this.ContactInfo, Description:this.Description, MajorEvent:this.MajorEventId, ProjectDirector:this.ProjectDirectorId}).then(result => {
                let data = result;
                this.loading = false;
        if(data.length > 18){
            
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