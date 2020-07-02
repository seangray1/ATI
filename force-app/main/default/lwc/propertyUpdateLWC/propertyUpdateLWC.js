import { LightningElement, api, track } from 'lwc';
import UpdatePropertyAddress from "@salesforce/apex/NewJobController.UpdateProperty";
import GetUserInfo from "@salesforce/apex/NewJobController.GetUserInfo";
export default class PropertyUpdateLWC extends LightningElement {
@api recordId;
@track loading = false;
MarketSegmentSubClass;
MarketClass;
MarketSegment;



    connectedCallback(){
        GetUserInfo({}).then(result =>{
            
            console.log('Result is ' + result);
            // if(result.MasterJobCount > 1)
            if(result === 'System Administrator' || result === 'Contact Center Rep'){
                console.log('working');
            }else{
                alert('Access Not Allowed');
                this.dispatchEvent(new CustomEvent('closePage')); 
            }
        })
    }
    // MarketClass:this.MarketClass
    //     ,MarketSegment:this.MarketSegment, MarketSegmentSubClass:this.MarketSegmentSubClass
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
        UpdatePropertyAddress({recordId: this.recordId, Street: Street, City:City, State:State, Zip:Zip,Country:Country, }).then(result =>{
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
    MarketClassChange(event)
    {
        this.MarketClass = event.detail.value;
    }
    MarketSegmentChange(event)
    {
        this.MarketSegment = event.detail.value;
    }
    MarketSegmentSubClassChange(event)
    {
        this.MarketSegmentSubClass = event.detail.value;
    }
}