import { LightningElement, api, track } from 'lwc';
import UpdatePropertyAddress from "@salesforce/apex/NewJobController.UpdateProperty";
export default class PropertyUpdateLWC extends LightningElement {
@api recordId;
@track loading = false;
    PropertyUpdate(){
        this.loading = true;
        const address = this.template.querySelector('[data-id="AddressLookup"]');
      const isValid = address.checkValidity();
      if (isValid) {
        let Street = address.street;
        let City = address.city;
        let State = address.province;
        let Zip = address.postalCode;
        let Country = address.country;
        console.log(Street + City + State + Zip + Country);
        UpdatePropertyAddress({recordId: this.recordId, Street: Street, City:City, State:State, Zip:Zip,Country:Country}).then(result =>{
            if(result === 'SUCCESS'){
                this.loading = false;
                this.dispatchEvent(new CustomEvent('closePage')); 
            }else{
                this.loading = false;
                alert(result);
            }
        })
    }else{
        this.loading = false;
        alert('Address Not Valid');
    }
}
    Close(){
        this.dispatchEvent(new CustomEvent('closePage'));
    }
}