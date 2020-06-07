/**
 * @File Name          : largeLossLWC.js
 * @Description        : 
 * @Author             : Sean Gray
 * @Group              : 
 * @Last Modified By   : Sean Gray
 * @Last Modified On   : 2/28/2020, 11:09:59 AM
 * @Modification Log   : 
 * Ver       Date            Author                 Modification
 * 1.0    2/27/2020   Sean Gray     Initial Version
**/
import { LightningElement,api,track } from 'lwc';
import jobApproval from '@salesforce/apex/JobButtons.LargeLossApprovalSubmission';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
export default class LargeLossLWC extends LightningElement {
@api recordId
@track loading = false;

Send(){
    this.loading = true;
jobApproval({
    recordId : this.recordId
}).then(result => {
    this.loading = false;
    let message = result;

    if(message === 'success'){
    //     const evt = new ShowToastEvent({
    //         title: 'Success',
    //         message: 'Record Saved!',
    //         variant: 'success',
    //     });
        // this.dispatchEvent(evt);
        const event = new ShowToastEvent({
            title:'Success',
            message: 'Submitted for Approval',
            variant: 'success',
        });
        this.dispatchEvent(event);
        this.dispatchEvent(new CustomEvent('refreshRecord'));  
      
    }

    else{
        alert(message);
    }
});
  

}

Back(){
    this.dispatchEvent(new CustomEvent('Close'));  
}


}