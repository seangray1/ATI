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
import jobApproval from '@salesforce/apex/LargeLossUtility.LargeLossApprovalSubmission';
import ValidateRecord from '@salesforce/apex/LargeLossUtility.ValidateRecord';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
export default class LargeLossLWC extends LightningElement {
@api recordId
@track loading = false;
Validated = false;

connectedCallback()
{
    ValidateRecord({recordId:this.recordId}).then(result =>
    {
        if(result === 'Success')
        {
            //code
            this.Validated = true;
        }
        else
        {
            alert(result);
            this.dispatchEvent(new CustomEvent('Close'));
        }
    })
}
Send()
{
    this.loading = true;
    jobApproval({recordId : this.recordId}).then(result => 
    {
        this.loading = false;
        let message = result;
        if(message === 'success')
        {
            const event = new ShowToastEvent({
                title:'Success',
                message: 'Submitted for Approval',
                variant: 'success',
            });
            this.dispatchEvent(event);
            this.dispatchEvent(new CustomEvent('refreshRecord'));  
        }
        else
        {
        alert(message);
        }
    }
    );
}

Back()
{
    this.dispatchEvent(new CustomEvent('Close'));  
}


}