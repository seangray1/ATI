import { LightningElement, api, track, wire } from 'lwc';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import GetJobAccountRoles from '@salesforce/apex/NewJobController.GetJobAccountRoles';
import InsertContact from "@salesforce/apex/NewJobController.InsertContact";
import InsertAccount from "@salesforce/apex/NewJobController.InsertAccount";
import InsertPersonAccount from "@salesforce/apex/NewJobController.InsertPersonAccount";
import GetAccountRolesPicklist from "@salesforce/apex/NewJobController.getPickListValuesIntoList";
import SearchCustomers from "@salesforce/apex/NewJobController.GetCustomers";
import SearchContactAccounts from "@salesforce/apex/NewJobController.GetContactAccounts";
import EditAccountRoles from "@salesforce/apex/NewJobController.EditAccountRoles";
import { getPicklistValues } from "lightning/uiObjectInfoApi";
import { getObjectInfo } from "lightning/uiObjectInfoApi";
import ACCOUNT_OBJECT from "@salesforce/schema/Account";
import CONTACT_OBJECT from "@salesforce/schema/Contact";
import ACCOUNTROLES_OBJECT from "@salesforce/schema/Account_Roles__c";
import ROLE_FIELD from "@salesforce/schema/Account_Roles__c.Roles__c";
import CONTACTTYPE_FIELD from "@salesforce/schema/Contact.Contact_Type__c";
import TYPE_FIELD from "@salesforce/schema/Account.Type";
import GetUserInfo from "@salesforce/apex/NewJobController.GetUserInfo";
import { NavigationMixin } from 'lightning/navigation';
import { refreshApex } from '@salesforce/apex';
let AccountRolesPassed= false;
const DELAY = 100;
export default class AccountRolesEditLWC extends NavigationMixin (LightningElement) 
{
@api recordId;
@track MarketsDisabled = false;
buttonsDisabled = false;
  PersonAccount = false;
  jobLoading = false;
  ARContacts;
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
  ContactAccountName;
  searchKey;
  JobRealName;
  NewCaller = false;
  NewAccount = false;
  AccountRolesSelected = false;
  AccountRolesRecieved = "";
  inputDisabled = true;
  bShowModal = false;
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
  ContactAccountBlank = false;
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
  Zip;
  EstimateType;
  AccountRoleLineItems = [{}];
  loading = false;
  data;
  ContactSelected = false;
  AccountRole;
  ContactRole;
  CustomerAccountId;
  CustomerAccountName;
  AccountRolePicklistValuesContainer = [{}];
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
  DateOfLoss;
  ClientJob;
  YearBuilt;
  PolicyDisabled = false;
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

