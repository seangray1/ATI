import { LightningElement, track, wire, api } from "lwc";
import getAPINamesFromMetadata from '@salesforce/apex/NewRecordGetAPINames.getAPINames'; 
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import { getListUi } from 'lightning/uiListApi';
import ACCOUNT_OBJECT from '@salesforce/schema/Account';

export default class NewAccountLWC extends LightningElement {
  @track _ApiWiredResult;
  @track APIfields = [];
  sObjectAPIName = 'Account';
  sObject = 'Account';
  records;
  error;

  @wire(getListUi, { objectApiName: ACCOUNT_OBJECT, listViewApiName: 'Recent' })
  listView({ error, data }) {
      console.log('Data',data);
      console.log('Error',error);
    if (data) {
        this.records = data.records.records;
        this.error = undefined;
        
    } else if (error) {
        this.error = error;
        this.records = undefined;
    }
}
    propertyOrFunction;
  @wire(getAPINamesFromMetadata,{objectName: 'Account'})
  wiredgetAPINamesFromMetadata(result) {
      console.log('Testing result ',result);
    var objData = {};
    var DataList;
    var EnableAPIList = ["Rating"];
    this._ApiWiredResult = result;
    if (result.data) {
      DataList = result.data;
      //console.log('datassssssssssssss'+JSON.stringify(DataList));
      if (DataList.length > 0) {
        let count = 0;
        for (let i in DataList) {
          if (DataList[i].API_Names__c) {
            var DataAPIList = DataList[i].API_Names__c.split(",");
            //console.log('APIList'+JSON.stringify(DataAPIList));
            for (let j in DataAPIList) {
              if (DataAPIList[j]) {
                objData = {};
                //console.log('API: '+DataAPIList[j]+' Section: '+DataList[i].LWC_Section__c);
                objData.key = count;
                
                objData.APIName = DataAPIList[j].trim();
                console.log('objData ',objData);
                // if (
                //   objData.APIName == "ATI_Job__c" &&
                //   this.jobId != null &&
                //   this.IsBudgetNew == true
                // ) {
                //   objData.value = this.jobId;
                // }
                // if (
                //   objData.APIName == "Regional_Manager__c" &&
                //   this.JobRegionalManger &&
                //   this.IsBudgetNew == true
                // ) {
                //   objData.value = this.JobRegionalManger;
                // }
                // if (
                //   objData.APIName == "Project_Director__c" &&
                //   this.JobProjectDirecor &&
                //   this.IsBudgetNew == true
                // ) {
                //   objData.value = this.JobProjectDirecor;
                // }
                // if (
                //   objData.APIName == "Project_Manager__c" &&
                //   this.JobProjectManager &&
                //   this.IsBudgetNew == true
                // ) {
                //   objData.value = this.JobProjectManager;
                // }
                // if (
                //   objData.APIName == "GP_Goal__c" ||
                //   objData.APIName == "Allocation_Overhead__c" ||
                //   objData.APIName == "Allocations__c" ||
                //   objData.APIName == "X3_Program_Fees__c"
                // ) {
                //   objData.changevnt = true;
                // }
                // if (DataList[i].LWC_Section__c == "Budget Info") {
                //   objData.BudgetSection = true;
                //   objData.TotalSection = false;
                //   objData.AllTotalSection = false;
                // } else if (DataList[i].LWC_Section__c == "Totals") {
                //   objData.BudgetSection = false;
                //   objData.TotalSection = true;
                //   objData.AllTotalSection = false;
                // } else if (DataList[i].LWC_Section__c == "Overall Total") {
                //   objData.BudgetSection = false;
                //   objData.TotalSection = false;
                //   objData.AllTotalSection = true;
                // }
                // objData.Section = DataList[i].LWC_Section__c;
                if (EnableAPIList.includes(objData.APIName)) {
                  objData.Section = true;
                } else {
                  objData.Section = false;
                }
                this.APIfields.push(objData);
                count++;
              }
            }
          }
        }
        console.log("API: " + JSON.stringify(this.APIfields));
      }
    } else if (result.error) {
      this.dispatchEvent(
        new ShowToastEvent({
          title: "Error Processing record",
          message: result.error,
          variant: "error"
        })
      );
    }
  }
}