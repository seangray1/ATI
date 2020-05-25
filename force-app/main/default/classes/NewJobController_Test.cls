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
            Jobs[0].RecordTypeId = notApprovedId;
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
            String AccountRoleInfo = '{"AccountRoleLineItems":[{"Text":"Primary/Bill-to;Caller;Referred By;Project Site Contact","Contact":"' + lstContact[0].Id + '","Account":"' + lstAccounts[0].Id + '"}]}';
            String PropertyInfo = '{"PropertyId":"","City":"El Monte","Country":"United States","State":"CA","Street":"3534 North Peck Road","Zip":"91731","AddressLine2":"444","AlternateName":"test23"}';
            String JobInfo = '{"Description":"Type of Loss","JobRealName":"","Division":"Catastrophes","Office":"' + off.Id + '","JobClass":"Educational - Private","ProjectDirector":"' + u2 + '","TakenBy":"' + u2 + '","Claim":"444","Policy":"444","JobName":"test job RQF x232","LeadSource":"Consulting Firm","MultipleDivisions":"Asbestos","DateOfLoss":"2020-05-07","ClientJob":"44","YearBuilt":"1999","MajorEvent":""}';
            NewJobController.CreateNewJob(AccountRoleInfo, PropertyInfo, JobInfo, '', 'AfterHoursJobEntry', '', true);
            
            NewJobController.CreateNewProp(AccountRoleInfo, PropertyInfo);
            NewJobController.UpdateProperty(jobs[0].Property_Id__c, '15632 Youngwood Drive', 'Whittier', 'CA', '90603','USA');
        }
    }
}