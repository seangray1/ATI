/**
 * @File Name          : cloneJobLWC.js
 * @Description        : 
 * @Author             : Sean Gray
 * @Group              : 
 * @Last Modified By   : Sean Gray
 * @Last Modified On   : 1/21/2020, 5:31:04 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    1/21/2020   Sean Gray     Initial Version
**/
import { LightningElement, track, api, wire } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { getRecord } from 'lightning/uiRecordApi';
import CloneJobRecord from '@salesforce/apex/CloneATIJob.CloneJobRecord';
import JOB_OBJECT from '@salesforce/schema/ATI_Job__c';
import { NavigationMixin, CurrentPageReference } from 'lightning/navigation';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

const fields = [
    'ATI_Job__c.Name',  'ATI_Job__c.Job_Name__c', 
    'ATI_Job__c.Job_Number__c', 'ATI_Job__c.Account__c', 'ATI_Job__c.Contact__c', 'ATI_Job__c.Taken_By__c', 
    'ATI_Job__c.Lead_Source__c', 'ATI_Job__c.Year_Structure_Built__c', 
    'ATI_Job__c.Date_of_Loss__c', 'ATI_Job__c.Description__c', 'ATI_Job__c.Job_Class__c', 
    'ATI_Job__c.Project_Site_Contact_Name__c', 'ATI_Job__c.Project_Site_Contact_Account__c', 'ATI_Job__c.Office2__c',  'ATI_Job__c.Stage__c', 
    'ATI_Job__c.Project_Type__c', 
    'ATI_Job__c.Referred_by__c', 
    'ATI_Job__c.Branch_Manager__c', 
    'ATI_Job__c.Project_Manager__c',
    'ATI_Job__c.CloseDate__c',
    'ATI_Job__c.City_of_LA__c', 
    'ATI_Job__c.Project_Site_Address__c', 
    'ATI_Job__c.Project_Site_Address_2__c', 
    'ATI_Job__c.Project_Site_City__c', 
    'ATI_Job__c.Project_Site_State__c', 
    'ATI_Job__c.Project_Site_Zipcode__c', 
    'ATI_Job__c.County__c',
    'ATI_Job__c.No_Email_Available__c', 
    'ATI_Job__c.Policy__c', 
    'ATI_Job__c.Deductible__c', 
    'ATI_Job__c.Claim__c', 
    'ATI_Job__c.Cont_P_O_Client_Job__c', 
    'ATI_Job__c.PO__c', 
    'ATI_Job__c.Send_Prelim__c',
    //'ATI_Job__c.Parent_Job__c',
];
export default class CloneJobLWC extends NavigationMixin(LightningElement) {
    connectedCallback(){
        console.log('Record id is ' + this.recordId);
    }
@track loading;
@track ErrorMessage;
@track Error;
@track JobResults;
@api objectApiName;
@track objectInfo;
@track ParentJob;
@track ContPOClientJob;
@track PO;
@track SendPrelim;
@track CityOfLA;
@track County;
@track ProjectSiteCity;
@track ProjectSiteState;
@track ProjectSiteZipcode;
@track ProjectSiteContactEmail;
@track NoEmailAvailable;
@track Policy;
@track Deductible;
@track Claim;
@track Probability;
@track ProjectSiteAddress;
@track ProjectSiteAddress2;
@track ProjectSiteContactAccount;
@track ProjectSiteContactName;
@track Office;
@track Stage;
@track ReferredBy;
@track CloseDate;
@track ContactInformation;
@track LeadSource;
@track YearStructureBuilt;
@track DateOfLoss;
@track Description;
@track JobClass;
@track Name;
@track JobName;
@track JobNumber;
@track Account;
@track Contact;
@track TakenBy;
@track Customer;
@track ProjectDirector;
@track BranchManager;
@track No = false;
@track loading = false;

@api recordId;    
@track Yes = false;
@track Start = true;

@wire(getObjectInfo, { objectApiName: JOB_OBJECT })
    objectInfo;   
get recordTypeId() {
        // Returns a map of record type Ids 
        const rtis = this.objectInfo.data.recordTypeInfos;
        console.log('works up to here');
        return Object.keys(rtis).find(rti => rtis[rti].name === 'New Job (Not Approved)');
}
@wire(CurrentPageReference) pageRef;

@wire(getObjectInfo, { objectApiName: JOB_OBJECT })
    objectInfo;

@wire(getRecord, { recordId: '$recordId', fields })
	loadJob({ error, data }) {
		if (error) {
            console.log('error' + error);
			// TODO: handle error
		} else if (data) {
			
           console.log('Testing name ' + data.fields.Name.value);
           this.Name = data.fields.Name.value;
            this.JobName = data.fields.Job_Name__c.value;
            this.JobNumber = data.fields.Job_Number__c.value;
            this.Account = data.fields.Account__c.value;
            this.Contact = data.fields.Contact__c.value;
            this.TakenBy = data.fields.Taken_By__c.value;
            
            this.ParentJob = this.recordId;
            
            this.LeadSource = data.fields.Lead_Source__c.value;
            this.YearStructureBuilt = data.fields.Year_Structure_Built__c.value;
            this.DateOfLoss = data.fields.Date_of_Loss__c.value;
            this.Description = data.fields.Description__c.value;
            this.JobClass = data.fields.Job_Class__c.value;
           
            this.ProjectSiteContactName = data.fields.Project_Site_Contact_Name__c.value;
            this.ProjectSiteContactAccount = data.fields.Project_Site_Contact_Account__c.value;
            this.Office = data.fields.Office2__c.value;
            this.Stage = 'Qualification';
            this.ProjectType = data.fields.Project_Type__c.value;
            this.ReferredBy = data.fields.Referred_by__c.value;
            this.County = data.fields.County__c.value;
            this.CloseDate = data.fields.CloseDate__c.value;
            //this.ProjectDirector = data.fields.Project_Manager__c.value;
            this.BranchManager = data.fields.Branch_Manager__c.value;

           
            this.CityOfLA = data.fields.City_of_LA__c.value;
            this.ProjectSiteAddress = data.fields.Project_Site_Address__c.value;
            this.ProjectSiteAddress2 = data.fields.Project_Site_Address_2__c.value;
            this.ProjectSiteCity = data.fields.Project_Site_City__c.value;
            this.ProjectSiteState = data.fields.Project_Site_State__c.value;
            this.ProjectSiteZipcode = data.fields.Project_Site_Zipcode__c.value;
          
            this.NoEmailAvailable = data.fields.No_Email_Available__c.value;
            this.Policy = data.fields.Policy__c.value;
            this.Deductible = data.fields.Deductible__c.value;
            this.Claim = data.fields.Claim__c.value;
            this.ContPOClientJob = data.fields.Cont_P_O_Client_Job__c.value;
            this.PO = data.fields.PO__c.value;
            this.SendPrelim = data.fields.Send_Prelim__c.value;
            

		}
    }
    YesTrue(){
        this.Start = false;
        this.Yes = true;
    }
    NoTrue(){
        this.Start = false;
        this.Yes = true;
        this.ParentJob = '';
        // this.Description = '';
    }
    handleSuccess(event){
        const payload = event.detail;
        console.log(JSON.stringify(payload));
        console.log('before payload');
        const test = JSON.stringify(payload);
        const ContactJSON = JSON.parse(test);
        const jobId = ContactJSON.id;
        console.log(jobId);
       
        location.href='https://' + window.location.hostname + '/lightning/r/ATI_Job__c/' + jobId + '/view';
        event.action= this.location;
        // this[NavigationMixin.Navigate]({
        //     type: 'standard__recordPage',
        //     attributes: {
        //         recordId: jobId,
        //         objectApiName: 'ATI_Job__c',
        //         actionName: 'view',
        //     },
        // });
    }
    Loading(){
        console.log('Starting Load');
        this.loading = true;
    }
    Cancel(){
        this.loading = true;
        this.dispatchEvent(new CustomEvent('closeform'));
        
    }
    CloneJobRecordRelated(){
        var related = true;
        this.loading = true;
        CloneJobRecord({recordId:this.recordId, related: related}).then(result =>{
            this.JobResults = result;
            if(this.JobResults.length > 18){
                this.loading = false;
                this.ErrorMessage = this.JobResults;
                this.Error = true;
                console.log('Error ' + this.JobResults);
            }else{
                console.log('Success ' + this.JobResults);
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: this.JobResults,
                        objectApiName: 'ATI_Job__c',
                        actionName: 'view',
                    },
                });
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: this.JobResults,
                        objectApiName: 'ATI_Job__c',
                        actionName: 'edit',
                    },
                });
            }
        })
    }
    CloneJobRecordNotRelated(){
        var related = false;
        this.loading = true;
        CloneJobRecord({recordId: this.recordId, related: related}).then(result =>{
            this.JobResults = result;
            console.log('Job Results is ' + this.JobResults);
            if(this.JobResults.length > 18){
                this.loading = false;
                this.ErrorMessage = this.JobResults;
                this.Error = true;
            }else{
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: this.JobResults,
                        objectApiName: 'ATI_Job__c',
                        actionName: 'view',
                    },
                });
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: this.JobResults,
                        objectApiName: 'ATI_Job__c',
                        actionName: 'edit',
                    },
                });
            }
        })
    }
}