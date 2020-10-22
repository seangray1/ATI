@isTest
private class LargeLossUtility_Test {

static testmethod void LargeLossUtility_Test1() 
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
        
        ATI_Job__c job = jobs[0];
        Account [] acct= ObjectData.accountList;
        Contact [] cont = ObjectData.contactList;
        Master_Job__c [] masterjob = ObjectData.masterjobList;
        Office__c [] offices = ObjectData.OfficeList;
        User [] users = ObjectData.UserList;
        Property__c [] property = ObjectData.PropertyList;
        Test.startTest();
        Large_Loss_Review__c l = LargeLossUtility.CreateLargeLossRecord(job.Id);
        l.NLLS_Number__c = 0;
        insert l;
        system.debug('Large Loss is ' + l);
        List<Large_Loss_Review__c> lList = new List<Large_Loss_Review__c>();
        lList.add(l);
        Map<Id,Large_Loss_Review__c> lMap = new Map<Id,Large_Loss_Review__c>();
        lMap.put(l.Id, l);
        LargeLossUtility.AutoCreateNewLargeLoss(lMap, lList);
        LargeLossUtility.LargeLossApprovalSubmission(l.Id, 'Test');
        LargeLossUtility.getLargeLossReviews(l.Id);
        LargeLossUtility.ValidateRecord(job.Id);
        LargeLossUtility.RefreshLargeLoss(l.Id);
        LargeLossUtility.createNewLargeLoss(lMap);
        LargeLossUtility.PassTestMethod(lList);
        Test.stopTest();
       

        }

}
// static testmethod void NewJobController_Test1() 
// {
//     Id u2 = UserInfo.getUserId();
    
//     system.runAs(new User(Id=Userinfo.getUserId()))
//     {
//         Map <String, Schema.RecordTypeInfo> jobRecordTypeMap = Schema.SObjectType.ATI_job__c.RecordTypeInfosByName;
//         Id notApprovedId = Schema.SObjectType.ATI_job__c.RecordTypeInfosByName.get('New Job (Not Approved)').RecordTypeId;
//         Id approvedId = Schema.SObjectType.ATI_job__c.RecordTypeInfosByName.get('Job (Approved)').RecordTypeId;
//         Integer NumToInsert = 3;

//         ObjectInserts ObjectData = TestDataUtil.createObjects(NumToInsert, false);
//         List<ATI_Job__c> jobs = ObjectData.jobList;
//         insert jobs;
        
//         ATI_Job__c job = jobs[0];
//         Account [] acct= ObjectData.accountList;
//         Contact [] cont = ObjectData.contactList;
//         Master_Job__c [] masterjob = ObjectData.masterjobList;
//         Office__c [] offices = ObjectData.OfficeList;
//         User [] users = ObjectData.UserList;
//         Property__c [] property = ObjectData.PropertyList;
        
//         SubmitForApprovalExtension.submitForApproval(cont[0].Id);
//         SubmitForApprovalExtension.submitForApproval(job.Id);
//         String AccountRoleInfo = '{"AccountRoleLineItems":[{"Text":"Primary/Bill-to;Caller;Referred By;Project Site Contact","Contact":"' + cont[0].Id + '","Account":"' + acct[0].Id + '"}]}';
//         String PropertyInfo = '{"PropertyId":"","City":"El Monte","Country":"United States","State":"CA","Street":"3534 North Peck Road","Zip":"91731","AddressLine2":"444","AlternateName":"test23"}';
//         String JobInfo = '{"Description":"Type of Loss","JobRealName":"","Division":"Catastrophes","Office":"' + offices[0].Id + '","JobClass":"Educational - Private","ProjectDirector":"' + u2 + '","TakenBy":"' + u2 + '","Claim":"444","Policy":"444","JobName":"test job RQF x232","LeadSource":"Consulting Firm","MultipleDivisions":"Asbestos","DateOfLoss":"2020-05-07","ClientJob":"44","YearBuilt":"1999","MajorEvent":""}';
//         NewJobController.EditAccountRoles(AccountRoleInfo, job.id);
        
        
//     }
// }
}