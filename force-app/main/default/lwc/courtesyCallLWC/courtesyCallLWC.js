/**
 * @File Name          : courtesyCallLWC.js
 * @Description        : 
 * @Author             : Sean Gray
 * @Group              : 
 * @Last Modified By   : Sean Gray
 * @Last Modified On   : 1/30/2020, 2:54:08 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    1/30/2020   Sean Gray     Initial Version
**/
import { LightningElement, api, wire} from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';

import COURTESYCALL_FIELD from '@salesforce/schema/Case.Case_Type__c';
import CASE_OBJECT from '@salesforce/schema/Case';

export default class CourtesyCallLWC extends LightningElement {
Notes;
data;
CaseType;
CourtesyCallOutcome;
@api recordId;

@wire(getObjectInfo, { objectApiName: CASE_OBJECT })
    objectInfo;

    get recordTypeId() {
        // Returns a map of record type Ids 
        const rtis = this.objectInfo.data.recordTypeInfos;
        return Object.keys(rtis).find(rti => rtis[rti].name === 'Collection Case');
    }

@wire(getPicklistValues, {
    recordTypeId: '0120g000000chbbAAA',
    fieldApiName: COURTESYCALL_FIELD
  })
  setPicklistOptions1({ data }) {
    if (data) {
      this.CaseType = data.values;
    }
  }
    
    CourtesyCallChange(e)
    {
        this.CourtesyCallOutcome = e.detail.value;
    }
    CourtesyCallChange(e)
    {
        this.Notes = e.detail.value;
    }
    SubmitForm()
    {
        this.dispatchEvent(new CustomEvent('Submit'));
    }
    Cancel()
    {
        this.dispatchEvent(new CustomEvent('Close'));
    }


}