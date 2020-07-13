/* eslint-disable vars-on-top */
/* eslint-disable no-console */
/* eslint-disable no-alert */
/**
 * @File Name          : newJobLWC.js
 * @Description        :
 * @Author             : Sean Gray
 * @Group              :
 * @Last Modified By   : Sean Gray
 * @Last Modified On   : 2/4/2020, 8:12:03 PM
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    1/23/2020   Sean Gray     Initial Version
 **/
import { LightningElement, track, wire, api } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import StrUserId from "@salesforce/user/Id";

//import SearchAccountRoles from '@salesforce/apex/NewJobController.GetAccountRoles';
import GetUserName from "@salesforce/apex/NewJobController.GetUserName";
import InsertContact from "@salesforce/apex/NewJobController.InsertContact";
import InsertAccount from "@salesforce/apex/NewJobController.InsertAccount";
import InsertPersonAccount from "@salesforce/apex/NewJobController.InsertPersonAccount";
import SearchProperties from "@salesforce/apex/NewJobController.GetProperties";
import GetPropertyInfo from "@salesforce/apex/NewJobController.GetPropertyInfo";
import GetUsers from "@salesforce/apex/NewJobController.GetUsers";
import GetMajorEvents from "@salesforce/apex/NewJobController.GetMajorEvents";
import GetPropertyTypePicklist from "@salesforce/apex/NewJobController.GetPropertyTypePicklist";
import GetAccountRolesPicklist from "@salesforce/apex/NewJobController.getPickListValuesIntoList";
import GetDivisionPicklist from "@salesforce/apex/NewJobController.GetDivisionPicklist";
import GetJobClassPicklist from "@salesforce/apex/NewJobController.GetJobClassPicklist";
import GetEsJobTypePicklist from "@salesforce/apex/NewJobController.GetEsJobTypePicklist";
import GetLeadSourcePicklist from "@salesforce/apex/NewJobController.GetLeadSourcePicklist";
import GetMultipleDivisionPicklist from "@salesforce/apex/NewJobController.GetLeadSourcePicklist";
import SearchCustomers from "@salesforce/apex/NewJobController.GetCustomers";
import SearchContactAccounts from "@salesforce/apex/NewJobController.GetContactAccounts";
import SearchOffices from "@salesforce/apex/NewJobController.GetOffices";
import GetMasterJobs from "@salesforce/apex/NewJobController.GetMasterJobs";
import GetJobInfo from "@salesforce/apex/NewJobController.GetJobInfo";
import checkId from "@salesforce/apex/NewJobController.CheckId";
import CreateNewJob from "@salesforce/apex/NewJobController.CreateNewJob";
import { NavigationMixin } from "lightning/navigation";
import { getPicklistValues } from "lightning/uiObjectInfoApi";
import { getObjectInfo } from "lightning/uiObjectInfoApi";

import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import ATIJOB_OBJECT from "@salesforce/schema/ATI_Job__c";
import MASTERJOB_OBJECT from "@salesforce/schema/Master_Job__c";
import ACCOUNT_OBJECT from "@salesforce/schema/Account";
import CONTACT_OBJECT from "@salesforce/schema/Contact";
import PROPERTY_OBJECT from "@salesforce/schema/Property__c";
import ACCOUNTROLES_OBJECT from "@salesforce/schema/Account_Roles__c";
import ROLE_FIELD from "@salesforce/schema/Account_Roles__c.Roles__c";
import MULTIPLEDIVISION_FIELD from "@salesforce/schema/Master_Job__c.Multiple_Divisions__c";
import DIVISION_FIELD from "@salesforce/schema/ATI_Job__c.Division__c";
import JOBCLASS_FIELD from "@salesforce/schema/ATI_Job__c.Job_Class__c";
import ESTIMATETYPE_FIELD from "@salesforce/schema/ATI_Job__c.Estimate_Type__c";
import PROPERTYTYPE_FIELD from "@salesforce/schema/Property__c.Property_Type__c";
import MARKETCLASS_FIELD from "@salesforce/schema/ATI_Job__c.Market_Class__c";
import MARKETSEGMENT_FIELD from "@salesforce/schema/ATI_Job__c.Market_Segment__c";
import MARKETSEGMENTSUBCLASS_FIELD from "@salesforce/schema/ATI_Job__c.Market_Segment_Sub_Class__c";
import CONTACTTYPE_FIELD from "@salesforce/schema/Contact.Contact_Type__c";
import TYPE_FIELD from "@salesforce/schema/Account.Type";

var ContactJSON;
var AccountJSON;
var PropertyJSON;
var JobJSON;
var AccountRolesPassed = false;
const DELAY = 100;
export default class NewJobLWC extends NavigationMixin(LightningElement) {
  activeSections = [
    "Customer Search",
    "Additional Information",
    "Account Roles",
    "Property Information"
  ];
  @track MarketsDisabled = false;
  PersonAccount = false;
  jobLoading = false;
  testingProperty;
  ARContacts;
  Properties;
  Offices;
  OfficeId;
  @track OfficeValue;
  ContactAccountRole;
  Customers;
  CustomerValue;
  CustomerPicked = false;
  CustomerId;
  CustomerSelectedField;
  ContactAccounts;
  ContactAccountValue;
  ContactAccountPicked = false;
  ContactAccountSelected = false;
  ContactAccountId;
  ContactAccountBlank = false;
  ContactAccountName;
  searchKey;
  JobRealName;
  NewCaller = false;
  NewAccount = false;
  NewProperty = false;
  PropertyID = "";
  PropertyPicked = false;
  AccountRolesSelected = false;
  AccountRolesRecieved = "";
  inputDisabled = true;
  PropertySelected = false;
  PropertySelectedField;
  PropertyValue;
  bShowModal = false;
  MasterJobDetails;
  MasterJobId;
  ContactId;
  ContactType;
  FirstName;
  LastName;
  MailingStreet;
  MailingCity;
  MailingState;
  MailingCounty;
  AccountId = "";
  MailingPostalCode;
  Phone;
  Email;
  PersonEmail;
  PhoneExt;
  AccountName;
  BillingStreet;
  BillingCity;
  BillingState;
  BillingPostalCode;
  Policy;
  AlternateName;
  Type;
  BillingCountry;
  AccountPhone;
  AccountPhoneExt;
  City;
  Country;
  State;
  AddressLine1;
  PropertyType = "";
  Zip;
  @track PropertyChecked = false;
  Description =
    "Type of Loss:" +
    "\n" +
    "Cause of Loss:" +
    "\n" +
    "Customer Type:" +
    "\n" +
    "Property Description:" +
    "\n" +
    "Areas Affected:" +
    "\n" +
    "Damaged Materials:" +
    "\n" +
    "Flooring Type:" +
    "\n" +
    "Is power shut-off in the building? (Y/N)" +
    "\n" +
    "Is there a gate code?" +
    "\n" +
    "Is there standing water? (Y/N)" +
    "\n" +
    "Is the standing water clean, gray or black water?(Clean,Gray,Black)" +
    "\n" +
    "Have you called a plumber?(Y/N)" +
    "\n" +
    "Has the water been shut off? (Y/N)" +
    "\n" +
    "Has the leak been fixed? (Y/N)" +
    "\n" +
    "What type of fire damage is there? (Smoke, soot, ashes)" +
    "\n" +
    "Were emergency responders on the scene? (Police, Fire)" +
    "\n" +
    "Have emergency responders given clearance to access the building?" +
    "\n" +
    "Are we dealing with blood or body fluids?" +
    "\n" +
    "How long was the body on site?" +
    "\n" +
    "Is there an odor we need to address?" +
    "\n" +
    "Are we packing the belongings for the next of kin?";
  Division;
  Office;
  JobClass;
  EstimateType;
  Claim = "";
  Deductible = "";
  AccountRoleLineItems = [{}];
  loading = false;
  data;
  ContactSelected = false;
  AccountRole;
  ContactRole;
  CustomerAccountId;
  CustomerAccountName;
  AccountRolePicklistValuesContainer;
  DivisionPicklistValues = [{}];
  JobClassPicklistValues = [{}];
  EsJobTypePicklistValues = [{}];
  LeadSourcePicklistValues = [{}];
  MultipleDivisionPicklistValues = [{}];
  PropertyTypeValuesContainer = [{}];
  ARReady = false;
  AccountRoles = [{}];
  CreateContact = false;
  AccountEmpty = true;
  CreateNewContact = false;
  PersonAccountModal = false;
  AccountQuestion = false;
  AccountLastName;
  AccountFirstName;
  newAccountRoles = false;
  loadingContact = false;
  loadingPersonAccount = false;
  MultipleRoles;
  MultRoleInd;
  CompanyAccountRoles = "";
  PersonAccountRoles = "";
  TypeOfInsert = "";
  JobName;
  Division;
  ARDivision = false;
  EsJobType;
  JobClass;
  LeadSource;
  DivisionEs = false;
  MultipleDivision;
  NotNewProperty = true;
  AutoComplete = false;
  ProjectDirectorValue = "";
  ProjectDirectors;
  ProjectDirectorId;
  TakenByUsers;
  TakenByValue;
  TakenById;
  billToCount = 0;
  AddressLine2;
  projectSiteContactCount = 0;
  ProjectDirectorSelected = false;
  OfficeSelected = false;
  DateOfLoss;
  ClientJob;
  YearBuilt;
  PolicyDisabled = false;
  MajorEventDisabled = false;
  ARRoleBlank = false;
  ClientJobDisabled = false;
  ClaimDisabled = false;
  LeadSourceDisabled = false;
  DateOfLossDisabled = false;
  DescriptionDisabled = false;
  OfficeDisabled = false;
  NewAccountCreated = false;
  callerCount = 0;
  caller = false;
  newDescription = false;
  fireLoss = false;
  waterLoss = false;
  bioLoss = false;
  //@track MarketClassValues =[{}]; @track MarketSegmentValues = [{}]; @track MarketSegmentSubClassValues = [{}];
  UserId = StrUserId;
  name;
  TypeOfLoss = "";
  CauseOfLoss = "";
  CustomerType = "";
  PropertyDescription = "";
  AreasAffected = "";
  DamagedMaterials = "";
  FlooringType = "";
  PowerShutOff = "";
  GateCode = "";
  StandingWater = "";
  CleanWater = "";
  Plumber = "";
  WaterShutOff = "";
  LeakFixed = "";
  FireDamage = "";
  EmergencyResponders = "";
  Clearance = "";
  BloodOrFluids = "";
  Body = "";
  Odor = "";
  Belongings = "";
  @track ExistingMasterJob = false;
  @api jobrecordId;
  @api TypeOfJobEntry;
  @track PropertyIsNotSelected = true;	
  @track PropertyPrompt = false;	
  @track PropertyTempId;	
  @track JobTemp;
  @track Policy;
  @track MarketSegmentOptions;
  @track MarketClassValues;
  @track MarketClass;
  @track MarketSegment;
  @track MarketSegmentValues;
  @track MarketSegmentSubClass;
  @track MarketSegmentSubClassValues;
  @track MarketSegmentSubClassOptions;
  @track NonResidential = false;
  @track AccountRoles = [{}];
  @track MajorEvents;
  @track MajorEventValue;
  @track MajorEventId;
  @track MajorEventSelected = false;
  @track Coronavirus = "";
  @track SameDayDispatch = "";
  @track focusClicked = false;

