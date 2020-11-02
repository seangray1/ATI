/* eslint-disable no-alert */
/* eslint-disable no-undef */
/* eslint-disable no-console */
import { LightningElement, wire,api,track} from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//import { publish, createMessageContext, releaseMessageContext } from 'lightning/messageService';
import { deleteRecord, updateRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import { loadStyle } from 'lightning/platformResourceLoader';
import getAPINamesFromMetadata from '@salesforce/apex/BudgetLWCController.getAPINamesFromMetadata';
import getTradeOptionPickValues from '@salesforce/apex/BudgetLWCController.getTradeOptionPickValues';
import RetrieveBudgetLineItems from '@salesforce/apex/BudgetLWCController.RetrieveBudgetLineItems';
import UpdateSalesTax from '@salesforce/apex/BudgetLWCController.UpdateSalesTax';
import RetrieveBudget from '@salesforce/apex/BudgetLWCController.RetrieveBudget';
import deleteBLI from '@salesforce/apex/BudgetLWCController.deleteBLI';
import RetrieveJob from '@salesforce/apex/BudgetLWCController.RetrieveJob';
//import GetBudgetLineItemData from '@salesforce/apex/BudgetLWCController.GetBudgetLineItemData';
import UpdateBLI from '@salesforce/apex/BudgetLWCController.UpdateBLI';

import UpdateOnlyBLI from '@salesforce/apex/BudgetLWCController.UpdateOnlyBLI';
import LWCBudgetOverrideStyle from '@salesforce/resourceUrl/LWCBudgetOverrideStyle';
import BLIReportId from '@salesforce/label/c.LWC_BLI_Report_ID';

//import { getRecordUi } from 'lightning/uiRecordApi';


export default class BudgetLWC extends NavigationMixin(LightningElement) {
    @api recordId; @api jobId;

    getcurrentpageurl = (new URL(document.location)).searchParams;
    //@api BudgetId = this.getcurrentpageurl.get('ati__budgetId');
    @api IsFromNew =  this.getcurrentpageurl.get('c__FromNew');
    @api isLoading = false; @api TradeOptionVal =[]; @api ToBeDeletedId = null; @api ToDeleteNewBLI =null; @api BLIEditId = null; @api PopupTitle;
    @track APIfields =[];  @track BLIList =[]; @api OldBudgetData =[]; @api OldBLIData=[]; @api NewlyAddedBLIData = []; @api OldBLIDeletedData =[]; @api OldBLIToUpdate =[];
    @track AllowBLISection = false; @api DmyId=""; @track DeleteConfirmVisisble = false; @track isBLIAppPopup = false;
    @api BLINewFields =['Trade_Option__c', 'Selector__c','Revenue__c','X10_10_Allocation__c','GP__c','Subcontractor__c','Subcontractor_bid__c','In_House_Hours__c','In_House_Rate__c','Materials__c','Equipment__c','Other_Costs__c','Item_Description__c'];
    _wiredResult; _wiredJobResult; _ApiWiredResult; @track SaveBtnLabel;
    @track IsBudgetNew = false; @api JobStartDate; @api JobEstimatedCompletionDate; @api JobRegionalManger; @api JobProjectDirecor; @api JobProjectManager; @track NewBLIData=[]; @track hasChanged=false;
    label = {BLIReportId}; @api IsImported = false;@track SalesTax = 0;
    //FoR BLI Tree Grid
    parentId = null; levelsDeep = 0; depthChildrenCountMap = new Map(); datarestrucuted = false; @track FormattedBLIData;
    @track BudgetGPValue ='';
    // FOR BLI Tree Grid

    
    connectedCallback() {
        loadStyle(this, LWCBudgetOverrideStyle + '/css/style.css');
        if(this.recordId!=null){
            this.AllowBLISection=true;
            this.SaveBtnLabel = 'Save & Exit';
            
        } else{
            //this.GenerateNewBLIList();
            this.SaveBtnLabel = 'Next';
        }
        console.log('From New: '+this.IsFromNew);
        if(this.recordId==null && this.jobId!=null){
            this.IsBudgetNew = true;
        }
        this.datarestrucuted=false;
        
        refreshApex(this._wiredResult);
        refreshApex(this._wiredJobResult);

        if (this._wiredResult && this._wiredResult.data) {
            refreshApex(this._wiredResult);
        }
    }

    // renderedCallback() {
    //     this.ToRetainExpandCollapsePosition();    
    // }

    //Get the New BLI List
    GenerateNewBLIList(){
        var NewBLITradeOpt =['APP Appliances', 'CAB Cabinetry', 'CLN Cleaning', 'CON Contents', 'DMO General Demolition', 'DOR Doors', 'DRY Drywall', 'ELE Electrical', 'FCC Floor Covering Carpet', 'FCW Floor Covering Wood', 'FNC Finish Carpentry', 'FRM Framing & Rough Carpentry', 'HVC Heat, Vent, & Air Conditioning', 'INS Insulation', 'PLM Plumbing', 'PNT Painting', 'RFG Roofing', 'SDG Siding', 'WDV Window Vinyl'];
        for(let k=0; k<NewBLITradeOpt.length; k++){
            var objNewBLI={};
            objNewBLI.Trade__c = NewBLITradeOpt[k];
            objNewBLI.Trade_Option__c = NewBLITradeOpt[k];
            objNewBLI.Budget__c = BudgetId;
            // objNewBLI.GP__c = 30;
            objNewBLI.Id =null;
            this.NewBLIData.push(objNewBLI);
        }
        console.log('NEw List data: '+JSON.stringify(this.NewBLIData));
    }

    OnChangeBudgetFields(event){
        var ChangedAPIName = event.target.name;
        var GpGoalVal = event.target.value;
        if(ChangedAPIName == 'GP_Goal__c')
        {
            this.BudgetGPValue = GpGoalVal;
        }
        
        if(this.AllowBLISection && this.recordId){
            this.isLoading = true;
            var obj={};
            var key=event.target.name;
            var value = event.target.value;
            obj[key]=value;
            obj.Id=this.recordId;
            console.log('Obj Update Data: '+JSON.stringify(obj));
            if(ChangedAPIName=='Allocation_Overhead__c')
            {
                var TblRow =  Array.from(this.template.querySelectorAll('table.TblTreeView tbody tr.parent'));
                        var AllData=[];
                        for (let i = 0; i < TblRow.length; i++) {
                            var obj1={};
                            obj1.Id=TblRow[i].dataset.id;
                            // obj1.GP__c = GpGoalVal;
                            AllData.push(obj1);
                        }
                       
                        console.log('Record to Update: '+JSON.stringify(AllData));
                        
                        UpdateBLI({UpdateBLIList: AllData, OverheadProfit:value}).then(result => {
                            console.log('result is ' + JSON.stringify(result));
                            console.log('GP Goal Updated success');
                            
                            refreshApex(this._wiredResult);
                            this.refreshBudgetValues();
                            this.isLoading = false;
                            this.datarestrucuted=false;
                        }).catch(error => {
                            window.console.log(error);
                            this.isLoading = false;
                            this.dispatchEvent(
                                new ShowToastEvent({
                                    title: 'Error Inserting Budget Line Item', 
                                    message: error.message, 
                                    variant: 'error'
                                }),
                            );
                        });
            }


            updateRecord({ fields: obj }).then(() => {
                console.log('Success -Updated Budget');
                if(ChangedAPIName=='GP_Goal__c'){
                    console.log('Change API: '+ChangedAPIName);
                    if(GpGoalVal!=null && GpGoalVal!='' && this.AllowBLISection){
                        //this.isLoading = true;
                        console.log('GP val: '+GpGoalVal);
                        var TblRow =  Array.from(this.template.querySelectorAll('table.TblTreeView tbody tr.parent'));
                        var AllData=[];
                        for (let i = 0; i < TblRow.length; i++) {
                            var obj1={};
                            obj1.Id=TblRow[i].dataset.id;
                            obj1.GP__c = GpGoalVal;
                            AllData.push(obj1);
                        }
                       
                        console.log('Record to Update: '+JSON.stringify(AllData));
                        
                        UpdateBLI({UpdateBLIList: AllData, OverheadProfit:null}).then(result => {
                            console.log('GP Goal Updated success');
                            this.isLoading = false;
                            this.datarestrucuted=false;
                            refreshApex(this._wiredResult);
                            
                        }).catch(error => {
                            window.console.log(error);
                            this.isLoading = false;
                            this.dispatchEvent(
                                new ShowToastEvent({
                                    title: 'Error Inserting Budget Line Item', 
                                    message: error.message, 
                                    variant: 'error'
                                }),
                            );
                        });
            
                        console.log('ToUpdate record: '+JSON.stringify(AllData));
                    } else { this.isLoading = false; }
                } 
                // else if(ChangedAPIName=='Allocation_Overhead__c'){
                //     var TblRow =  Array.from(this.template.querySelectorAll('table.TblTreeView tbody tr.parent'));
                //         var AllData=[];
                //         for (let i = 0; i < TblRow.length; i++) {
                //             var obj1={};
                //             obj1.Id=TblRow[i].dataset.id;
                //             // obj1.GP__c = GpGoalVal;
                //             AllData.push(obj1);
                //         }
                       
                //         console.log('Record to Update: '+JSON.stringify(AllData));
                        
                //         UpdateBLI({UpdateBLIList: AllData}).then(result => {
                //             console.log('result is ' + JSON.stringify(result));
                //             console.log('GP Goal Updated success');
                //             this.isLoading = false;
                //             this.datarestrucuted=false;
                //             refreshApex(this.wiredRetrieveBudget);
                //         }).catch(error => {
                //             window.console.log(error);
                //             this.isLoading = false;
                //             this.dispatchEvent(
                //                 new ShowToastEvent({
                //                     title: 'Error Inserting Budget Line Item', 
                //                     message: error.message, 
                //                     variant: 'error'
                //                 }),
                //             );
                //         });

                // }
                
                else {
                    this.datarestrucuted=false;
                    refreshApex(this._wiredResult); 
                    this.isLoading = false; 
                }

            }).catch(error => {
                console.log('Errod d: '+JSON.stringify(error));
                this.isLoading = false;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error updating Budget data',
                        message: error.message,
                        variant: 'error',
                    }),
                );
            });
            // updateRecord({ fields: obj }).then(result => {
            // refreshApex(this._wiredResult);
            // });
        }        
    }

    // Delete New BLI
    deleteNewBLI(event){
        this.ToDeleteNewBLI = event.target.dataset.targetId;
        this.DeleteConfirmVisisble = true;
        console.log('TId: '+this.ToDeleteNewBLI);
    } 

    OpenBLIAddEditPopup(event){
        if(event.target.name=='Edit'){
            this.BLIEditId = event.target.dataset.targetId;
            this.PopupTitle = 'Edit Budget Line Item';
        } else{
            this.BLIEditId = null;
            this.PopupTitle = 'Add Budget Line Item';
        }
        this.isBLIAppPopup = true;
    }

    closeBLIAddPopup(){
        this.isBLIAppPopup = false;
    }

    OnCancelAddEditPopup(){
        this.isBLIAppPopup = false;
    }

    AddEditBLIFromError(event){
        let message = event.detail.message;
        //window.console.log('Error: '+JOSN.stringify(event.detail));
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error Inserting record',
                message: message,
                variant: 'error',
            }),
        );
    }

    AddEditBLIFromSuccess(event){
        this.closeBLIAddPopup();
        this.datarestrucuted=false;
        refreshApex(this._wiredResult);
        this.isLoading = false;
        var msg = '';
        if(this.BLIEditId!=null){
            msg = 'Updated Successfully';
        } else {
            msg = 'Inserted Successfully';
            console.log('Inserted Id: '+event.detail.id);
            //if(event.detail.Id!=null){
                this.NewlyAddedBLIData.push(event.detail.id);
            //}
            console.log('Add Id: '+this.NewlyAddedBLIData);
        }
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: msg,
                variant: 'success',
            }),
        );
    }

    AddEditBLIFromPopup(event){
        event.preventDefault();
        this.isLoading = true;
        var ValidationMessage = '';
        const fields = event.detail.fields;
        console.log('Fields'+JSON.stringify(fields));
        fields.Budget__c = this.recordId; // Assign Budget Id.
        var Selector = fields.Selector__c;
        //console.log('BEdit id: '+this.BLIEditId);
        if(fields.Trade_Option__c==null || fields.Trade_Option__c==''){
            ValidationMessage = 'Trade Option is required'; 
        } else if(this.FormattedBLIData!=null && this.FormattedBLIData.length>0) {
            //console.log('Inside Else');
            //if(this.FormattedBLIData.length>0){
                //console.log('Inside if Leng check');
                for(let m=0; m<this.FormattedBLIData.length; m++){
                    //console.log('Inside Lopp..');
                    //console.log('Loop value: '+JSON.stringify(this.FormattedBLIData[m]));
                    if(this.FormattedBLIData[m].Trade_Option__c===fields.Trade_Option__c && (Selector!=null || Selector!='') && this.FormattedBLIData[m].Selector__c===Selector && this.BLIEditId!=this.FormattedBLIData[m].Id) {
                        ValidationMessage = 'Duplicate of Trade/Selector is not allowed. Please update the existing line item.';
                    } else if(this.FormattedBLIData[m].Trade_Option__c===fields.Trade_Option__c && (Selector==null || Selector=='') && this.BLIEditId!=this.FormattedBLIData[m].Id){
                        ValidationMessage = 'Duplicate of Trade/Selector is not allowed. Please update the existing line item.';
                    }  
                }
            //}    
        }
        //console.log('VMd: '+ValidationMessage);

        if(ValidationMessage==''){
            if(Selector=='' || Selector==null){
                fields.Is_Parent__c = true; 
                fields.Is_sub_Parent__c = false;
            } else{
                fields.Is_sub_Parent__c = true;
                fields.Is_Parent__c = false;
            }
            fields.Trade__c=fields.Trade_Option__c;

            if(fields.Revenue__c==null){
                fields.Revenue__c=0.00;
            }
            if(fields.GP__c==null){
                fields.GP__c=0;
            }
            // if(fields.Subcontractor_bid__c==null){
            //     fields.Subcontractor_bid__c=0;
            // }
            if(fields.In_House_Hours__c==null){
                fields.In_House_Hours__c=0;
            }
            if(fields.In_House_Rate__c==null){
                fields.In_House_Rate__c=0;
            }
            if(fields.Materials__c==null){
                fields.Materials__c=0;
            }
            if(fields.Equipment__c==null){
                fields.Equipment__c=0;
            }
            if(fields.Other_Costs__c==null){
                fields.Other_Costs__c=0;
            }
            //if(fields.In_House_Rate__c!=null){
                fields.In_House_Rate_Full__c = fields.In_House_Rate__c;
            //}

            if(this.BLIEditId!=null){
                fields.Id = this.BLIEditId;
            }
            console.log('B4submit: '+JSON.stringify(fields));
            this.template.querySelector('.AddNewBLIForm').submit(fields);
        } else {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error Inserting record',
                    message: ValidationMessage,
                    variant: 'error',
                }),
            );
            this.isLoading = false;
        }

    }

   GenerateBLIItems(){
        console.log('Inside GenrateBLI Structure: '+this.datarestrucuted);
        if(!this.datarestrucuted){
            this.FormattedBLIData = [];
            console.log('B4 Formated BLI: '+this.BLIList);
			this.restructureData(this.BLIList);
			//console.log('GenrateBLI Structure: '+JSON.stringify(this.FormattedBLIData));
			this.datarestrucuted = true;
			this.parentId = null;
			this.levelsDeep = 0;
            this.depthChildrenCountMap = new Map();
            this.ToRetainExpandCollapsePosition();
		}
    }

    //TO Render action the Tree Structure
    restructureData(datastructure){
		datastructure.map((obj) => {
			if(this.levelsDeep > 0){
				obj.nameStyle = 'applyLeftPadding';
				obj.rowStyle = 'hide';
                obj.parentId = this.parentId;
                obj.isChild = true;
				this.depthChildrenCountMap.get(this.levelsDeep).currentChildNumber = this.depthChildrenCountMap.get(this.levelsDeep).currentChildNumber + 1; 
			} else {
				obj.rowStyle = 'parent';
				obj.nameStyle = '';
			}
			
			if(this.depthChildrenCountMap.has(this.levelsDeep) && 
				this.depthChildrenCountMap.get(this.levelsDeep).currentChildNumber == this.depthChildrenCountMap.get(this.levelsDeep).totalNumberOfChildren){
				this.levelsDeep = this.levelsDeep - 1;
				
			}

			if(obj.childrens){
				this.parentId = obj.rowId;
				this.levelsDeep = this.levelsDeep + 1;
				this.depthChildrenCountMap.set(this.levelsDeep,{totalNumberOfChildren: obj.childrens.length , currentChildNumber : 0  });
				obj.iconName = 'utility:chevronright';
				this.FormattedBLIData.push(obj);
				this.restructureData(obj.childrens);
			}else{
				obj.iconName = '';
				this.FormattedBLIData.push(obj);
			}
        });
        //this.ToRetainExpandCollapsePosition();
        console.log('Formated Data: '+JSON.stringify(this.FormattedBLIData));
    }

    showOrHideChildrenRows(event){
        //console.log('Event'+event);
        let rowId = event.target.dataset.rowid;
        //console.log('ROWWW'+rowId);
		let isExpanded = event.target.dataset.expanded;
		
		 
		this.FormattedBLIData = this.FormattedBLIData.map((obj) => {
			if(obj.parentId == rowId &&  !JSON.parse(isExpanded)){
                event.target.iconName = JSON.parse(isExpanded) ? "utility:chevronright": "utility:chevrondown";
		        event.target.dataset.expanded = JSON.stringify(!JSON.parse(isExpanded));
				obj.rowStyle = "ChildRow";
			}
			if(obj.parentId == rowId && JSON.parse(isExpanded)){
                event.target.iconName = JSON.parse(isExpanded) ? "utility:chevronright": "utility:chevrondown";
		        event.target.dataset.expanded = JSON.stringify(!JSON.parse(isExpanded));
				obj.rowStyle = "ChildRow hide";
			}
			return obj;
		});
		//console.log(this.FormattedBLIData);

    }
    
    ToRetainExpandCollapsePosition(){
        var qData = Array.from(this.template.querySelectorAll('table.TblTreeView tbody tr.parent lightning-icon'));
        var ParentInExpand = [];
        for(let i=0; i<qData.length; i++){
            if(qData[i].dataset.expanded=='true'){
                console.log('IconsName:'+qData[i].iconName);
                qData[i].dataset.expanded = false;
                qData[i].iconName =  'utility:chevronright';
                qData[i].click();
            }
        }
    }
    
    
    handleAppEditConfirm(event){
        if(event.target.name=='Save'){
            this.template.querySelector('.AddNewBLIForm').submit();
        } else if(event.target.name=='Cancel'){
            this.isBLIAppPopup = false;
        }
    }

    ExpandAllChild(){
       var qData = Array.from(this.template.querySelectorAll('table.TblTreeView tbody tr.parent lightning-icon'));
        for(let i=0; i<qData.length; i++){
            if(qData[i].dataset.expanded=='false'){
                qData[i].click();
            }
        }
    }
    CollapseAllChild(){
        var qData = Array.from(this.template.querySelectorAll('table.TblTreeView tbody tr.parent lightning-icon'));
        for(let i=0; i<qData.length; i++){
            if(qData[i].dataset.expanded=='true'){
                qData[i].click();
            }
        }
    }

    //EOF Rendered Tree Structure

    ViewReport(){
        // this[NavigationMixin.Navigate]({
        //     type: 'standard__recordPage',x
        //     attributes: {
        //         recordId: '00O0R000000uv9XUAQ',
        //         objectApiName: 'Report',
        //         actionName: 'view?fv0=a3u0R000000DUDRQA4'
        //     },
        // });
        var reportUrl = window.location.origin+ '/lightning/r/Report/'+this.label.BLIReportId+'/view?fv0='+this.recordId;
        console.log('RId: '+reportUrl);
        window.open(reportUrl, '_blank');

        // this[NavigationMixin.GenerateUrl]({
        //     type: 'standard__objectPage',
        //     attributes: {
        //         url: '/00O0R000000uv9XUAQ/view?fv0=a3u0R000000DUDRQA4'
        //     }
        // }).then(generatedUrl => {
        //     window.open(generatedUrl,'_blank');
        // });
    }
    
    // Navigation to Budget List view(recent)
    navigateToBudgetListView() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Budget__c',
                actionName: 'list'
            },
            state: {
                filterName: 'Recent'
            },
        });
        this.isLoading=false;
    }
   
    // Navigate to View Budget Page
    navigateToViewBudgetPage() {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.recordId,
                objectApiName: 'Budget__c',
                actionName: 'view'
            },
        });
        this.isLoading=false;
    }

    
    OnCancel(){
        if(this.IsFromNew!=null && this.IsFromNew){ // To Delete ALL BLI and Budget on click cancel in New
            this.isLoading = true;
            var DeletBLIList = [];
            let BLILId = new Set();
            var TblRow =  Array.from(this.template.querySelectorAll('table.TblTreeView tbody tr'));
            for (let i = 0; i < TblRow.length; i++) {
                BLILId.add(TblRow[i].dataset.id);
            }
            DeletBLIList = Array.from(BLILId)
            console.log('DLelete Id: '+JSON.stringify(DeletBLIList));
            deleteBLI({listBLI: DeletBLIList}).then(result => {
                window.console.log('result ====> ' + result);
                deleteRecord(this.recordId).then(() => {
                    //this.datarestrucuted=false;
                    //refreshApex(this._wiredResult);
                    
                    if(this.jobId!=null){
                        window.location.href='/lightning/r/ATI_Job__c/'+this.jobId+'/view';
                    } else{
                        window.location.href='/lightning/o/Budget__c/home';
                    }

                }).catch(error => {
                    this.isLoading = false;
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error deleting record',
                            message: error.body.message,
                            variant: 'error'
                        })
                    );
                    console.log('ErrorMsg: '+JSON.stringify(error));
                });


            }).catch(error => {
                window.console.log(error);
                this.isLoading = false;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error while getting Budget Line Item', 
                        message: error.message, 
                        variant: 'error'
                    }),
                );
            });

        } else if(this.recordId){ 
            this.isLoading = true;
            console.log('Old Budget Data: '+this.OldBudgetData);
            console.log('Newly Add BLI: '+this.NewlyAddedBLIData);
            console.log('Old BLI Data: '+this.OldBLIData);
            console.log('Old Deleted BLI: '+this.OldBLIDeletedData);
            //console.log(this.OldBudgetData[0]);
            
            var BudgetObj = JSON.parse(JSON.stringify(this.OldBudgetData));
            BudgetObj = BudgetObj.map((obj) => {
                if(!obj.Allocation_Overhead__c){
                    obj.Allocation_Overhead__c=null;
                }
                if(!obj.Allocations__c){
                    obj.Allocations__c=null;
                }
                if(!obj.X3_Program_Fees__c){
                    obj.X3_Program_Fees__c=null;
                }
                if(!obj.GP_Goal__c){
                    obj.GP_Goal__c=null;
                }
                if(!obj.Overhead__c){
                    obj.Overhead__c=null;
                }
                if(!obj.Profit__c){
                    obj.Profit__c=null;
                }
                if(!obj.Sales_Tax__c){
                    obj.Sales_Tax__c=null;
                }
                return obj;
            });
            // BudgetObj.map((obj) =>{
            //     if(!obj.Subcontractor__c){
            //         obj.Subcontractor__c=null;
            //     }
            // });    

            let recordToUpdate ={fields:BudgetObj[0]};
            console.log('dd: '+JSON.stringify(BudgetObj));
            updateRecord(recordToUpdate).then(() => {

                if(this.NewlyAddedBLIData){
                    deleteBLI({listBLI: this.NewlyAddedBLIData}).then(result => {
                        console.log('Success-deleted');

                        if(this.OldBLIData){
                            //var BLIModifyObj = this.OldBLIData;
                            //this.AddBypassToBLIToCancel(this.OldBLIData);

                            this.OldBLIToUpdate=[];
                            var BLIObj = JSON.parse(JSON.stringify(this.OldBLIData));
                            BLIObj.map((obj) =>{
                                if(!obj.Subcontractor__c){
                                    obj.Subcontractor__c=null;
                                }
                                if(!obj.Subcontractor_bid__c){
                                    obj.Subcontractor_bid__c=0;
                                }
                                if(!obj.In_House_Hours__c){
                                    obj.In_House_Hours__c=0;
                                }
                                if(!obj.In_House_Rate__c){
                                    obj.In_House_Rate__c=0;
                                }
                                if(!obj.Materials__c){
                                    obj.Materials__c=0;
                                }
                                if(!obj.Equipment__c){
                                    obj.Equipment__c=0;
                                }
                                if(!obj.Other_Costs__c){
                                    obj.Other_Costs__c=0;
                                }
                                obj.Bypass_Calculation__c=true;
                                this.OldBLIToUpdate.push(obj);
                            });
                            console.log('Update List: '+JSON.stringify(this.OldBLIToUpdate));
                            UpdateOnlyBLI({UpdateBLIList: this.OldBLIToUpdate}).then(result => {
                                console.log('Sucesss-update.');
                                
                                if(this.OldBLIDeletedData){
                                    console.log('To be Inserte data: '+JSON.stringify(this.OldBLIDeletedData));
                                    UpdateBLI({UpdateBLIList: this.OldBLIDeletedData, OverheadProfit:null}).then(result => {
                                        console.log('Sucesss-Inserted.');
                                        //this.datarestrucuted=false;
                                        //refreshApex(this._wiredResult);
                                        window.location.href='/lightning/r/Budget__c/'+this.recordId+'/view';

                                    }).catch(error => {
                                        window.console.log(error);
                                        this.isLoading = false;
                                        this.dispatchEvent(
                                            new ShowToastEvent({
                                                title: 'Error Inserting Budget Line Item', 
                                                message: error.message, 
                                                variant: 'error'
                                            }),
                                        );
                                    });
                                }

                            }).catch(error => {
                                window.console.log(error);
                                this.isLoading = false;
                                this.dispatchEvent(
                                    new ShowToastEvent({
                                        title: 'Error Updating Budget Line Item', 
                                        message: error.message, 
                                        variant: 'error'
                                    }),
                                );
                            });


                        }

                    }).catch(error => {
                        window.console.log(error);
                        this.isLoading = false;
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Error deleting Budget Line item.', 
                                message: error.message, 
                                variant: 'error'
                            }),
                        );
                    });
                }

            }).catch(error => {
                console.log('Errod d: '+JSON.stringify(error));
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error on Budget data save',
                        message: error.message,
                        variant: 'error',
                    }),
                );
            });
           
        } else if(this.jobId!=null && this.recordId==null) {
            // const inputFields = this.template.querySelectorAll(
            //     'lightning-input-field'
            // );
            // if (inputFields) {
            //     inputFields.forEach(field => {
            //         //field.reset();
            //     });
            // }
            // refreshApex(this._wiredJobResult);
            // this[NavigationMixin.Navigate]({
            //     type: 'standard__recordPage',
            //     attributes: {
            //         recordId: this.jobId,
            //         objectApiName: 'ATI_Job__c',
            //         actionName: 'view'
            //     },
            // });
            // this.isLoading=false;
            window.location.href='/lightning/r/ATI_Job__c/'+this.jobId+'/view';
        }
    }

    HandleBudgetSuccess(event){
        var dispatchMessage = '';
            if(this.recordId!=null){
                //dispatchMessage = 'Updated Successfully';
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Updated Successfully',
                        variant: 'success',
                    }),
                );
                this.datarestrucuted=false;
                refreshApex(this._wiredResult);
                window.location.href='/lightning/r/Budget__c/'+this.recordId+'/view';
            } else {
                this.isLoading =true;
                dispatchMessage = 'Please proceed to Add/Update Budget Line Items.'
                //this.recordId = event.detail.id;
                //console.log('Inserted Id: '+event.detail.id);
                this.SaveNewBudgetLineItem(event.detail.id);
                 
                // Navigation to Edit
                
                    // this[NavigationMixin.Navigate]({
                    //     type: 'standard__recordPage',
                    //     attributes: {
                    //         recordId: event.detail.id,
                    //         objectApiName: 'Budget__c',
                    //         actionName: 'edit'
                    //     },
                    //     state:{
                    //         c__FromNew: true
                    //     }
                    // });
                
                
            }
            
            //this.navigateToViewBudgetPage();
        //console.log('@@@@'+this.recordId);
    }

    SaveNewBudgetLineItem(BudgetId){
        console.log('Inserted BId: '+BudgetId);
        if(BudgetId!=null){
            var InsertBLIListArg = []; var obj={};
            
            //var TblRow =  Array.from(this.template.querySelectorAll('table.TblNewBLI tbody tr'));
            // for(let k=0; k<TblRow.length; k++){
            //     var TblRowInput = Array.from(TblRow[k].querySelectorAll('lightning-input'));
            //     TblRowInput.forEach(function(element){
            //         var key=element.name;
            //         var value = element.value;
            //         obj[key]=value;
            //         if(element.name=='Trade_Option__c'){
            //             //TradeOptVal = element.value;
            //             obj.Trade__c = element.value;
            //         }
            //         if(element.name=='Selector__c'){
            //             if(element.value!=null || element.value!=''){
            //                 obj.Is_sub_Parent__c=true;
            //                 obj.Is_Parent__c=false;
            //             } else{
            //                 obj.Is_sub_Parent__c=false;
            //                 obj.Is_Parent__c=true;
            //             }
            //         }
            //         obj.Budget__c=BudgetId;
            //     }); // EOF For Each
            //     InsertBLIListArg.push(obj);
            // } // EOF For
            var NewBLITradeOpt =['APP Appliances', 'CAB Cabinetry', 'CLN Cleaning', 'CON Contents', 'DMO General Demolition', 'DOR Doors', 'DRY Drywall', 'ELE Electrical', 'FCC Floor Covering Carpet', 'FCW Floor Covering Wood', 'FNC Finish Carpentry', 'FRM Framing & Rough Carpentry', 'HVC Heat, Vent, & Air Conditioning', 'INS Insulation', 'PLM Plumbing', 'PNT Painting', 'RFG Roofing', 'SDG Siding', 'WDV Window Vinyl'];
            for(let k=0; k<NewBLITradeOpt.length; k++){
                var objNewBLI={};
                objNewBLI.Trade__c = NewBLITradeOpt[k];
                objNewBLI.Trade_Option__c = NewBLITradeOpt[k];
                objNewBLI.Budget__c = BudgetId;
                objNewBLI.Is_Parent__c = true;
                objNewBLI.X10_10_Allocation__c = true;
                console.log('BudgetGPValueInsideBLI------> ' + this.BudgetGPValue);
                if(this.BudgetGPValue != ''){
                    objNewBLI.GP__c = this.BudgetGPValue;
                }
                objNewBLI.Id =null;
                InsertBLIListArg.push(objNewBLI);
            }
            
            console.log('Insert ee:'+JSON.stringify(InsertBLIListArg));
            if(InsertBLIListArg.length>0){
                UpdateBLI({UpdateBLIList: InsertBLIListArg, OverheadProfit:null}).then(result => {
                    
                    console.log('Success Status: '+result);
                    this[NavigationMixin.Navigate]({
                        type: 'standard__recordPage',
                        attributes: {
                            recordId: BudgetId,
                            objectApiName: 'Budget__c',
                            actionName: 'edit'
                        },
                        state:{
                            c__FromNew: true
                        }
                    });
                    // this.dispatchEvent(
                    //     new ShowToastEvent({
                    //         title: 'Success',
                    //         message: 'Insertd Successfully, Please proceed to Add/Update Budget Line Items.',
                    //         variant: 'success',
                    //     }),
                    // );

                }).catch(error => {
                    console.log('Error Status: '+JSON.stringify(error));
                    if(error.body.message!=null && error.body.message!=''){
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Error on Insert Budget Line Item',
                                message: error.body.message,
                                variant: 'error'
                            })
                        );
                        this.isLoading=false;
                    }
                });
            }
        } else {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error Insertin record',
                    message: 'Unable to get Inserted Budget Id.',
                    variant: 'error'
                })
            );
        }  
    }

    OnSaveBudget(){
        var isVal = true;
        this.template.querySelectorAll('.BudgetEditForm lightning-input-field').forEach(element => {
            isVal = isVal && element.reportValidity();
        });
        if (isVal) {
            this.isLoading =true;
            var dd = this.template.querySelector('.BudgetEditForm').submit();
            //console.log('Save Da:'+dd);
        }  else {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error Updating record',
                    message: 'Please enter all the required fields',
                    variant: 'error',
                }),
            );
        }
        //this._refreshView();
    }

    handleDeleteConfirm(event){
        
        if(event.target.name==='No'){
            this.DeleteConfirmVisisble = false;
            this.ToBeDeletedId = null;
            this.ToDeleteNewBLI = null;
        } else if(event.target.name==='Yes') {
            // To Delete Edit section
            this.DeleteConfirmVisisble = false;
            this.isLoading = true;
            if(this.ToBeDeletedId!=null){
                var DId = this.ToBeDeletedId;
                console.log('idd: '+DId);
                var TblRow =  this.template.querySelector('tr[data-id="'+DId+'"]');
                console.log('TBLrow: '+JSON.stringify(TblRow));
                var TblRowInput = Array.from(TblRow.querySelectorAll('lightning-input')); var obj={};
                console.log('TblRowInput: '+JSON.stringify(TblRowInput));
                // GetBudgetLineItemData({BLIId: DId}).then(result => {
                //     console.log('BLI Data :'+JSON.stringify(result));
                //     if(result.data){
                //         this.OldBLIDeletedData.push(result.data);
                //     }
                //     console.log('OLDBLIDeleted: '+this.OldBLIDeletedData);
                // }).catch(error => {
                //     if(error.body.message!=null && error.body.message!=''){
                //         this.dispatchEvent(
                //             new ShowToastEvent({
                //                 title: 'Error on getting the BLI data',
                //                 message: error.body.message,
                //                 variant: 'error'
                //             })
                //         );
                //         this.isLoading=false;
                //     }
                // });

                deleteRecord(this.ToBeDeletedId)
                    .then(() => {
                        //console.log('B4 Delt: '+this.NewlyAddedBLIData+' Tobede: '+DId);
                        var removeIndex = this.NewlyAddedBLIData.indexOf(DId);
                        if (removeIndex > -1) {
                            this.NewlyAddedBLIData.splice(removeIndex, 1);
                        } else {
                            //Get the BLI Data
                            for(let i=0; i<TblRowInput.length; i++){
                                var key=TblRowInput[i].name;
                                var value = TblRowInput[i].value;
                                console.log('Key: '+key+' Value: '+value+' recoId: '+this.recordId);
                                obj[key]=value;
                                if(key=='Trade_Option__c'){
                                    //TradeOptVal = element.value;
                                    obj.Trade__c = value;
                                    obj.Budget__c=this.recordId;
                                }
                                if(key=='Id'){
                                    obj.Id = null;
                                }
                                if(key=='Is_sub_Parent__c'){
                                    obj[key]=TblRowInput[i].checked;
                                } 
                                if(key=='Is_Parent__c'){
                                    obj[key]=TblRowInput[i].checked;
                                }    
                            }
                            this.OldBLIDeletedData.push(obj);
                        }
                        console.log('After remove: '+JSON.stringify(this.OldBLIDeletedData));
                        this.datarestrucuted=false;
                        

                        
                        // UpdateBLI({UpdateBLIList: AllData, OverheadProfit:null})
                        refreshApex(this._wiredResult);
                        this.refreshBudgetValues();
                 
                        this.isLoading = false;
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Success',
                                message: 'Record deleted',
                                variant: 'success'
                            })
                        );
                    })
                    .catch(error => {
                        this.isLoading = false;
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Error deleting record',
                                message: error.body.message,
                                variant: 'error'
                            })
                        );
                        console.log('ErrorMsg: '+JSON.stringify(error));
                    });
                this.ToBeDeletedId = null;
            } else if(this.ToDeleteNewBLI!=null){
                this.NewBLIData.splice(this.ToDeleteNewBLI,1);
                this.ToDeleteNewBLI = null;
                this.isLoading = false;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Record removed',
                        variant: 'success'
                    })
                );
            } else {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error Deleting record',
                        message: 'Error on deleting record.',
                        variant: 'error',
                    }),
                );
                this.ToDeleteNewBLI = null;
            }
            
        }
    }

    deleteBLI(event){
        this.ToBeDeletedId = event.target.dataset.targetId;
        this.DeleteConfirmVisisble = true;
        //let targetId = event.target.dataset.targetId;
        //console.log('DeleteID: '+targetId);
        // this.isLoading = true;
        // deleteRecord(targetId)
        //     .then(() => {
        //         this.datarestrucuted=false;
        //         refreshApex(this._wiredResult);
        //         this.isLoading = false;
        //         this.dispatchEvent(
        //             new ShowToastEvent({
        //                 title: 'Success',
        //                 message: 'Record deleted',
        //                 variant: 'success'
        //             })
        //         );
        //     })
        //     .catch(error => {
        //         this.isLoading = false;
        //         this.dispatchEvent(
        //             new ShowToastEvent({
        //                 title: 'Error deleting record',
        //                 message: error.body.message,
        //                 variant: 'error'
        //             })
        //         );
        //         console.log('ErrorMsg: '+JSON.stringify(error));
        //     });
    }

    HandleBudgetError(event){
        this.isLoading = false;
    }

    handleOnFocusIn(event){
        //if(this.OnFocusInOutHandler==null || this.OnFocusInOutHandler==''){
            //this.isLoading=false;
            this.hasChanged = true;
        //}
    }
    handleTotalsChange(e)
    {
        var evntValue = e.target.value;
        let SalesTax = this.SalesTax;
        this.SalesTax = e.target.value;
        if(this.SalesTax != SalesTax)
        {
            this.isLoading = true;
            if(evntValue === undefined || evntValue === null || evntValue === '')
            {
                evntValue = 0;
            }
            console.log('evntValue is ' + evntValue);
            UpdateSalesTax({BudgetId:this.recordId, SalesTax:evntValue}).then(result => {
                refreshApex(this._wiredResult);
                this.refreshBudgetValues();
                this.isLoading = false;
            });
        }
        
    }
    handleFormInputChange(event){
        //event.preventDefault();
        //console.log('!ParentNode: '+event.target.dataset.targetId);
        //this.isLoading=true;
        var evntValue = event.target.value;
        var ValidationMessage = '';
        if(this.hasChanged || event.target.name=='X10_10_Allocation__c') {
            this.isLoading = true;
            let targetId = event.target.dataset.targetId;
            console.log('Bluered tId: '+targetId);
            var UpdateBLIListArg = []; var obj={};
            var TblRow =  this.template.querySelector('tr[data-id="'+targetId+'"]');
            //var TblRowInput = Array.from(TblRow.querySelectorAll('lightning-input-field'));
            var TblRowInput = Array.from(TblRow.querySelectorAll('lightning-input'));
            //var TradeOptVal = ''; var SelectorVal = '';
            TblRowInput.forEach(function(element){
                var key=element.name;
                var value = element.value;
                if(key!='Is_sub_Parent__c' && key!='Is_Parent__c'){
                    obj[key]=value;
                    /*if(element.name=='Trade_Option__c'){
                        //TradeOptVal = element.value;
                        obj.Trade__c = element.value;
                    }*/
                    if(element.name=='X10_10_Allocation__c'){
                        obj.X10_10_Allocation__c =element.checked;
                    }
                    if(element.name=='In_House_Rate__c'){
                        obj.In_House_Rate_Full__c = element.value;
                    }
                }   
            });
            
            UpdateBLIListArg.push(obj);
            console.log('SaveList: '+JSON.stringify(UpdateBLIListArg));
            if(UpdateBLIListArg.length>0){
                //this.isLoading=true;
                UpdateBLI({UpdateBLIList: UpdateBLIListArg, OverheadProfit:null}).then(result => {
                    
                    console.log('Success Status: '+result);
                    this.datarestrucuted=false;
                    refreshApex(this._wiredResult);
                    this.refreshBudgetValues();
                    //this.isLoading=false;
                    //refreshApex(this._ApiWiredResult);
                    //this.GenerateBLIItems();
                    //this.ToRetainExpandCollapsePosition();
                }).catch(error => {
                    console.log('Error Status: '+JSON.stringify(error));
                    if(error.body.message!=null && error.body.message!=''){
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Error Updating Fields',
                                message: error.body.message,
                                variant: 'error'
                            })
                        );
                        this.isLoading=false;
                    }
                });
            } 
            this.hasChanged = false;
        }
        
    
    }
    // handleBLIEdit(event){
    //     let targetRowId = event.target.dataset.targetId;
    //     console.log('Row:'+targetRowId);
    //     var TblRow =  this.template.querySelector('tr[data-id="'+targetRowId+'"]');
    //     console.log('Row:'+TblRow);
    //     TblRow.querySelector('lightning-input-field.ToggleEditFields').setAttribute('disabled','False');
    // }

    refreshBudgetValues() {
        this.isLoading = true;
        updateRecord({ fields: { Id: this.recordId } }).then(() => {
            this.isLoading=false;
        }).catch(error => {
            console.log('Errod d: '+JSON.stringify(error));
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error refreshing Budget data',
                    message: error.message,
                    variant: 'error',
                }),
            );
        });
    }


    //Get Job details
    @wire(RetrieveJob,{jobId: '$jobId'}) 
    wiredRetrieveJob(result){
        console.log('Result'+JSON.stringify(result.data));
        var DataList; 
        this._wiredJobResult = result;
        if(result.data){    
            DataList =result.data;
            console.log('Len: '+DataList.Branch_Manager__c);
            if(DataList.length>0){
                //console.log('Len: '+DataList.length+' data:'+DataList);
                this.JobStartDate=DataList[0].Job_Start_Date__c;
                this.JobEstimatedCompletionDate=DataList[0].Estimated_Completion_Date__c;
                this.JobRegionalManger=DataList[0].Branch_Manager__c;
                this.JobProjectDirecor=DataList[0].Project_Manager__c;
                this.JobProjectManager=DataList[0].Project_Manager_new__c;

                console.log(this.JobStartDate+'-'+this.JobEstimatedCompletionDate+'-'+this.JobRegionalManger+'-'+this.JobProjectDirecor+'-'+this.JobProjectManager);
                //refreshApex(this._ApiWiredResult);

            }
        } else if(result.error) {
            console.log('Error---'+JSON.stringify(result.error));
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error Processing record',
                    message: result.error,
                    variant: 'error',
                }),
            );
        }
    }

    //Get Budget Data 
    @wire(RetrieveBudget,{budgetId: '$recordId'})
    wiredRetrieveBudget(result){
        console.log('res' +JSON.stringify(result));
        if(result.data){
            console.log('Sales tax ' + result.data[0].Sales_Tax__c);
            console.log('BudgetGPValue------> ' + result.data[0].GP_Goal__c);
            this.BudgetGPValue = result.data[0].GP_Goal__c;
            if(result.data[0].Sales_Tax__c)
            {
                console.log('Test is sales tax passes');
                this.SalesTax = result.data[0].Sales_Tax__c;
            }
            
            this.OldBudgetData = result.data;
            console.log('Old Budget Data: '+JSON.stringify(this.OldBudgetData[0]));
            if(this.OldBudgetData[0].Budget_LineItem_Status__c){
                if(this.APIfields!=null){
                    this.APIfields = this.APIfields.map((obj) => {
                        if(obj.APIName=='Allocation_Overhead__c'){
                            obj.Enable = true;
                        }
                        return obj;
                    });
                }
                this.IsImported = true;
            }
        } else if(result.error) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error Processing record',
                    message: result.error,
                    variant: 'error',
                }),
            );
        }
    }
    // @wire(RetrieveBudget, {budgetId: '$recordId'})
    // wiredRetrieveBudget(result) {
    //     console.log('dk'+JSON.stringify(result));
    //     if(result.data){
    //         this.OldBudgetData = reuslt.data;
    //         console.log('Old Budget Data: '+JSON.stringify(this.OldBudgetData));
    //     }  else if(result.error) {
    //         this.dispatchEvent(
    //             new ShowToastEvent({
    //                 title: 'Error Processing record',
    //                 message: result.error,
    //                 variant: 'error',
    //             }),
    //         );
    //     }
    // }
    
    //Get all Budget Line Item details
    @wire(RetrieveBudgetLineItems,{budgetId: '$recordId'})
    wiredRetrieveBudgetLineItems(result) { 
        var DataList;
        this._wiredResult = result;
        if(result.data){
            console.log('Olddata Len:'+this.OldBLIData.length);
            if(this.OldBLIData.length==0){
                this.OldBLIData = result.data;
            }
            console.log('Old BLI Data: '+JSON.stringify(this.OldBLIData));
            DataList = result.data; var BLIChildList =[]; this.BLIList=[];
            //console.log('data size: '+DataList.length);
            if(DataList.length>0){
                for(let i=0; i<DataList.length; i++){
                    //console.log('Inside I For: '+DataList[i].Is_Parent__c);
                    if(DataList[i].Is_Parent__c){
                        var objParent={}; BLIChildList =[];
                        for(let j=0; j<DataList.length; j++){
                            //console.log('Inside J For: '+DataList[j].Is_sub_Parent__c);
                            if(DataList[j].Is_sub_Parent__c && DataList[i].Trade__c==DataList[j].Trade__c){
                                //console.log('Inside If:'+DataList[j].Trade__c);
                                var objChild={};
                                objChild.Id = DataList[j].Id;
                                objChild.rowId = i;
                                objChild.Trade__c = DataList[j].Trade__c;
                                objChild.Trade_Option__c = DataList[j].Trade_Option__c;
                                objChild.Selector__c = DataList[j].Selector__c;
                                objChild.Item_Description__c = DataList[j].Item_Description__c;
                                if(objChild.Item_Description__c){
                                    objChild.IsDesc = true;
                                } else {
                                    objChild.IsDesc = false;
                                }
                                if(DataList[j].Revenue__c!=null){
                                    objChild.Revenue__c = parseFloat(DataList[j].Revenue__c).toFixed(2);
                                } else {
                                    objChild.Revenue__c = parseFloat(0).toFixed(2);
                                }
                                if(DataList[j].Budget_Goal__c!=null){
                                    objChild.Budget_Goal__c = parseFloat(DataList[j].Budget_Goal__c).toFixed(2);
                                } else {
                                    objChild.Budget_Goal__c = parseFloat(0).toFixed(2);
                                }
                                
                                objChild.X10_10_Allocation__c = DataList[j].X10_10_Allocation__c;
                                if(DataList[j].GP__c!=null){
                                    objChild.GP__c = parseFloat(DataList[j].GP__c).toFixed(2);
                                } else{
                                    objChild.GP__c = DataList[j].GP__c;
                                }
                                objChild.Subcontractor__c = DataList[j].Subcontractor__c;
                                if(DataList[j].Subcontractor_bid__c!=null){
                                    objChild.Subcontractor_bid__c = parseFloat(DataList[j].Subcontractor_bid__c).toFixed(2);
                                } else{
                                    objChild.Subcontractor_bid__c = parseFloat(0).toFixed(2);
                                }
                                if(DataList[j].In_House_Hours__c!=null){
                                    objChild.In_House_Hours__c = parseFloat(DataList[j].In_House_Hours__c).toFixed(2);
                                } else{
                                    objChild.In_House_Hours__c = parseFloat(0).toFixed(2);
                                }
                                //objChild.In_House_Rate__c = parseFloat(DataList[j].In_House_Rate__c).toFixed(2);
                                if(DataList[j].In_House_Rate__c!=null){
                                    objChild.In_House_Rate__c = parseFloat(DataList[j].In_House_Rate__c).toFixed(2);
                                } else{
                                    objChild.In_House_Rate__c = parseFloat(0).toFixed(2);
                                }
                                objChild.In_House_Total__c = DataList[j].In_House_Total__c;
                                //objChild.Materials__c = parseFloat(DataList[j].Materials__c).toFixed(2);
                                if(DataList[j].Materials__c!=null){
                                    objChild.Materials__c = parseFloat(DataList[j].Materials__c).toFixed(2);
                                } else{
                                    objChild.Materials__c = parseFloat(0).toFixed(2);
                                }
                                //objChild.Equipment__c = parseFloat(DataList[j].Equipment__c).toFixed(2);
                                if(DataList[j].Equipment__c!=null){
                                    objChild.Equipment__c = parseFloat(DataList[j].Equipment__c).toFixed(2);
                                } else{
                                    objChild.Equipment__c = parseFloat(0).toFixed(2);
                                }
                                //objChild.Other_Costs__c = parseFloat(DataList[j].Other_Costs__c).toFixed(2);
                                if(DataList[j].Other_Costs__c!=null){
                                    objChild.Other_Costs__c = parseFloat(DataList[j].Other_Costs__c).toFixed(2);
                                } else{
                                    objChild.Other_Costs__c = parseFloat(0).toFixed(2);
                                }
                                objChild.Actual_Costs__c = DataList[j].Actual_Costs__c;
                                //objChild.Actual_Costs_BL__c = DataList[j].Actual_Costs_BL__c;
                                if(DataList[j].Actual_Costs_BL__c!=null){
                                    objChild.Actual_Costs_BL__c = parseFloat(DataList[j].Actual_Costs_BL__c).toFixed(2);
                                } else{
                                    objChild.Actual_Costs_BL__c = DataList[j].Actual_Costs_BL__c;
                                }
                                objChild.Is_Parent__c = DataList[j].Is_Parent__c;
                                objChild.Is_sub_Parent__c = DataList[j].Is_sub_Parent__c;
                                objChild.DonotDelete__c = DataList[j].DonotDelete__c;
                                BLIChildList.push(objChild);
                            }
                        } //EOF J Loop
                        objParent.Id = DataList[i].Id;
                        objParent.rowId = i;
                        objParent.Trade__c = DataList[i].Trade__c;
                        objParent.Trade_Option__c = DataList[i].Trade_Option__c;
                        objParent.Selector__c = DataList[i].Selector__c;
                        objParent.Item_Description__c = DataList[i].Item_Description__c;
                        if(objParent.Item_Description__c){
                            objParent.IsDesc = true;
                        } else {
                            objParent.IsDesc = false;
                        }
                        if(DataList[i].Revenue__c!=null){
                            objParent.Revenue__c = parseFloat(DataList[i].Revenue__c).toFixed(2);
                        } else{
                            objParent.Revenue__c = parseFloat(0).toFixed(2);
                        }
                        if(DataList[i].Budget_Goal__c!=null){
                            objParent.Budget_Goal__c = parseFloat(DataList[i].Budget_Goal__c).toFixed(2);
                        } else {
                            objParent.Budget_Goal__c = parseFloat(0).toFixed(2);
                        }
                        objParent.X10_10_Allocation__c = DataList[i].X10_10_Allocation__c;
                        //objParent.GP__c = parseFloat(DataList[i].GP__c).toFixed(2);
                        if(DataList[i].GP__c!=null){
                            objParent.GP__c = parseFloat(DataList[i].GP__c).toFixed(2);
                        } else{
                            objParent.GP__c = parseFloat(0).toFixed(2);
                        }
                        objParent.Subcontractor__c = DataList[i].Subcontractor__c;
                        //objParent.Subcontractor_bid__c = DataList[i].Subcontractor_bid__c;
                        if(DataList[i].Subcontractor_bid__c!=null){
                            objParent.Subcontractor_bid__c = parseFloat(DataList[i].Subcontractor_bid__c).toFixed(2);
                        } else{
                            objParent.Subcontractor_bid__c = parseFloat(0).toFixed(2);
                        }
                        //objParent.In_House_Hours__c = parseFloat(DataList[i].In_House_Hours__c).toFixed(0);
                        if(DataList[i].In_House_Hours__c!=null){
                            objParent.In_House_Hours__c = parseFloat(DataList[i].In_House_Hours__c).toFixed(2);
                        } else{
                            objParent.In_House_Hours__c = parseFloat(0).toFixed(2);
                        }
                        //objParent.In_House_Rate__c = parseFloat(DataList[i].In_House_Rate__c).toFixed(2);
                        if(DataList[i].In_House_Rate__c!=null){
                            objParent.In_House_Rate__c = parseFloat(DataList[i].In_House_Rate__c).toFixed(2);
                        } else{
                            objParent.In_House_Rate__c = parseFloat(0).toFixed(2);
                        }
                        objParent.In_House_Total__c = DataList[i].In_House_Total__c;
                        //objParent.Materials__c = parseFloat(DataList[i].Materials__c).toFixed(2);
                        if(DataList[i].Materials__c!=null){
                            objParent.Materials__c = parseFloat(DataList[i].Materials__c).toFixed(2);
                        } else{
                            objParent.Materials__c = parseFloat(0).toFixed(2);
                        }
                        //objParent.Equipment__c = parseFloat(DataList[i].Equipment__c).toFixed(2);
                        if(DataList[i].Equipment__c!=null){
                            objParent.Equipment__c = parseFloat(DataList[i].Equipment__c).toFixed(2);
                        } else{
                            objParent.Equipment__c = parseFloat(0).toFixed(2);
                        }
                        //objParent.Other_Costs__c = parseFloat(DataList[i].Other_Costs__c).toFixed(2);
                        if(DataList[i].Other_Costs__c!=null){
                            objParent.Other_Costs__c = parseFloat(DataList[i].Other_Costs__c).toFixed(2);
                        } else{
                            objParent.Other_Costs__c = parseFloat(0).toFixed(2);
                        }
                        objParent.Actual_Costs__c = DataList[i].Actual_Costs__c;
                        //objParent.Actual_Costs_BL__c = DataList[i].Actual_Costs_BL__c;
                        if(DataList[i].Actual_Costs_BL__c!=null){
                            objParent.Actual_Costs_BL__c = parseFloat(DataList[i].Actual_Costs_BL__c).toFixed(2);
                        } else{
                            objParent.Actual_Costs_BL__c = DataList[i].Actual_Costs_BL__c;
                        }
                        objParent.Is_Parent__c = DataList[i].Is_Parent__c;
                        objParent.Is_sub_Parent__c = DataList[i].Is_sub_Parent__c; 
                        objParent.DonotDelete__c = DataList[i].DonotDelete__c;    
                        if(BLIChildList.length>0){
                            objParent.childrens = BLIChildList;  
                        }
                        this.BLIList.push(objParent);
                    }
                } //EOF I Loop
                //console.log('Full BLI LISt: '+JSON.stringify(this.BLIList));
                this.GenerateBLIItems();
            }
        }  else if(result.error) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error Processing record',
                    message: result.error,
                    variant: 'error',
                }),
            );
        }
    }

    //Get Trade Pick Value
    @wire(getTradeOptionPickValues)
    wiredgetTradeOptionPickValues(result){
        if(result.data){
            this.TradeOptionVal = result.data;
        } else if(result.error) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error Processing record',
                    message: result.error,
                    variant: 'error',
                }),
            );
        }
        console.log('Trade val:'+this.TradeOptionVal);
    }
   
    //Get all Budget API details
    @wire(getAPINamesFromMetadata)
    //wiredgetAPINamesFromMetadata({ error, data }) { 
    wiredgetAPINamesFromMetadata(result) { 
        var objData ={};
        var DataList; 
        var EnableAPIList = ['Allocations__c', 'X3_Program_Fees__c', 'GP_Goal__c', 'Sales_Tax__c', 'Overhead_Profit_Sales_Tax__c','ATI_Job__c', 'Allocation_Overhead__c', 'Tax_Exempt__c'];
        this._ApiWiredResult = result;
        if(result.data){
            DataList =result.data;
            //console.log('datassssssssssssss'+JSON.stringify(DataList));
            if(DataList.length>0){
                let count=0;
                for(let i in DataList){
                    if(DataList[i].Budget_API_Names__c){ 
                        var DataAPIList = DataList[i].Budget_API_Names__c.split(',');
                        //console.log('APIList'+JSON.stringify(DataAPIList));
                        for(let j in DataAPIList){
                            if(DataAPIList[j]){
                                objData ={};
                                //console.log('API: '+DataAPIList[j]+' Section: '+DataList[i].LWC_Section__c);
                                objData.key = count;
                                objData.APIName = DataAPIList[j].trim();
                                if(objData.APIName=='ATI_Job__c' && this.jobId!=null && this.IsBudgetNew==true){
                                    objData.value = this.jobId;
                                }
                                if(objData.APIName=='Regional_Manager__c' && this.JobRegionalManger && this.IsBudgetNew==true){
                                    objData.value = this.JobRegionalManger;
                                }
                                if(objData.APIName=='Project_Director__c' && this.JobProjectDirecor && this.IsBudgetNew==true){
                                    objData.value = this.JobProjectDirecor;
                                }
                                if(objData.APIName=='Project_Manager__c' && this.JobProjectManager && this.IsBudgetNew==true){
                                    objData.value = this.JobProjectManager;
                                }
                                if(objData.APIName=='GP_Goal__c' || objData.APIName=='Allocation_Overhead__c' || objData.APIName=='Allocations__c' || objData.APIName=='X3_Program_Fees__c' || objData.APIName=='Tax_Exempt__c' ||  objData.APIName=='Overhead_Profit_Sales_Tax__c'){
                                    objData.changevnt = true;
                                }
                                if(objData.APIName === 'Sales_Tax__c')
                                {
                                    objData.onBlurEvent = true;
                                }
                                if(DataList[i].LWC_Section__c=='Budget Info'){
                                    objData.BudgetSection = true;
                                    objData.TotalSection = false;
                                    objData.AllTotalSection = false;    
                                } else if(DataList[i].LWC_Section__c=='Totals'){
                                    objData.BudgetSection = false;
                                    objData.TotalSection = true;
                                    objData.AllTotalSection = false;    
                                } else if(DataList[i].LWC_Section__c=='Overall Total'){
                                    objData.BudgetSection = false;
                                    objData.TotalSection = false;
                                    objData.AllTotalSection = true;    
                                }
                                objData.Section = DataList[i].LWC_Section__c;
                                if(!EnableAPIList.includes(objData.APIName)) {
                                    objData.Enable = true;
                                } else{
                                    objData.Enable = false;
                                }
                                if(objData.APIName=='Allocation_Overhead__c' && this.IsImported==true){
                                    objData.Enable = true;
                                }
                                this.APIfields.push(objData);
                                count++;
                            }
                        }
                    }
                }
               console.log('API: '+JSON.stringify(this.APIfields));
            }
        } else if(result.error) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error Processing record',
                    message: result.error,
                    variant: 'error',
                }),
            );
        }
    }

    ShowToolTip(event){
        event.target.parentNode.classList.add('ShowDescToolTip');
    }
    HideToolTip(event){
        event.target.parentNode.classList.remove('ShowDescToolTip');
    }

}