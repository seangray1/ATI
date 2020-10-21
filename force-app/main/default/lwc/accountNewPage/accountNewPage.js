import { LightningElement,api,wire, track } from 'lwc';
import getAPINamesFromMetadata from '@salesforce/apex/AccountController.getAPINamesFromMetadata';
// import getBDRecordTypeId from '@salesforce/apex/LeadOppConversion.GetBDRecordTypeId';
import { NavigationMixin } from "lightning/navigation";

export default class AccountNewPage extends LightningElement {
    
    
    @track APIfieldsQueried;
    @track APIfields = [];
 
  
    @wire(getAPINamesFromMetadata)
    wiredgetAPINamesFromMetadata(result) { 
        console.log('Result ',result);
        var objData ={};
        var DataList; 
        
        this._ApiWiredResult = result;
        if(result.data){
            console.log('result.data ',result.data);
            DataList =result.data;
            //console.log('datassssssssssssss'+JSON.stringify(DataList));
            if(DataList.length>0){
                let count=0;
                for(let i in DataList){
                    if(DataList[i].API_Names__c){ 
                        console.log('Datalist ' + i + ' API Names ', DataList[i].API_Names__c);
                        var DataAPIList = DataList[i].API_Names__c.split(',');
                        //console.log('APIList'+JSON.stringify(DataAPIList));
                        for(let j in DataAPIList){
                            if(DataAPIList[j]){
                                objData ={};
                                //console.log('API: '+DataAPIList[j]+' Section: '+DataList[i].LWC_Section__c);
                                objData.key = count;
                                objData.APIName = DataAPIList[j].trim();
                                console.log('objData ',objData);
                                this.APIfields.push(objData);
                                
                        }
                    }
                }
               console.log('API: '+JSON.stringify(this.APIfields));
            }
        } else if(result.error) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error Processing record',
                    message: result.error,
                    variant: 'error',
                }),
            );
        }
    }
}
}