  // @wire(getRecord, {
  //     recordId: UserId,
  //     fields: [NAME_FIELD]
  // }) wireuser({
  //     error,
  //     data
  // }) {
  //     if (error) {
  //        this.error = error ;
  //     } else if (data) {

  //         this.name = data.fields.Name.value;
  //         this.TakenByValue = this.name;
  //     }
  // }
  @wire(getObjectInfo, { objectApiName: ACCOUNTROLES_OBJECT })
  objectInfo;
  @wire(getObjectInfo, { objectApiName: ACCOUNT_OBJECT })
  accountInfo;
  @wire(getObjectInfo, { objectApiName: CONTACT_OBJECT })
  contactInfo;
  @wire(getObjectInfo, { objectApiName: PROPERTY_OBJECT })
  propertyInfo;
  @wire(getObjectInfo, { objectApiName: MASTERJOB_OBJECT })
  masterjobInfo;
  @wire(getObjectInfo, { objectApiName: ATIJOB_OBJECT })
  atijobInfo;
  @wire(getPicklistValues, {
    recordTypeId: "$objectInfo.data.defaultRecordTypeId",
    fieldApiName: ROLE_FIELD
  })
  AccountRolesValues({ data }) {
    if (data) {
      this.AccountRolePicklistValuesContainer = data.values;
      console.log(this.AccountRolePicklistValuesContainer);
    }
  }
  // @wire(getPicklistValues, {
  //   recordTypeId: "$objectInfo.data.defaultRecordTypeId",
  //   fieldApiName: ROLE_FIELD
  // })
  // AccountRoleValues;
  @wire(getPicklistValues, {
    recordTypeId: "0120g000000l3yMAAQ",
    fieldApiName: DIVISION_FIELD
  })
  AtiJobDivisionValues;
  @wire(getPicklistValues, {
    recordTypeId: "0120g000000l3yMAAQ",
    fieldApiName: JOBCLASS_FIELD
  })
  AtiJobJobClassValues;
  @wire(getPicklistValues, {
    recordTypeId: "0120g000000l3yM",
    fieldApiName: ESTIMATETYPE_FIELD
  })
  AtiJobEstimateTypeValues;
  @wire(getPicklistValues, {
    recordTypeId: "$accountInfo.data.defaultRecordTypeId",
    fieldApiName: TYPE_FIELD
  })
  AccountTypeValues;
  @wire(getPicklistValues, {
    recordTypeId: "$contactInfo.data.defaultRecordTypeId",
    fieldApiName: CONTACTTYPE_FIELD
  })
  ContactTypeValues;
  @wire(getPicklistValues, {
    recordTypeId: "$propertyInfo.data.defaultRecordTypeId",
    fieldApiName: PROPERTYTYPE_FIELD
  })
  PropertyTypeValues;
  @wire(getPicklistValues, {
    recordTypeId: "$masterjobInfo.data.defaultRecordTypeId",
    fieldApiName: MULTIPLEDIVISION_FIELD
  })
  MultipleDivisionPicklistValues;
  // @wire(getPicklistValues, { recordTypeId: '$propertyInfo.data.defaultRecordTypeId', fieldApiName: MARKETCLASS_FIELD})
  // MarketClassValues;
  // @wire(getPicklistValues, { recordTypeId: '$propertyInfo.data.defaultRecordTypeId', fieldApiName: MARKETSEGMENT_FIELD})
  // MarketSegmentValues;
  // @wire(getPicklistValues, { recordTypeId: '$propertyInfo.data.defaultRecordTypeId', fieldApiName: MARKETSEGMENTSUBCLASS_FIELD})
  // MarketSegmentSubClassValues;

  // get options() {
  //     return [{
  //         AccountRolesValues.data.values}];
  // }
  @wire(getPicklistValues, {
    recordTypeId: "0120g000000l3yMAAQ",
    fieldApiName: MARKETCLASS_FIELD
  })
  setPicklistOptions1({ data }) {
    if (data) {
      this.MarketClassValues = data.values;
      console.log(this.MarketClassValues);
    }
  }
  @wire(getPicklistValues, {
    recordTypeId: "0120g000000l3yMAAQ",
    fieldApiName: MARKETSEGMENT_FIELD
  })
  setPicklistOptions2({ data }) {
    if (data) {
      this.MarketSegmentValues = data.values;
      console.log(this.MarketSegmentValues);
    }
  }
  @wire(getPicklistValues, {
    recordTypeId: "0120g000000l3yMAAQ",
    fieldApiName: MARKETSEGMENTSUBCLASS_FIELD
  })
  setPicklistOptions3({ data }) {
    if (data) {
      this.MarketSegmentSubClassValues = data.values;
      console.log(this.MarketSegmentSubClassValues);
    }
  }
  // get MarketClass() {

  //     return [{label:"Residential", value:"Residential"}, {label:"Non-Residential", value:"Non-Residential"}];
  // }
  // get MarketSegment() {

  //     return [{label:"", value:""}, {label:"", value:""}];
  // }
  // get MarketSegmentResidential() {

  //     return [{label:"", value:""}, {label:"", value:""}];
  // }
  // get MarketSegmentSubClass() {

  //     return [{label:"", value:""}, {label:"", value:""}];
  // }

  connectedCallback() {
    console.log(
      "Testing api.. Test is :  " +
        this.TypeOfJobEntry +
        " record id is " +
        this.jobrecordId
    );
    if(this.TypeOfJobEntry === "NewJobEntry"){
      this.PropertyChecked = true;
    }
    if (this.TypeOfJobEntry === "AfterHoursJobEntry") {
      GetJobInfo({ recordId: this.jobrecordId }).then((result) => {
        let jobresults = result;
        this.JobTemp = result;
        this.MasterJobId = jobresults.Master_Job__c;
        console.log('MasterJob Id from ConnectedCallback is ' + this.MasterJobId);
        GetPropertyInfo({
          City: jobresults.Project_Site_City__c,
          Address: jobresults.Project_Site_Address__c,
          State: jobresults.Project_Site_State__c,
          Zipcode: jobresults.Project_Site_Zipcode__c
        }).then((result) => {
          let Prop = result;
          this.PropertyChecked = true;
          console.log("Prop is " + JSON.stringify(Prop));
          if (Prop.County__c === "Same Property") {
            this.PropertyPrompt = true;
            this.PropertyTempId = Prop;
          } else {
            this.NewProperty = true;
          }
        });
        console.log(
          "Job results are " +
            jobresults +
            "   jobresults city " +
            jobresults.Project_Site_City__c
        );
        if (
          jobresults.Project_Manager__c !== undefined &&
          jobresults.Project_Manager__c !== null &&
          jobresults.Project_Manager__c !== ""
        ) {
          console.log(
            "Project Director is " + jobresults.Project_Manager__r.Name
          );

          this.ProjectDirectorId = jobresults.Project_Manager__c;
          this.ProjectDirectorValue = jobresults.Project_Manager__r.Name;
        }
        if (
          jobresults.Taken_By__c !== undefined &&
          jobresults.Taken_By__c !== null &&
          jobresults.Taken_By__c !== ""
        ) {
          
          this.TakenByValue = jobresults.Taken_By__r.Name;
          this.TakenById = jobresults.Taken_By__c;
        }
        if (
          jobresults.Major_Event__c !== undefined &&
          jobresults.Major_Event__c !== null &&
          jobresults.Major_Event__c !== ""
        ) {
          console.log("Major Event is " + jobresults.Major_Event__c);
          console.log("Major Event is " + jobresults.Major_Event__r.Name);
          this.MajorEventValue = jobresults.Major_Event__r.Name;
          this.MajorEventId = jobresults.Major_Event__c;
        }
        this.JobRealName = jobresults.Name;
        this.Description = jobresults.Description__c;
        this.OfficeId = jobresults.Office2__c;
        this.OfficeValue = jobresults.Office2__r.Name;
        this.Street = jobresults.Project_Site_Address__c;
        this.City = jobresults.Project_Site_City__c;
        this.State = jobresults.Project_Site_State__c;
        this.Zip = jobresults.Project_Site_Zipcode__c;
        this.AddressLine2 = jobresults.Project_Site_Address_2__c;
        // this.PropertyValue = jobresults.Project_Site_Address__c;
        this.DateOfLoss = jobresults.Date_of_Loss__c;
        this.JobName = jobresults.Job_Name__c;
        this.Division = jobresults.Division__c;
        
        this.Afterhoursform = true;

        this.ContactInfoAndDescription =
          jobresults.Contact_Info__c + "\n" + "\n" + jobresults.Description__c;
        console.log(jobresults.Contact_Info__c);
        console.log(this.ContactInfoAndDescription);
      });
    }
    if(this.TypeOfJobEntry === 'NewJobEntry'){
    GetUserName({}).then((result) => {
      this.TakenByValue = result;
      this.TakenById = this.UserId;
    });
  }
    // GetAccountRolesPicklist({}).then((result) => {
    //   var AccountRolePicklistValues = result;
    //   for (var i = 0; i < AccountRolePicklistValues.length; i++) {
    //     this.AccountRolePicklistValuesContainer.push({
    //       label: AccountRolePicklistValues[i],
    //       value: AccountRolePicklistValues[i]
    //     });
    //   }
    //   this.AccountRolePicklistValuesContainer.shift();
      this.ARReady = true;
      this.AccountRoles.push({
        Contact_ID__c: "",
        Account_ID__c: "",
        Multiple_Roles__c: ""
      });
      this.AccountRoles.shift();
   // });
    GetPropertyTypePicklist({}).then((result) => {
      var PropertyTypePicklist = result;
      for (var i = 0; i < PropertyTypePicklist.length; i++) {
        this.PropertyTypeValuesContainer.push({
          label: PropertyTypePicklist[i],
          value: PropertyTypePicklist[i]
        });
      }
    //   this.PropertyTypeValuesContainer.shift();
    //   if (this.TypeOfJobEntry === "AfterHoursJobEntry") {
    //     this.NewProperty = true;
    //   }
    });
    GetDivisionPicklist({}).then((result) => {
      var AccountRolePicklistValues = result;
      for (var i = 0; i < AccountRolePicklistValues.length; i++) {
        this.DivisionPicklistValues.push({
          label: AccountRolePicklistValues[i],
          value: AccountRolePicklistValues[i]
        });
      }

      this.DivisionPicklistValues.shift();
      this.ARDivision = true;
    });
    GetJobClassPicklist({}).then((result) => {
      var AccountRolePicklistValues = result;
      for (var i = 0; i < AccountRolePicklistValues.length; i++) {
        this.JobClassPicklistValues.push({
          label: AccountRolePicklistValues[i],
          value: AccountRolePicklistValues[i]
        });
      }

      this.JobClassPicklistValues.shift();
    });
    GetEsJobTypePicklist({}).then((result) => {
      var AccountRolePicklistValues = result;
      for (var i = 0; i < AccountRolePicklistValues.length; i++) {
        this.EsJobTypePicklistValues.push({
          label: AccountRolePicklistValues[i],
          value: AccountRolePicklistValues[i]
        });
      }

      this.EsJobTypePicklistValues.shift();
    });
    GetLeadSourcePicklist({}).then((result) => {
      var AccountRolePicklistValues = result;
      for (var i = 0; i < AccountRolePicklistValues.length; i++) {
        this.LeadSourcePicklistValues.push({
          label: AccountRolePicklistValues[i],
          value: AccountRolePicklistValues[i]
        });
      }

      this.LeadSourcePicklistValues.shift();
    });

    // GetMultipleDivisionPicklist({}).then(result =>{
    //     var AccountRolePicklistValues = result;
    //     for(var i = 0; i<AccountRolePicklistValues.length;i++){
    //         console.log('Lenght is '+ AccountRolePicklistValues.length + '    values are ' + AccountRolePicklistValues[i] );
    //         this.MultipleDivisionPicklistValues.push({label : AccountRolePicklistValues[i], value : AccountRolePicklistValues[i], });
    //     }

    //     this.MultipleDivisionPicklistValues.shift();
    // })
  }
  get options() {
    return this.DivisionPicklistValues;
  }
  get optionsYesNo() {
    return [
      { label: "Yes", value: "Yes" },
      { label: "No", value: "No" }
    ];
  }
  get grayBlackWater() {
    return [
      { label: "Clean", value: "Clean" },
      { label: "Gray", value: "Gray" },
      { label: "Black", value: "Black" }
    ];
  }
  
