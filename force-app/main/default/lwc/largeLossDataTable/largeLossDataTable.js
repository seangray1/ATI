import { LightningElement, wire, api, track } from 'lwc';
import getLargeLossReviews from '@salesforce/apex/LargeLossUtility.getLargeLossReviews';


export default class LargeLossDataTable extends LightningElement {
    @track data = [];
    reviews;
    error;
    @api recordId;
    columns = [
        { label: 'Large Loss Review', fieldName: 'name' },
        { label: 'Amount', fieldName: 'amount', type: 'currency' },
        { label: 'Job to Date Costs', fieldName: 'jobcosts', type: 'currency' },
        { label: 'Estimated GP%', fieldName: 'estimatedgp', type: 'percent' },
        { label: 'Forecast for Current Month', fieldName: 'forecastscurrentmonth', type: 'currency' },
        
    ];
    connectedCallback()
    {
        console.log(this.recordId);
        getLargeLossReviews({recordId:this.recordId}).then(result =>
            {
                let data = result;
                console.log(JSON.stringify(result));
                let datareturned = [];
                for(var i = 0;i<data.length; i++)
                {
                    datareturned.push({id:i, name:data[i].Name, amount:data[i].Amount__c, jobcosts:data[i].Job_to_Date_Costs__c,
                        forecastscurrentmonth:data[i].Forecast_for_Current_Month__c, estimatedgp:data[i].Estimated_GP_Percent__c }); 
                }
                this.data = datareturned;
                console.log(JSON.stringify(this.data));
            })
    }
    // @wire(getLargeLossReviews, { recordId: '$recordId' })
    // wiredReviews({ error, data }) 
    // {
    //     console.log('Record id is ' + this.recordId + 'datatable ' + JSON.stringify(data));
    //     let returnedData = [];
    //     if (data) 
    //     {
    //         for(var i = 0;i<data.length; i++)
    //         {
    //            this.data.push({id:i, name:data[i].Name, amount:data[i].Amount__c, jobcosts:data[i].Job_to_Date_Costs__c}); 
    //         }
    //         console.log('data ' + this.data);
    //         //this.data = returnedData;
    //         this.error = undefined;
    //     } else if (error) {
    //         this.error = error;
    //         this.data = undefined;
    //         alert(this.error);
    //     }
    // }
    
}