import { LightningElement } from 'lwc';
import getListObjectName from "@salesforce/apex/AllSobjects.getListObjectName";
import getFieldNames from "@salesforce/apex/AllSobjects.getFieldNames";
import SaveApprovalView from "@salesforce/apex/AllSobjects.SaveApprovalView";

export default class ApprovalConfigurationLWC extends LightningElement {
    ObjectOptions = [{}];
    FieldOptions = [{}];
    ObjectValue;
    min = 1;
    max = 5;
    ObjectDataLoaded = false;
    FieldOptionsLoaded = false;
    ObjectSelected = false;
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
    SaveApprovalView()
    {
        console.log('Object name is ' + this.Object + '  fields are ' + this.Fields);
        
        SaveApprovalView({objectName : this.Object, Columns:this.Fields}).then(result => {
            let Results = result;
            if(Results === 'Success')
            {
                //clear Data
                console.log('Object name is ' + this.Object + '  fields are ' + this.Fields);
            }
            else{
                alert(Results);
            }
        })
    }
    ObjectChange(event){
        this.Object = event.detail.value;
        console.log('the object is ' + this.Object);
        if(this.Object === '' || this.Object === null || this.Object === undefined)
        {
            this.ObjectSelected = false;
            this.FieldOptionsLoaded = false;
            this.Fields = '';
        }
        else if(this.Object.length >= 1)
        {
        getFieldNames({objectName:this.Object}).then((result) => {
            let FieldOptions = result;
            for (var i = 0; i < FieldOptions.length; i++) {
              this.FieldOptions.push({
                label: FieldOptions[i],
                value: FieldOptions[i]
              });
            }
            
            this.FieldOptions.shift();
            this.FieldOptionsLoaded = true;
           
          });
        this.ObjectSelected = true;
        }
    }

    FieldChange(event){
        this.Fields = event.detail.value;
        
    }

}