  MarketClassChange(event) {
    try {
      this.MarketClass = event.detail.value;
      let key;
      if (this.MarketClass === "Non-Residential") this.NonResidential = true;
      if (this.MarketClass === "Residential") {
        this.NonResidential = false;
        this.MarketSegmentSubClass = "";
      }
      switch (this.MarketClass) {
        case "Residential":
          key = 0;
          console.log("Res " + key);
          break;

        case "Non-Residential":
          key = 1;
          console.log("NonRes " + key);
          break;
      }
      this.MarketSegmentOptions = this.MarketSegmentValues.filter((opt) =>
        opt.validFor.includes(key)
      );
    } catch (err) {
      console.error("Error is " + err);
    }
  }
  MarketSegmentChange(event) {
    try {
      this.MarketSegment = event.detail.value;
      let key;
      if (this.NonResidential) {
        switch (this.MarketSegment) {
          case "Education":
            key = 3;
            console.log(key);
            break;

          case "Federal Government":
            key = 4;
            console.log(key);
            break;
          case "Healthcare":
            key = 5;
            console.log(key);
            break;
          case "Hospitality":
            key = 6;
            console.log(key);
            break;
          case "Industrial & Commercial":
            key = 7;
            console.log(key);
            break;
          case "Multi Family":
            key = 8;
            console.log(key);
            break;
          case "Retail":
            key = 9;
            console.log(key);
            break;
          case "State/Municipal":
            key = 10;
            console.log(key);
            break;
        }
        this.MarketSegmentSubClassOptions = this.MarketSegmentSubClassValues.filter(
          (opt) => opt.validFor.includes(key)
        );
      }
    } catch (err) {
      console.error("Error is " + err);
    }
  }
  MarketSegmentSubClassChange(event) {
    this.MarketSegmentSubClass = event.detail.value;
  }
  AlternateNameChange(e){
    this.AlternateName = e.detail.value;
}
  PolicyChange(e) {
    this.Policy = e.detail.value;
  }
  TypeOfLossChange(e) {
    this.TypeOfLoss = e.detail.value;
  }
  CauseOfLossChange(e) {
    this.CauseOfLoss = e.detail.value;
  }
  CustomerTypeChange(e) {
    this.CustomerType = e.detail.value;
  }
  PropertyDescriptionChange(e) {
    this.PropertyDescription = e.detail.value;
  }
  AreasAffectedChange(e) {
    this.AreasAffected = e.detail.value;
  }
  DamagedMaterialsChange(e) {
    this.DamagedMaterials = e.detail.value;
  }
  FlooringTypeChange(e) {
    this.FlooringType = e.detail.value;
  }
  PowerShutOffChange(e) {
    this.PowerShutOff = e.detail.value;
  }
  GateCodeChange(e) {
    this.GateCode = e.detail.value;
  }
  CoronavirusChange(e) {
    this.Coronavirus = e.detail.value;
  }
  SameDayDispatchChange(e) {
    this.SameDayDispatch = e.detail.value;
  }
  StandingWaterChange(e) {
    this.StandingWater = e.detail.value;
  }
  CleanWaterChange(e) {
    this.CleanWater = e.detail.value;
  }
  PlumberChange(e) {
    this.Plumber = e.detail.value;
  }
  WaterShutOffChange(e) {
    this.WaterShutOff = e.detail.value;
  }
  LeakFixedChange(e) {
    this.LeakFixed = e.detail.value;
  }
  FireDamageChange(e) {
    this.FireDamage = e.detail.value;
  }
  EmergencyRespondersChange(e) {
    this.EmergencyResponders = e.detail.value;
  }
  ClearanceChange(e) {
    this.Clearance = e.detail.value;
  }
  BloodOrFluidsChange(e) {
    this.BloodOrFluids = e.detail.value;
  }
  BodyChange(e) {
    this.Body = e.detail.value;
  }
  OdorChange(e) {
    this.Odor = e.detail.value;
  }
  BelongingsChange(e) {
    this.Belongings = e.detail.value;
  }

