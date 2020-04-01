/**
 * @File Name          : Create_Opportunity_Handler.cls
 * @Description        : 
 * @Author             : sean.gray@atirestoration.com
 * @Group              : 
 * @Last Modified By   : sean.gray@atirestoration.com
 * @Last Modified On   : 3/18/2020, 7:35:16 AM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    3/18/2020   sean.gray@atirestoration.com     Initial Version
**/
public class Create_Opportunity_Handler 
{
   public static void createOpportunity(ATI_Job__c[] lstJobs)
    {
        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Job Opportunity').getRecordTypeId();
		set<id> setAccountIds = new Set<id>();
      
            for(ATI_Job__c newJob: lstJobs)
            {
                if(newJob.Property_ID__c <> null)
                {
                                  setAccountIds.add(newJob.Property_ID__c) ; 
                }
             	system.debug('Property_ID__c' +newJob.Property_ID__c);
            }
  		 List<Opportunity> lstinsertOpp= new List<Opportunity>();
        List<Account_Roles__c> Fetch_BillTo_AccountRoles = new List<Account_Roles__c>();
        system.debug('Set AccountIds' + setAccountIds);
        if(!setAccountIds.isEmpty())
        {
          system.debug('Set AccountIds is not empty ');
          Fetch_BillTo_AccountRoles = [select id,name, Roles__c, Property_ID__c from Account_Roles__c where Property_ID__c IN: setAccountIds AND Multiple_Roles__c includes('Primary/Bill-to') LIMIT 1];  
        }
		system.debug('accounroles' +Fetch_BillTo_AccountRoles);
        if(!Fetch_BillTo_AccountRoles.isEmpty())
        {
			Opportunity newOpportunity = new Opportunity ();
          for(ATI_Job__c eachjob: lstJobs)
          {
              newOpportunity.Job__c = eachjob.id;
              newOpportunity.RecordTypeId = recordTypeId;
              newOpportunity.StageName = 'Prospecting';
              newOpportunity.Property__c = Fetch_BillTo_AccountRoles[0].Property_ID__c;
              newOpportunity.Contact__c = eachjob.Contact__c;
              newOpportunity.Project_Site_Contact_Name__c = eachjob.Project_Site_Contact_Name__c;
              newOpportunity.Project_Site_Contact_Account__c = eachjob.Project_Site_Contact_Account__c;
              newOpportunity.Owner__c = eachjob.Owner__c;
              newOpportunity.Insurance_Adjuster_Broker__c = eachjob.Insurance_Adjuster_Broker__c;
              newOpportunity.Name = eachjob.Job_Name__c;
              newOpportunity.Job_Name__c= eachjob.Job_Name__c;
              newOpportunity.Project_Site_State__c= eachjob.Project_Site_State__c;
              newOpportunity.Project_Site_Address__c= eachjob.Project_Site_Address__c;
              newOpportunity.Project_Site_Zipcode__c= eachjob.Project_Site_Zipcode__c;
              newOpportunity.County__c=eachjob.County__c;
              newOpportunity.Project_Site_City__c= eachjob.Project_Site_City__c;
              newOpportunity.CloseDate = date.today();
              newOpportunity.AccountId = eachjob.Account__c;
        	 system.debug('newOpportunity' +newOpportunity);
          }
             lstinsertOpp.add(newOpportunity);
        }
        if(!lstinsertOpp.isEmpty())
        {
             system.debug('lstinsertOpp' +lstinsertOpp.size());
             insert lstinsertOpp;
        }
         
        	
    }

}