import { LightningElement } from 'lwc';
import getListObjectName from "@salesforce/apex/AllSobjects.getListObjectName";

export default class ApprovalConfigurationLWC extends LightningElement {
    ObjectOptions = [{}];
    ObjectValue;
    ObjectDataLoaded = false;
    async connectedCallback()
    {
        getListObjectName({}).then((result) => {
            let ObjectOptions = result;
            for (var i = 0; i < ObjectOptions.length; i++) {
              this.ObjectOptions.push({
                label: ObjectOptions[i],
                value: ObjectOptions[i]
              });
            }
            
            this.ObjectOptions.shift();
            this.ObjectDataLoaded = true;
           
          });
    }
    ObjectChange(event){
        this.Object = event.detail.value;
    }
}