  newDescriptionClick() {
    this.newDescription = true;
  }
  focusText() {
    if ((this.focusClicked = false)) {
      this.focusClicked = true;
      this.newDescription = true;
    }
  }
  SaveDescription() {
    this.Description =
      "Type of Loss: " +
      this.TypeOfLoss +
      "\n" +
      "Cause of Loss: " +
      this.CauseOfLoss +
      "\n" +
      "Customer Type: " +
      this.CustomerType +
      "\n" +
      "Property Description: " +
      this.PropertyDescription +
      "\n" +
      "Areas Affected: " +
      this.AreasAffected +
      "\n" +
      "Damaged Materials: " +
      this.DamagedMaterials +
      "\n" +
      "Flooring Type: " +
      this.FlooringType +
      "\n" +
      "Is power shut-off in the building? (Y/N) " +
      this.PowerShutOff +
      "\n" +
      "Is there a gate code? " +
      this.GateCode +
      "\n" +
      "Is this related to the Coronavirus?" +
      this.Coronavirus +
      "\n" +
      "Are you requiring same-day dispatch?" +
      this.SameDayDispatch;
    this.newDescription = false;
    console.log(this.Division);
    console.log(
      "waterLoss " + this.waterLoss + "       fireLoss " + this.fireLoss
    );
    if (this.Division === "Emergency Svces") {
      console.log("Emg called");
      if (this.waterLoss === true) {
        console.log("waterLoss called " + this.waterLoss);
        this.Description =
          this.Description +
          "\n" +
          "Is there standing water? (Y/N) " +
          this.StandingWater +
          "\n" +
          "Is the standing water clean, gray or black water?(Clean,Gray,Black) " +
          this.CleanWater +
          "\n" +
          "Have you called a plumber?(Y/N) " +
          this.Plumber +
          "\n" +
          "Has the water been shut off? (Y/N) " +
          this.WaterShutOff +
          "\n" +
          "Has the leak been fixed? (Y/N) ";
      }
      if (this.fireLoss === true) {
        this.Description =
          this.Description +
          "\n" +
          "What type of fire damage is there? (Smoke, soot, ashes) " +
          this.FireDamage +
          "\n" +
          "Were emergency responders on the scene? (Police, Fire) " +
          this.EmergencyResponders +
          "\n" +
          "Have emergency responders given clearance to access the building? " +
          this.Clearance;
      }
      if (this.bioLoss === true) {
        this.Description =
          this.Description +
          "\n" +
          "Are we dealing with blood or body fluids? " +
          this.BloodOrFluids +
          "\n" +
          "How long was the body on site? " +
          this.Body +
          "\n" +
          "Is there an odor we need to address? " +
          this.Odor +
          "\n" +
          "Are we packing the belongings for the next of kin? " +
          this.Belongings;
      }
    }
  }
  closeDescriptionModal() {
    this.newDescription = false;
  }
  closePropertyPromptModal() {
    this.PropertyPrompt = false;
  }
  PropertyPromptSelected() {
    this.PropertyID = this.PropertyTempId.Id;
    this.Address = this.JobTemp.Address_Line_1__c;
    this.City = this.JobTemp.Project_Site_City__c;
    this.State = this.JobTemp.Project_Site_State__c;
    this.Zip = this.JobTemp.Project_Site_Zipcode__c;
    this.JobClass = this.PropertyTempId.Job_Class__c;
     this.YearBuilt = this.PropertyTempId.Year_Structure_Built__c;
    //  console.log('Market Class is ' + this.PropertyTempId.Market_Segment__c);
    //  if(this.PropertyTempId.Market_Class__c !== "" && this.PropertyTempId.Market_Class__c !== undefined && this.PropertyTempId.Market_Class__c !== null){
    //   this.MarketClass = this.PropertyTempId.Market_Class__c;
    //   this.MarketSegment = this.PropertyTempId.Market_Segment__c;
    //   this.MarketSegmentSubClass = this.PropertyTempId.Market_Segment_Sub_Class__c;
    //   this.MarketsDisabled = true;
    //  }
      
    this.PropertyPrompt = false;
    this.NotNewProperty = false;
    checkId({ propId: this.PropertyID }).then((result) => {
      let data = result;
      // if(data != undefined && data != null && data.length != null){
      if (JSON.stringify(data) !== "[]") {
        this.AccountRoles = result;
      }
      console.log("ARs" + JSON.stringify(this.AccountRoles));
      this.AccountRolesSelected = true;
    });
    GetMasterJobs({ propId: this.PropertyID }).then((result) => {
      this.MasterJobs = result;
      console.log("Master Jobs " + this.MasterJobs);
      if (JSON.stringify(this.MasterJobs) !== "[]") {
        console.log(
          "Master Jobs result " + JSON.stringify(this.MasterJobs)
        );
        this.bShowModal = true;
      }
    });
  }
  closeDescriptionModal() {
    this.newDescription = false;
  }
  searchAgain() {
    this.ProjectDirectorSelected = false;
    this.ProjectDirectorValue = "";
    this.ProjectDirectorId = "";
  }
  searchAgain1() {
    this.ProjectDirectorSelected = false;
    this.ProjectDirectorValue = "";
    this.ProjectDirectorId = "";
  }
  AddressLine2Change(e) {
    this.AddressLine2 = e.detail.value;
  }
  DateOfLossChange(e) {
    this.DateOfLoss = e.detail.value;
  }
  YearBuiltChange(e) {
    this.YearBuilt = e.detail.value;
  }
  ClientJobChange(e) {
    this.ClientJob = e.detail.value;
  }
  ResetPropertyForm() {
    this.NotNewProperty = true;
    this.Street = "";
    this.City = "";
    this.State = "";
    this.Zip = "";
    this.Country = "";
    this.PropertyType = "";
  }
  closeProperty() {
    const input = [
      ...this.template.querySelectorAll(".propertyFormControl")
    ].reduce((validSoFar, inputCmp) => {
      inputCmp.reportValidity();
      return validSoFar && inputCmp.checkValidity();
    }, true);
    if (!input) {
      alert("Fill in all required fields before saving");
    } else {
      const address = this.template.querySelector('[data-id="AddressLookup"]');
      // const isValid = address.checkValidity();
      // if (isValid) {

      if(address.street !== null && address.street !== undefined && address.street !== ""){
        this.Street = address.street;
        this.City = address.city;
        this.State = address.province;
        this.Zip = address.postalCode;
        this.Country = address.country;
        this.NewProperty = false;
        this.NotNewProperty = false;
        const event = new ShowToastEvent({
          title: "Success",
          message: "Saved",
          variant: "success"
        });
        this.dispatchEvent(event);
      }
    }
  }

  AccountPhoneChange(e) {
    this.AccountPhone = e.detail.value;
  }
  AccountPhoneExtChange(e) {
    this.AccountPhoneExt = e.detail.value;
  }
  AccountFirstNameChange(e) {
    this.AccountFirstName = e.detail.value;
  }
  AccountLastNameChange(e) {
    this.AccountLastName = e.detail.value;
  }
  MultipleDivisionChange(e) {
    this.MultipleDivision = e.detail.value;
  }
  JobNameChange(e) {
    this.JobName = e.detail.value;
  }
  closePropertyModal() {
    this.NewProperty = false;
  }
  NewAccountRoleSelected(event) {
    var rowInd = event.target.parentNode.parentNode.parentNode.rowIndex;
    rowInd = rowInd - 1;
    this.MultRoleInd = rowInd;
    this.MultipleRoles = this.AccountRoles[this.MultRoleInd].Multiple_Roles__c;
    this.newAccountRoles = true;
  }
  CloseAccountRole() {
    this.newAccountRoles = false;
    this.MultRoleInd = "";
    this.MultipleRoles = "";
  }

  closeAccountQuestion() {
    this.AccountQuestion = false;
  }
  saveMultipleRoles() {
    this.AccountRoles[this.MultRoleInd].Multiple_Roles__c = this.MultipleRoles;
    this.newAccountRoles = false;
    this.MultRoleInd = "";
    this.MultipleRoles = "";
  }
  AccountMultipleRoles(e) {
    this.MultipleRoles = e.detail.value;
  }
  PersonAccountRolesChange(e) {
    this.PersonAccountRoles = e.detail.value;
  }
  addAccountQuestion() {
    this.AccountQuestion = true;
  }
  PersonAccountClicked() {
    this.AccountQuestion = false;
    this.PersonAccountModal = true;
  }
  BusinessAccountClicked() {
    this.AccountQuestion = false;
    this.addAccount();
  }
  closePersonAccountModal() {
    this.PersonAccountModal = false;
    this.AccountId = "";
    this.AccountName = "";
    this.AccountLastName = "";
    this.AccountFirstName = "";
    this.AccountPhone = "";
    this.Type = "";
    this.AccountPhoneExt = "";
    this.PersonAccountRoles = "";
    this.BillingStreet = "";
    this.BillingCity = "";
    this.BillingState = "";
    this.BillingPostalCode = "";
    this.ContactAccountRole = "";
    this.PersonEmail = "";
  }
  SaveContact() {
    const input = [
      ...this.template.querySelectorAll(".contactFormControl")
    ].reduce((validSoFar, inputCmp) => {
      inputCmp.reportValidity();
      return validSoFar && inputCmp.checkValidity();
    }, true);
    if (!input) {
      alert("Fill in all required fields before saving");
    } else {
      if (
        this.ContactAccountValue === null ||
        this.ContactAccountValue === ""
      ) {
        alert("Select or Create an Account before saving");
      } else {
        if (
          this.CompanyAccountRoles === null ||
          this.CompanyAccountRoles === ""
        ) {
          alert("Select a Role before saving");
        } else {
          // var ACCOUNTJSON = {'AccountId': this.ContactAccountValue};

          // var PackagedString = JSON.stringify(ACCOUNTJSON);

          // var cavalue = JSON.stringify(this.ContactAccountValue);
          // var cavalueid = JSON.parse(cavalue);
          // console.log('Cavalueid ' + cavalueid);

          const address = this.template.querySelector(
            '[data-id="ContactAddressLookup"]'
          );

          this.MailingStreet = address.street;
          this.MailingCity = address.city;
          this.MailingState = address.province;
          this.MailingPostalCode = address.postalCode;
          this.MailingCountry = address.country;
          this.loadingContact = true;

          InsertContact({
            FirstName: this.FirstName,
            LastName: this.LastName,
            Email: this.Email,
            Phone: this.Phone,
            Type: this.ContactType,
            PhoneExt: this.PhoneExt,
            MailingStreet: this.MailingStreet,
            MailingCity: this.MailingCity,
            MailingState: this.MailingState,
            MailingPostalCode: this.MailingPostalCode,
            MailingCountry: this.MailingCountry,
            AccountId: this.ContactAccountValue,
            AccountList: this.NewAccountCreated
          }).then((result) => {
            let Message = result;
            if (Message.length > 18) {
              this.loadingContact = false;
              alert(Message);
            } else {
              this.ContactId = result;
              this.TypeOfInsert = "BusinessAccount";
              this.AccountRoles = this.ReplaceEmptyAccountRoleRows();
              const event = new ShowToastEvent({
                title: "Success",
                message: "Saved",
                variant: "success"
              });
              this.dispatchEvent(event);
              this.loadingContact = false;
              //now Reset the form
              this.Email = "";
              this.ContactId = "";
              this.AccountId = "";
              this.Type = "";
              this.ContactAccountRole = "";
              this.AccountPhoneExt = "";
              this.AccountPhone = "";
              this.AccountName = "";
              this.MailingStreet = "";
              this.MailingCity = "";
              this.MailingState = "";
              this.MailingPostalCode = "";
              this.MailingCountry = "";
              this.FirstName = "";
              this.LastName = "";
              this.Phone = "";
              this.ContactType = "";
              this.PhoneExt = "";
              this.CreateContact = false;
              this.CreateNewContact = false;
              this.ContactAccountValue = "";
              this.ContactAccountName = "";
              this.PersonAccountRoles = "";
              this.CompanyAccountRoles = "";
              this.ContactAccountSelected = false;
              this.NewAccountCreated = false;
            }
            //    this.AccountLastName = null;
            //    this.AccountFirstName = null;
            //    this.AccountPhone = null;
            //    this.Type = null;
            //    this.AccountPhoneExt = null;

            //    this.BillingStreet = null;
            //    this.BillingCity = null;
            //    this.BillingState = null;
            //    this.BillingPostalCode = null;
            //    this.ContactAccountRole = null;
          });
        }
      }
    }
  }

