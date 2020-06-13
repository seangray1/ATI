import { LightningElement } from 'lwc';
import GetAccountData from '@salesforce/apex/DynamicApprovalController.GetAccountData';
import ApproveSelectedItems from '@salesforce/apex/DynamicApprovalController.ApproveSelectedItems';
import GetColumns from '@salesforce/apex/DynamicApprovalController.GetColumns';
import GetViewTypes from '@salesforce/apex/DynamicApprovalController.GetViewTypes';
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
const columnsAll = [
    {label: 'Approval Name', fieldName: 'ApprovalName' , wrapText: true, type: 'url',
    typeAttributes: {label: { fieldName: 'ApprovalName1' }, target: '_blank'}},
    { label: 'Submitted By', fieldName: 'CreatedBy' },
    { label: 'Type', fieldName: 'ObjectName' },
    
    {
        type: 'action',
        typeAttributes: { rowActions: actions },
    },
    
];
export default class ItemsToApprove extends LightningElement {
    data = [];
    datasetup = [];
    Columns = [
        // { label: 'Master Job', fieldName: 'MasterJob' , wrapText: true, type: 'url',
        // typeAttributes: {label: { fieldName: 'MasterJobName1' }, target: '_blank'}},
        // { label: 'Submitted By', fieldName: 'CreatedBy' },
        // { label: 'Account', fieldName: 'AccountName', type: 'url',
        // typeAttributes: {label: { fieldName: 'AccountName1' }, target: '_blank'} },
        // { label: 'Contact', fieldName: 'ContactName', type: 'url',
        // typeAttributes: {label: { fieldName: 'ContactName1' }, target: '_blank'} },
        // { label: 'Referred By', fieldName: 'ReferredBy', type: 'url',
        // typeAttributes: {label: { fieldName: 'ReferredBy1' }, target: '_blank'} },
        // {
        //     type: 'action',
        //     typeAttributes: { rowActions: actions },
        // },
        
        
    ];
    SelectedData = [];
    Comments = '';
    Decision = '';
    row = '';
    objectName = 'Master_Job__c';
    ColumnsLoaded = false;
    SingleDecision = false;
    DecisionClicked = false;
    loading = false;
    AllView = true;
    MasterJobView = false;
    ApprovalListViews =[{}];
    ApprovalListViewLoaded = false;



