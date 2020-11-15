import { LightningElement,api } from 'lwc';
import { createRecord, updateRecord } from 'lightning/uiRecordApi';
export default class PropertyTest extends LightningElement {
    test;
    @api recordId;
    handleTestChange(e)
    {
        this.test = e.detail.value;
    }
    handleClick()
    {
    const sglvBeneficiaryFields = [{Id:this.recordId,Mortgage_Company__c:this.test}];
    updateRecord({ fields: sglvBeneficiaryFields })
      .then(() => {
        this.setError(undefined);
        this.refreshData();
      })
      .catch(error => this.setError(error));
    }
}