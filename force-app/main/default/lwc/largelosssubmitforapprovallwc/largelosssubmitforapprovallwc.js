import { LightningElement,api,track } from 'lwc';
import LargeLossApproval from '@salesforce/apex/LargeLossUtility.LargeLossApprovalSubmission';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

export default class Largelosssubmitforapprovallwc extends LightningElement {
@api recordId;
loading = false;
Comments = '';

submit(){
    this.loading = true;
    let comments = this.template.querySelector('textarea');
    console.log('comments are ' + comments);
    LargeLossApproval({
    recordId : this.recordId, comments : this.Comments
    }).then(result => {
    ;
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
        this.loading = false;
        alert(message);
    }
});
  

}
handleFormInputChange(event)
{
    this.Comments = event.target.value;
}
cancel(){
    this.dispatchEvent(new CustomEvent('Close'));  
}

}