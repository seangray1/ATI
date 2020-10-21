import { LightningElement, api } from 'lwc';
import AddLeadContact from '@salesforce/apex/LeadOppConversion.AddLeadContact';

import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import { NavigationMixin } from "lightning/navigation";
export default class BDOppRelateLeadContact extends NavigationMixin(LightningElement) {

@api recordId;
loading = false;
Validated = false;
Leads = [{}];
Contacts = [{}];
LeadSelection = false;
ContactSelection = false;
OpportunityCreation = true;
index = 0;
contactindex = 0;
Street;
Zipcode;
State;
Country;
City;
AddressLine2;
AddressValidation = false;
    

    addRow()
{
    this.index++;
    console.log('Leads : ' + JSON.stringify(this.Leads));
    this.Leads.push({Id:"",Lead__c:"",num:this.index});
    let test = this.Leads;
    this.Leads = [{}];
    for(var i = 0; i<test.length;i++)
    {
        this.Leads.push({Id:test[i].Id, Lead__c:test[i].Lead__c, num:test[i].num});
    }
    this.Leads.shift();
    
   
    console.log('Leads : ' + JSON.stringify(this.Leads));
}
addContactRow()
{
  this.contactindex++;
  
  this.Contacts.push({Id:"",Contact__c:"",num:this.contactindex});
  let test = this.Contacts;
  this.Contacts = [{}];
  for(var i = 0; i<test.length;i++)
  {
      this.Contacts.push({Id:test[i].Id, Lead__c:test[i].Contact__c, num:test[i].num});
  }
  this.Contacts.shift();
  
 
  console.log('Leads : ' + JSON.stringify(this.Leads));
}
Send()
{
    this.loading = true;
    console.log('Before generating JSON');
    let Leads;
    let Contacts;
    let ContactDataCheck = Array.from(
      this.template.querySelectorAll("table.getContacts tbody tr")
    );
    let lead = ContactDataCheck[0].querySelector(".ContactId").value;
    console.log('Contact Data check lenght is ' + JSON.stringify(ContactDataCheck) + ' ' + lead);
    let LeadDataCheck = Array.from(
      this.template.querySelectorAll("table.ActRoles tbody tr")
    );
    let cont = LeadDataCheck[0].querySelector(".LeadId").value;
    console.log('LeadData check lenght is ' + JSON.stringify(LeadDataCheck) + ' ' + cont);
    if(cont != null)
    {
      Leads = this.GenerateAccountRoleJSON();
    }
    console.log('Leads Passed' );
    
    
    if(lead != null)
    {
      Contacts = this.GenerateContactJSON();
    }
   
     
    
    console.log('After generating JSON');
    AddLeadContact({recordId : this.recordId, LeadData:Leads, ContactData:Contacts}).then(result => 
    {
        //this.loading = false;
        let message = result;
        if(message.length <= 18)
        {
            this.dispatchEvent(new CustomEvent('refreshRecord'));  
        }
        else
        {
        this.loading = false;
        alert(message);
        }
    }
    );
}

Back()
{
    this.dispatchEvent(new CustomEvent('Close'));  
}

DeleteARRow(e) 
{
    var DeleteRowIndex = e.target.parentNode.parentNode.rowIndex;
    console.log('Row index is ' + DeleteRowIndex);
    console.log('Leads before delete' + JSON.stringify(this.Leads));
    this.Leads = this.getAllAccountRoleObjects();
    console.log('Leads semi after delete' +JSON.stringify(this.Leads));
    this.Leads.splice(DeleteRowIndex - 1, 1);
    console.log('Leads  after delete' +JSON.stringify(this.Leads));
}
DeleteARRow(e) 
{
    var DeleteRowIndex = e.target.parentNode.parentNode.rowIndex;
    console.log('Row index is ' + DeleteRowIndex);
    console.log('Leads before delete' + JSON.stringify(this.Leads));
    this.Contacts = this.getAllContacts();
    console.log('Leads semi after delete' +JSON.stringify(this.Leads));
    this.Contacts.splice(DeleteRowIndex - 1, 1);
    console.log('Leads  after delete' +JSON.stringify(this.Leads));
}

getAllAccountRoleObjects() 
{
var AccountRoles = [];

let TblRow = Array.from(
    this.template.querySelectorAll("table.ActRoles tbody tr")
);

let RowCount = TblRow.length;

for (let k = 0; k < RowCount; k++) {
    let lead = TblRow[k].querySelector(".LeadId").value;
    AccountRoles.push({
    Lead__c: lead,
    num:k
    });
    
}
console.log('Leads ' + AccountRoles);
return AccountRoles;
}
getAllContacts() 
{
var AccountRoles = [];

let TblRow = Array.from(
    this.template.querySelectorAll("table.getContacts tbody tr")
);

let RowCount = TblRow.length;

for (let k = 0; k < RowCount; k++) {
    let lead = TblRow[k].querySelector(".ContactId").value;
    AccountRoles.push({
    Contact__c: lead,
    num:k
    });
    
}
console.log('Leads ' + AccountRoles);
return AccountRoles;
}

GenerateAccountRoleJSON() {
    var AccountRoleObject = {
      AccountRoleLineItems: this.GetAccountRolesObjects()
    };
    return JSON.stringify(AccountRoleObject);
  }

  GetAccountRolesObjects() {
   
    var AccountRoles = [];
    let ActTblRow = Array.from(
      this.template.querySelectorAll("table.ActRoles tbody tr")
    );
    
    let ActRowCount = ActTblRow.length;
    for (let Actindex = 0; Actindex < ActRowCount; Actindex++) 
    {
      // let ARName = ActTblRow[Actindex].querySelector('.ARName').value;
      let ARRoles = ActTblRow[Actindex].querySelector(".LeadId").value;
      if (ARRoles === "" || ARRoles === null || ARRoles === undefined)
      {
        console.log("Removing row" + ARContact + ARAccount + ARRoles);
      } 
      else 
      {
          AccountRoles.push({
            LeadId: ARRoles
          });
        }
    }
   
    return AccountRoles;
  }

  GenerateContactJSON() {
    var AccountRoleObject = {
      AccountRoleLineItems: this.GetContacts()
    };
    return JSON.stringify(AccountRoleObject);
  }

  GetContacts() {
   
    var AccountRoles = [];
    let ActTblRow = Array.from(
      this.template.querySelectorAll("table.getContacts tbody tr")
    );
    
    let ActRowCount = ActTblRow.length;
    for (let Actindex = 0; Actindex < ActRowCount; Actindex++) 
    {
      // let ARName = ActTblRow[Actindex].querySelector('.ARName').value;
      let ARRoles = ActTblRow[Actindex].querySelector(".ContactId").value;
      if (ARRoles === "" || ARRoles === null || ARRoles === undefined)
      {
        
      } 
      else 
      {
          AccountRoles.push({
            ContactId: ARRoles
          });
        }
    }
   
    return AccountRoles;
  }

}