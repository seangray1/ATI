/**
 * @File Name          : micaLWC.js
 * @Description        : 
 * @Author             : Sean Gray
 * @Group              : 
 * @Last Modified By   : Sean Gray
 * @Last Modified On   : 11/15/2019, 9:18:38 AM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    9/20/2019   Sean Gray     Initial Version
**/
import { LightningElement, api, track, wire } from 'lwc';
// import MICASync from '@salesforce/apex/MICASync.queryDivision';
//import QueryRecordType from '@salesforce/apex/MICASync.queryRecordType';
import SendToMica from '@salesforce/apex/MICASync.executeJobWithoutWater';
//import SendToMicaWithWater from '@salesforce/apex/MICASync.executeJobWithWater';
import UploadEstimate from '@salesforce/apex/MICASync.executeUploadEstimate';
// import getClassCategory from '@salesforce/apex/MICASync.getClassCategory';
// import StartWithMain from '@salesforce/apex/MICASync.StartWithMain';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { getRecord } from 'lightning/uiRecordApi';
import JOB_OBJECT from '@salesforce/schema/ATI_Job__c';
import CLASS_FIELD from '@salesforce/schema/ATI_Job__c.Class__c';
import CATEGORY_FIELD from '@salesforce/schema/ATI_Job__c.Category__c';
import ESJOBTYPE_FIELD from '@salesforce/schema/ATI_Job__c.ES_Job_Type__c';
import { NavigationMixin, CurrentPageReference } from 'lightning/navigation';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
var a;
var b;
var ClassCategory;
const fields = [
	'ATI_Job__c.Class__c',
    'ATI_Job__c.Category__c',
    'ATI_Job__c.ProjectGuid__c',
    'ATI_Job__c.ES_Job_Type__c',
    'ATI_Job__c.Division__c',
    
	
];
export default class MicaLWC extends NavigationMixin(LightningElement) {

   
    @track ClassCategory;
    @track recordTypeId;
    @track value;
    
    @track categoryclass;
  
