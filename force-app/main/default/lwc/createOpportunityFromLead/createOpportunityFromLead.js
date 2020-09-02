import { LightningElement, api } from 'lwc';
import ConvertToOpp from '@salesforce/apex/LeadOppConversion.ConvertLeadToOpp';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import { NavigationMixin } from "lightning/navigation";
export default class CreateOpportunityFromLead extends NavigationMixin(LightningElement) {
@api recordId;
loading = false;
Validated = false;
Leads = [{}];
LeadSelection = false;
OpportunityCreation = true;
index = 0;
connectedCallback()
{
    this.index++;
    this.Leads.push({
        Id:"",
        Lead__c:this.recordId,
        num:this.index
    });
    this.Leads.shift();
}
Next()
{
    this.LeadSelection = true;
    this.OpportunityCreation = false;
}
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
Send()
{
    this.loading = true;
    let AccountRoleInfo = this.GenerateAccountRoleJSON();
    ConvertToOpp({recordId : this.recordId, LeadData:AccountRoleInfo}).then(result => 
    {
        //this.loading = false;
        let message = result;
        if(message.length <= 18)
        {
            const event = new ShowToastEvent({
                title:'Success',
                message: 'Opportunity Created',
                variant: 'success',
            });
            this.dispatchEvent(event);
            this[NavigationMixin.Navigate]({
                type: "standard__recordPage",
                attributes: {
                  recordId: message,
                  objectApiName: "Opportunity",
                  actionName: "view"
                }
              }); 
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

}
