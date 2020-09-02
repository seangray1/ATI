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

import ValidateRecord from '@salesforce/apex/LargeLossUtility.ValidateRecord';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import { NavigationMixin } from "lightning/navigation";
export default class LargeLossLWC extends NavigationMixin(LightningElement) {
@api recordId;
@track loading = false;
Validated = false;

// connectedCallback()
// {
//     ValidateRecord({recordId:this.recordId}).then(result =>
//     {
//         if(result === 'Success')
//         {
//             //code
//             this.Validated = true;
//         }
//         else
//         {
//             alert(result);
//             this.dispatchEvent(new CustomEvent('Close'));
//         }
//     })
// }
Send()
{
    this.loading = true;
    ValidateRecord({recordId : this.recordId}).then(result => 
    {
        //this.loading = false;
        let message = result;
        if(message.length <= 18)
        {
            const event = new ShowToastEvent({
                title:'Success',
                message: 'Large Loss Review Created',
                variant: 'success',
            });
            this.dispatchEvent(event);
            this[NavigationMixin.Navigate]({
                type: "standard__recordPage",
                attributes: {
                  recordId: message,
                  objectApiName: "Large_Loss_Review__c",
                  actionName: "view"
                }
              }); 
        }
        else
        {
        this.loading = false;
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