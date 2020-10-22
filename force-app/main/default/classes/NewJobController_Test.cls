@isTest
private class NewJobController_Test {

static testmethod void NewJobController_Test() 
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
       
        String AccountRoleInfo = '{"AccountRoleLineItems":[{"Text":"Primary/Bill-to;Caller;Referred By;Project Site Contact","Contact":"' + cont[0].Id + '","Account":"' + acct[0].Id + '"}]}';
        String PropertyInfo = '{"PropertyId":"","City":"El Monte","Country":"United States","State":"CA","Street":"3534 North Peck Road","Zip":"91731","AddressLine2":"444","AlternateName":"test23"}';
        String JobInfo = '{"Description":"Type of Loss","JobRealName":"","Division":"Catastrophes","Office":"' + offices[0].Id + '","JobClass":"Educational - Private","ProjectDirector":"' + u2 + '","TakenBy":"' + u2 + '","Claim":"444","Policy":"444","JobName":"test job RQF x232","LeadSource":"Consulting Firm","MultipleDivisions":"Asbestos","DateOfLoss":"2020-05-07","ClientJob":"44","YearBuilt":"1999","MajorEvent":""}';
        // NewJobController.CreateNewJob(AccountRoleInfo, PropertyInfo, JobInfo, '', 'AfterHoursJobEntry', '', true);
        NewJobController.CreateNewJob(AccountRoleInfo, PropertyInfo, JobInfo, '', 'AfterHoursJobEntry', '', false);
        NewJobController.CreateNewJob(AccountRoleInfo, PropertyInfo, JobInfo, '', 'NewJobEntry', '', false);
        NewJobController.CreateNewJob(AccountRoleInfo, PropertyInfo, JobInfo, job.Master_Job__c, 'AfterHoursJobEntry', '', false);

        }

}
static testmethod void NewJobController_Test1() 
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
        
        SubmitForApprovalExtension.submitForApproval(cont[0].Id,'Comments');
        SubmitForApprovalExtension.submitForApproval(job.Id, 'Comments');
        String AccountRoleInfo = '{"AccountRoleLineItems":[{"Text":"Primary/Bill-to;Caller;Referred By;Project Site Contact","Contact":"' + cont[0].Id + '","Account":"' + acct[0].Id + '"}]}';
        String PropertyInfo = '{"PropertyId":"","City":"El Monte","Country":"United States","State":"CA","Street":"3534 North Peck Road","Zip":"91731","AddressLine2":"444","AlternateName":"test23"}';
        String JobInfo = '{"Description":"Type of Loss","JobRealName":"","Division":"Catastrophes","Office":"' + offices[0].Id + '","JobClass":"Educational - Private","ProjectDirector":"' + u2 + '","TakenBy":"' + u2 + '","Claim":"444","Policy":"444","JobName":"test job RQF x232","LeadSource":"Consulting Firm","MultipleDivisions":"Asbestos","DateOfLoss":"2020-05-07","ClientJob":"44","YearBuilt":"1999","MajorEvent":""}';
        NewJobController.EditAccountRoles(AccountRoleInfo, job.id);
        
        
    }
}
    static testmethod void NewJobController_Test2() {
        Id u2 = UserInfo.getUserId();
        
        system.runAs(new User(Id=Userinfo.getUserId())){
            Map <String, Schema.RecordTypeInfo> jobRecordTypeMap = Schema.SObjectType.ATI_job__c.RecordTypeInfosByName;
            Id notApprovedId = Schema.SObjectType.ATI_job__c.RecordTypeInfosByName.get('New Job (Not Approved)').RecordTypeId;
            Id approvedId = Schema.SObjectType.ATI_job__c.RecordTypeInfosByName.get('Job (Approved)').RecordTypeId;
            Integer NumToInsert = 15;
            
            ObjectInserts ObjectData = TestDataUtil.createObjects(NumToInsert, false);
            Office__c off = new Office__c(Name = 'Anaheim', Branch_Manager__c = u2, Asbestos_Operations_Manager__c = u2);
            insert off;
            List<ATI_Job__c> jobs = ObjectData.jobList;
            jobs[0].RecordTypeId = notApprovedId;
            jobs[1].RecordTypeId = approvedId;
            
            jobs[13].Office2__c = off.Id;
            jobs[13].Division__c = 'Lead';
            jobs[14].Office2__c = off.Id;
            jobs[14].Division__c = 'Catastrophes';
            insert jobs;
            TestDataUtil.CreateObjectAccountRoles(NumToInsert, jobs, ObjectData.accountList, ObjectData.contactList);
            ATI_Job__c job = jobs[0];
            ATI_Job__c job1 = jobs[2];
            ATI_Job__c job5 = jobs[5];
            
            Account [] acct= ObjectData.accountList;
            Contact [] cont = ObjectData.contactList;
            Master_Job__c [] masterjob = ObjectData.masterjobList;
            Office__c [] offices = ObjectData.OfficeList;
            User [] users = ObjectData.UserList;
            Property__c [] property = ObjectData.PropertyList;
            
            job.RecordTypeId = approvedId;
            job.Stage__c = 'Won';
            job.Office2__c = offices[0].Id;
            job.Project_Manager_New__c = u2;
            job.Project_Manager__c = users[2].Id;
            job.Amount__c = 100;
            job.Division__c = 'Biohazard';

            job1.Master_Job__c = masterjob[4].Id;
            
            job1.Office2__c = offices[0].Id;
            job1.Division__c = 'Microbial';
            job1.Project_Manager_New__c = u2;
            job1.Project_Manager__c = users[2].Id;
            job1.Account_Executive_1__c = users[2].Id;
            job1.Account_Executive_2__c = users[3].Id;
            job1.Branch_Manager__c = users[4].Id;
            job5.Division__c = 'Catastrophes';
            List<ATI_Job__c> jobsToUpdate = new List<ATI_Job__c>();
            jobsToUpdate.add(job);
            jobsToUpdate.add(job1);
            jobsToUpdate.add(job5);
            
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new fake_AddTask());
            update jobsToUpdate;
            Test.stopTest();
            // Test.startTest();
            // Test.setMock(HttpCalloutMock.class, new MockHttpGoogleMapsResponse());
            // NewJobController.CreateNewJob(AccountRoleInfo, PropertyInfo, JobInfo, MasterJobId, JobEntryType, jobrecordId, ExistingMasterJob);
            // Test.stopTest();
            
        }
    }
    public class fake_AddTask implements HttpCalloutMock{
        // Implement this interface method
        public HTTPResponse respond(HTTPRequest req) {
            // Create a fake response
            string response = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'+
                '<soapenv:Body>'+
                '<ns1:addTaskForManagerResponse soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" xmlns:ns1="http://nads.econz.co.nz/timecard1/" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">'+
                '<addTaskForManagerResponse xsi:type="ns1:AddNewTaskResult" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ns1="http://nads.econz.co.nz/timecard1/">'+
                '<accessDeniedFailure xsi:type="ns2:AccessDeniedFailure" xsi:nil="true" xmlns:ns2="http://auth.soap.econz.co.nz" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" />'+
                '<validationFailure xsi:type="ns3:ValidationFailure" xsi:nil="true" xmlns:ns3="http://soap.econz.co.nz" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" />'+
                '</addTaskForManagerResponse>'+
                '</ns1:addTaskForManagerResponse>'+
                '</soapenv:Body>'+
                '</soapenv:Envelope>';
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(response);
            res.setStatusCode(200);
            return res;
        }
    }
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
        NewJobController.GetUserInfoAndIntakeStatus(jobs[0].id); 
        NewJobController.GetProperties('Test');
        NewJobController.GetOffices('HQ');
        NewJobController.CheckId(jobs[0].Property_Id__c);
        NewJobController.CheckId6(jobs[0].Property_Id__c);
        Create_Opportunity_Handler.CheckId6(jobs[0].Property_Id__c);
        NewJobController.GetPropertyInfo('Whittier','15632 Youngwood Drive', 'CA', '90603');
        NewJobController.GetJobInfo(jobs[0].id);
        NewJobController.GetMajorEvents('Test');
        NewJobController.InsertContact('FirstName', 'LastName', 'test@gmail.com', '222-222-2222', 'Adjuster', '', '15632 Youngwood Drive', 'Whittier', 'CA', '90603', 'US', acct[0].Id, false);
        NewJobController.InsertAccount('Name',  '222-222-2222' , 'Farmers', '', '15632 Youngwood Drive', 'Whittier', 'CA', '90603', 'US');
        NewJobController.InsertPersonAccount('Name', 'LastName', '222-222-2222' , 's@gmail.com','Farmers', '', '15632 Youngwood Drive', 'Whittier', 'CA', '90603', 'US');
        
        NewJobController.AfterHoursJobCreation('TestJob', 'Construction', '', offices[0].id, '15632 Youngwood Drive', 'CA', 'Whittier', '90603', 'US', '15632 Youngwood Drive', 'Test', 'Test', '', '', jobs[0].Id);
        NewJobController.UpdateProperty(jobs[0].Property_Id__c, '15632 Youngwood Drive', 'Whittier', 'CA', '90603','USA');

    }
}
static testmethod void NewJobController_Test4() 
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
        NewJobController.GetProperties('Test');
        NewJobController.GetOffices('HQ');
        NewJobController.CheckId(jobs[0].Property_Id__c);
        
        
        
        NewJobController.GetPropertyInfo('Whittier','15632 Youngwood Drive', 'CA', '90603');
        NewJobController.GetJobInfo(jobs[0].id);
        NewJobController.GetMajorEvents('Test');

        NewJobController.InsertContact('FirstName', 'LastName', 'test@gmail.com', '222-222-2222', 'Adjuster', '', '15632 Youngwood Drive', 'Whittier', 'CA', '90603', 'US', acct[0].Id, false);
        NewJobController.InsertAccount('Name',  '222-222-2222' , 'Farmers', '', '15632 Youngwood Drive', 'Whittier', 'CA', '90603', 'US');
        // NewJobController.GetAccountRoless(jobs[0].Property_Id__c);
        NewJobController.InsertPersonAccount('Name', 'LastName', '222-222-2222' , 's@gmail.com','Farmers', '', '15632 Youngwood Drive', 'Whittier', 'CA', '90603', 'US');
        NewJobController.GetCustomers('Test');
        NewJobController.GetDivisionPicklist();
        NewJobController.GetDivisionPicklist1();
        NewJobController.GetDivisionPicklist2();
        NewJobController.GetDivisionPicklist3();
        
        JobTriggerHandlerWorkflow.CheckId6(jobs[0].Property_Id__c);
        NewJobController.GetEsJobTypePicklist();
        NewJobController.GetLeadSourcePicklist();
        NewJobController.GetMultipleDivisionPicklist();
        NewJobController.GetPropertyTypePicklist();
        NewJobController.GetJobClassPicklist();
        NewJobController.GetJobClassPicklist1();
        NewJobController.GetJobClassPicklist2();
        NewJobController.GetJobClassPicklist3();
        NewJobController.GetJobClassPicklist4();
        NewJobController.GetContactAccounts('Test');
        NewJobController.getPickListValuesIntoList();
        NewJobController.GetUserName();
        NewJobController.GetUsers('Sean');
        NewJobController.GetCustomers('Test');
        NewJobController.GetUserInfo();
        SubmitForApprovalExtension.submitForApproval(jobs[0].Master_Job__c, 'Test');
        NewJobController.AfterHoursJobCreation('TestJob', 'Construction', '', offices[0].id, '15632 Youngwood Drive', 'CA', 'Whittier', '90603', 'US', '15632 Youngwood Drive', 'Test', 'Test', '', '', null);

    }
}
// static testmethod void NewJobController_Test5() 
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
//         TestDataUtil.CreateObjectAccountRoles(NumToInsert, jobs, ObjectData.accountList, ObjectData.contactList);
//         ATI_Job__c job = jobs[0];
//         Account [] acct= ObjectData.accountList;
//         Contact [] cont = ObjectData.contactList;
//         Master_Job__c [] masterjob = ObjectData.masterjobList;
//         Office__c [] offices = ObjectData.OfficeList;
//         User [] users = ObjectData.UserList;
//         Property__c [] property = ObjectData.PropertyList;
        
