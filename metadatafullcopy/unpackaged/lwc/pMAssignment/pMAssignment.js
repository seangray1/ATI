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
var ContactJSON;
var PackagedString;
var PDQueryResult;
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
projectManagerChange(event){
    this.projectManager1 = event.detail.value;

}

createPMAssignment(){
    if((!this.notes)||(!this.startDate)||(!this.completionDate)||(!this.briefScope)||(!this.contactInfo1)||(!this.projectManager1)){
        this.error = true;
    }else{
        ContactJSON = {'ContactString': this.contactInfo1, 'ProjectManagerString': this.projectManager1};
        
        PackagedString = JSON.stringify(ContactJSON);
        
    this.loading = true;
        
    PMAssignmentChatter({startDate:this.startDate, recordId:this.recordId,ownerId:Id, completionDate:this.completionDate,notes:this.notes,briefScope:this.briefScope,PackagedJSON:PackagedString})
    .then(result => {
        this.loading = false;
        this.ExtraData = result;
        if(this.ExtraData === 'Success'){
            this.dispatchEvent(new CustomEvent('recordChange'));  
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: this.recordId,
                    objectApiName: 'ATI_Job__c',
                    actionName: 'view',       
            },
        });   
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