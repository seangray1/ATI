@isTest
private class JobTriggerHandlerWorkflowTest {
    static testmethod void NewJobController_Test3() 
{
    Id u2 = UserInfo.getUserId();

    system.runAs(new User(Id=Userinfo.getUserId()))
    {
        Map <String, Schema.RecordTypeInfo> jobRecordTypeMap = Schema.SObjectType.ATI_job__c.RecordTypeInfosByName;
        Id notApprovedId = Schema.SObjectType.ATI_job__c.RecordTypeInfosByName.get('New Job (Not Approved)').RecordTypeId;
        Id approvedId = Schema.SObjectType.ATI_job__c.RecordTypeInfosByName.get('Job (Approved)').RecordTypeId;
        Integer NumToInsert = 3;
        
        ObjectInserts ObjectData = TestDataUtil.createObjects(NumToInsert, false);
        List<ATI_Job__c> jobs = ObjectData.jobList;
        insert jobs;
        TestDataUtil.CreateObjectAccountRoles(NumToInsert, jobs, ObjectData.accountList, ObjectData.contactList);
        ATI_Job__c job = jobs[0];
        Account [] acct= ObjectData.accountList;
        Contact [] cont = ObjectData.contactList;
        Master_Job__c [] masterjob = ObjectData.masterjobList;
        Office__c [] offices = ObjectData.OfficeList;
        User [] users = ObjectData.UserList;
        Property__c [] property = ObjectData.PropertyList;
       
        JobTriggerHandlerWorkflow.CheckId6(jobs[0].Property_Id__c);
    }
}
}