//         List<Approval.ProcessSubmitRequest> allReq = new List<Approval.ProcessSubmitRequest>(); 
//             Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
//             req1.setComments('Submitting request for approval.');
//             req1.setProcessDefinitionNameOrId('Credit_Request_Approval_Process');
//             req1.setObjectId(masterjob[0].Id);
//             req1.setskipentrycriteria(true);
//     		req1.submitterId = UserInfo.getUserId();
//     		allreq.add(req1);
//             Approval.ProcessResult[] result = Approval.process(allreq);
//             List<ProcessInstance> pda = [Select Id, targetObjectId, CreatedDate FROM PRocessInstance WHere Status = 'Pending'];
//             ProcessInstance p = new ProcessInstance();
//             for(ProcessInstance f : pda)
//             {
//                 if(f.targetobjectId.getSObjectType().getDescribe().getName() == 'Master_Job__c')
//                 {
//                     p = f;
//                 }
//             }
//             ProcessInstanceWorkItem p1 = [Select Id FROM PRocessInstanceWorkItem WHere ProcessInstanceId =: p.Id];
           

//         string ItemsToApproveReject = '{"ItemsToApproveReject":[{"AccountName1":"EZ Realty & Property Mgmt","ContactName1":"tests agas","MasterJobName1":"123 Sesame St Kings Park NY &#124; 2020-06-26","ReferredBy1":"tests agas","processId":"'+ p1.Id + '","processinstanceId":"' + p.Id + '","id":1,"MasterJob":"/a8G0R0000009dKCUAY","CreatedBy":"Sean Gray","AccountName":"/0010g00001bQoykAAC","ContactName":"/0030R000012jxB1QAI","ReferredBy":"/0030R000012jxB1QAI"}]}';
//         NewJobController.ApproveSelectedItems(ItemsToApproveReject, 'Test', 'Approve', p1.Id);
//         NewJobController.GetAccountData('Master Job');

