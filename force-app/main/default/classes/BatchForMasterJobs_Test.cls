@isTest
private with sharing class BatchForMasterJobs_Test {
    static testMethod void BatchForMasterJobs_Test() {
        Id u2 = UserInfo.getUserId();
        
        system.runAs(new User(Id=Userinfo.getUserId())){
            
            
            Property__c prop = new Property__c(Name = 'Test', Address_Line_1__c = '92832 La Palma Ave ', City__c = 'T', Zip__c = '92',State__c = 'CA', Property_Type__c = 'Residential', Alternate_Name__c = 'Test Prop');
            Property__c prop1 = new Property__c(Name = 'Test1', Address_Line_1__c = '92832 Laaf Palma Ave ', City__c = 'Ta', Zip__c = '92',State__c = 'CA', Property_Type__c = 'Residential', Alternate_Name__c = 'Test Prop');
            insert prop;
            insert prop1;
            Master_Job__c mj = new Master_Job__c(Name = 'Test', property__c = prop.id, Description_of_Loss__c = 'Description', Stage__c = 'Pre-work');
            Master_Job__c mj1 = new Master_Job__c(Name = 'Test1', property__c = prop1.id, Description_of_Loss__c = 'Description', Stage__c = 'Pre-work', Date_of_Loss__c = system.today());
            insert mj;
            insert mj1;
            BatchForMasterJobs b = new BatchForMasterJobs();
            Id ba = Database.executeBatch(b);
        }
    }
}