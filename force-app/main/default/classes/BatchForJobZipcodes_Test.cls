@isTest
private with sharing class BatchForJobZipcodes_Test {
    static testMethod void BatchForJobs_Test() {
        Id u2 = UserInfo.getUserId();
        
        system.runAs(new User(Id=Userinfo.getUserId())){
            ObjectInserts ObjectData = TestDataUtil.createObjects(5, false);
            List<ATI_Job__c> jobs = ObjectData.jobList;
            insert jobs;
            ATI_Job__c job = jobs[0];
            Account [] acct= ObjectData.accountList;
            Contact [] cont = ObjectData.contactList;
            Master_Job__c [] masterjob = ObjectData.masterjobList;
            Office__c [] offices = ObjectData.OfficeList;
            User [] users = ObjectData.UserList;
            Property__c [] property = ObjectData.PropertyList;
            Office_Zip_Code__c z = new Office_Zip_Code__c(Office__c = offices[0].Id, Name = '90027');
            insert z;
            BatchToUpdateJobZipCodes b = new BatchToUpdateJobZipCodes();
            b.query = 'Select Id, Office2__r.Name, Office2__c, Project_Site_Zipcode__c FROM ATI_Job__c';
            Id ba = Database.executeBatch(b);
        }
    }
}