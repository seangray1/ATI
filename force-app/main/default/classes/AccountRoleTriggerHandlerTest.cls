@isTest
Public Class AccountRoleTriggerHandlerTest{

@isTest
Static Void AccountTriggerFunctionalityTest(){

        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Restricted Process Execution' LIMIT 1];
        
        User usr = new User(LastName = 'Testofc',
                           FirstName='DeBki',
                           Alias = 'jliv',
                           Email = 'jason.liveston@asdf.com',
                           Username = 'testati@google.com',
                           ProfileId = profileId.id,
                           TimeZoneSidKey = 'GMT',
                           LanguageLocaleKey = 'en_US',
                           EmailEncodingKey = 'UTF-8',
                           LocaleSidKey = 'en_US'
                           );
                           
                           
        system.runAs(usr){
        
        Account acct = new Account (Name = 'Acme, Inc.');
        insert acct;

        Contact con = new Contact(
                          FirstName = 'Preludesys',
                          LastName = 'Test',
                          AccountId = acct.Id
                          );
        insert con;   
        
        
        Contact con1 = new Contact(
                          FirstName = 'Demand',
                          LastName = 'Blue',
                          AccountId = acct.Id
                          );
        insert con1;  
        
        Campaign camp = new Campaign(
                            Name = 'TestCampaign',
            				StartDate = system.today()-100,
                            EndDate = system.today()+10,
                            IsActive = TRUE
                            );            
        insert camp;
        
        
         Campaign camp1 = new Campaign(
                            Name = 'CampaignTest',
             				StartDate = system.today()-92,
                            EndDate = system.today()-90,
                            IsActive = TRUE
                            );            
        insert camp1;
        
        CampaignMember member = new CampaignMember(
            ContactId = con.Id,
            Status = 'sent',
            CampaignId = camp.Id
            ); 
        insert member; 
        
        
        CampaignMember member1 = new CampaignMember(
            ContactId = con1.Id,
            Status = 'sent',
            CampaignId = camp1.Id
            ); 
            
            
       Office__c office = new Office__c();
       office.Name = 'Office Test';
       insert office;
       
       ATI_Job__c job = new ATI_Job__c();
       job.name = 'Test';
       job.Job_Name__c = 'Job Test';
       job.Office2__c = office.id;
       job.Lead_Source__c = 'Advertising and Publications';
       job.Stage__c = 'Qualification';
       job.Project_Site_Address__c = '665 S 300 E';
       job.Project_Site_City__c = 'LasVegas';
       job.Project_Site_State__c = 'UT';
       job.Project_Site_Zipcode__c = '12345';
       job.County__c = 'CL';
       insert job;
       
       List<Account_Roles__c> accRoles = new List<Account_Roles__c>();
       List<Account_Roles__c> updAccRoles = new List<Account_Roles__c>();
       
       Account_Roles__c accRole = new Account_Roles__c();
       accRole.Contact_ID__c = con.id;
       accRole.Master_Job_ID__c = job.id;
       accRoles.add(accRole);
       
       Account_Roles__c accRole1 = new Account_Roles__c();
       accRole1.Contact_ID__c = con1.id;
       accRole1.Master_Job_ID__c = job.id;
       accRoles.add(accRole1);
       
       insert accRoles;
       
       for(Account_Roles__c acRole: accRoles){
       
       
           if(acRole.Contact_ID__c == con.Id){
           
               acRole.Contact_ID__c = con1.Id;
                updAccRoles.add(acRole);
           
           }
           
           else if(acRole.Contact_ID__c == con1.Id){
           
               acRole.Contact_ID__c = con.Id;
                updAccRoles.add(acRole);
           
           }
           
          
       
       
       }
       
  
       update updAccRoles;        
       delete updAccRoles;
       
       
     }         

  }
  
  @isTest
  Static Void AccountRoleFunctionalityBatchTest(){
  
  Account acct = new Account (Name = 'Acme, Inc.');
        insert acct;

        Contact con = new Contact(
                          FirstName = 'Preludesys',
                          LastName = 'Test',
                          AccountId = acct.Id
                          );
        insert con;   
        
        
        Contact con1 = new Contact(
                          FirstName = 'Demand',
                          LastName = 'Blue',
                          AccountId = acct.Id
                          );
        insert con1;  
        
        Campaign camp = new Campaign(
                            Name = 'TestCampaign',
                            EndDate = system.today()-100,
                            IsActive = TRUE
                            );            
        insert camp;
        
        
         Campaign camp1 = new Campaign(
                            Name = 'CampaignTest',
                            EndDate = system.today()-90,
                            IsActive = TRUE
                            );            
        insert camp1;
        
        CampaignMember member = new CampaignMember(
            ContactId = con.Id,
            Status = 'sent',
            CampaignId = camp.Id
            ); 
        insert member; 
        
        
        CampaignMember member1 = new CampaignMember(
            ContactId = con1.Id,
            Status = 'sent',
            CampaignId = camp1.Id
            ); 
            
       List<Account_Roles__c> accRolesBatch = new List<Account_Roles__c>();
       
       Account_Roles__c accRole2 = new Account_Roles__c();
       accRole2.Contact_ID__c = con.id;
       accRolesBatch.add(accRole2);
       
       Account_Roles__c accRole3 = new Account_Roles__c();
       accRole3.Contact_ID__c = con1.id;
       accRolesBatch.add(accRole3);

       insert accRolesBatch;
      List< Campaign_Junction__c> campJunctions = [select id from Campaign_Junction__c];
      delete campJunctions;
       
       Test.startTest();
       AccountRoleInsertBatch accRoleBatch = new AccountRoleInsertBatch();
       Database.ExecuteBatch(accRoleBatch);
       Test.stopTest();
       
       
       


}

}