//         List<Approval.ProcessSubmitRequest> allReq1 = new List<Approval.ProcessSubmitRequest>(); 
//             Approval.ProcessSubmitRequest req12 = new Approval.ProcessSubmitRequest();
//             req12.setComments('Submitting request for approval.');
//             req12.setProcessDefinitionNameOrId('Credit_Request_Approval_Process');
//             req12.setObjectId(masterjob[1].Id);
//             req12.setskipentrycriteria(true);
//     		req12.submitterId = UserInfo.getUserId();
//     		allreq1.add(req12);
//             Approval.ProcessResult[] result1 = Approval.process(allreq1);
//             List<ProcessInstance> pda2 = [Select Id, targetObjectId, CreatedDate FROM PRocessInstance WHere Status = 'Pending'];
//             ProcessInstance p3 = new ProcessInstance();
//             for(ProcessInstance f : pda2)
//             {
//                 if(f.targetobjectId.getSObjectType().getDescribe().getName() == 'Master_Job__c')
//                 {
//                     p3 = f;
//                 }
//             }
//             ProcessInstanceWorkItem p12 = [Select Id FROM PRocessInstanceWorkItem WHere ProcessInstanceId =: p3.Id];
           

//         string ItemsToApproveReject2 = '{"ItemsToApproveReject":[{"AccountName1":"EZ Realty & Property Mgmt","ContactName1":"tests agas","MasterJobName1":"123 Sesame St Kings Park NY &#124; 2020-06-26","ReferredBy1":"tests agas","processId":"'+ p12.Id + '","processinstanceId":"' + p3.Id + '","id":1,"MasterJob":"/a8G0R0000009dKCUAY","CreatedBy":"Sean Gray","AccountName":"/0010g00001bQoykAAC","ContactName":"/0030R000012jxB1QAI","ReferredBy":"/0030R000012jxB1QAI"}]}';
//         Id queue = System.enqueueJob(new ApproveSelectedItemsQueueable(ItemsToApproveReject2, 'Test', 'Approve'));
//     }