    @track data;
    @track data2;
    @track EmgSvs = false;
    @track Water = false;
    @track WaterNo = false;
    @track ExtraData;
    @api recordId;
    @track startEmgSvsPGEmpty;
    @track startNotEmgSvsPGEmpty;
    @track startPGNotEmpty;
    @track UploadMethod = 'Main';
    @track start = false;
    @track categoryNum;
    @track classNum;
    @track msg= false;
    @track classValue;
    @track categoryValue;
    @track ClassCategoryBlank = true;
    @track ClassHasChanged;
    @track CategoryHasChanged;
    @track wait;
    @track MainHelp = 'Main is used to upload a Stand Alone Estimate';
    @track EstimateClassCategoryScreenBoolean = false;
    @track EstimateFileUploadBoolean = false;
    @track waterloss = false;
    @track CategorySelect;
    @track ClassSelect;
    @track classValue12;
    @track categoryValue12;
    @track divisionTest;
    @track ProjectGuid;
    @track noProjectGuid = false;
    @track ESJobType;
    @track EsJobTypeScreen = false;
    @track SelectEsJobType;
    @track selectMethodScreen;
    @track EsJobTypeButtonDisabled = true;
    @track notCorrectEstimate = false;
    @wire(CurrentPageReference) pageRef;
    @wire(getObjectInfo, { objectApiName: JOB_OBJECT })
    objectInfo;
    @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: CLASS_FIELD})
    ClassPicklistValues;
    @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: CATEGORY_FIELD})
    CategoryPicklistValues;
    @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: ESJOBTYPE_FIELD})
    EsJobTypePicklistValues;
    @wire(getRecord, { recordId: '$recordId', fields })
	loadJob({ error, data }) {
		if (error) {
			// TODO: handle error
		} else if (data) {
            // Get Bear data
            
            
			this.classValue12 = data.fields.Class__c.value;
            this.categoryValue12 = data.fields.Category__c.value;
            this.ProjectGuid = data.fields.ProjectGuid__c.value;
            this.divisionTest = data.fields.Division__c.value;
            this.ESJobType = data.fields.ES_Job_Type__c.value;
            console.log('ES Job Type is + ' + this.ESJobType);
            console.log('Project Guid is    + ' + this.ProjectGuid);
            console.log('Division ' + this.divisionTest)
            if(this.ESJobType !== null && this.ESJobType !== 'Other'){
                this.EsJobTypeButtonDisabled = false;
            }
            if(this.ProjectGuid !== null && this.ESJobType === 'Water Mitigation'){
                this.EstimateClassCategoryScreenBoolean = true; 
                console.log('6');
            }
            if(this.classValue12 !== '1' || this.classValue12 !== '2' || this.classValue12 !== '3' || this.classValue12 !== '4'){
                this.ClassCategoryBlank = true;
            
            }
            if(this.classValue12 === '1' || this.classValue12 === '2' || this.classValue12 === '3' || this.classValue12 === '4'){
                this.ClassCategoryBlank = false;
                console.log('category blank = ' + this.ClassCategoryBlank);
            } if(this.classValue12 !== '1' || this.classValue12 !== '2' || this.classValue12 !== '3' || this.classValue12 !== '4'){
                this.ClassCategoryBlank = true;
            
            }
            if(this.classValue12 === '1' || this.classValue12 === '2' || this.classValue12 === '3' || this.classValue12 === '4'){
                this.ClassCategoryBlank = false;
                console.log('category blank = ' + this.ClassCategoryBlank);
            }
            if(!this.ProjectGuid && this.divisionTest === 'Construction'){
                this.noProjectGuid = true;
                console.log('1');
            }
            if(this.divisionTest === 'Construction' && this.ProjectGuid !== null){
                this.selectMethodScreen = true;
                console.log('2');
            }
            if(this.ESJobType === 'Other' || (this.divisionTest === 'Emergency Svces' && this.ESJobType === null)){
                this.EsJobTypeScreen = true;
                console.log('3');
            }
            
            if(!this.ProjectGuid && this.ESJobType === 'Water Mitigation'){
                this.EstimateClassCategoryScreenBoolean = true;
                console.log('4');
            }
            if(!this.ProjectGuid && (this.ESJobType === 'Board-Up' || this.ESJobType === 'Roof Tarp' || this.ESJobType === 'Smoke Cleaning')){
                this.noProjectGuid = true ;
                console.log('5');
            }
           
            
                //this.startPGNotEmpty = true;
            
            if(this.ProjectGuid !== null && (this.ESJobType === 'Board-Up' || this.ESJobType === 'Roof Tarp' || this.ESJobType === 'Smoke Cleaning')){
                this.selectMethodScreen = true;
                console.log('7');
            }
            if(!this.ProjectGuid && this.divisionTest !== 'Construction' && this.divisionTest !== 'Emergency Svces'){
                this.noProjectGuid = true;
                console.log('8');
            }
            if(this.ProjectGuid !== null && this.divisionTest !== 'Construction' && this.divisionTest !== 'Emergency Svces'){
                this.selectMethodScreen = true;
                console.log('8');
            }
            
			// Transform bear data into map markers	
		}
	}

   // @wire(getObjectInfo, { objectApiName: JOB_OBJECT})
    //objectInfo; 
    
    //@wire(getPicklistValues, { recordTypeId: this.recordTypeId, fieldApiName: CLAIM_FIELD})
    //ClassPicklistValues;
    MainButton(){
        this.UploadMethod = 'Main';
        this.selectMethodScreen = false;
        this.EstimateFileUploadBoolean = true;
        // if((this.ProjectGuid === null) && this.Division === 'Emergency Svces'){this.startEmgSvsPGEmpty = true;}
        // if((this.ProjectGuid === null) && this.Division !== 'Emergency Svces'){this.startNotEmgSvsPGEmpty = true;}
        // if(this.ProjectGuid && this.Division === 'Emergency Svces'){this.startPGNotEmpty = true;}
        // if((this.ProjectGuid) && this.Division !== 'Emergency Svces'){this.EstimateFileUploadBoolean = true;}
    }
    SupplementButton(){ 
        this.UploadMethod = 'Supplement';
        this.selectMethodScreen = false;
        this.EstimateFileUploadBoolean = true;
        // if((this.ProjectGuid === null) && this.Division === 'Emergency Svces'){this.startEmgSvsPGEmpty = true;}
        // if((this.ProjectGuid === null) && this.Division !== 'Emergency Svces'){this.startNotEmgSvsPGEmpty = true;}
        // if(this.ProjectGuid && this.Division === 'Emergency Svces'){this.startPGNotEmpty = true;}
        // if((this.ProjectGuid) && this.Division !== 'Emergency Svces'){this.EstimateFileUploadBoolean = true;}
    }
    ChangeOrderButton(){ 
        this.UploadMethod = 'Change Order';
        this.selectMethodScreen = false;
        this.EstimateFileUploadBoolean = true;
        // if((this.ProjectGuid === null) && this.Division === 'Emergency Svces'){this.startEmgSvsPGEmpty = true;}
        // if((this.ProjectGuid === null) && this.Division !== 'Emergency Svces'){this.startNotEmgSvsPGEmpty = true;}
        // if(this.ProjectGuid && this.Division === 'Emergency Svces'){this.startPGNotEmpty = true;}
        // if((this.ProjectGuid) && this.Division !== 'Emergency Svces'){this.EstimateFileUploadBoolean = true;}
    }
    notEmgSvs(){
        this.startPGNotEmpty = false;
        this.startEmgSvsPGEmpty = false;
        this.startNotEmgSvsPGEmpty = true;
    }
    categoryChange(event){
        this.categoryNum = event.detail.value;
    }
    estimateUploadNotWater(){
        this.noProjectGuid = false;
        this.startPGNotEmpty = false;
        this.EstimateFileUploadBoolean = true;
    }
    EstimateClassCategoryScreen(){
        this.waterloss = true;
        this.startPGNotEmpty = false;
        this.EstimateClassCategoryScreenBoolean = true;
        if(this.classValue12 !== '1' || this.classValue12 !== '2' || this.classValue12 !== '3' || this.classValue12 !== '4'){
            this.ClassCategoryBlank = true;
        
        }
        if(this.classValue12 === '1' || this.classValue12 === '2' || this.classValue12 === '3' || this.classValue12 === '4'){
            this.ClassCategoryBlank = false;
            console.log('category blank = ' + this.ClassCategoryBlank);
        } if(this.classValue12 !== '1' || this.classValue12 !== '2' || this.classValue12 !== '3' || this.classValue12 !== '4'){
            this.ClassCategoryBlank = true;
        
        }
        if(this.classValue12 === '1' || this.classValue12 === '2' || this.classValue12 === '3' || this.classValue12 === '4'){
            this.ClassCategoryBlank = false;
            console.log('category blank = ' + this.ClassCategoryBlank);
        }
    }
    classChangePicklist(event){
        this.classValue12 = event.detail.value;
            this.ClassHasChanged = true;
            if(this.CategoryHasChanged === true){
            this.ClassCategoryBlank = false;
        }
    }
    categoryChangePicklist(event){
        this.categoryValue12 = event.detail.value;
        this.CategoryHasChanged = true;
            if(this.ClassHasChanged === true){
            this.ClassCategoryBlank = false;
        }
    }
    EsJobTypeChangePicklist(event){
        this.ESJobType = event.detail.value;
        
            if(this.ESJobType !== 'Other'){
            this.EsJobTypeButtonDisabled = false;
        }
        if(this.ESJobType === 'Other'){
            this.EsJobTypeButtonDisabled = true;
        }
    }
    EsJobTypeButton(){
        this.EsJobTypeScreen = false;
        if(this.ESJobType === 'Water Mitigation'){
            this.EstimateClassCategoryScreenBoolean = true;
        }
        if(this.ESJobType !== 'Water Mitigation' && this.ProjectGuid !== null){
            this.selectMethodScreen = true;
        }
        if(this.ESJobType !== 'Water Mitigation' && this.ProjectGuid === null){
            this.noProjectGuid = true;
        }
    }

    EstimateFileUploadButton(){
        this.EstimateClassCategoryScreenBoolean = false;
        if(this.ProjectGuid === null){
            this.noProjectGuid = true;
        }
        else{
            this.selectMethodScreen = true;
        }
        
        //this.EstimateFileUploadBoolean = true;
    }
    classChange(event){
        this.classNum = event.detail.value;
    }


    get acceptedFormats() {
        return ['.pdf', '.png', '.txt'];

        
    }
    get acceptedFormats1() {
        
        return ['.pdf', '.png', '.txt'];
    }
    //handleChange(event){
     //   this.value = event.detail.value;
    //} 
    
    WaterUploadFile(){
        this.Water = true;
        this.categoryclass = false;

    }
    // categoryclassButton(){
    //     this.categoryclass = true;
    //     this.waterloss = true;
        
    //     this.startEmgSvsPGEmpty = false;
    //    console.log('classValue12 = ' + this.classValue12);
    //     if(this.classValue12 !== '1' || this.classValue12 !== '2' || this.classValue12 !== '3' || this.classValue12 !== '4'){
    //         this.ClassCategoryBlank = true;
        
    //     }
    //     if(this.classValue12 === '1' || this.classValue12 === '2' || this.classValue12 === '3' || this.classValue12 === '4'){
    //         this.ClassCategoryBlank = false;
    //         console.log('category blank = ' + this.ClassCategoryBlank);
    //     }
    // }
    UploadEstimate(){
        this.startPGNotEmpty = false;
        this.wait = true;
        this.EstimateFileUploadBoolean = false;
        console.log('Upload Method   ' + this.UploadMethod);
        UploadEstimate({recordId : this.recordId, EstimateType : this.UploadMethod, classNum : this.classValue12, category : this.categoryValue12, ESJobType : this.ESJobType})
        
        .then(result => {
            this.ExtraData = result;
            if(this.ExtraData === 'true'){
                const event = new ShowToastEvent({
                    title:'Success',
                    message: 'Saved',
                    variant: 'success',
                });
                this.dispatchEvent(event);
                this.dispatchEvent(new CustomEvent('recordChange'));
                this.msg = true;
                this.wait=false;
                this.ExtraData = 'Successful, You May Now Close The Popup Window';

                
            }
            else{
                this.wait=false;
                this.msg = true;
                this.startNotEmgSvsPGEmpty = false;
                this.startPGNotEmpty = false;
               // this.ExtraData = 'Error, Please Contact Your Administrator';
            }
        })
        this.startPGNotEmpty = false;
    }
   
    NotWaterLoss(){
        this.noProjectGuid = false;
       this.startNotEmgSvsPGEmpty = false;
       this.wait = true;
    //    if(this.ProjectGuid === null){
    //        this.UploadMethod = 'Main'; 
    //    }
       SendToMica({recordId : this.recordId, classNum : this.classValue12, category: this.categoryValue12, ESJobType : this.ESJobType})
        .then(result => {
            this.ExtraData = result;
            if(this.ExtraData === 'true'){
                const event = new ShowToastEvent({
                    title:'Success',
                    message: 'Saved',
                    variant: 'success',
                });
                this.dispatchEvent(event);
                this.dispatchEvent(new CustomEvent('recordChange'));
                this.wait = false;
                this.msg = true;
                this.ExtraData = 'Successful, You May Now Close The Popup Window';
                this.Water = false;
                this.startNotEmgSvsPGEmpty = false;
                this.startPGNotEmpty = false;
            }
            else{
                this.wait = false;
                this.msg = true;
                this.startNotEmgSvsPGEmpty = false;
                this.startPGNotEmpty = false;
                //this.ExtraData = 'Error, Please Contact Your Administrator';
            }
        
        })
        .catch(error => {
            this.error = error;
        });
    }
    
    // WaterLossUpload(){
    //    this.Water = false;
    //    this.wait = true;
    // //    if(this.ProjectGuid === null){
    // //     this.UploadMethod = 'Main'; 
    // // }
    // console.log('WaterLoss Method Upload ' + this.UploadMethod);
    //     SendToMicaWithWater({recordId : this.recordId, waterLoss : true, EstimateType: this.UploadMethod, classNum : this.classValue12, categoryNum : this.categoryValue12}) 
    //     .then(result => {
    //         this.ExtraData = result;
    //         if(this.ExtraData === 'true'){
    //             const event = new ShowToastEvent({
    //                 title:'Success',
    //                 message: 'Saved',
    //                 variant: 'success',
    //             });
    //             this.dispatchEvent(event);
    //             this.dispatchEvent(new CustomEvent('recordChange'));
    //             this.wait = false;
    //             this.msg = true;
    //             this.ExtraData = 'Successful, You May Now Close The Popup Window';
    //             this.Water = false;
    //             this.startEmgSvsPGEmpty = false;
    //             this.startNotEmgSvsPGEmpty = false;
    //             this.startPGNotEmpty = false;
    //         }
    //         else{
    //             this.wait= false;
    //             this.msg = true;
    //             this.startNotEmgSvsPGEmpty = false;
    //             this.startPGNotEmpty = false;
    //             //this.ExtraData = 'Error, Please Contact Your Administrator';
                
    //         }
        
    //     })
    //     .catch(error => {
    //         this.error = error;
    //     });
    
    // }

    navigateToRecord() {
        this.dispatchEvent(new CustomEvent('recordChange'));
    }  