    get ApprovalListViews() {

      return [{label:"All", value:"All"}, {label:"Master Job", value:"Master Job"}, {label:"Contact", value:"Contact"}];
  }
    // eslint-disable-next-line @lwc/lwc/no-async-await
    connectedCallback() {
        
        GetViewTypes({}).then(result =>{
            console.log('Result is ' + result);
            for (var i = 0; i < result.length; i++) 
            {
                this.ApprovalListViews.push({label:result[i].label, value:result[i].apiName});
            }
            this.ApprovalListViews.shift();
            this.ApprovalListViewLoaded = true;
      
        });
        GetColumns({objectName:this.objectName}).then(result =>{
            let ColumnNames = result;
            // for (var i = 0; i < ColumnNames.length; i++) 
            // {
                    console.log('ColumnNames are ' + ColumnNames);
                    // this.Columns = [{label:ColumnNames[0].Column_1__c, fieldName:ColumnNames[0].Column_1__c},
                    // {label:ColumnNames[1].Column_2__c, fieldName:ColumnNames[1].Column_2__c},
                    // {label:ColumnNames[2].Column_3__c, fieldName:ColumnNames[2].Column_3__c},
                    // {label:ColumnNames[3].Column_4__c, fieldName:ColumnNames[3].Column_4__c},
                    // {label:ColumnNames[4].Column_5__c, fieldName:ColumnNames[4].Column_5__c}];
                    
                    this.Columns = [{label:ColumnNames[0], fieldName:'Column_1__c'},
                    {label:ColumnNames[1], fieldName:'Column_2__c'},
                    {label:ColumnNames[2], fieldName:'Column_3__c'},
                    {label:ColumnNames[3], fieldName:'Column_4__c'},
                    {label:ColumnNames[4], fieldName:'Column_5__c'},
                    {
                        type: 'action',
                        typeAttributes: { rowActions: actions },
                    }];

                    type: 'url',
        // typeAttributes: {label: { fieldName: 'ReferredBy1' }, target: '_blank'} 
                    console.log('Columns array 0 is ' + JSON.stringify(this.Columns[0]));
                    this.Columns[0].type = 'url';
                    this.Columns[0].typeAttributes = {label: { fieldName: 'Column_1_Name__c' }, target: '_blank'};
                    
                    console.log('Columns array 0 is ' + JSON.stringify(this.Columns[0]));
                    console.log(this.Columns);
                    this.dataLoaded = true;
                    // this.Columns.push[];
                    // this.Columns.push[{];
                    // this.Columns.push[];
                    // this.Columns.push[];
                        
                        
                        //ContactName1:accounts[i].Contact,MasterJobName1:accounts[i].MasterJob,ReferredBy1:accounts[i].ReferredBy,processId:accounts[i].processId,processinstanceId:accounts[i].processinstanceId, id:i,MasterJob: '/' + accounts[i].MasterJobId, CreatedBy: accounts[i].createdByName, AccountName:'/' + accounts[i].AccountId, ContactName:'/' + accounts[i].ContactId, ReferredBy:'/' + accounts[i].ReferredById});
                    // console.log('Account name is ' + JSON.stringify(this.datasetup[i].AccountName));
                    // if(accounts[i].Account === undefined)
                    // {
                    //     console.log('clearing account name ' + i + ' ' + this.datasetup[i].AccountName);
                    //     this.datasetup[i].AccountName = "";
                    //     this.datasetup[i].AccountNameId = "";
                    // }
                    // if(accounts[i].Contact === undefined)
                    // {
                    //     this.datasetup[i].ContactName = "";
                    //     this.datasetup[i].ContactName1 = "";
                    // }
                    // if(accounts[i].MasterJob === undefined)
                    // {
                    //     this.datasetup[i].MasterJob = "";
                    //     this.datasetup[i].MasterJobName1 = "";
                    // }
                    // if(accounts[i].ReferredBy === undefined)
                    // {
                    //     this.datasetup[i].ReferredBy = "";
                    //     this.datasetup[i].ReferredBy1 = "";
                    // }
                
        //    }
            //this.data = this.datasetup;
            
        });
       
        GetAccountData({objectName:this.objectName}).then(result =>{
            // console.log('Result ' + JSON.stringify(result));
           let ObjectData = result;
            
            // console.log('Account is ' + accounts);
            // console.log('Account is ' + JSON.stringify(accounts));
        //     console.log('Accounts lenght is ' + accounts.length );
        //     console.log(' and account name is ' + accounts[0].Account);
            for (var i = 0; i < ObjectData.length; i++) 
            {
        //     //     // if(this.objectName == 'All')
        //     //     // {
        //     //         console.log('1st Account Name ' + accounts[i].Account);
                    this.datasetup.push({Column_1__c:ObjectData[i].Column1, Column_2__c:ObjectData[i].Column2,
                                        Column_3__c:ObjectData[i].Column3, Column_4__c:ObjectData[i].Column4,
                                        Column_5__c:ObjectData[i].Column5, });
                                        
                    if(ObjectData[i].Column1Name !== null)
                    {
                        this.datasetup[i].Column_1__c = '/' + ObjectData[i].Column1;
                        this.datasetup[i].Column_1_Name__c = ObjectData[i].Column1Name;
                    }
                    
                    console.log('ObjectData is ' + JSON.stringify(ObjectData[i]));
                }
                this.data = this.datasetup;
                
                
        //             console.log('1st Account Name ' + accounts[i].Account);
        //             this.datasetup.push({AccountName1:accounts[i].Account,ContactName1:accounts[i].Contact,MasterJobName1:accounts[i].MasterJob,ReferredBy1:accounts[i].ReferredBy,processId:accounts[i].processId,processinstanceId:accounts[i].processinstanceId, id:i,MasterJob: '/' + accounts[i].MasterJobId, CreatedBy: accounts[i].createdByName, AccountName:'/' + accounts[i].AccountId, ContactName:'/' + accounts[i].ContactId, ReferredBy:'/' + accounts[i].ReferredById});
        //             console.log('Account name is ' + JSON.stringify(this.datasetup[i].AccountName));
        //             if(accounts[i].Account === undefined)
        //             {
        //                 console.log('clearing account name ' + i + ' ' + this.datasetup[i].AccountName);
        //                 this.datasetup[i].AccountName = "";
        //                 this.datasetup[i].AccountNameId = "";
        //             }
        //             if(accounts[i].Contact === undefined)
        //             {
        //                 this.datasetup[i].ContactName = "";
        //                 this.datasetup[i].ContactName1 = "";
        //             }
        //             if(accounts[i].MasterJob === undefined)
        //             {
        //                 this.datasetup[i].MasterJob = "";
        //                 this.datasetup[i].MasterJobName1 = "";
        //             }
        //             if(accounts[i].ReferredBy === undefined)
        //             {
        //                 this.datasetup[i].ReferredBy = "";
        //                 this.datasetup[i].ReferredBy1 = "";
        //             }
                
        //    }
        //     this.data = this.datasetup;
            
        });
    }
    handleRowAction(event) {
        this.Decision = event.detail.action.name;
        this.DecisionClicked = true;
        this.SingleDecision = true;
        console.log('Decision' + this.Decision);
        this.row = event.detail.row;
    }
    SelectedDecisionClicked(event)
    {
        this.Decision = event.target.name;
        this.DecisionClicked = true;
        
    }
    CommentsSaved()
    {
        console.log('Approve selected');
        ApproveSelected(event);
         
    }
    CloseComments()
    {
        this.Comments = '';
        this.Decision = '';
        this.row = '';
        this.DecisionClicked = false;
        this.SingleDecision = false;
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
        try 
        {
        console.log('The single decision before all is ' + this.SingleDecision);
        if(this.SingleDecision === false)
        {
            console.log('Single decision is false ' + this.SingleDecision);
            this.loading = true;
            // var testeventname = event.detail.name;
            // console.log('Testeventname ' + testeventname);
            let rowindexes = [];
            if(this.SelectedData.length > 0)
            {
                for (let i = 0; i < this.SelectedData.length; i++)
                {  
                    rowindexes.push(this.SelectedData[i].id);
                    console.log('After push ' + JSON.stringify(this.SelectedData) + ' rowindexes is ' + rowindexes); 
                }
                console.log('141 is hit');
                let ItemsToSend = JSON.stringify({ItemsToApproveReject: this.SelectedData});
                console.log('Items to send is ' + ItemsToSend);
                ApproveSelectedItems({ItemsToApproveReject:ItemsToSend,Comments:this.Comments, Decision:this.Decision}).then(result => 
                {
                    if(result === '200')
                    {
                        console.log('Result is ' + result);
                        let rows = this.data;
                        let rowsetup = [];
                        this.data = [];
                        console.log('Result lenght is ' + rowindexes.length);
                        for (let i = rowindexes.length -1; i >= 0; i--)
                        {
                            rows.splice(rowindexes[i], 1);
                        }
                        if(rows.length > 0)
                        {
                        for (var i = 0; i < rows.length; i++) 
                        {
                            this.data.push({id:i,MasterJob: rows[i].MasterJob, MasterJobName1: rows[i].MasterJobName1, CreatedBy: rows[i].createdByName, AccountName:rows[i].AccountName, AccountName1:rows[i].AccountName1, ContactName:rows[i].ContactName, ContactName1:rows[i].ContactName1, ReferredBy:rows[i].ReferredBy, ReferredBy1:rows[i].ReferredBy1});   
                        }
                        this.loading = false;
                        this.Comments = '';
                        this.Decision = '';
                        this.DecisionClicked = false;
                        this.SelectedData =[];
                        }else{
                            this.loading = false;
                            this.Comments = '';
                            this.Decision = '';
                            this.DecisionClicked = false;
                            this.SelectedData =[];

                        }
                    }
                    else{
                        this.loading = false;
                        alert(result);
                    }
                })
            }else
            {
                this.loading = false;
                alert('Must select one or more to Approve Selected');
            }
        }
    } catch (error) 
    {
        this.loading = false;
        alert(error);        
    }
        if(this.SingleDecision === true)
        {
            try {
            console.log('Single decision is true ' + this.SingleDecision);
            this.loading = true;
            
            
            const { id } = this.row;
            const index = this.findRowIndexById(id);
            // let ItemsToApproveReject =[];
            let rowsetup = [];
            let ItemsToSend = JSON.stringify(this.data[index]);
            for (var i = 0; i < ItemsToSend.length; i++) 
            {   
                rowsetup.push({id:ItemsToSend[0].id,MasterJob: ItemsToSend[i].MasterJob, MasterJobName1: ItemsToSend[i].MasterJobName1, CreatedBy: ItemsToSend[i].createdByName, AccountName:ItemsToSend[i].AccountName, AccountName1:ItemsToSend[i].AccountName1, ContactName:ItemsToSend[i].ContactName, ContactName1:ItemsToSend[i].ContactName1, ReferredBy:ItemsToSend[i].ReferredBy, ReferredBy1:ItemsToSend[i].ReferredBy1});   
            } 
            // rowsetup.push(ItemsToSend);
            let ItemToSend = JSON.stringify({ItemsToApproveReject:rowsetup});
            const rows = this.data;
            ApproveSelectedItems({ItemsToApproveReject:ItemToSend,Comments:this.Comments, Decision:this.Decision}).
            then(result => 
            {
                
                if(result === '200')
                {  
                    rows.splice(index, 1);
                    console.log('rows is ' + JSON.stringify(rows));
                    
                    this.data = [];
                    for (var i = 0; i < rows.length; i++) 
                    {   
                        this.data.push({id:i,MasterJob: rows[i].MasterJob, MasterJobName1: rows[i].MasterJobName1, CreatedBy: rows[i].createdByName, AccountName:rows[i].AccountName, AccountName1:rows[i].AccountName1, ContactName:rows[i].ContactName, ContactName1:rows[i].ContactName1, ReferredBy:rows[i].ReferredBy, ReferredBy1:rows[i].ReferredBy1});   
                    } 
                    this.loading = false;
                    this.row = '';
                    this.Comments = '';
                    this.Decision = '';
                    this.DecisionClicked = false; 
                }else
                {
                    this.loading = false;
                    alert(result);   
                }
            })
        }
        catch (error) 
        {
            this.loading = false;
            alert(error);  
        }
    }
}
    CommentsChange(event){
        this.Comments = event.detail.value;
    }
    ApprovalViewChanged(event){
        this.objectName = event.detail.value;
        if(this.objectName == 'Master Job')
        {
            reloadData();
            this.MasterJobView = true;
            this.AllView = false;
        }
        if(this.objectName == 'All')
        {
            reloadData();
            this.MasterJobView = false;
            this.AllView = true;
        }
    }
    reloadData()
    {
        GetAccountData({objectName:this.objectName}).then(result =>{
            // console.log('Result ' + JSON.stringify(result));
            let accounts = result;
            // console.log('Account is ' + accounts);
            // console.log('Account is ' + JSON.stringify(accounts));
            console.log('Accounts lenght is ' + accounts.length );
            console.log(' and account name is ' + accounts[0].Account);
            this.data = [];
            for (var i = 0; i < accounts.length; i++) 
            {
                if(this.objectName == 'All')
                {
                    console.log('1st Account Name ' + accounts[i].Account);
                    this.datasetup.push({ApprovalName:accounts[i].processId, CreatedBy: accounts[i].createdByName, ObjectName: accounts[i].ObjectName});
                    
                    
                }
                if(this.objectName == 'Master Job')
                {
                
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
                }
            }
            this.data = this.datasetup;
            
        });
    }
    // GenerateDataJSON() {
    //     console.log('165 is hit');
    //     var ItemsToApproveRejectObject = 
    //     console.log('Items line 168 ' + ItemsToApproveRejectObject);
    //     return JSON.stringify(ItemsToApproveRejectObject);
    //   }
}