// }
static testmethod void NewJobController_Test6() 
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
        // TestDataUtil.CreateObjectAccountRoles(NumToInsert, jobs, ObjectData.accountList, ObjectData.contactList);
        ATI_Job__c job = jobs[0];
        Account [] acct= ObjectData.accountList;
        Contact [] cont = ObjectData.contactList;
        Master_Job__c [] masterjob = ObjectData.masterjobList;
        Office__c [] offices = ObjectData.OfficeList;
        User [] users = ObjectData.UserList;
        Property__c [] property = ObjectData.PropertyList;
        String AccountRoleInfo = '{"AccountRoleLineItems":[{"Text":"Primary/Bill-to;Caller;Referred By;Project Site Contact","Contact":"' + cont[0].Id + '","Account":"' + acct[0].Id + '"}]}';
        String PropertyInfo = '{"PropertyId":"","City":"El Monte","Country":"United States","State":"CA","Street":"3534 North Peck Road","Zip":"91731","AddressLine2":"444","AlternateName":"test23"}';
        String JobInfo = '{"Description":"Type of Loss","JobRealName":"","Division":"Catastrophes","Office":"' + offices[0].Id + '","JobClass":"Educational - Private","ProjectDirector":"' + u2 + '","TakenBy":"' + u2 + '","Claim":"444","Policy":"444","JobName":"test job RQF x232","LeadSource":"Consulting Firm","MultipleDivisions":"Asbestos","DateOfLoss":"2020-05-07","ClientJob":"44","YearBuilt":"1999","MajorEvent":""}';
        NewJobController.EditAccountRoles(AccountRoleInfo, job.id);
        NewJobController.CreateNewJob(AccountRoleInfo, PropertyInfo, JobInfo, '', 'AfterHoursJobEntry', '', true);
        NewJobController.CreateNewJob(AccountRoleInfo, PropertyInfo, JobInfo, jobs[0].Master_Job__c, 'NewJobEntry', '', true);

        
        NewJobController.CreateNewProp(AccountRoleInfo, PropertyInfo);
        // Test.startTest();
        //     Map<String,String> fotoinheaders = new Map<String,String>();
        //     fotoinheaders.put('Content-Type', 'application/json');
        //     Map<String,String> googleheaders = new Map<String,String>();
        //     googleheaders.put('Content-Type', 'application/json');
        //     String outPutJson = '{"location": { "lat": 37.09024, "lng": -95.712891}}';
        //     String outputJsonAddress = '{{"results" : [{"access_points" : [],"address_components" : [{"long_name" : "15632","short_name" : "15632","types" : [ "street_number" ]},{"long_name" : "Youngwood Drive","short_name" : "Youngwood Dr","types" : [ "route" ]},{"long_name" : "East Whitter","short_name" : "East Whitter","types" : [ "neighborhood", "political" ]},{"long_name" : "Whittier","short_name" : "Whittier","types" : [ "locality", "political" ]},{"long_name" : "Los Angeles County","short_name" : "Los Angeles County","types" : [ "administrative_area_level_2", "political" ]},{"long_name" : "California","short_name" : "CA","types" : [ "administrative_area_level_1", "political" ]},{"long_name" : "United States","short_name" : "US","types" : [ "country", "political" ]},{"long_name" : "90603","short_name" : "90603","types" : [ "postal_code" ]},{"long_name" : "1235","short_name" : "1235","types" : [ "postal_code_suffix" ]}],"formatted_address" : "15632 Youngwood Dr, Whittier, CA 90603, USA","geometry" : {"bounds" : {"northeast" : {"lat" : 33.9551556,"lng" : -117.9936276},"southwest" : {"lat" : 33.9549415,"lng" : -117.9938733}},"location" : {"lat" : 33.9550515,"lng" : -117.9937451},"location_type" : "ROOFTOP","viewport" : {"northeast" : {"lat" : 33.9563975302915,"lng" : -117.9924014697085},"southwest" : {"lat" : 33.9536995697085,"lng" : -117.9950994302915}}},"place_id" : "ChIJ--yIXe3UwoARtn_JzLhd-i0","types" : [ "premise" ]}],"status" : "OK"}';
        //     SingleRequestMock fakeAccountResp = new SingleRequestMock(200,
        //                                                  '200',
        //                                                  outPutJson,
        //                                                  fotoinheaders);
 
        //     SingleRequestMock fakeContactsResp = new SingleRequestMock(200,
        //                                           'Complete',
        //                                           outputJsonAddress,
        //                                            googleheaders);
 
            // Map<String, HttpCalloutMock> endpoint2TestResp =
            //                         new Map<String,HttpCalloutMock>();
            // endpoint2TestResp.put('https://maps.googleapis.com/maps/api/geocode/json?key=AIzaSyBuE7iBv1fugjx2Az7h-bCwJCoWOadglz8&address=',fakeAccountResp);
            // endpoint2TestResp.put('https://maps.googleapis.com/maps/api/geocode/json?key=AIzaSyBuE7iBv1fugjx2Az7h-bCwJCoWOadglz8&address=',fakeContactsResp);
    
            // HttpCalloutMock multiCalloutMock =
            //                         new MultiRequestMock(endpoint2TestResp);
    
            //Test.setMock(HttpCalloutMock.class, multiCalloutMock);
            // Test.setMock(HttpCalloutMock.class, fakeContactsResp);
            //     // Test.setMock(HttpCalloutMock.class, new MockHttpFotoIn(200, 'success', outPutJson, null));
            //     // Test.setMock(HttpCalloutMock.class, new MockHttpGoogleMapsResponse(200, 'success', outputJsonAddress, null));
                
            
        
            //     jobs[0].Project_Site_City__c ='Test FotoIN Add';
            //     // Id fotonInQueue = System.enqueueJob(new FotoIn_Queueable_Integration(jobs, 'Edit'));
            // Test.stopTest();
        
        

    }

}
static testmethod void NewJobController_Test7() 
{
    Id u2 = UserInfo.getUserId();

    system.runAs(new User(Id=Userinfo.getUserId()))
    {
        Map <String, Schema.RecordTypeInfo> jobRecordTypeMap = Schema.SObjectType.ATI_job__c.RecordTypeInfosByName;
        Id notApprovedId = Schema.SObjectType.ATI_job__c.RecordTypeInfosByName.get('New Job (Not Approved)').RecordTypeId;
        Id approvedId = Schema.SObjectType.ATI_job__c.RecordTypeInfosByName.get('Job (Approved)').RecordTypeId;
        Integer NumToInsert = 3;
        
        Map<String,String> fotoinheaders = new Map<String,String>();
        fotoinheaders.put('Content-Type', 'application/json');
        Map<String,String> googleheaders = new Map<String,String>();
        googleheaders.put('Content-Type', 'application/json');
        String outPutJson = '{"location": { "lat": 37.09024, "lng": -95.712891}}';
        String outputJsonAddress = '{"results" : [{"access_points" : [],"address_components" : [{"long_name" : "15632","short_name" : "15632","types" : [ "street_number" ]},{"long_name" : "Youngwood Drive","short_name" : "Youngwood Dr","types" : [ "route" ]},{"long_name" : "East Whitter","short_name" : "East Whitter","types" : [ "neighborhood", "political" ]},{"long_name" : "Whittier","short_name" : "Whittier","types" : [ "locality", "political" ]},{"long_name" : "Los Angeles County","short_name" : "Los Angeles County","types" : [ "administrative_area_level_2", "political" ]},{"long_name" : "California","short_name" : "CA","types" : [ "administrative_area_level_1", "political" ]},{"long_name" : "United States","short_name" : "US","types" : [ "country", "political" ]},{"long_name" : "90603","short_name" : "90603","types" : [ "postal_code" ]},{"long_name" : "1235","short_name" : "1235","types" : [ "postal_code_suffix" ]}],"formatted_address" : "15632 Youngwood Dr, Whittier, CA 90603, USA","geometry" : {"bounds" : {"northeast" : {"lat" : 33.9551556,"lng" : -117.9936276},"southwest" : {"lat" : 33.9549415,"lng" : -117.9938733}},"location" : {"lat" : 33.9550515,"lng" : -117.9937451},"location_type" : "ROOFTOP","viewport" : {"northeast" : {"lat" : 33.9563975302915,"lng" : -117.9924014697085},"southwest" : {"lat" : 33.9536995697085,"lng" : -117.9950994302915}}},"place_id" : "ChIJ--yIXe3UwoARtn_JzLhd-i0","types" : [ "premise" ]}],"status" : "OK"}';
        SingleRequestMock fakeAccountResp = new SingleRequestMock(200,
                                                        '200',
                                                        outPutJson,
                                                        fotoinheaders);

        SingleRequestMock fakeContactsResp = new SingleRequestMock(200,
                                                'Complete',
                                                outputJsonAddress,
                                                googleheaders);

            //Test.setMock(HttpCalloutMock.class, fakeContactsResp);
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
        NewJobController.RetrieveAccountRoles(property[0].Id);
        NewJobController.GetJobAccountRoles(masterjob[0].Id);
        NewJobController.GetMasterJobs(property[0].Id);

        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, fakeContactsResp);
        NewJobController.GoogleCallout('TestMethod', 'Whittier', '90603', 'CA');
        
        Test.stopTest();
        
        
    }
}
    // public class ObjectData {
    //     public list<ATI_Job__c> jobList {get;set;}
    //     public list<Contact> contactList {get;set;}
    //     public list<Account> accountList {get;set;}
    //     public list<Master_Job__c> masterjobList {get;set;}
    //     public list<Property__c> propertyList {get;set;}
    // }
// static testmethod void NewJobController_Test5() 
// {
//     Id u2 = UserInfo.getUserId();

//     system.runAs(new User(Id=Userinfo.getUserId()))
//     {
        
//         Integer NumToInsert = 10;
        
//         ObjectInserts ObjectData = TestDataUtil.createObjects(NumToInsert, true);
//     }
// }
}