  savePersonAccount() {
    console.log("Starting Person Account ");

    const input = [
      ...this.template.querySelectorAll(".personAccountFormControl")
    ].reduce((validSoFar, inputCmp) => {
      inputCmp.reportValidity();
      console.log("inside the return");
      return validSoFar && inputCmp.checkValidity();
    }, true);
    console.log("Valid input " + input);
    if (!input) {
      alert("Fill in all required fields before saving");
    } else {
      if (this.PersonAccountRoles === null || this.PersonAccountRoles === "") {
        alert("Select a Role before Saving");
      } else {
        console.log("Inside the else statement ");
        const address = this.template.querySelector(
          '[data-id="PersonAccountAddressLookup"]'
        );
        if(address.street !== null && address.street !== undefined && address.street !== ""){
        this.BillingStreet = address.street;
        this.BillingCity = address.city;
        this.BillingState = address.province;
        this.BillingPostalCode = address.postalCode;
        this.BillingCountry = address.country;
        console.log("Inside the else statement 2");
        this.loadingPersonAccount = true;
        InsertPersonAccount({
          FirstName: this.AccountFirstName,
          LastName: this.AccountLastName,
          Phone: this.AccountPhone,
          Email: this.PersonEmail,
          Type: this.Type,
          PhoneExt: this.AccountPhoneExt,
          BillingStreet: this.BillingStreet,
          BillingCity: this.BillingCity,
          BillingState: this.BillingState,
          BillingPostalCode: this.BillingPostalCode,
          BillingCountry: this.BillingCountry
        }).then((result) => {
          this.AccountId = result;

          if (this.AccountId.length > 18) {
            this.loadingPersonAccount = false;
            alert(this.AccountId);
          } else {
            this.PersonAccountModal = false;
            this.loadingPersonAccount = false;
            this.TypeOfInsert = "PersonAccount";
            this.ContactAccountValue = this.AccountId;
            this.AccountRoles = this.ReplaceEmptyAccountRoleRows();
            const event = new ShowToastEvent({
              title: "Success",
              message: "Saved",
              variant: "success"
            });
            this.dispatchEvent(event);
            //now Reset the form
            this.AccountId = "";
            this.ContactAccountValue = "";
            this.AccountName = "";

            this.AccountLastName = "";
            this.AccountFirstName = "";
            this.AccountPhone = "";
            this.Type = "";
            this.AccountPhoneExt = "";
            this.BillingStreet = "";
            this.BillingCity = "";
            this.BillingState = "";
            this.BillingPostalCode = "";
            this.ContactAccountRole = "";
            this.PersonAccountRoles = "";
            this.PersonEmail = "";
          }
        });
      }else{
        alert('Must search for an Address');}
    }
    }
  }

  saveAccount() {
    const input = [
      ...this.template.querySelectorAll(".companyAccountFormControl")
    ].reduce((validSoFar, inputCmp) => {
      inputCmp.reportValidity();
      return validSoFar && inputCmp.checkValidity();
    }, true);
    if (!input) {
      alert("Fill in all required fields before saving");
    } else {
      console.log("Company Account Roles " + this.CompanyAccountRoles);
      if (
        this.CompanyAccountRoles === null ||
        this.CompanyAccountRoles === ""
      ) {
        console.log("Company Account Roles " + this.CompanyAccountRoles);
        alert("Select a Role before saving");
      } else {
        console.log("Everything Passed ");
        const address = this.template.querySelector(
          '[data-id="AccountAddressLookup"]'
        );
        if(address.street !== null && address.street !== undefined && address.street !== ""){
        this.BillingStreet = address.street;
        this.BillingCity = address.city;
        this.BillingState = address.province;
        this.BillingPostalCode = address.postalCode;
        this.BillingCountry = address.country;
        this.loading = true;

        InsertAccount({
          Name: this.AccountName,
          Phone: this.AccountPhone,
          Type: this.Type,
          PhoneExt: this.AccountPhoneExt,
          BillingStreet: this.BillingStreet,
          BillingCity: this.BillingCity,
          BillingState: this.BillingState,
          BillingPostalCode: this.BillingPostalCode,
          BillingCountry: this.BillingCountry
        }).then((result) => {
          let Account = result;
          this.AccountId = Account.Id;
          if (Account.Name.length > 18) {
            this.loading = false;
            alert(Account.Name);
          } else {
            const event = new ShowToastEvent({
              title: "Success",
              message: "Saved",
              variant: "success"
            });
            this.dispatchEvent(event);
            if (this.CreateNewContact) {
              this.loading = false;
              // this.ContactAccountValue = this.AccountId;
              this.NewAccount = false;
              this.CreateContact = true;
              this.AccountEmpty = false;
              this.ContactAccountValue = Account.Id;
              this.ContactAccountName = Account.Name;
            }
            if (!this.CreateNewContact) {
              this.ContactAccountValue = this.AccountId;
              this.TypeOfInsert = "BusinessAccount";
              this.AccountRoles = this.ReplaceEmptyAccountRoleRows();

              //now Reset the form
              this.AccountId = "";
              this.ContactAccountValue = "";
              this.AccountName = "";
              this.AccountPhone = "";
              this.Type = "";
              this.AccountPhoneExt = "";
              this.PersonAccount = "";
              this.BillingStreet = "";
              this.BillingCity = "";
              this.BillingState = "";
              this.BillingPostalCode = "";
              this.ContactAccountRole = "";
              this.CompanyAccountRoles = "";
              this.loading = false;
              this.NewAccount = false;
            }
          }
        });
      }else{
        alert('Must search for an Address');}
    }
    }
  }

  ReplaceEmptyAccountRoleRows() {
    var AccountRoles = [];
    //var AccountRoless
    //Get Value from HTML
    if (this.TypeOfInsert === "PersonAccount") {
      this.ContactAccountRole = this.PersonAccountRoles;
    }
    if (this.TypeOfInsert === "BusinessAccount") {
      this.ContactAccountRole = this.CompanyAccountRoles;
    }
    let TblRow = Array.from(
      this.template.querySelectorAll("table.ActRoles tbody tr")
    );

    let RowCount = TblRow.length;

    var Inserted = false;
    for (let k = 0; k < RowCount; k++) {
      // let ARName = TblRow[k].querySelector('.ARName').value;
      let ARRoles = TblRow[k].querySelector(".ARRoles").value;
      //let ARAddress = TblRow[k].querySelector('.ARAddress').value;
      let ARContact = TblRow[k].querySelector(".ARContact").value;
      let ARAccount = TblRow[k].querySelector(".ARAccount").value;

      if (
        (ARContact !== "" && ARContact !== null) ||
        (ARAccount !== "" && ARAccount !== null)
      ) {
        AccountRoles.push({
          Multiple_Roles__c: ARRoles,
          Contact_ID__c: ARContact,
          Account_ID__c: ARAccount
        });
      } else if (
        (ARContact === "" || ARContact === null) &&
        (ARRoles === "" || ARRoles === null) &&
        (ARAccount === "" || ARAccount === null)
      ) {
        AccountRoles.push({
          Multiple_Roles__c: this.ContactAccountRole,
          Contact_ID__c: this.ContactId,
          Account_ID__c: this.ContactAccountValue
        });
        Inserted = true;
      }
    }
    if (!Inserted) {
      if (!this.CreateNewContact) {
        AccountRoles.push({
          Multiple_Roles__c: this.ContactAccountRole,
          Contact_ID__c: "",
          Account_ID__c: this.ContactAccountValue
        });
      } else {
        AccountRoles.push({
          Multiple_Roles__c: this.ContactAccountRole,
          Contact_ID__c: this.ContactId,
          Account_ID__c: this.ContactAccountValue
        });
      }
    }

    return AccountRoles;
  }

  CompanyAccountRolesChange(e) {
    this.CompanyAccountRoles = e.detail.value;
  }
  handleSectionToggle(event) {
    const openSections = event.detail.openSections;
  }
  addContact() {
    this.CreateContact = true;
    this.CreateNewContact = true;
  }
  addAccount() {
    this.NewAccount = true;
    this.CreateContact = false;
  }
  closeAccountModal() {
    this.NewAccount = false;
    this.AccountId = "";
    this.AccountName = "";
    this.AccountLastName = "";
    this.AccountFirstName = "";
    this.AccountPhone = "";
    this.Type = "";
    this.AccountPhoneExt = "";
    this.CompanyAccountRoles = "";
    this.NewAccountCreated = false;
    this.BillingStreet = "";
    this.BillingCity = "";
    this.BillingState = "";
    this.BillingPostalCode = "";
    this.ContactAccountRole = "";
    // remember to reset all the values for contact.
  }
  closeContact() {
    this.CreateContact = false;
    this.CreateNewContact = false;
    this.AccountId = "";
    this.AccountName = "";
    this.AccountLastName = "";
    this.AccountFirstName = "";
    this.AccountPhone = "";
    this.Type = "";
    this.AccountPhoneExt = "";
    this.Phone = "";
    this.BillingStreet = "";
    this.BillingCity = "";
    this.BillingState = "";
    this.BillingPostalCode = "";
    this.ContactAccountRole = "";
    this.FirstName = "";
    this.LastName = "";
    this.Email = "";
    this.ContactType = "";
    this.PhoneExt = "";
    this.ContactAccountValue = "";
    this.AccountId = "";
    this.CompanyAccountRoles = "";
    // remember to reset all the values for contact.
  }
  CustomerSelectedFalse(event) {
    event.preventDefault();
    this.CustomerSelected = !this.CustomerSelected;
  }

