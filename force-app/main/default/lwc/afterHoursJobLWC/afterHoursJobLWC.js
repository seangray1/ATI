import { LightningElement, track } from 'lwc';
import SearchOffices from '@salesforce/apex/NewJobController.GetOffices';
import AfterHoursJobCreation from '@salesforce/apex/NewJobController.AfterHoursJobCreation';
import GetDivisionPicklist from '@salesforce/apex/NewJobController.GetDivisionPicklist';
const DELAY = 600;
var Street, City, State, ZipCode, Country;
export default class AfterHoursJobLWC extends LightningElement {

JobName; Office; Offices; Division; AddressLine2; Comments;Description;OfficeValue;OfficeId;DivisionPicklistValues =[{}];
DivisionEs = false; EsJobType; PageStateReady = false;
connectedCallback(){
    GetDivisionPicklist({}).then(result =>{
        var AccountRolePicklistValues = result;
        for(var i = 0; i<AccountRolePicklistValues.length;i++){
            
            this.DivisionPicklistValues.push({label : AccountRolePicklistValues[i], value : AccountRolePicklistValues[i], });
        }
        
        this.DivisionPicklistValues.shift();   
        this.PageStateReady = true;    
    })
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
                AfterHoursJobCreation({JobName:this.JobName, Division:this.Division, EsJobType:this.EsJobType, Office:this.OfficeId, Street:Street, State:State, City:City, 
    ZipCode:ZipCode, Country:Country, AddressLine2:this.AddressLine2, Comments:this.Comments, Description:this.Description})    
}
    }
}
}