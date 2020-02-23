/**
 * @File Name          : allocationsApp.js
 * @Description        : 
 * @Author             : Sean Gray
 * @Group              : 
 * @Last Modified By   : Sean Gray
 * @Last Modified On   : 2/2/2020, 2:20:43 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    2/2/2020   Sean Gray     Initial Version
**/
import { LightningElement, track, api, wire } from 'lwc';
import AllocationApproval from '@salesforce/apex/JobButtons.AllocationApproval';
import { getRecord } from 'lightning/uiRecordApi';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
const fields = [
	'ATI_Job__c.Job_Number__c',
    'ATI_Job__c.Name',
    'ATI_Job__c.Amount__c'
];
export default class AllocationsApp extends LightningElement {
@track FirstQ;
@track SecondQ;
@track ThirdQ;
@track Subcontractor;
@track Amount;
@track JobNumber;
@track OppName;
@track Description;
@api recordId;
@track ReturnMessage;
@track data;
@track loading = false;
@track error = false;
get options() {
    return [ 
        { label: 'Yes', value: 'Yes' },
        { label: 'No', value: 'No' },
    ];
}
@wire(getRecord, { recordId: '$recordId', fields })
	loadJob({ error, data }) {
		if (error) {
            console.log('Error is ' + error);
            //this.error = true;
		} else if (data) {
			this.OppName = data.fields.Name.value;
			this.Amount = data.fields.Amount__c.value;
            this.JobNumber = data.fields.Job_Number__c.value;
        }}

handleFirstChange(e){
    this.FirstQ = e.detail.value;
}
handleSecondChange(e){
    this.SecondQ = e.detail.value;
}
handleThirdChange(e){
    this.ThirdQ = e.detail.value;
}
handleSubcontractorChange(e){
    this.Subcontractor = e.detail.value;
}
handleDescriptionChange(e){
    this.Description= e.detail.value;
}

    createAllocation(){
        console.log('Testing ');
        if((!this.FirstQ)||(!this.SecondQ)||(!this.ThirdQ)||(!this.Description)||(!this.Subcontractor)){
            this.error = true;
        }else{
        this.loading = true; 
        console.log(' Oppname ' + this.OppName + this.recordId + this.JobNumber + this.Amount + this.FirstQ + this.SecondQ + this.ThirdQ + this.Description);
        AllocationApproval({OppName:this.OppName, recordId:this.recordId, JobNumber:this.JobNumber, Amount:this.Amount,FirstQ:this.FirstQ,SecondQ:this.SecondQ,ThirdQ:this.ThirdQ,Subcontractor:this.Subcontractor,Description:this.Description})
        .then(result => {
            this.ReturnMessage = result;
            if(this.ReturnMessage === 'success'){
                console.log('Success ' + this.ReturnMessage);
                const event = new ShowToastEvent({
                    title:'Success',
                    message: 'Saved',
                    variant: 'success',
                });
                this.dispatchEvent(event);
                this.dispatchEvent(new CustomEvent('recordChange'));  
            //     this[NavigationMixin.Navigate]({
            //         type: 'standard__recordPage',
            //         attributes: {
            //             recordId: this.recordId,
            //             objectApiName: 'ATI_Job__c',
            //             actionName: 'view',       
            //     },
        }else{
            console.log('error ' + this.ReturnMessage);
            this.loading = false;
            alert(this.ReturnMessage);
            
        }});   
    
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