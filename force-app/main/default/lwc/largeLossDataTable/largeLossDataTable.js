import { LightningElement, wire, api, track } from 'lwc';
import getLargeLossReviews from '@salesforce/apex/LargeLossUtility.getLargeLossReviews';


export default class LargeLossDataTable extends LightningElement {
    @track data = [];
    reviews;
    error;
    @api recordId;
    columns = [
        // { label: 'Large Loss Review', fieldName: 'name' },
        { label: 'Large Loss Review', fieldName: 'name1', type: 'url',
        typeAttributes: {label: { fieldName: 'name' }, target: '_blank'} },
        // { label: 'Amount', fieldName: 'amount', type: 'currency' },
        // { label: 'Job to Date Costs', fieldName: 'jobcosts', type: 'currency' },
        // { label: 'Estimated GP%', fieldName: 'estimatedgp', type: 'percent' },
        // { label: 'Forecast for Current Month', fieldName: 'forecastscurrentmonth', type: 'currency' },
        { label: 'Status', fieldName: 'status', type: 'text' },
     
        { label: 'NLLS Reviewer', fieldName: 'nlssreviewer1', type: 'url',
        typeAttributes: {label: { fieldName: 'nlssreviewer' }, target: '_blank'} },
        { label: 'Additional Comments', fieldName: 'additionalcomments', type: 'text' },
        
        
    ];
    connectedCallback()
    {
        console.log(this.recordId);
        getLargeLossReviews({recordId:this.recordId}).then(result =>
            {
                let data = result;
                // console.log(JSON.stringify(result));
                let datareturned = [];
                for(var i = 0;i<data.length; i++)
                {
                    datareturned.push({id:i, name:data[i].Name, name1:'/' +data[i].Id,  status:data[i].Status__c, additionalcomments:data[i].Additional_Comments__c }); 
                    if(data[i].NLLS_Reviewer__c != undefined && data[i].NLLS_Reviewer__c != "" && data[i].NLLS_Reviewer__c != null)
                    {
                        console.log(i +'             ' + JSON.stringify(data[i]));
                        datareturned[i].nlssreviewer1 = '/' +data[i].NLLS_Reviewer__c;
                        datareturned[i].nlssreviewer = data[i].NLLS_Reviewer__r.Name;
                        // datareturned[i].nlssreviewer = data[i].NLSS_Reviewer__r.Name;
                    }
                }
                
                // amount:data[i].Amount__c, jobcosts:data[i].Job_to_Date_Costs__c,
                //         forecastscurrentmonth:data[i].Forecast_for_Current_Month__c, estimatedgp:data[i].Estimated_GP_Percent__c,
                this.data = datareturned;
                // console.log(JSON.stringify(this.data));
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