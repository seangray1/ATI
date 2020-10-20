import { LightningElement,api,track } from 'lwc';
import RefreshData from '@salesforce/apex/LargeLossUtility.RefreshLargeLoss';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
export default class LargeLossRefreshLWC extends LightningElement {
@api recordId;
loading = false;    
    connectedCallback(){
        this.loading = true;
       
        RefreshData({
        recordId : this.recordId
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
                message: 'Data Refreshed',
                variant: 'success',
            });
            this.dispatchEvent(event);
            this.dispatchEvent(new CustomEvent('refreshRecord'));  
          
        }
    
        else{
            this.loading = false;
            alert(message);
            this.dispatchEvent(new CustomEvent('refreshRecord'));
        }
    });
      
    }
}