  setAddressFields() {
    const address = this.template.querySelector('[data-id="AddressLookup"]');
    const isValid = address.checkValidity();
    if (!isValid) {
      console.log("Address street " + address.street);
    }

    if (!isValid) {
      alert("Not a Valid Address");
    }
  }
  PropertyEmpty() {
    this.ClearSearch();
    this.Customers = "";
  }
  ClearProperty(event) {
    let searchKey = event.detail.value;
    if (searchKey.length === 0) {
      this.ClearSearch();
    }
  }
  ClearOffice(event) {
    let searchKey = event.detail.value;
    if (searchKey.length === 0) {
      this.Offices = "";
    }
  }
  ClearProjectDirector(event) {
    let searchKey = event.detail.value;
    if (searchKey.length === 0) {
      this.ProjectDirectors = "";
    }
  }
  ClearMajorEvent(event) {
    let searchKey = event.detail.value;
    if (searchKey.length === 0) {
      this.MajorEvents = "";
    }
  }
  ClearTakenBy(event) {
    let searchKey = event.detail.value;
    if (searchKey.length === 0) {
      this.TakenByUsers = "";
    }
  }
  ClearSearch() {
    this.PropertyIsNotSelected = true;
    this.Properties = "";
    this.Street = "";
    this.Zip = "";
    this.City = "";
    this.State = "";
  }
  ContactIdChangeNew() {
    this.CustomerSelected = true;
  }
  ClearCustomer() {
    this.Customers = "";
  }
  ContactIdChange(e) {
    this.ContactId = e.detail.value;
    if (this.ContactId > 0) {
      this.ContactSelected = true;
    } else {
      this.ContactSelected = false;
      this.ContactRole = "";
      this.AccountRole = "";
    }
  }
  ContactRoleChanged(e) {
    this.ContactRole = e.detail.value;
  }
  ContactAccountRoleChanged(e) {
    this.ContactAccountRole = e.detail.value;
  }
  ContactTypeChange(e) {
    this.ContactType = e.detail.value;
  }
  FirstNameChange(e) {
    this.FirstName = e.detail.value;
  }
  LastNameChange(e) {
    this.LastName = e.detail.value;
  }
  MailingStreetChange(e) {
    this.MailingStreet = e.detail.value;
  }
  MailingCityChange(e) {
    this.MailingCity = e.detail.value;
  }
  MailingStateChange(e) {
    this.MailingState = e.detail.value;
  }
  MailingCountyChange(e) {
    this.MailingCounty = e.detail.value;
  }
  AccountIdChange(e) {
    this.AccountId = e.detail.value;
  }
  MailingPostalCodeChange(e) {
    this.MailingPostalCode = e.detail.value;
  }
  PhoneChange(e) {
    this.Phone = e.detail.value;
  }
  EmailChange(e) {
    this.Email = e.detail.value;
  }
  PersonEmailChange(e) {
    this.PersonEmail = e.detail.value;
  }
  PhoneExtChange(e) {
    this.PhoneExt = e.detail.value;
  }
  AccountNameChange(e) {
    this.AccountName = e.detail.value;
  }
  BillingStreetChange(e) {
    this.BillingStreet = e.detail.value;
  }
  BillingCityChange(e) {
    this.BillingCity = e.detail.value;
  }
  BillingStateChange(e) {
    this.BillingState = e.detail.value;
  }
  BillingPostalCodeChange(e) {
    this.BillingPostalCode = e.detail.value;
  }
  TypeChange(e) {
    this.Type = e.detail.value;
  }
  BillingCountryChange(e) {
    this.BillingCountry = e.detail.value;
  }
  PropertyNameChange(e) {
    this.PropertyName = e.detail.value;
  }
  CityChange(e) {
    this.City = e.detail.value;
  }
  CountryChange(e) {
    this.Country = e.detail.value;
  }
  StateChange(e) {
    this.State = e.detail.value;
  }
  AddressLine1Change(e) {
    this.AddressLine1 = e.detail.value;
  }
  PropertyTypeChange(e) {
    this.PropertyType = e.detail.value;
  }
  ZipChange(e) {
    this.Zip = e.detail.value;
  }
  DescriptionChange(e) {
    this.Description = e.detail.value;
  }
  DivisionChange(e) {
    this.Division = e.detail.value;
    this.Description = this.Description.replace(
      "Division:",
      "Division: " + this.Division
    );
    if (this.Division === "Emergency Svces") {
      this.DivisionEs = true;
    } else {
      this.DivisionEs = false;
    }
  }
  LeadSourceChange(e) {
    this.LeadSource = e.detail.value;
  }
  JobClassChange(e) {
    this.JobClass = e.detail.value;
  }
  EsJobTypeChange(e) {
    this.EsJobType = e.detail.value;
    this.bioLoss = false;
    this.fireLoss = false;
    this.waterLoss = false;
    if (this.EsJobType === "Water Mitigation") {
      this.waterLoss = true;
      this.bioLoss = false;
      this.fireLoss = false;
    }
    if (this.EsJobType === "Smoke Cleaning") {
      this.fireLoss = true;
      this.waterLoss = false;
      this.bioLoss = false;
    }
    if (this.EsJobType === "Other") {
      this.bioLoss = true;
      this.waterLoss = false;
      this.fireLoss = false;
    }
  }
  ClaimChange(e) {
    this.Claim = e.detail.value;
  }
  DeductibleChange(e) {
    this.Deductible = e.detail.value;
  }
  //connectedCallback(){
  //     this.AccountRoles.push({Name : '',})
  //}
  AccountSelectionChange(e) {
    this.ContactAccountSelected = true;
    this.ContactAccountValue = e.detail.value;
    console.log("ContactAccoutnValue is " + this.ContactAccountValue);
  }
  ToggleNewCaller() {
    this.NewAccount = false;
    if (!this.NewCaller) {
      this.NewCaller = true;
    } else {
      this.NewCaller = false;
    }
  }
  ClearAccount(event) {
    var searchKey = event.detail.value;
    if (searchKey.length === 0) {
      this.ContactAccounts = "";
      this.AccountEmpty = true;
    }
  }
  ToggleNewAccount() {
    this.CreateContact = false;
    this.CreateNewContact = true;
    this.NewAccount = true;
    this.NewAccountCreated = true;
  }
  ToggleNewProperty() {
    if (!this.NewProperty) {
      this.NewProperty = true;
    } else {
      this.NewProperty = false;
    }
  }
  AddNewRow() {
    //this.AccountRoleNew(Name ='test');
    this.AccountRoles.push({ Type: "", Contact: "", Account: "" });
  }
  showModal() {
    this.bShowModal = true;
  }
  closeModal() {
    this.bShowModal = false;
  }
  // PropertyChange(event){
  //     this.PropertyID = event.detail.value;
  //     console.log(this.PropertyID.length);
  //     if(this.PropertyID.length > 17){
  //     this.PropertyPicked = true;

  //     var PropertyJSON = {'PropertyId': this.PropertyID};
  //     var PackagedJSON = JSON.stringify(PropertyJSON);

  //     SearchAccountRoles({PropertyId:PackagedJSON})
  //     .then(result => {
  //         this.AccountRolesRecieved = result;
  //         for (var i = 0; i < this.AccountRolesRecieved.length; i++){
  //                 this.AccountRoles.push({name: this.AccountRolesRecieved[i],})
  //             }
  //         console.log('records' + this.records);
  //         this.error = undefined;
  //         //console.log(' records ', this.records);
  //     })
  //     .catch(error => {
  //         this.error = error;
  //         this.records = undefined;
  //     });

  // }
  // }
  // ARContactChangeNew(event){
  //     var rowInd = event.target.parentNode.parentNode.rowIndex;

  // }

  ARContactChange(event) {
    window.clearTimeout(this.delayTimeout);
    var searchKey = event.target.value;
    if (searchKey.length === 0) {
      this.ARContacts = null;
    }
    if (searchKey.length >= 1) {
      // eslint-disable-next-line @lwc/lwc/no-async-operation
      //this.delayTimeout = setTimeout(() => {
      // eslint-disable-next-line @lwc/lwc/no-async-operation
      this.delayTimeout = setTimeout(() => {
        SearchCustomers({ searchKey: searchKey })
          .then((result) => {
            this.ARContacts = result;

            var rowInd = event.target.parentNode.parentNode.rowIndex;

            this.AccountRoles = this.getAllAccountRoleObjects();
            //    this.AccountRoles[rowInd].ContactSearch = 't';
          })

          .catch((error) => {
            this.error = error;
          });
      }, DELAY);
    }
  }
  OfficeChange(event) {
    console.log('Offices Search ' + event.target.value);
    window.clearTimeout(this.delayTimeout);
    var searchKey = event.target.value;
    if (searchKey.length === 0) {
      this.Offices = null;
    }
    if (searchKey.length >= 1) {
      // eslint-disable-next-line @lwc/lwc/no-async-operation
      //this.delayTimeout = setTimeout(() => {
      // eslint-disable-next-line @lwc/lwc/no-async-operation
      this.delayTimeout = setTimeout(() => {
        SearchOffices({ searchKey: searchKey })
          .then((result) => {
            console.log('Offices result ' + JSON.stringify(result));
            this.Offices = result;
            console.log('Offices result ' + JSON.stringify(this.Offices));
          })

          .catch((error) => {
            this.error = error;
          });
      }, DELAY);
    }
  }
  ProjectDirectorChange(event) {
    window.clearTimeout(this.delayTimeout);
    var searchKey = event.target.value;
    if (searchKey.length === 0) {
      this.ProjectDirectors = null;
    }
    if (searchKey.length >= 1) {
      // eslint-disable-next-line @lwc/lwc/no-async-operation
      //this.delayTimeout = setTimeout(() => {
      // eslint-disable-next-line @lwc/lwc/no-async-operation
      this.delayTimeout = setTimeout(() => {
        GetUsers({ searchKey: searchKey })
          .then((result) => {
            this.ProjectDirectors = result;
          })

          .catch((error) => {
            this.error = error;
          });
      }, DELAY);
    }
  }
  MajorEventChange(event) {
    window.clearTimeout(this.delayTimeout);
    var searchKey = event.target.value;
    if (searchKey.length === 0) {
      this.MajorEvents = null;
    }
    if (searchKey.length >= 1) {
      // eslint-disable-next-line @lwc/lwc/no-async-operation
      //this.delayTimeout = setTimeout(() => {
      // eslint-disable-next-line @lwc/lwc/no-async-operation
      this.delayTimeout = setTimeout(() => {
        GetMajorEvents({ searchKey: searchKey })
          .then((result) => {
            this.MajorEvents = result;
          })

          .catch((error) => {
            this.error = error;
          });
      }, DELAY);
    }
  }
  TakenByChange(event) {
    window.clearTimeout(this.delayTimeout);
    var searchKey = event.target.value;
    if (searchKey.length === 0) {
      this.TakenByUsers = null;
    }
    if (searchKey.length >= 1) {
      // eslint-disable-next-line @lwc/lwc/no-async-operation
      //this.delayTimeout = setTimeout(() => {
      // eslint-disable-next-line @lwc/lwc/no-async-operation
      this.delayTimeout = setTimeout(() => {
        GetUsers({ searchKey: searchKey })
          .then((result) => {
            this.TakenByUsers = result;
          })

          .catch((error) => {
            this.error = error;
          });
      }, DELAY);
    }
  }

