import { LightningElement, track, wire, api } from "lwc";
import getAPINamesFromMetadata from '@salesforce/apex/NewRecordGetAPINames.getAPINames';
import {handleReset} from 'c/recordEditFormActions'; 
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import { getListUi } from 'lightning/uiListApi';
import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import * as Utils from 'c/utils';

export default class NewAccountLWC extends NavigationMixin(LightningElement) {
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
  handleCancel()
  {
    this.handleReset();
    this[NavigationMixin.Navigate]({
      type: 'standard__objectPage',
            attributes: {
                objectApiName: this.sObjectAPIName,
                actionName: 'home',
            },
    });
  }
  inputFields(){
    return this.template.querySelectorAll(
      'lightning-input-field');
  }
  addressFields(){
    return this.template.querySelector('[data-id="AddressLookup"]');
  }
  handleReset() {
    const inputFields = this.inputFields();
    const addressFields = this.addressFields();
    if(addressFields){
      addressFields.forEach(field => {
        field.reset();
      });
    }
    if (inputFields) {
        inputFields.forEach(field => {
            field.reset();
        });
    }
  }
  saveHandler(){
    console.log('test');
    // const test = log('test again');
    // console.logt(test);
    // log('Saving');
    // let inputfIeldss = Array.from(
    //   this.template.querySelectorAll('lightning-input-field')
    // );

    // let RowCount = inputfIeldss.length;

    // let test = inputfIeldss[0].value;
    // console.log('test' + JSON.stringify(test));
      // let ARName = TblRow[k].querySelector('.ARName').value;

      //let ARAddress = TblRow[k].querySelector('.ARAddress').value;
      
    const inputFields = this.inputFields();
    // console.log('fields name is ' + JSON.stringify(inputFields));
    for(var i = 0; i<inputFields.length;i++){
      console.log(inputFields[i].value);
      onsole.log('Input field ' + i + ' ' + inputFields[i]);
      // console.log(inputFields[i].fieldName);
    }
    console.log('inputFIelsd ',inputFields);
    const addressFields = this.addressFields();
    console.log('addressFields ',addressFields);
    console.log('addressfields now ' + addressFields);
    // const addressIsValid = addressFields.checkValidity();
    // if(addressIsValid) {
    //   if(this.sObjectAPIName == 'Account')
    //   {
    //     inputFields.BillingStreet = addressFields.street;
    //   }
      
      console.log('fields name is ' + JSON.stringify(inputFields));
      
      // fields.Job_Name__c = fields.Name;
      this.template.querySelector('lightning-record-edit-form').submit(inputFields).then(() => 
      this._handleSuccess(isComplete)).catch(error => this.setError(error));
      
    // }
    // else{
    //   this.setError('Unable to save record');
    // }

  }
}