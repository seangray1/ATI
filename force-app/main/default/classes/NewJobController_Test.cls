@isTest
private class NewJobController_Test {
    static testmethod void NewJobController_Test() {
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
            NewJobController.GetUserInfoAndIntakeStatus(jobs[0].id); 
            NewJobController.GetProperties('Test');
            NewJobController.GetOffices('HQ');
            NewJobController.CheckId(jobs[0].Property_Id__c);
           
            NewJobController.CheckId6(jobs[0].Property_Id__c);
            
            NewJobController.GetPropertyInfo('Whittier','15632 Youngwood Drive', 'CA', '90603');
            NewJobController.GetJobInfo(jobs[0].id);
            NewJobController.GetMajorEvents('Test');

            NewJobController.InsertContact('FirstName', 'LastName', 'test@gmail.com', '222-222-2222', 'Adjuster', '', '15632 Youngwood Drive', 'Whittier', 'CA', '90603', 'US', lstAccounts[0].Id, false);
            NewJobController.InsertAccount('Name',  '222-222-2222' , 'Farmers', '', '15632 Youngwood Drive', 'Whittier', 'CA', '90603', 'US');
            // NewJobController.GetAccountRoless(jobs[0].Property_Id__c);
            NewJobController.InsertPersonAccount('Name', 'LastName', '222-222-2222' , 's@gmail.com','Farmers', '', '15632 Youngwood Drive', 'Whittier', 'CA', '90603', 'US');
            // NewJobController.GetCustomers('Test');
            // NewJobController.GetDivisionPicklist();
            // NewJobController.GetDivisionPicklist1();
            // NewJobController.GetDivisionPicklist2();
            // NewJobController.GetDivisionPicklist3();
            
           
            // NewJobController.GetEsJobTypePicklist();
            // NewJobController.GetLeadSourcePicklist();
            // NewJobController.GetMultipleDivisionPicklist();
            // NewJobController.GetPropertyTypePicklist();
            // NewJobController.GetJobClassPicklist();
            // NewJobController.GetJobClassPicklist1();
            // NewJobController.GetJobClassPicklist2();
            // NewJobController.GetJobClassPicklist3();
            // NewJobController.GetJobClassPicklist4();
            // NewJobController.GetContactAccounts('Test');
            // NewJobController.getPickListValuesIntoList();
            // NewJobController.GetUserName();
            // NewJobController.GetUsers('Sean');
            // NewJobController.GetCustomers('Test');
            // NewJobController.GetUserInfo();
            NewJobController.AfterHoursJobCreation('TestJob', 'Construction', '', off.id, '15632 Youngwood Drive', 'CA', 'Whittier', '90603', 'US', '15632 Youngwood Drive', 'Test', 'Test', '', '');
            String AccountRoleInfo = '{"AccountRoleLineItems":[{"Text":"Primary/Bill-to;Caller;Referred By;Project Site Contact","Contact":"' + lstContact[0].Id + '","Account":"' + lstAccounts[0].Id + '"}]}';
            String PropertyInfo = '{"PropertyId":"","City":"El Monte","Country":"United States","State":"CA","Street":"3534 North Peck Road","Zip":"91731","AddressLine2":"444","AlternateName":"test23"}';
            String JobInfo = '{"Description":"Type of Loss","JobRealName":"","Division":"Catastrophes","Office":"' + off.Id + '","JobClass":"Educational - Private","ProjectDirector":"' + u2 + '","TakenBy":"' + u2 + '","Claim":"444","Policy":"444","JobName":"test job RQF x232","LeadSource":"Consulting Firm","MultipleDivisions":"Asbestos","DateOfLoss":"2020-05-07","ClientJob":"44","YearBuilt":"1999","MajorEvent":""}';
            // NewJobController.CreateNewJob(AccountRoleInfo, PropertyInfo, JobInfo, '', 'AfterHoursJobEntry', '', true);
            NewJobController.CreateNewJob(AccountRoleInfo, PropertyInfo, JobInfo, '', 'AfterHoursJobEntry', '', false);
            NewJobController.CreateNewJob(AccountRoleInfo, PropertyInfo, JobInfo, '', 'NewJobEntry', '', false);
            // NewJobController.CreateNewJob(AccountRoleInfo, PropertyInfo, JobInfo, '', 'AfterHoursJobEntry', '');
            // NewJobController.CreateNewProp(AccountRoleInfo, PropertyInfo);
            // NewJobController.UpdateProperty(jobs[0].Property_Id__c, '15632 Youngwood Drive', 'Whittier', 'CA', '90603','USA');
        }
        
    }
    static testmethod void NewJobController_Test1() {
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
            //Jobs[0].RecordTypeId = notApprovedId;
            Jobs[0].Job_Name__c ='test';
            
    
        
            
            insert Jobs;   
            NewJobController.GetProperties('Test');
            NewJobController.GetOffices('HQ');
            NewJobController.CheckId(jobs[0].Property_Id__c);
           
            NewJobController.CheckId6(jobs[0].Property_Id__c);
            
            NewJobController.GetPropertyInfo('Whittier','15632 Youngwood Drive', 'CA', '90603');
            NewJobController.GetJobInfo(jobs[0].id);
            NewJobController.GetMajorEvents('Test');

            NewJobController.InsertContact('FirstName', 'LastName', 'test@gmail.com', '222-222-2222', 'Adjuster', '', '15632 Youngwood Drive', 'Whittier', 'CA', '90603', 'US', lstAccounts[0].Id, false);
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
            SubmitForApprovalExtension.submitForApproval(jobs[0].Master_Job__c);
            SubmitForApprovalExtension.submitForApproval(lstContact[0].Id);
            String AccountRoleInfo = '{"AccountRoleLineItems":[{"Text":"Primary/Bill-to;Caller;Referred By;Project Site Contact","Contact":"' + lstContact[0].Id + '","Account":"' + lstAccounts[0].Id + '"}]}';
            String PropertyInfo = '{"PropertyId":"","City":"El Monte","Country":"United States","State":"CA","Street":"3534 North Peck Road","Zip":"91731","AddressLine2":"444","AlternateName":"test23"}';
            String JobInfo = '{"Description":"Type of Loss","JobRealName":"","Division":"Catastrophes","Office":"' + off.Id + '","JobClass":"Educational - Private","ProjectDirector":"' + u2 + '","TakenBy":"' + u2 + '","Claim":"444","Policy":"444","JobName":"test job RQF x232","LeadSource":"Consulting Firm","MultipleDivisions":"Asbestos","DateOfLoss":"2020-05-07","ClientJob":"44","YearBuilt":"1999","MajorEvent":""}';
            NewJobController.CreateNewJob(AccountRoleInfo, PropertyInfo, JobInfo, '', 'AfterHoursJobEntry', '', true);
            NewJobController.CreateNewJob(AccountRoleInfo, PropertyInfo, JobInfo, jobs[0].Master_Job__c, 'NewJobEntry', '', true);
            NewJobController.CreateNewJob(AccountRoleInfo, PropertyInfo, JobInfo, jobs[0].Master_Job__c, 'AfterHoursJobEntry', '', false);
            
            NewJobController.CreateNewProp(AccountRoleInfo, PropertyInfo);
            NewJobController.UpdateProperty(jobs[0].Property_Id__c, '15632 Youngwood Drive', 'Whittier', 'CA', '90603','USA');
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
    // public class ObjectData {
    //     public list<ATI_Job__c> jobList {get;set;}
    //     public list<Contact> contactList {get;set;}
    //     public list<Account> accountList {get;set;}
    //     public list<Master_Job__c> masterjobList {get;set;}
    //     public list<Property__c> propertyList {get;set;}
    // }
}