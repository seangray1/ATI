import { LightningElement } from 'lwc';
import GetAccountData from '@salesforce/apex/NewJobController.GetAccountData';
import ApproveSelectedItems from '@salesforce/apex/NewJobController.ApproveSelectedItems';
const actions = [
    { label: 'Approve', name: 'Approve' },
    { label: 'Reject', name: 'Reject' },
    
]; 

const columns = [
    { label: 'Master Job', fieldName: 'MasterJob' , wrapText: true, type: 'url',
    typeAttributes: {label: { fieldName: 'MasterJobName1' }, target: '_blank'}},
    { label: 'Submitted By', fieldName: 'CreatedBy' },
    { label: 'Account', fieldName: 'AccountName', type: 'url',
    typeAttributes: {label: { fieldName: 'AccountName1' }, target: '_blank'} },
    { label: 'Contact', fieldName: 'ContactName', type: 'url',
    typeAttributes: {label: { fieldName: 'ContactName1' }, target: '_blank'} },
    { label: 'Referred By', fieldName: 'ReferredBy', type: 'url',
    typeAttributes: {label: { fieldName: 'ReferredBy1' }, target: '_blank'} },
    {
        type: 'action',
        typeAttributes: { rowActions: actions },
    },
    
    
];
export default class ItemsToApprove extends LightningElement {
    data = [];
    datasetup = [];
    columns = columns;
    SelectedData = [];

    // eslint-disable-next-line @lwc/lwc/no-async-await
    connectedCallback() {
        
           
        GetAccountData({}).then(result =>{
            // console.log('Result ' + JSON.stringify(result));
            let accounts = result;
            // console.log('Account is ' + accounts);
            // console.log('Account is ' + JSON.stringify(accounts));
            console.log('Accounts lenght is ' + accounts.length );
            console.log(' and account name is ' + accounts[0].Account);
            for (var i = 0; i < accounts.length; i++) {
                console.log('1st Account Name ' + accounts[i].Account);
                this.datasetup.push({AccountName1:accounts[i].Account,ContactName1:accounts[i].Contact,MasterJobName1:accounts[i].MasterJob,ReferredBy1:accounts[i].ReferredBy,processId:accounts[i].processId,processinstanceId:accounts[i].processinstanceId, id:i,MasterJob: '/' + accounts[i].MasterJobId, CreatedBy: accounts[i].createdByName, AccountName:'/' + accounts[i].AccountId, ContactName:'/' + accounts[i].ContactId, ReferredBy:'/' + accounts[i].ReferredById});
                console.log('Account name is ' + JSON.stringify(this.datasetup[i].AccountName));
                if(accounts[i].Account === undefined)
                {
                    console.log('clearing account name ' + i + ' ' + this.datasetup[i].AccountName);
                    this.datasetup[i].AccountName = "";
                    this.datasetup[i].AccountNameId = "";
                }
                if(accounts[i].Contact === undefined)
                {
                    this.datasetup[i].ContactName = "";
                    this.datasetup[i].ContactName1 = "";
                }
                if(accounts[i].MasterJob === undefined)
                {
                    this.datasetup[i].MasterJob = "";
                    this.datasetup[i].MasterJobName1 = "";
                }
                if(accounts[i].ReferredBy === undefined)
                {
                    this.datasetup[i].ReferredBy = "";
                    this.datasetup[i].ReferredBy1 = "";
                }
                // console.log('Account is ' + JSON.stringify(this.datasetup));
            }
            this.data = this.datasetup;
            // console.log('Data is ' + this.data);
            
        });
        // console.log('Data after is ' + this.data);
        // this.data = [{Name:'Sean', email:'test'}];
        // console.log('Data is ' +this.data);
    }
    handleRowAction(event) {
        
        
        const actionName = event.detail.action.name;
        console.log('Action name is ' + actionName);
        const row = event.detail.row;
        console.log('row is ' + JSON.stringify(row));
        
        switch (actionName) {
            case 'Approve':
                this.Approve(row);
                break;
            case 'Reject':
                this.Reject(row);
                break;
            default:
        }
    }

