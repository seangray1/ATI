import { LightningElement, api } from 'lwc';
import RetrieveAccountRoles from "@salesforce/apex/NewJobController.RetrieveAccountRoles";
import My_Resource from '@salesforce/resourceUrl/SLDS202';

const actions = [
    { label: 'View Contact and Account', name: 'View Contact and Account' }, 
]; 
const columns = [
    { label: 'Contact', fieldName: 'Contact' , wrapText: true, type: 'url',
        typeAttributes: {label: { fieldName: 'ContactId' }, tooltip:'Contact Tooltip', mouseover:'test', target: '_blank'}},
    { label: 'Account', fieldName: 'Account', type: 'url',
    typeAttributes: {label: { fieldName: 'AccountId' }, target: '_blank'} },
    { label: 'Roles', fieldName: 'Roles', type: 'text', wrapText: true},
    { label: 'Timberline Customer Number', fieldName: 'TimberlineCustomerNumber', type: 'text', wrapText: true},

    {
        type: 'action',
        typeAttributes: { rowActions: actions },
    },
    
];
export default class AccountRolesDataTable extends LightningElement {
    data = [];
    columns = columns;
    AccountRolesSize;
    spring20Logo = My_Resource + '/assets/icons/custom-sprite/svg/symbols.svg#custom91';
    row;
    ViewDetails = false;
    ContactSelected;
    RowLevelDetails;
    AccountExists = false;
    ContactExists = false;
    @api recordId;
    
    // eslint-disable-next-line @lwc/lwc/no-async-await
    connectedCallback() {
        RetrieveAccountRoles({recordId:this.recordId}).then(result =>{
            const data = result;
            this.AccountRolesSize = data.length;
            this.ViewAll = '/lightning/r/' + this.recordId + '/related/Account_Roles__r/view'
            console.log('Data ' + JSON.stringify(data));
            let datasetup = [];
            for(var i = 0; i < data.length; i++)
            {
                
                datasetup.push({id:i, Roles:data[i].Multiple_Roles__c, TimberlineCustomerNumber:data[i].TimberlineCustomerNumber, Contact:"", Account:""})
                if(data[i].Contact_ID__c !== undefined)
                {
                    console.log('inside Contact part' + JSON.stringify(data[i].Contact_ID__r.Name));
                    datasetup[i].Contact ='/' + data[i].Contact_ID__c;
                    datasetup[i].ContactId=data[i].Contact_ID__r.Name;
                    datasetup[i].ContactPhone=data[i].Contact_ID__r.Phone;
                    datasetup[i].ContactEmail=data[i].Contact_ID__r.Email;
                }
                if(data[i].Account_ID__c !== undefined)
                {
                    console.log('inside Account part' + JSON.stringify(data[i].Account_ID__c.Name));
                    datasetup[i].Account ='/' + data[i].Account_ID__c;
                    datasetup[i].AccountId=data[i].Account_ID__r.Name;
                    datasetup[i].AccountPhone=data[i].Account_ID__r.Phone;
                    datasetup[i].AccountEmail=data[i].Account_ID__r.Type;
                }
            }
            console.log(datasetup);
            this.data = datasetup;
        })
        
    }
    handleRowAction(event) 
    {
        //this.Decision = event.detail.action.name;
        //ContactSelected
        
        this.row = event.detail.row;
        console.log('row is ' + JSON.stringify(this.row));
        const { id } = this.row;
        const index = this.findRowIndexById(id);
        // let ItemsToApproveReject =[];
        
        //let ItemsToSend = JSON.stringify(this.data[index]);
        this.RowLevelDetails = this.data[index];
        console.log(JSON.stringify(this.RowLevelDetails));
        if(this.RowLevelDetails.Contact !== "")
        {
            this.ContactExists = true;
        }
        if(this.RowLevelDetails.Account !== "")
        {
            this.AccountExists = true;
        }
        this.ViewDetails = true;
        //this.AccountNameSelected = this.data[index].Contact_ID__r.Name;
        
    }
    SelectedDecisionClicked(event)
    {
        this.Decision = event.target.name;
        this.DecisionClicked = true;
        
    }
    findRowIndexById(id) {
        let ret = -1;
        this.data.some((row, index) => {
            if (row.id === id) {
                ret = index;
                console.log('ret is ' + ret);
                return true;
            }
            return false;
        });
        return ret;
    }
    CloseViewDetails()
    {
        this.ViewDetails = false;
    }
}