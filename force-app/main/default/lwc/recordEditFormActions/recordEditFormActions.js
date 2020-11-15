import UtilJS from '@salesforce/resourceUrl/UtilJS';
import { LightningElement,api } from 'lwc';
import * as Utils from 'c/utils';

export default class RecordEditFormActions extends LightningElement {
    @api handleReset() {
        const inputFields = this.template.querySelectorAll(
            'lightning-input-field'
        );
        if (inputFields) {
            inputFields.forEach(field => {
                field.reset();
            });
        }
      }
}