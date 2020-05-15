@istest
public class Create_Opportunity_Handler_Test {
    static testMethod void testCreateOpportunityMethod() {
        
        Id u2 = UserInfo.getUserId();
        
        system.runAs(new User(Id=Userinfo.getUserId())){
            
            Map <String, Schema.RecordTypeInfo> jobRecordTypeMap = Schema.SObjectType.ATI_job__c.RecordTypeInfosByName;
            Id notApprovedId = Schema.SObjectType.ATI_job__c.RecordTypeInfosByName.get('New Job (Not Approved)').RecordTypeId;
            Id approvedId = Schema.SObjectType.ATI_job__c.RecordTypeInfosByName.get('Job (Approved)').RecordTypeId;
    
            TestDataUtil.createCustomSettings_TriggerStatus();
            //create Account 
            Office__c off = new Office__c(Name = 'HQ');
            insert off;
            list<Account> lstAccounts = TestDataUtil.createAccounts(2, false, new map<String,Object>());
            lstAccounts[0].type ='Property Owner';             
            insert lstAccounts;
            
            lstAccounts[0].Status__c = 'Approved';
            update lstAccounts;
            
            list<contact> lstContact = TestDataUtil.createContacts(2, false, new map<String,Object>(), lstAccounts[0].Id);
            insert lstContact;
            List<ATI_Job__c> jobs = new List<ATI_Job__c>();
            Jobs = TestDataUtil.createJob(1, false, new map<String,Object>(), lstAccounts[0].Id);
    
            Jobs[0].contact__c = lstContact[0].id;
            Jobs[0].Project_Site_Contact_Name__c = lstContact[1].id;
            Jobs[0].Insurance_Adjuster_Broker__c = lstContact[0].id;
            Jobs[0].Primary_Account__c = 'Caller Account';
            Jobs[0].Project_Site_Address__c = '7550 st. patrick way';
            Jobs[0].Project_Site_Address_2__c = '';
            Jobs[0].Project_Site_City__c = 'Dublin';
            Jobs[0].Project_Site_State__c = 'CA';
            Jobs[0].Project_Site_Zipcode__c = '94568';
            Jobs[0].Project_Site_Contact_Account__c = lstAccounts[0].id;
            Jobs[0].Project_Site_Record_Id__c = '12345';
            Jobs[0].RecordTypeId = notApprovedId;
            Jobs[0].Job_Name__c ='test';
            insert Jobs;

            Create_Opportunity_Handler.createOpportunity(Jobs);
            ATI_Job__c Job = new ATI_Job__c(Name = 'Testasd');
            Map<Id,ATI_Job__c> oldJobsList = new Map<Id,ATI_Job__c>();
            oldJobsList.put(jobs[0].id, Job);
            Create_Opportunity_Handler.updateOpportunity(Jobs, oldJobsList);

        // Property__c propertyInsert = new Property__c();
        // propertyInsert.Address_Line_1__c = 'Test Property';
        // Insert propertyInsert;
        
        // Account accInsert = new Account(Name = 'Test Account');
        // Insert accInsert;
        
        // Contact conInsert = new Contact();
        // conInsert.LastName='TestContact';
        // conInsert.Contact_Type__c='Project Site Contact';
        // conInsert.AccountId=accInsert.Id;
        // conInsert.MailingStreet='TestStreet';
        // conInsert.MailingState='Teststate';
        // conInsert.MailingCity='TestCity';
        // conInsert.MailingCountry='TestCountry';
        // conInsert.MailingPostalCode='123456';
        // Insert conInsert;
        
        // Account_Roles__c accountRoleInsert = new Account_Roles__c();
        // accountRoleInsert.Account_ID__c = accInsert.Id;
        // accountRoleInsert.Property_ID__c=propertyInsert.Id;
        // accountRoleInsert.Roles__c='Bill To';
        // Insert accountRoleInsert;
        
        // Master_Job__c masterJob = new Master_Job__c();
        // masterJob.Stage__c='Pre-work';
 		// masterJob.Master_Job_Id__c='TestMasterJob';
        // Insert masterJob;
        
        // Office__c office= new Office__c(Name='TestOffice');
        // Insert office;


             
		// ATI_Job__c jobInsert =new ATI_Job__c();
        // jobInsert.Property_ID__c=propertyInsert.Id;
        // jobInsert.Master_Job__c=masterJob.Id;
        // jobInsert.Job_Name__c='TestJob';
        // jobInsert.Account__c=accInsert.Id;
        // //jobInsert.Job_Number__c='Test Number';
        // jobInsert.Office2__c=office.Id;
        // jobInsert.Date_Time_Taken__c=system.today()+450;
        // jobInsert.Lead_Source__c='Attorney';
        // jobInsert.Job_Class__c='Multi-Family';
        // jobInsert.Project_Type__c='Standard';
        // jobInsert.GL_Account_Prefix__c='1-80-10';
        // jobInsert.Job_Number_Sequence_Group__c='20200';
        // jobInsert.Stage__c='Qualification';
        // jobInsert.CloseDate__c=date.today()+7;
        // jobInsert.Project_Site_Contact_Account__c=accInsert.Id;
        // jobInsert.Division__c='Asbestos';   
        // jobInsert.Project_Site_Contact_Name__c=conInsert.id;
        // Insert jobInsert;
        }
    }
}