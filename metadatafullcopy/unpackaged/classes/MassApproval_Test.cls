@isTest
public with sharing class MassApproval_Test {
    public MassApproval_Test() {

    }
    static testmethod void MassApprovalTest() 
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
        users[0].managerId = UserInfo.getUserId();
        update users;
        system.runAs(users[0])
        {
        List<Approval.ProcessSubmitRequest> allReq = new List<Approval.ProcessSubmitRequest>(); 
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setComments('Submitting request for approval.');
            req1.setProcessDefinitionNameOrId('Credit_Request_Approval_Process');
            req1.setObjectId(masterjob[0].Id);
            req1.setskipentrycriteria(true);
            
    		req1.submitterId = users[0].Id;
    		allreq.add(req1);
            Approval.ProcessResult[] result = Approval.process(allreq);
        }
            List<ProcessInstance> pda = [Select Id, targetObjectId, CreatedDate FROM PRocessInstance WHere Status = 'Pending'];
            ProcessInstance p = new ProcessInstance();
            for(ProcessInstance f : pda)
            {
                if(f.targetobjectId.getSObjectType().getDescribe().getName() == 'Master_Job__c')
                {
                    p = f;
                }
            }
            ProcessInstanceWorkItem p1 = [Select Id FROM PRocessInstanceWorkItem WHere ProcessInstanceId =: p.Id];
           

        

        List<Approval.ProcessSubmitRequest> allReq1 = new List<Approval.ProcessSubmitRequest>(); 
            Approval.ProcessSubmitRequest req12 = new Approval.ProcessSubmitRequest();
            req12.setComments('Submitting request for approval.');
            req12.setProcessDefinitionNameOrId('Credit_Request_Approval_Process');
            req12.setObjectId(masterjob[1].Id);
            req12.setskipentrycriteria(true);
    		req12.submitterId = UserInfo.getUserId();
    		allreq1.add(req12);
            Approval.ProcessResult[] result1 = Approval.process(allreq1);
            List<ProcessInstance> pda2 = [Select Id, targetObjectId, CreatedDate FROM PRocessInstance WHere Status = 'Pending'];
            ProcessInstance p3 = new ProcessInstance();
            for(ProcessInstance f : pda2)
            {
                if(f.targetobjectId.getSObjectType().getDescribe().getName() == 'Master_Job__c')
                {
                    p3 = f;
                }
            }
            List<Approval.ProcessSubmitRequest> allReq2 = new List<Approval.ProcessSubmitRequest>(); 
            Approval.ProcessSubmitRequest req123 = new Approval.ProcessSubmitRequest();
            req123.setComments('Submitting request for approval.');
            req123.setProcessDefinitionNameOrId('Contact_Ownership_Request_Approval');
            req123.setObjectId(cont[0].Id);
            req123.setskipentrycriteria(true);
    		req123.submitterId = UserInfo.getUserId();
    		allreq2.add(req123);
            Approval.ProcessResult[] result4 = Approval.process(allreq2);
            
            List<ProcessInstance> pda5 = [Select Id, targetObjectId, CreatedDate FROM PRocessInstance WHere Status = 'Pending'];
            ProcessInstance p5 = new ProcessInstance();
            for(ProcessInstance f : pda5)
            {
                if(f.targetobjectId.getSObjectType().getDescribe().getName() == 'Contact')
                {
                    p5 = f;
                }
            }

            ProcessInstanceWorkItem p12 = [Select Id FROM PRocessInstanceWorkItem WHere ProcessInstanceId =: p3.Id];
            ProcessInstanceWorkItem p125 = [Select Id FROM PRocessInstanceWorkItem WHere ProcessInstanceId =: p5.Id];
           
            string ItemsToApproveReject = '{"ItemsToApproveReject":[{"AccountName1":"EZ Realty & Property Mgmt","ContactName1":"tests agas","MasterJobName1":"123 Sesame St Kings Park NY &#124; 2020-06-26","ReferredBy1":"tests agas","processId":"'+ p125.Id + '","processinstanceId":"' + p5.Id + '","id":1,"MasterJob":null,"CreatedBy":"Sean Gray","AccountName":"/0010g00001bQoykAAC","ContactName":"/0030R000012jxB1QAI","ReferredBy":"/0030R000012jxB1QAI"}]}';
            DynamicApprovalController.ApproveSelectedItems(ItemsToApproveReject, 'Test', 'Approve', p1.Id);
            DynamicApprovalController.GetAccountData('Master Job');
            DynamicApprovalController.GetAccountData('Contact');
            string ItemsToApproveReject2 = '{"ItemsToApproveReject":[{"AccountName1":"EZ Realty & Property Mgmt","ContactName1":"tests agas","MasterJobName1":"123 Sesame St Kings Park NY &#124; 2020-06-26","ReferredBy1":"tests agas","processId":"'+ p12.Id + '","processinstanceId":"' + p3.Id + '","id":1,"MasterJob":"/' + masterjob[1].Id+ '","CreatedBy":"Sean Gray","AccountName":"/0010g00001bQoykAAC","ContactName":"/0030R000012jxB1QAI","ReferredBy":"/0030R000012jxB1QAI"}]}';
            Id queue = System.enqueueJob(new ApproveSelectedItemsQueueable(ItemsToApproveReject2, 'Test', 'Approve'));
            Id queue1 = System.enqueueJob(new ApproveSelectedItemsQueueable(ItemsToApproveReject, 'Test', 'Approve'));
    }

}
static testmethod void MassApprovalTest1() 
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
        
        SubmitForApprovalExtension.submitForApproval(cont[0].Id, 'Test');
        SubmitForApprovalExtension.submitForApproval(job.Id, 'Test ');
        SubmitForApprovalExtension.submitForApproval(masterjob[0].Id, 'Test ');
        // String AccountRoleInfo = '{"AccountRoleLineItems":[{"Text":"Primary/Bill-to;Caller;Referred By;Project Site Contact","Contact":"' + cont[0].Id + '","Account":"' + acct[0].Id + '"}]}';
        // String PropertyInfo = '{"PropertyId":"","City":"El Monte","Country":"United States","State":"CA","Street":"3534 North Peck Road","Zip":"91731","AddressLine2":"444","AlternateName":"test23"}';
        // String JobInfo = '{"Description":"Type of Loss","JobRealName":"","Division":"Catastrophes","Office":"' + offices[0].Id + '","JobClass":"Educational - Private","ProjectDirector":"' + u2 + '","TakenBy":"' + u2 + '","Claim":"444","Policy":"444","JobName":"test job RQF x232","LeadSource":"Consulting Firm","MultipleDivisions":"Asbestos","DateOfLoss":"2020-05-07","ClientJob":"44","YearBuilt":"1999","MajorEvent":""}';
        // NewJobController.EditAccountRoles(AccountRoleInfo, job.id);
        
        
    }
}
}