  ContactAccountChanged(event) {
    window.clearTimeout(this.delayTimeout);
    var searchKey = event.target.value;
    if (searchKey.length === 0) {
      this.ContactAccounts = null;
    }
    if (searchKey.length >= 1) {
      // eslint-disable-next-line @lwc/lwc/no-async-operation
      //this.delayTimeout = setTimeout(() => {
      // eslint-disable-next-line @lwc/lwc/no-async-operation
      this.delayTimeout = setTimeout(() => {
        SearchContactAccounts({ searchKey: searchKey })
          .then((result) => {
            this.ContactAccounts = result;
          })

          .catch((error) => {
            this.error = error;
          });
      }, DELAY);
    }
    // });
  }
  CustomerChanged(event) {
    window.clearTimeout(this.delayTimeout);
    var searchKey = event.target.value;
    if (searchKey.length === 0) {
      this.Customers = null;
    }
    if (searchKey.length >= 1) {
      // eslint-disable-next-line @lwc/lwc/no-async-operation
      //this.delayTimeout = setTimeout(() => {
      // eslint-disable-next-line @lwc/lwc/no-async-operation
      this.delayTimeout = setTimeout(() => {
        SearchCustomers({ searchKey: searchKey })
          .then((result) => {
            this.Customers = result;
          })

          .catch((error) => {
            this.error = error;
          });
      }, DELAY);
    }
    // });
  }
  populateOfficeField(event) {
    this.Offices = '';
    let OfficeField = event.target.value;
    console.log('officefield ' + JSON.stringify(OfficeField));
    console.log(this.OfficeValue);
    this.OfficeValue = '';
    console.log(this.OfficeValue);
    this.OfficeValue = OfficeField.Name;
    console.log(this.OfficeValue);
    this.OfficeId = OfficeField.Id;
    this.OfficeSelected = true;
  }
  populateProjectDirectorField(event) {
    this.ProjectDirectors = "";
    let ProjectDirector = event.target.value;
    this.ProjectDirectorValue = ProjectDirector.Name;
    this.ProjectDirectorId = ProjectDirector.Id;
    this.ProjectDirectorSelected = true;
  }
  populateMajorEventField(event) {
    this.MajorEvents = "";
    let MajorEvent = event.target.value;
    this.MajorEventValue = MajorEvent.Name;
    this.MajorEventId = MajorEvent.Id;
    this.MajorEventSelected = true;
  }
  populateTakenByField(event) {
    this.TakenByUsers = "";
    let TakenBy = event.target.value;
    this.TakenByValue = TakenBy.Name;
    this.TakenById = TakenBy.Id;
  }
  populateContactAccountField(event) {
    // console.log('Property Id first is + ' + this.Property.Id);
    //console.log('Property Id first is + ' + this.testingProperty);
    //this.PropertyID = event.detail.value;
    this.ContactAccounts = "";
    this.ContactAccountSelected = true;
    this.AccountEmpty = false;
    var ContactAccountField = event.target.value;
    this.ContactAccountValue = ContactAccountField.Id;
    this.ContactAccountId = ContactAccountField.Id;
    this.ContactAccountName = ContactAccountField.Name;
  }
  populateCustomerField(event) {
    // console.log('Property Id first is + ' + this.Property.Id);
    //console.log('Property Id first is + ' + this.testingProperty);
    //this.PropertyID = event.detail.value;
    this.Customers = "";
    this.CustomerSelected = true;
    this.CustomerSelectedField = event.target.value;
    this.CustomerValue = this.CustomerSelectedField.Name;
    this.CustomerId = this.CustomerSelectedField.Id;
    this.CustomerAccountId = this.CustomerSelectedField.Account.Id;
    this.CustomerAccountName = this.CustomerSelectedField.Account.Name;
  }
  populatePropertyField(event) {
    // console.log('Property Id first is + ' + this.Property.Id);
    //console.log('Property Id first is + ' + this.testingProperty);
    //this.PropertyID = event.detail.value;

    this.Properties = "";
    this.PropertySelected = true;
    this.testingProperty = event.target.value;
    this.PropertySelectedField = event.target.value;
    this.PropertyValue = this.PropertySelectedField.Name;
    console.log("Property " + this.PropertySelectedField);
    console.log("Street " + this.PropertySelectedField.Address_Line_1__c);
    console.log("City " + this.PropertySelectedField.City__c);
    console.log("State " + this.PropertySelectedField.State__c);
    this.PropertyID = this.PropertySelectedField.Id;
    this.Street = this.PropertySelectedField.Address_Line_1__c;
    this.Zip = this.PropertySelectedField.Zip__c;
    this.City = this.PropertySelectedField.City__c;
    this.State = this.PropertySelectedField.State__c;
    console.log('Market Class is '  + this.PropertySelectedField.Market_Class__c);
    
    
    

    checkId({ propId: this.testingProperty.Id }).then((result) => {
      let data = result;
      // if(data != undefined && data != null && data.length != null){
      if (JSON.stringify(data) !== "[]") {
        this.AccountRoles = result;
      }
      console.log("ARs" + JSON.stringify(this.AccountRoles));
      this.AccountRolesSelected = true;
    });
    GetMasterJobs({ propId: this.testingProperty.Id }).then((result) => {
      this.MasterJobs = result;
      console.log("Master Jobs " + this.MasterJobs);
      if (JSON.stringify(this.MasterJobs) !== "[]") {
        console.log("Master Jobs result " + JSON.stringify(this.MasterJobs));
        this.bShowModal = true;
      }
    });
    this.PropertyIsNotSelected = false;
  }
  PropertyChanged(event) {
    // window.clearTimeout(this.delayTimeout);

    window.clearTimeout(this.delayTimeout);
    var searchKey = event.target.value;
    if (searchKey.length === 0) {
      this.Properties = null;
    }
    if (searchKey.length >= 1) {
      // eslint-disable-next-line @lwc/lwc/no-async-operation
      //this.delayTimeout = setTimeout(() => {
      // eslint-disable-next-line @lwc/lwc/no-async-operation
      this.delayTimeout = setTimeout(() => {
        SearchProperties({ searchKey: searchKey })
          .then((result) => {
            this.Properties = result;
          })

          .catch((error) => {
            this.error = error;
          });
      }, DELAY);
    }
    // });
  }

  getAllAccountRoleObjects() {
    var AccountRoles = [];
    //var AccountRoless
    //Get Value from HTML
    let TblRow = Array.from(
      this.template.querySelectorAll("table.ActRoles tbody tr")
    );

    let RowCount = TblRow.length;

    for (let k = 0; k < RowCount; k++) {
      // let ARName = TblRow[k].querySelector('.ARName').value;

      //let ARAddress = TblRow[k].querySelector('.ARAddress').value;
      let ARContact = TblRow[k].querySelector(".ARContact").value;
      let ARAccount = TblRow[k].querySelector(".ARAccount").value;
      let ARRoles = TblRow[k].querySelector(".ARRoles").value;
      AccountRoles.push({
        Contact_ID__c: ARContact,
        Account_ID__c: ARAccount,
        Multiple_Roles__c: ARRoles
      });
    }
    return AccountRoles;
  }

  populateMasterJobField(event) {
    this.MasterJobDetails = event.target.value;
    this.MasterJobId = this.MasterJobDetails.Id;
    console.log('MasterJob Id from PopulateMasterJobFIeld is ' + this.MasterJobId);
    if(this.TypeOfJobEntry === "AfterHoursJobEntry"){
      this.ExistingMasterJob = true;
    }

    if (
      this.MasterJobDetails.Claim__c !== "" &&
      this.MasterJobDetails.Claim__c !== undefined &&
      this.MasterJobDetails.Claim__c !== null
    ) {
      this.Claim = this.MasterJobDetails.Claim__c;
      this.ClaimDisabled = true;
    }
    if (
      this.MasterJobDetails.Description_of_Loss__c !== "" &&
      this.MasterJobDetails.Description_of_Loss__c !== undefined &&
      this.MasterJobDetails.Description_of_Loss__c !== null
    ) {
      this.Description = this.MasterJobDetails.Description_of_Loss__c;
      this.DescriptionDisabled = true;
    }
    if (
      this.MasterJobDetails.Lead_Source__c !== "" &&
      this.MasterJobDetails.Lead_Source__c !== undefined &&
      this.MasterJobDetails.Lead_Source__c !== null
    ) {
      this.LeadSource = this.MasterJobDetails.Lead_Source__c;
      this.LeadSourceDisabled = true;
    }
    if (
      this.MasterJobDetails.Date_of_Loss__c !== "" &&
      this.MasterJobDetails.Date_of_Loss__c !== undefined &&
      this.MasterJobDetails.Date_of_Loss__c !== null
    ) {
      this.DateOfLoss = this.MasterJobDetails.Date_of_Loss__c;
      this.DateOfLossDisabled = true;
    }
    if (
      this.MasterJobDetails.Cont_P_O_Client_Job__c !== "" &&
      this.MasterJobDetails.Cont_P_O_Client_Job__c !== undefined &&
      this.MasterJobDetails.Cont_P_O_Client_Job__c !== null
    ) {
      this.ClientJob = this.MasterJobDetails.Cont_P_O_Client_Job__c;
      this.ClientJobDisabled = true;
    }
    if (
      this.MasterJobDetails.Office2__c !== "" &&
      this.MasterJobDetails.Office2__c !== undefined &&
      this.MasterJobDetails.Office2__c !== null
    ) {
      this.OfficeValue = this.MasterJobDetails.Office2__r.Name;
      this.OfficeId = this.MasterJobDetails.Office2__c;
      //this.OfficeDisabled = true;
    }
    console.log('policy is ' + this.MasterJobDetails.Policy__c);
    if (
      this.MasterJobDetails.Policy__c !== "" &&
      this.MasterJobDetails.Policy__c !== undefined &&
      this.MasterJobDetails.Policy__c !== null
    ) {
      this.Policy = this.MasterJobDetails.Policy__c;
      
      this.PolicyDisabled = true;
    }
    if (
      this.MasterJobDetails.Major_Event__c !== "" &&
      this.MasterJobDetails.Major_Event__c !== undefined &&
      this.MasterJobDetails.Major_Event__c !== null
    ) {
      this.MajorEventValue = this.MasterJobDetails.Major_Event__r.Name;
      this.MajorEventId= this.MasterJobDetails.Major_Event__c;
      
      this.MajorEventDisabled = true;
    }
    if (
      this.MasterJobDetails.Multiple_Divisions__c !== "" &&
      this.MasterJobDetails.Multiple_Divisions__c !== undefined &&
      this.MasterJobDetails.Multiple_Divisions__c !== null
    ) {
      this.MultipleDivision = this.MasterJobDetails.Multiple_Divisions__c;
    }
    

    this.bShowModal = false;
  }
  DeleteARRow(e) {
    var DeleteRowIndex = e.target.parentNode.parentNode.parentNode.rowIndex;

    this.AccountRoles = this.getAllAccountRoleObjects();
    this.AccountRoles.splice(DeleteRowIndex - 1, 1);
  }

