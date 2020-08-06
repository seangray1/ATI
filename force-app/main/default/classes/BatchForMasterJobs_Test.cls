@isTest
private with sharing class BatchForMasterJobs_Test {
    static testMethod void BatchForMasterJobs_Test() {
        Id u2 = UserInfo.getUserId();
        
        system.runAs(new User(Id=Userinfo.getUserId())){
            ObjectInserts objectinfo = TestDataUtil.createObjects(10, true);
            objectinfo.jobList[0].Amount__c = 100;
            ATI_Job__c job = objectinfo.jobList[0];
            update job;
            BatchForMasterJobs b = new BatchForMasterJobs();
            b.query = 'Select Id, Amount__c, Name, Master_Job__c FROM ATI_Job__c';
            Id ba = Database.executeBatch(b);
        }
    }
}