  @wire(getObjectInfo, { objectApiName: ACCOUNTROLES_OBJECT })
  objectInfo;
  @wire(getObjectInfo, { objectApiName: ACCOUNT_OBJECT })
  accountInfo;
  @wire(getObjectInfo, { objectApiName: CONTACT_OBJECT })
  contactInfo;
  @wire(getPicklistValues, {
    recordTypeId: "$objectInfo.data.defaultRecordTypeId",
    fieldApiName: ROLE_FIELD
  })
  AccountRolesValues;
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
 connectedCallback()
    {
        console.log('Working');
        console.log('Record Id is ' + this.recordId);
        GetJobAccountRoles({recordId:this.recordId}).then(result =>
            {
                console.log(result);
                if (JSON.stringify(result) !== "[]") {
                    this.AccountRoles = result;
                    this.ARReady = true;
                  }
            })
        GetUserInfo({}).then(result => {
          let profileName = result;
          if(profileName !== 'System Administrator' && profileName !== 'Contact Center Rep')
          {
              this.buttonsDisabled = true;
          }
          else{
            this.buttonsDisabled = false;
          }
        })
        GetAccountRolesPicklist({}).then((result) => {
      var AccountRolePicklistValues = result;
      for (var i = 0; i < AccountRolePicklistValues.length; i++) {
        this.AccountRolePicklistValuesContainer.push({
          label: AccountRolePicklistValues[i],
          value: AccountRolePicklistValues[i]
        });
      }
    });
        
    }
DeleteARRow(e) {
    var DeleteRowIndex = e.target.parentNode.parentNode.parentNode.rowIndex;

    this.AccountRoles = this.getAllAccountRoleObjects();
    this.AccountRoles.splice(DeleteRowIndex - 1, 1);
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
  ContactAccountChanged(event) {
    window.clearTimeout(this.delayTimeout);
    var searchKey = event.target.value;
    console.log('Search Key is ' + searchKey);
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
  ARContactChange(event) {
    window.clearTimeout(this.delayTimeout);
    var searchKey = event.target.value;
    console.log('Search Key ' + searchKey);
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
AddNewRow() {
    //this.AccountRoleNew(Name ='test');
    this.AccountRoles.push({ Type: "", Contact: "", Account: "" });
  }
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
  CustomerSelectedFalse(event) {
    event.preventDefault();
    this.CustomerSelected = !this.CustomerSelected;
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
  Cancel()
  {
    this.dispatchEvent(new CustomEvent('CloseEditAccountRoles'));  
  }
  EditAccountRoles()
  {
    let AccountRoleInfo = this.GenerateAccountRoleJSON();
    console.log(this.ARRoleBlank);
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
          "Only One Primary/Bill-to and One Project Site Contact and Caller can be selected as a Role"
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
          console.log('about to send');
          this.jobLoading = true;
          EditAccountRoles({
            AccountRoleInfo: AccountRoleInfo,
            recordId:this.recordId
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
                this[NavigationMixin.Navigate]
                ({
                type: 'standard__recordPage',
                attributes: {
                  recordId: this.recordId,
                  objectApiName: 'ATI_Job__c',
                  actionName: 'view',
                  },
                });
              //this.dispatchEvent(new CustomEvent('CloseEditAccountRoles'));  
            }
        })
    }
}
      }
    }
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
    console.log('Account Roles contains ' + ActTblRow);
    console.log("Account Roles lenght is  " + ActTblRow.length);
    let ActRowCount = ActTblRow.length;

    for (let Actindex = 0; Actindex < ActRowCount; Actindex++) {
      // let ARName = ActTblRow[Actindex].querySelector('.ARName').value;
      let ARRoles = ActTblRow[Actindex].querySelector(".ARRoles").value;
      let ARContact = ActTblRow[Actindex].querySelector(".ARContact").value;
      let ARAccount = ActTblRow[Actindex].querySelector(".ARAccount").value;
      console.log(
        "Inside for loop :     AR Roles is " +ARRoles 
      );
      if (ARRoles !== null && ARRoles.includes("Project Site Contact")) {
        projectSiteContact = true;
        console.log("ARRoles Contains inside");
        this.projectSiteContactCount += 1;
      }
      console.log("contains AR");
      if (ARRoles !== null && ARRoles.includes("Primary/Bill-to")) {
        billTo = true;
        this.billToCount += 1;
      }
      if (ARRoles !== null && ARRoles.includes("Caller")) {
        console.log("Caller has been called");
        caller = true;
        this.callerCount += 1;
      }
      if (
        (ARContact === "" || ARContact === null) &&
        (ARRoles === "" || ARRoles === null) &&
        (ARAccount === "" || ARAccount === null)
      ) {
        console.log("Removing row");
      } else {
        console.log('AR ROles is ' + ARRoles);
        if (ARRoles === "" || ARRoles === null || ARRoles === undefined) 
        {
          console.log('1AR ROles is ' + this.ARRoleBlank);
          this.ARRoleBlank = true;
          console.log('2AR ROles is ' + this.ARRoleBlank);
        }
        else if((ARContact === "" || ARContact === null || ARContact === undefined) && (ARAccount === "" || ARAccount === null || ARAccount === undefined))
        {
          console.log('Cont and ACct blank ' );
          this.ContactAccountBlank = true;
        }
        else if(((ARContact !== null && ARContact !== "") || (ARAccount !== null && ARAccount !== ""))&& (ARRoles !== "" || ARRoles !== null)) 
        {
          console.log('passed' );
          AccountRoles.push({
            //name: ARName,
            Text: ARRoles,
            Contact: ARContact,
            Account: ARAccount
          });
        }
      }
    }
    console.log('Hit the end');
    if (projectSiteContact === false || billTo === false || caller === false) {
      AccountRolesPassed = false;
    } else {
      AccountRolesPassed = true;
    }
    console.log("AccountRolesPassed " + AccountRolesPassed);
    return AccountRoles;
  }
}