    Reject(row) {        
           
        const { id } = row;
        const index = this.findRowIndexById(id);
        // console.log('index is ' + index);
                    const rows = this.data;
                    // console.log('Row id is ' + JSON.stringify(row.id));
                    // console.log('Row master job is ' + JSON.stringify(row.MasterJob));
                    // console.log('Rows is ' + JSON.stringify(rows));
                    // console.log('Rows with index included is ' + JSON.stringify(rows[row.id]));
                   
                    rows.splice(index, 1);
                    console.log('rows is ' + JSON.stringify(rows));
                    let rowsetup = [];
                    this.data = [];
                    for (var i = 0; i < rows.length; i++) {
                        
                        this.data.push({id:i,MasterJob: rows[i].MasterJob, MasterJobName1: rows[i].MasterJobName1, CreatedBy: rows[i].createdByName, AccountName:rows[i].AccountName, AccountName1:rows[i].AccountName1, ContactName:rows[i].ContactName, ContactName1:rows[i].ContactName1, ReferredBy:rows[i].ReferredBy, ReferredBy1:rows[i].ReferredBy1});   
                    }
                    // this.data = this.datasetup;
                    // this.data = rows;
                   
                    // console.log('data is ' + JSON.stringify(this.data));
        
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

   

    showRowDetails(row) {
        this.record = row;
    }
    getSelectedName(event)
    {
        const selectedRows = event.detail.selectedRows;
        console.log('Selected Row when blank is ' + selectedRows);
        console.log('Before ' + this.SelectedData);
        this.SelectedData = [];
        // Display that fieldName of the selected rows
        for (let i = 0; i < selectedRows.length; i++){
            console.log("You selected: " + selectedRows[i].MasterJob);
           
            console.log('After clear ' + this.SelectedData);
            this.SelectedData.push(selectedRows[i]);
            console.log('After push ' + JSON.stringify(this.SelectedData));
            
        }
    }
    ApproveSelected(event)
    {   
        var testeventname = event.detail.name;
        console.log('Testeventname ' + testeventname);
        let rowindexes = [];
        if(this.SelectedData.length > 0)
        {
            for (let i = 0; i < this.SelectedData.length; i++){  
                rowindexes.push(this.SelectedData[i].id);
                console.log('After push ' + JSON.stringify(this.SelectedData) + ' rowindexes is ' + rowindexes); 
            }
            console.log('141 is hit');
            let ItemsToSend = JSON.stringify({ItemsToApproveReject: this.SelectedData});
            console.log('Items to send is ' + ItemsToSend);
            ApproveSelectedItems({ItemsToApproveReject:ItemsToSend, Decision:'Approve'}).then(result => 
            {
                console.log('Result is ' + result);
                let rows = this.data;
                let rowsetup = [];
                this.data = [];
                console.log('Result lenght is ' + result.length);
                
    

                for (let i = result.length -1; i >= 0; i--)
                {
                    rows.splice(result[i], 1);
                }
                if(rows.length > 0)
                {
                for (var i = 0; i < rows.length; i++) 
                {
                    this.data.push({id:i,MasterJob: rows[i].MasterJob, MasterJobName1: rows[i].MasterJobName1, CreatedBy: rows[i].createdByName, AccountName:rows[i].AccountName, AccountName1:rows[i].AccountName1, ContactName:rows[i].ContactName, ContactName1:rows[i].ContactName1, ReferredBy:rows[i].ReferredBy, ReferredBy1:rows[i].ReferredBy1});   
                }
                }
            })
        }else
        {
            alert('Must select one or more to Approve Selected');
        }
    }
    // GenerateDataJSON() {
    //     console.log('165 is hit');
    //     var ItemsToApproveRejectObject = 
    //     console.log('Items line 168 ' + ItemsToApproveRejectObject);
    //     return JSON.stringify(ItemsToApproveRejectObject);
    //   }
}