WaterNoc(){
    this.data2 = false;
    this.data = false;
}
    
}

    
/*    
    handleUploadFinished1(){
    this.EmgSvs = true;
    this.data = false;
    SendToMica({recordId : this.recordId, waterloss : this.Water}) 
    
    .then(result => {
        this.ExtraData = result;
      
    })
    .catch(error => {
        this.error = error;
    });

}*/

    

    
    // connectedCallback(){
    //     MICASync({recordId : this.recordId}) 
    //     .then(result => {
    //         this.data = result;
    //         a = result;
    //   /*  if(a === '1'){this.startEmgSvsPGEmpty = true}
    //     if(a === '2'){this.startEmgSvsPGEmpty = true}
    //     if(a === '3'){this.startEmgSvsPGEmpty = true}*/
    //     })
    //     .catch(error => {
    //         this.error = error;
    //     });
    // //     StartWithMain({recordId : this.recordId}) 
       
        
    // //     .then(result => {
    // //         this.StartData = result;
    // //         if(this.StartData === '3'){
    // //             this.start = true;
    // //         }
    // //         if(this.StartData === '1'){this.startEmgSvsPGEmpty = true}
    // //         if(this.StartData === '2'){this.startNotEmgSvsPGEmpty = true}
    // //   /*  if(a === '1'){this.startEmgSvsPGEmpty = true}
    // //     if(a === '2'){this.startEmgSvsPGEmpty = true}
    // //     if(a === '3'){this.startEmgSvsPGEmpty = true}*/
    // //     })
    // //     .catch(error => {
    // //         this.error = error;
    // //     });
    //   /*  QueryRecordType({recordId : this.recordId}) 
        
    //     .then(result => {
    //         this.recordTypeId = result;
    //     })
    //     .catch(error => {
    //         this.error = error;
    //     });*/

    // }