  CreateNewJob() {
    // if(((!this.ContactId ) && (!this.LastName)) || ((!this.ContactId) && (!this.AccountId && (!this.AccountName || !this.AccountPhone)))){
    //     this.error = true;
    // }else{
    // this.loading = true;
    let AccountRoleInfo = this.GenerateAccountRoleJSON();
    console.log(
      "Property Id is " +
        this.PropertyID +
        "   PropertyType is " +
        this.PropertyType
    );
    if (this.ARRoleBlank) {
      this.ARRoleBlank = false;
      this.billToCount = 0;
      this.projectSiteContactCount = 0;
      this.callerCount = 0;
      alert("Roles cannot be left blank");
    } else {
      if(this.ContactAccountBlank)
      {
        
        this.billToCount = 0;
        this.projectSiteContactCount = 0;
        this.callerCount = 0;
        this.ContactAccountBlank = false;
        alert('If Roles are not blank, must select an Account or Contact');
      }
      else{
      if (this.billToCount > 1 || this.callerCount > 1) {
        alert(
          "Only One Primary/Bill-to and One Project Site Contact can be selected as a Role"
        );
        this.billToCount = 0;
        this.projectSiteContactCount = 0;
        this.callerCount = 0;
      } else {
        if (
          this.billToCount < 1 ||
          this.projectSiteContactCount < 1 ||
          this.callerCount < 1
        ) {
          this.billToCount = 0;
          this.projectSiteContactCount = 0;
          this.callerCount = 0;
          alert(
            "A Primary/Bill-to, Caller and Project Site Contact Role MUST be selected"
          );
        } else {
          if (this.PropertyID === "" && this.Street === "") {
            console.log(
              "Property Id is " +
                this.PropertyID +
                "   PropertyType is " +
                this.PropertyType
            );
            this.billToCount = 0;
            this.projectSiteContactCount = 0;
            this.callerCount = 0;
            alert("Either Select a Property or Create a New Property");
          } else {
            console.log("Description " + this.Description);
            if (
              this.Description === "" ||
              this.Description === undefined ||
              this.DateOfLoss === "" ||
              this.DateOfLoss === undefined ||
              this.JobName === "" ||
              this.JobName === undefined ||
              this.Division === "" ||
              this.Division === undefined ||
              this.MarketSegment === "" ||
              this.MarketSegment === undefined ||
              this.MarketClass === "" ||
              this.MarketClass === undefined ||
              this.LeadSource === "" ||
              this.LeadSource === undefined ||
              this.OfficeValue === undefined ||
              this.OfficeValue === "" ||
              this.TakenByValue === undefined ||
              this.TakenByValue === ""
            ) {
              this.billToCount = 0;
              this.projectSiteContactCount = 0;
              this.callerCount = 0;
              alert("Fill in all required Job Fields");
            } else {
              if (
                this.MarketClass === "Non-Residential" &&
                (this.MarketSegmentSubClass === "" ||
                  this.MarketSegmentSubClass === undefined)
              ) {
                this.billToCount = 0;
                this.projectSiteContactCount = 0;
                this.callerCount = 0;
                alert("Fill in Market Segment Sub Class");
              } else {
                //Account Roles is good to go.

                //Property Data
                PropertyJSON = JSON.stringify({
                  PropertyId: this.PropertyID,
                  City: this.City,
                  Country: this.Country,
                  State: this.State,
                  Street: this.Street,
                  PropertyType: this.PropertyType,
                  Zip: this.Zip,
                  AddressLine2: this.AddressLine2,
                  AlternateName: this.AlternateName
                });
                //Job Fields
                
                JobJSON = JSON.stringify({
                  Description: this.Description,
                  JobRealName: this.JobRealName,
                  Division: this.Division,
                  Office: this.OfficeId,
                  MarketSegment: this.MarketSegment,
                  ProjectDirector: this.ProjectDirectorId,
                  TakenBy: this.TakenById,
                  Claim: this.Claim,
                  JobName: this.JobName,
                  LeadSource: this.LeadSource,
                  MultipleDivisions: this.MultipleDivision,
                  EsJobType: this.EsJobType,
                  DateOfLoss: this.DateOfLoss,
                  Policy:this.Policy,
                  ClientJob: this.ClientJob,
                  YearBuilt: this.YearBuilt,
                  MajorEvent: this.MajorEventId,
                  MarketSegmentSubClass: this.MarketSegmentSubClass,
                  MarketClass: this.MarketClass,
                  ExistingMasterJob: this.ExistingMasterJob
                });
                //Master Job is just MasterJobId, if null then need to create a new one.
                console.log('Masterjob id before insert' + this.MasterJobId);
                console.log('ExistingMasterjob before insert ' + this.ExistingMasterJob);
                this.jobLoading = true;
                CreateNewJob({
                  AccountRoleInfo: AccountRoleInfo,
                  PropertyInfo: PropertyJSON,
                  JobInfo: JobJSON,
                  MasterJobId: this.MasterJobId,
                  JobEntryType: this.TypeOfJobEntry,
                  jobrecordId: this.jobrecordId,
                  ExistingMasterJob:this.ExistingMasterJob
                }).then((result) => {
                  console.log("Response is " + result);
                  this.jobLoading = false;
                  this.billToCount = 0;
                  this.projectSiteContactCount = 0;
                  this.callerCount = 0;
                  let data = result;
                  if (data.length > 18) {
                    this.jobLoading = false;
                    alert(data);
                  } else {
                    this[NavigationMixin.Navigate]({
                      type: "standard__recordPage",
                      attributes: {
                        recordId: data,
                        objectApiName: "ATI_Job__c",
                        actionName: "view"
                      }
                    });
                  }
                });
              }
            }
          }
        }
        }
      }
    }
  }

  Cancel(event) {
    location.href =
      "https://" +
      window.location.hostname +
      "/lightning/o/ATI_Job__c/list?filterName=Recent";
    event.action = this.location;
  }
  waitASecond(seconds) {
      return new PromiseRejectionEvent(function(resolve,reject){
          setTimeout(function(){
              seconds++;
              resolve(seconds);
          }, 1000);
          })
      }
      
  GenerateAccountRoleJSON() {
    var AccountRoleObject = {
      AccountRoleLineItems: this.GetAccountRolesObjects()
    };
    return JSON.stringify(AccountRoleObject);
  }

  GetAccountRolesObjects() {
    let projectSiteContact = false;
    let billTo = false;
    let caller = false;
    var AccountRoles = [];
    let ActTblRow = Array.from(
      this.template.querySelectorAll("table.ActRoles tbody tr")
    );
    console.log("Get Account Roles has been called ");
    let ActRowCount = ActTblRow.length;
    for (let Actindex = 0; Actindex < ActRowCount; Actindex++) 
    {
      // let ARName = ActTblRow[Actindex].querySelector('.ARName').value;
      let ARRoles = ActTblRow[Actindex].querySelector(".ARRoles").value;
      let ARContact = ActTblRow[Actindex].querySelector(".ARContact").value;
      let ARAccount = ActTblRow[Actindex].querySelector(".ARAccount").value;
      console.log(
        "Inside for loop :     AR Roles is " +
          ARRoles +
          "    ARCONTACT :  " +
          ARContact +
          "    ARAccount + " +
          ARAccount
      );
      if (ARRoles !== null && ARRoles.includes("Project Site Contact")) 
      {
        projectSiteContact = true;
        console.log("ARRoles Contains inside");
        this.projectSiteContactCount += 1;
      }
      console.log("contains AR");
      if (ARRoles !== null && ARRoles.includes("Primary/Bill-to")) 
      {
        billTo = true;
        this.billToCount += 1;
      }
      if (ARRoles !== null && ARRoles.includes("Caller")) 
      {
        console.log("Caller has been called");
        caller = true;
        this.callerCount += 1;
      }
      if (
        (ARContact === "" || ARContact === null) &&
        (ARRoles === "" || ARRoles === null) &&
        (ARAccount === "" || ARAccount === null)
      ) 
      {
        console.log("Removing row" + ARContact + ARAccount + ARRoles);
      } 
      else 
      {
        if (ARRoles === "" || ARRoles === null || ARRoles === undefined) 
        {
          this.ARRoleBlank = true;
        }
        else if((ARContact === "" || ARContact === null || ARContact === undefined) && (ARAccount === "" || ARAccount === null || ARAccount === undefined))
        {
          this.ContactAccountBlank = true;
        }
        else if(((ARContact !== null && ARContact !== "") || (ARAccount !== null && ARAccount !== ""))&& (ARRoles !== "" || ARRoles !== null)) 
        {
          AccountRoles.push({
            //name: ARName,
            Text: ARRoles,
            Contact: ARContact,
            Account: ARAccount
          });
        }
      }
    }
    if (projectSiteContact === false || billTo === false || caller === false) 
    {
      AccountRolesPassed = false;
    } else {
      AccountRolesPassed = true;
    }
    console.log("AccountRolesPassed " + AccountRolesPassed);
    return AccountRoles;
  }
}