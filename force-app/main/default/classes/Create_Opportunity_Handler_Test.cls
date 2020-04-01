@istest
public class Create_Opportunity_Handler_Test {
    static testMethod void testCreateOpportunityMethod() {
        
        Property__c propertyInsert = new Property__c();
        propertyInsert.Address_Line_1__c = 'Test Property';
        Insert propertyInsert;
        
        Account accInsert = new Account(Name = 'Test Account');
        Insert accInsert;
        
        Contact conInsert = new Contact();
        conInsert.LastName='TestContact';
        conInsert.Contact_Type__c='Project Site Contact';
        conInsert.AccountId=accInsert.Id;
        conInsert.MailingStreet='TestStreet';
        conInsert.MailingState='Teststate';
        conInsert.MailingCity='TestCity';
        conInsert.MailingCountry='TestCountry';
        conInsert.MailingPostalCode='123456';
        Insert conInsert;
        
        Account_Roles__c accountRoleInsert = new Account_Roles__c();
        accountRoleInsert.Account_ID__c = accInsert.Id;
        accountRoleInsert.Property_ID__c=propertyInsert.Id;
        accountRoleInsert.Roles__c='Bill To';
        Insert accountRoleInsert;
        
        Master_Job__c masterJob = new Master_Job__c();
        masterJob.Stage__c='Pre-work';
 		masterJob.Master_Job_Id__c='TestMasterJob';
        Insert masterJob;
        
        Office__c office= new Office__c(Name='TestOffice');
        Insert office;


             
		ATI_Job__c jobInsert =new ATI_Job__c();
        jobInsert.Property_ID__c=propertyInsert.Id;
        jobInsert.Master_Job__c=masterJob.Id;
        jobInsert.Job_Name__c='TestJob';
        jobInsert.Account__c=accInsert.Id;
        //jobInsert.Job_Number__c='Test Number';
        jobInsert.Office2__c=office.Id;
        jobInsert.Date_Time_Taken__c=system.today()+450;
        jobInsert.Lead_Source__c='Attorney';
        jobInsert.Job_Class__c='Multi-Family';
        jobInsert.Project_Type__c='Standard';
        jobInsert.GL_Account_Prefix__c='1-80-10';
        jobInsert.Job_Number_Sequence_Group__c='20200';
        jobInsert.Stage__c='Qualification';
        jobInsert.CloseDate__c=date.today()+7;
        jobInsert.Project_Site_Contact_Account__c=accInsert.Id;
        jobInsert.Division__c='Asbestos';   
        jobInsert.Project_Site_Contact_Name__c=conInsert.id;
        Insert jobInsert;
        
    }
}