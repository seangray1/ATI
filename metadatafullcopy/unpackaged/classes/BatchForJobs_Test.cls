@isTest
private with sharing class BatchForJobs_Test {
    static testMethod void BatchForJobs_Test() {
        Id u2 = UserInfo.getUserId();
        
        system.runAs(new User(Id=Userinfo.getUserId())){
            ObjectInserts objectinfo = TestDataUtil.createObjects(5, true);
            objectinfo.accountroleList[0].Multiple_Roles__c = 'Insurance Adjuster/Company';
            update objectinfo.accountroleList;
            BatchForJobs b = new BatchForJobs();
            b.query = 'Select Id, Insurance_Company__c, Insurance_Adjuster_Broker__c FROM ATI_Job__c';
            Id ba = Database.executeBatch(b);
        }
    }
}