/**
 * @File Name          : pMAssignment.js
 * @Description        : 
 * @Author             : Sean Gray
 * @Group              : 
 * @Last Modified By   : Sean Gray
 * @Last Modified On   : 2/1/2020, 6:07:03 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    10/4/2019   Sean Gray     Initial Version
**/
import { LightningElement, track, api } from 'lwc';
import Id from '@salesforce/user/Id';
import { NavigationMixin } from 'lightning/navigation';
import PMAssignmentChatter from '@salesforce/apex/JobButtons.PMAssignmentChatter';
import PMAssignmentQuery from '@salesforce/apex/JobButtons.PMAssignmentQuery';
import GetUsers from '@salesforce/apex/NewJobController.GetUsers';
import GetCustomers from '@salesforce/apex/NewJobController.GetCustomers';
var ContactJSON;
var PackagedString;
var PDQueryResult;
const DELAY = 300;
export default class PMAssignment extends NavigationMixin(LightningElement) {
    connectedCallback(){
        if(this.jobIdtosearch !== null){
        this.recordId = this.jobIdtosearch;
        
        }
        this.Id = Id;
        PMAssignmentQuery({recordId : this.recordId})
        .then(result => {
            this.PDQueryResults = result;
           
            PDQueryResult = JSON.parse(this.PDQueryResults);
            
            
            this.Insurance = PDQueryResult.Insurance;
            if(this.Insurance === 'null'){
                this.Insurance = 'None';
            }
           
            this.Fees= PDQueryResult.Fees;
            this.Allocation= PDQueryResult.Allocation;
            this.Price= PDQueryResult.Price;
            if(this.Price === 'null'){
                this.Price = 0;
            }
            this.Budget= PDQueryResult.Budget;
            this.Forecast= PDQueryResult.Forecast;
              
            
           // this.classValue = ClassCategory.class;
           
            //this.categoryValue = ClassCategory.category;
        })
        .catch(error => {
            this.error = error;
        });
    }
@track ExtraData;
@track loading = false;
@track error = false;
@api recordId;
@track ProjectManagerName;
@track ProjectManagers;
@track ProjectManagerValue;
@track ProjectManagerId;
@track ProjectManagerSelected = false;
@track ContactName;
@track Contacts;
@track ContactValue;
@track ContactId;
@track ContactSelected = false;
getcurrentpageurl = (new URL(document.location)).searchParams;
@api jobIdtosearch = this.getcurrentpageurl.get('job__id');
@track contactInfo;
@track notes;
@track briefScope;
@track startDate;
@track completionDate;
@track projectManager;
@track PMQueryResults;
@track Budget;
@track Fees;
@track Allocation;
@track Forecast;
@track Price;
@track Insurance;
@track projectManager1;
@track contactInfo1;

startDateChange(event){
    this.startDate = event.detail.value;

}
completionDateChange(event){
    this.completionDate = event.detail.value;

}
contactInfoChange(event){
    this.contactInfo1 = event.detail.value;

}
briefScopeChange(event){
    this.briefScope = event.detail.value;

}
notesChange(event){
    this.notes = event.detail.value;

}
ProjectManagerChange(event){
    window.clearTimeout(this.delayTimeout);
                   var searchKey = event.target.value;
                   if (searchKey.length === 0) {
                     this.ProjectManagers = null;
                   }
                   if (searchKey.length >= 1) {
                     // eslint-disable-next-line @lwc/lwc/no-async-operation
                     //this.delayTimeout = setTimeout(() => {
                     // eslint-disable-next-line @lwc/lwc/no-async-operation
                     this.delayTimeout = setTimeout(() => {
                       GetUsers({ searchKey: searchKey })
                         .then((result) => {
                           this.ProjectManagers = result;
                         })

                         .catch((error) => {
                           this.error = error;
                         });
                     }, DELAY);
                   }
                 }


populateProjectManagerField(event) {
    this.ProjectManagers = "";
    let ProjectManager = event.target.value;
    this.ProjectManagerName = ProjectManager.Name;
    this.ProjectManagerId = ProjectManager.Id;
    this.ProjectManagerSelected = true;
  }
  ClearProjectManager(event) {
    let searchKey = event.detail.value;
    if (searchKey.length === 0) {
      this.ProjectManagers = "";
    }
  }
  ContactChange(event){
    window.clearTimeout(this.delayTimeout);
                   var searchKey = event.target.value;
                   if (searchKey.length === 0) {
                     this.Contacts = null;
                   }
                   if (searchKey.length >= 1) {
                     // eslint-disable-next-line @lwc/lwc/no-async-operation
                     //this.delayTimeout = setTimeout(() => {
                     // eslint-disable-next-line @lwc/lwc/no-async-operation
                     this.delayTimeout = setTimeout(() => {
                        GetCustomers({ searchKey: searchKey })
                         .then((result) => {
                           this.Contacts = result;
                         })

                         .catch((error) => {
                           this.error = error;
                         });
                     }, DELAY);
                   }
                 }


populateContactField(event) {
    this.Contacts = "";
    let Contact = event.target.value;
    this.ContactName = Contact.Name;
    this.ContactId = Contact.Id;
    this.ContactSelected = true;
  }
  ClearContact(event) {
    let searchKey = event.detail.value;
    if (searchKey.length === 0) {
      this.Contacts = "";
    }
  }

createPMAssignment(){
    const input = [
        ...this.template.querySelectorAll(
          ".PMAssignmentFields"
        )
      ].reduce((validSoFar, inputCmp) => {
        inputCmp.reportValidity();
        return validSoFar && inputCmp.checkValidity();
      }, true);
      if (!input) {
        alert("Fill in all required fields before saving");
      } else {
        
    
        // ContactJSON = {'ContactString': this.contactInfo1, 'ProjectManagerString': this.projectManager1};
        
        // PackagedString = JSON.stringify(ContactJSON);
        
    this.loading = true;
        
    PMAssignmentChatter({startDate:this.startDate, recordId:this.recordId,ownerId:Id, completionDate:this.completionDate,notes:this.notes,briefScope:this.briefScope,ContactId:this.ContactId, ProjectManagerId:this.ProjectManagerId})
    .then(result => {
        this.loading = false;
        this.ExtraData = result;
        if(this.ExtraData === 'Success'){
            this.dispatchEvent(new CustomEvent('recordChange'));  
        //     this[NavigationMixin.Navigate]({
        //         type: 'standard__recordPage',
        //         attributes: {
        //             recordId: this.recordId,
        //             objectApiName: 'ATI_Job__c',
        //             actionName: 'view',       
        //     },
        // });   
        } else{
            alert(this.ExtraData);
        }
    });

}
}
Cancel(){
    this.loading = true;
    this.dispatchEvent(new CustomEvent('closeform')); 
    // this[NavigationMixin.Navigate]({
    //     type: 'standard__recordPage',
    //     attributes: {
    //         recordId: this.recordId,
    //         objectApiName: 'ATI_Job__c',
    //         actionName: 'view',
    //     },
    // });
}

}