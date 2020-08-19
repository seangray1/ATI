import { LightningElement, api } from 'lwc';
import GetAccountData from '@salesforce/apex/DynamicApprovalController.GetAccountData';
import ApproveSelectedItems from '@salesforce/apex/DynamicApprovalController.ApproveSelectedItems';
import My_Resource from '@salesforce/resourceUrl/SLDS202';

// import GetColumns from '@salesforce/apex/DynamicApprovalController.GetColumns';
// import GetViewTypes from '@salesforce/apex/DynamicApprovalController.GetViewTypes';
const actions = [
    { label: 'Approve', name: 'Approve' },
    { label: 'Reject', name: 'Reject' },
    
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
    // getcurrentpageurl = (new URL(document.location)).searchParams;
    // @api pageurl = this.getcurrentpageurl;
    data = [];
    datasetup = [];
    RefreshIcon = My_Resource + '/assets/icons/utility-sprite/svg/symbols.svg#refresh';
    // Columns = [
    //     // { label: 'Master Job', fieldName: 'MasterJob' , wrapText: true, type: 'url',
    //     // typeAttributes: {label: { fieldName: 'MasterJobName1' }, target: '_blank'}},
    //     // { label: 'Submitted By', fieldName: 'CreatedBy' },
    //     // { label: 'Account', fieldName: 'AccountName', type: 'url',
    //     // typeAttributes: {label: { fieldName: 'AccountName1' }, target: '_blank'} },
    //     // { label: 'Contact', fieldName: 'ContactName', type: 'url',
    //     // typeAttributes: {label: { fieldName: 'ContactName1' }, target: '_blank'} },
    //     // { label: 'Referred By', fieldName: 'ReferredBy', type: 'url',
    //     // typeAttributes: {label: { fieldName: 'ReferredBy1' }, target: '_blank'} },
    //     // {
    //     //     type: 'action',
    //     //     typeAttributes: { rowActions: actions },
    //     // },
        
        
    // ];
    columns = [
        { label: 'Master Job', fieldName: 'MasterJob' , wrapText: true, type: 'url',
        typeAttributes: {label: { fieldName: 'MasterJobName1' }, target: '_blank'}},
        { label: 'Submitted By', fieldName: 'CreatedBy' },
        { label: 'Account', fieldName: 'AccountName', type: 'url',
        typeAttributes: {label: { fieldName: 'AccountName1' }, target: '_blank'} },
        { label: 'Contact', fieldName: 'ContactName', type: 'url',
        typeAttributes: {label: { fieldName: 'ContactName1' }, target: '_blank'} },
        { label: 'Referred By', fieldName: 'ReferredBy', type: 'url',
        typeAttributes: {label: { fieldName: 'ReferredBy1' }, target: '_blank'} },
        { label: 'Comments', fieldName: 'Comments' },
        { label: 'Submitted Date', fieldName: 'SubmittedDate', type: 'date' },
        { label: 'Errors', fieldName: 'ApprovalError' },
        {
            type: 'action',
            typeAttributes: { rowActions: actions },
        },
        
        
    ];
    SelectedData = [];
    Comments = '';
    Decision = '';
    row = '';
    objectName = 'Master Job';
    ColumnsLoaded = false;
    SingleDecision = false;
    DecisionClicked = false;
    loading = false;
    AllView = true;
    MasterJobView = false;
    // ApprovalListViews =[{}];
    ApprovalListViewLoaded = false;
    DataTableHeight = 'short';



    get ApprovalListViews() {
      return [{label:"Master Job", value:"Master Job"}, {label:"Contact", value:"Contact"}];
  }
    // renderedCallback()
    // {
    //     this.pageurl = window.location.href;
    //     console.log('Page url is ' + this.pageurl);
    // }
    // eslint-disable-next-line @lwc/lwc/no-async-await
    connectedCallback() {
        let getcurrentpageurl = window.location.href;
        
        if(getcurrentpageurl.includes("home")){
            this.DataTableHeight = 'short';
           
        }
        else{
            this.DataTableHeight = 'tall';
        }
        GetAccountData({objectName:this.objectName}).then(result =>{
            // console.log('Result ' + JSON.stringify(result));
           let accounts = result;
            for (var i = 0; i < accounts.length; i++) 
            {
                //     this.datasetup.push({ApprovalName:ObjectData[i].ApprovalName, ApprovalName1:'/' + ObjectData[i].processId, CreatedBy:ObjectData[i].CreatedBy, ObjectName:ObjectData[i].ObjectName  });
                                        
                //     // if(ObjectData[i].Column1Name !== null)
                //     // {
                //     //     this.datasetup[i].Column_1__c = '/' + ObjectData[i].Column1;
                //     //     this.datasetup[i].Column_1_Name__c = ObjectData[i].Column1Name;
                //     // }
                    
                //     console.log('ObjectData is ' + JSON.stringify(ObjectData[i]));
                // }
                // this.data = this.datasetup;
                
                
                    
                    this.datasetup.push({id:i, ApprovalError:accounts[i].ApprovalErrors, SubmittedDate:accounts[i].SubmittedDate, Comments:accounts[i].Comments, AccountName1:accounts[i].Account,ContactName1:accounts[i].Contact,MasterJobName1:accounts[i].MasterJob,ReferredBy1:accounts[i].ReferredBy,processId:accounts[i].processId,processinstanceId:accounts[i].processinstanceId, id:i,MasterJob: '/' + accounts[i].MasterJobId, CreatedBy: accounts[i].createdByName, AccountName:'/' + accounts[i].AccountId, ContactName:'/' + accounts[i].ContactId, ReferredBy:'/' + accounts[i].ReferredById});
                    
                    if(accounts[i].Account === undefined)
                    {
                        
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
            this.data = this.datasetup;
            this.ApprovalListViewLoaded = true;
            
        });
    }
    handleRowAction(event) {
        this.Decision = event.detail.action.name;
        this.DecisionClicked = true;
        this.SingleDecision = true;
       
        this.row = event.detail.row;
    }
    SelectedDecisionClicked(event)
    {
        this.Decision = event.target.name;
        this.DecisionClicked = true;
        
    }
    CommentsSaved()
    {
        
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
        
        this.SelectedData = [];
        // Display that fieldName of the selected rows
        for (let i = 0; i < selectedRows.length; i++){
            
           
            
            this.SelectedData.push(selectedRows[i]);
           
            
        }
    }
    
    ApproveSelected(event)
    {   
        try 
        {
            // let selectedrowss = event.detail.selectedRows;
            // console.log('Selec ' + selectedrowss);
        if(this.SingleDecision === false)
        {
           
            this.loading = true;
            // var testeventname = event.detail.name;
            // console.log('Testeventname ' + testeventname);
            let rowindexes = [];
            if(this.SelectedData.length > 0)
            {
                for (let i = 0; i < this.SelectedData.length; i++)
                {  
                    rowindexes.push(this.SelectedData[i].id);
                    
                }
               
                let ItemsToSend = JSON.stringify({ItemsToApproveReject: this.SelectedData});
                
                
               
                ApproveSelectedItems({ItemsToApproveReject:ItemsToSend,Comments:this.Comments, Decision:this.Decision, processId: ''}).then(result => 
                {
                    if(result === '200')
                    {
                        this.SelectedData = [];
                        console.log('Result is ' + result);
                        
                      
                        var el = this.template.querySelector('lightning-datatable');
                        console.log('Elements are ' + el);
                        el.selectedRows = [];
                        // console.log('Selected rows are ' + selected);
                        // // selected = [];
                        // console.log('Selected rows are after ' + selected);
                        
                        let rows = this.data;
                        let rowsetup = [];
                        this.data = [];
                        console.log('rows before ' + rows);
                        for (let i = rowindexes.length -1; i >= 0; i--)
                        {
                            console.log('rows size ' + rows.length);
                            rows.splice(rowindexes[i], 1);
                            console.log('rows size ' + rows.length);
                            this.datasetup = rows;
                        }
                        console.log('rows after ' + rows);
                        if(rows.length > 0)
                        {
                        for (var i = 0; i < rows.length; i++) 
                        {
                            this.data.push({id:i,Comments:this.datasetup[i].Comments, SubmittedDate:this.datasetup[i].SubmittedDate, ApprovalError:this.datasetup[i].ApprovalError, Contact:this.datasetup[i].Contact, ContactNamee:this.datasetup[i].ContactNamee,processId:this.datasetup[i].processId,processinstanceId:this.datasetup[i].processinstanceId,MasterJob: this.datasetup[i].MasterJob, MasterJobName1: this.datasetup[i].MasterJobName1, CreatedBy: this.datasetup[i].CreatedBy, AccountName:this.datasetup[i].AccountName, AccountName1:this.datasetup[i].AccountName1, ContactName:this.datasetup[i].ContactName, ContactName1:this.datasetup[i].ContactName1, ReferredBy:this.datasetup[i].ReferredBy, ReferredBy1:this.datasetup[i].ReferredBy1});   
                        }
                        //this.data = rowsetup;
                        this.loading = false;
                        this.Comments = '';
                        this.Decision = '';
                        this.DecisionClicked = false;
                        //this.SelectedData =[];
                        }else{
                            this.loading = false;
                            this.Comments = '';
                            this.Decision = '';
                            this.DecisionClicked = false;
                            //this.SelectedData =[];

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
            const rows = this.data;
            console.log('Rows ' + JSON.stringify(rows));
            console.log('DEcision is ' + this.Decision + ' COmments ' + this.Comments + rows[index]);
            
            this.datasetup = [];
            
            ApproveSelectedItems({ItemsToApproveReject:'',Comments:this.Comments, Decision:this.Decision, processId:rows[index].processId}).
            then(result => 
            {
                console.log('Working??');
                if(result === '200')
                {  
                    rows.splice(index, 1);
                    console.log('rows is ' + JSON.stringify(rows));
                    
                    this.data = [];
                    for (var i = 0; i < rows.length; i++) 
                    {   
                        this.data.push({id:i, ApprovalError:rows[i].ApprovalError, SubmittedDate:rows[i].SubmittedDate, Comments:rows[i].Comments, Contact:rows[i].Contact, ContactNamee:rows[i].ContactNamee,processinstanceId:rows[i].processinstanceId,processId:rows[i].processId, MasterJob:rows[i].MasterJob, MasterJobName1: rows[i].MasterJobName1, CreatedBy: rows[i].CreatedBy, AccountName:rows[i].AccountName, AccountName1:rows[i].AccountName1, ContactName:rows[i].ContactName, ContactName1:rows[i].ContactName1, ReferredBy:rows[i].ReferredBy, ReferredBy1:rows[i].ReferredBy1});   
                    }
                    
                    //this.data = this.datasetup; 
                    console.log('datasetup ' + JSON.stringify(this.data));
                    this.datasetup = [];
                    this.loading = false;
                    this.row = '';
                    this.Comments = '';
                    this.Decision = '';
                    this.DecisionClicked = false; 
                    this.SingleDecision = false;
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
        console.log('Object name is ' + this.objectName);
        this.objectName = event.detail.value;
        console.log('Object name is ' + this.objectName);
        console.log(JSON.stringify(this.data));
        GetAccountData({objectName:this.objectName}).then(result =>{
            console.log('Test');
            // console.log('Result ' + JSON.stringify(result));
            let accounts = result;
            // console.log('Account is ' + accounts);
            // console.log('Account is ' + JSON.stringify(accounts));
            // console.log('Accounts lenght is ' + accounts.length );
            // console.log(' and account name is ' + accounts[0].Account);
            this.data = [];
            this.datasetup = [];
            console.log(JSON.stringify(this.data));

            this.columns = [];
            if(this.objectName === 'Contact')
            {
                this.columns = [
                    { label: 'Contact', fieldName: 'Contact' , wrapText: true, type: 'url',
                    typeAttributes: {label: { fieldName: 'ContactNamee' }, target: '_blank'}},
                    { label: 'Submitted By', fieldName: 'CreatedBy' },
                    { label: 'Submitted Date', fieldName: 'SubmittedDate', type: 'date' },
                    
                    
                    {
                        type: 'action',
                        typeAttributes: { rowActions: actions },
                    },  
                ];
                for (var i = 0; i < accounts.length; i++) 
                {
                    console.log('1st Account Name ' + accounts[i].Account);
                 
                    this.datasetup.push({id:i, Comments:accounts[i].Comments, SubmittedDate:accounts[i].SubmittedDate, Contact:'/' + accounts[i].processId,ContactNamee:accounts[i].Contact,processId:accounts[i].processId,processinstanceId:accounts[i].processinstanceId, CreatedBy: accounts[i].createdByName});  
                }
            }
            if(this.objectName === 'Master Job')
            {
                this.columns = [];
                this.columns = [
                    { label: 'Master Job', fieldName: 'MasterJob' , wrapText: true, type: 'url',
                    typeAttributes: {label: { fieldName: 'MasterJobName1' }, target: '_blank'}},
                    { label: 'Submitted By', fieldName: 'CreatedBy' },
                    { label: 'Account', fieldName: 'AccountName', type: 'url',
                    typeAttributes: {label: { fieldName: 'AccountName1' }, target: '_blank'} },
                    { label: 'Contact', fieldName: 'ContactName', type: 'url',
                    typeAttributes: {label: { fieldName: 'ContactName1' }, target: '_blank'} },
                    { label: 'Referred By', fieldName: 'ReferredBy', type: 'url',
                    typeAttributes: {label: { fieldName: 'ReferredBy1' }, target: '_blank'} },
                    { label: 'Comments', fieldName: 'Comments' },
                    { label: 'Submitted Date', fieldName: 'SubmittedDate', type: 'date' },
                    { label: 'Errors', fieldName: 'ApprovalError' },
                    {
                        type: 'action',
                        typeAttributes: { rowActions: actions },
                    },
                    
                    
                ];
                for (var i = 0; i < accounts.length; i++) 
                {
                    console.log('1st Account Name ' + accounts[i].Account);
                    this.datasetup.push({id:i, Comments:accounts[i].Comments, SubmittedDate:accounts[i].SubmittedDate, AccountName1:accounts[i].Account,ContactName1:accounts[i].Contact,MasterJobName1:accounts[i].MasterJob,ReferredBy1:accounts[i].ReferredBy,processId:accounts[i].processId,processinstanceId:accounts[i].processinstanceId, id:i,MasterJob: '/' + accounts[i].MasterJobId, CreatedBy: accounts[i].createdByName, AccountName:'/' + accounts[i].AccountId, ContactName:'/' + accounts[i].ContactId, ReferredBy:'/' + accounts[i].ReferredById, ApprovalError:accounts[i].ApprovalErrors});
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
    refreshView()
    {
        console.log(JSON.stringify(this.data));
        GetAccountData({objectName:this.objectName}).then(result =>{
            console.log('Test');
            // console.log('Result ' + JSON.stringify(result));
            let accounts = result;
            // console.log('Account is ' + accounts);
            // console.log('Account is ' + JSON.stringify(accounts));
            // console.log('Accounts lenght is ' + accounts.length );
            // console.log(' and account name is ' + accounts[0].Account);
            this.data = [];
            this.datasetup = [];
            console.log(JSON.stringify(this.data));

            this.columns = [];
            if(this.objectName === 'Contact')
            {
                this.columns = [
                    { label: 'Contact', fieldName: 'Contact' , wrapText: true, type: 'url',
                    typeAttributes: {label: { fieldName: 'ContactNamee' }, target: '_blank'}},
                    { label: 'Submitted By', fieldName: 'CreatedBy' },
                    { label: 'Submitted Date', fieldName: 'SubmittedDate', type: 'date' },
                    
                    
                    {
                        type: 'action',
                        typeAttributes: { rowActions: actions },
                    },  
                ];
                for (var i = 0; i < accounts.length; i++) 
                {
                    console.log('1st Account Name ' + accounts[i].Account);
                 
                    this.datasetup.push({id:i, SubmittedDate:accounts[i].SubmittedDate, Comments:accounts[i].Comments,Contact:'/' + accounts[i].processId,ContactNamee:accounts[i].Contact,processId:accounts[i].processId,processinstanceId:accounts[i].processinstanceId, CreatedBy: accounts[i].createdByName});  
                }
            }
            if(this.objectName === 'Master Job')
            {
                this.columns = [];
                this.columns = [
                    { label: 'Master Job', fieldName: 'MasterJob' , wrapText: true, type: 'url',
                    typeAttributes: {label: { fieldName: 'MasterJobName1' }, target: '_blank'}},
                    { label: 'Submitted By', fieldName: 'CreatedBy' },
                    { label: 'Account', fieldName: 'AccountName', type: 'url',
                    typeAttributes: {label: { fieldName: 'AccountName1' }, target: '_blank'} },
                    { label: 'Contact', fieldName: 'ContactName', type: 'url',
                    typeAttributes: {label: { fieldName: 'ContactName1' }, target: '_blank'} },
                    { label: 'Referred By', fieldName: 'ReferredBy', type: 'url',
                    typeAttributes: {label: { fieldName: 'ReferredBy1' }, target: '_blank'} },
                    { label: 'Comments', fieldName: 'Comments' },
                    { label: 'Submitted Date', fieldName: 'SubmittedDate', type: 'date' },
                    { label: 'Errors', fieldName: 'ApprovalError' },
                    {
                        type: 'action',
                        typeAttributes: { rowActions: actions },
                    },
                    
                    
                ];
                for (var i = 0; i < accounts.length; i++) 
                {
                    console.log('1st Account Name ' + accounts[i].Account);
                    this.datasetup.push({id:i,  Comments:accounts[i].Comments, SubmittedDate:accounts[i].SubmittedDate, ApprovalError:accounts[i].ApprovalErrors, AccountName1:accounts[i].Account,ContactName1:accounts[i].Contact,MasterJobName1:accounts[i].MasterJob,ReferredBy1:accounts[i].ReferredBy,processId:accounts[i].processId,processinstanceId:accounts[i].processinstanceId, MasterJob: '/' + accounts[i].MasterJobId, CreatedBy: accounts[i].createdByName, AccountName:'/' + accounts[i].AccountId, ContactName:'/' + accounts[i].ContactId, ReferredBy:'/' + accounts[i].ReferredById});
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
    
    // reloadData()
    // {
    //     console.log('Object name is ' + this.objectName);
    //     Test({Test:'Testing Comments'}).then(result => {
    //         console.log('It ran ' );
    //     })
    //     GetAccountData({objectName:this.objectName}).then(result =>{
    //         console.log('Test');
    //         // console.log('Result ' + JSON.stringify(result));
    //         let accounts = result;
    //         // console.log('Account is ' + accounts);
    //         // console.log('Account is ' + JSON.stringify(accounts));
    //         // console.log('Accounts lenght is ' + accounts.length );
    //         // console.log(' and account name is ' + accounts[0].Account);
    //         this.data = [];

    //         this.columns = [];
    //         if(this.objectName === 'Contact')
    //         {
    //             this.columns = [
    //                 { label: 'Contact', fieldName: 'Contact' , wrapText: true, type: 'url',
    //                 typeAttributes: {label: { fieldName: 'ContactName' }, target: '_blank'}},
    //                 { label: 'Submitted By', fieldName: 'CreatedBy' },
                    
                    
    //                 {
    //                     type: 'action',
    //                     typeAttributes: { rowActions: actions },
    //                 },  
    //             ];
    //             for (var i = 0; i < accounts.length; i++) 
    //             {
    //                 console.log('1st Account Name ' + accounts[i].Account);
                 
    //                 this.datasetup.push({Contact:accounts[i].Contact,ContactName: '/' + accounts[i].processId,processId:accounts[i].processId,processinstanceId:accounts[i].processinstanceId, id:i, CreatedBy: accounts[i].createdByName});  
    //             }
    //         }
    //         if(this.objectName === 'Master Job')
    //         {
    //             this.columns = [];
    //             this.columns = [
    //                 { label: 'Master Job', fieldName: 'MasterJob' , wrapText: true, type: 'url',
    //                 typeAttributes: {label: { fieldName: 'MasterJobName1' }, target: '_blank'}},
    //                 { label: 'Submitted By', fieldName: 'CreatedBy' },
    //                 { label: 'Account', fieldName: 'AccountName', type: 'url',
    //                 typeAttributes: {label: { fieldName: 'AccountName1' }, target: '_blank'} },
    //                 { label: 'Contact', fieldName: 'ContactName', type: 'url',
    //                 typeAttributes: {label: { fieldName: 'ContactName1' }, target: '_blank'} },
    //                 { label: 'Referred By', fieldName: 'ReferredBy', type: 'url',
    //                 typeAttributes: {label: { fieldName: 'ReferredBy1' }, target: '_blank'} },
    //                 {
    //                     type: 'action',
    //                     typeAttributes: { rowActions: actions },
    //                 },
                    
                    
    //             ];
    //             for (var i = 0; i < accounts.length; i++) 
    //             {
    //                 console.log('1st Account Name ' + accounts[i].Account);
    //                 this.datasetup.push({AccountName1:accounts[i].Account,ContactName1:accounts[i].Contact,MasterJobName1:accounts[i].MasterJob,ReferredBy1:accounts[i].ReferredBy,processId:accounts[i].processId,processinstanceId:accounts[i].processinstanceId, id:i,MasterJob: '/' + accounts[i].MasterJobId, CreatedBy: accounts[i].createdByName, AccountName:'/' + accounts[i].AccountId, ContactName:'/' + accounts[i].ContactId, ReferredBy:'/' + accounts[i].ReferredById});
    //                 console.log('Account name is ' + JSON.stringify(this.datasetup[i].AccountName));
    //                 if(accounts[i].Account === undefined)
    //                 {
    //                     console.log('clearing account name ' + i + ' ' + this.datasetup[i].AccountName);
    //                     this.datasetup[i].AccountName = "";
    //                     this.datasetup[i].AccountNameId = "";
    //                 }
    //                 if(accounts[i].Contact === undefined)
    //                 {
    //                     this.datasetup[i].ContactName = "";
    //                     this.datasetup[i].ContactName1 = "";
    //                 }
    //                 if(accounts[i].MasterJob === undefined)
    //                 {
    //                     this.datasetup[i].MasterJob = "";
    //                     this.datasetup[i].MasterJobName1 = "";
    //                 }
    //                 if(accounts[i].ReferredBy === undefined)
    //                 {
    //                     this.datasetup[i].ReferredBy = "";
    //                     this.datasetup[i].ReferredBy1 = "";
    //                 }
    //             }
    //         }
    //         this.data = this.datasetup;
            
    //     });
    // }
    // GenerateDataJSON() {
    //     console.log('165 is hit');
    //     var ItemsToApproveRejectObject = 
    //     console.log('Items line 168 ' + ItemsToApproveRejectObject);
    //     return JSON.stringify(ItemsToApproveRejectObject);
    //   }
}