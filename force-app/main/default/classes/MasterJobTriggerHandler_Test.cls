@isTest
public with sharing class MasterJobTriggerHandler_Test {
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
        Master_Job__c mj = masterjob[0];
        Property__c prop = property[0];
        mj.Credit_Request_Submitter_Email__c = 'sean.gray@atirestoration.com';
        update mj;
        prop.Alternate_Name__c = 'Test Job 1';
        prop.Address_Line_1__c = '3423';
        update prop;
        mj.Credit_Request_Status__c = 'Approved';
        mj.Property__c = property[1].Id;
        update mj;   
        }

}
//     static testMethod void MasterJobInsertUpdate() {
//         Id u2 = UserInfo.getUserId();
        
//         system.runAs(new User(Id=Userinfo.getUserId())){
            
//             Map <String, Schema.RecordTypeInfo> jobRecordTypeMap = Schema.SObjectType.ATI_job__c.RecordTypeInfosByName;
//             Id notApprovedId = Schema.SObjectType.ATI_job__c.RecordTypeInfosByName.get('New Job (Not Approved)').RecordTypeId;
//             Id approvedId = Schema.SObjectType.ATI_job__c.RecordTypeInfosByName.get('Job (Approved)').RecordTypeId;
    
//             TestDataUtil.createCustomSettings_TriggerStatus();
//             //create Account 
//             Office__c off = new Office__c(Name = 'HQ');
//             insert off;
//             list<Account> lstAccounts = TestDataUtil.createAccounts(2, false, new map<String,Object>());
//             lstAccounts[0].type ='Property Owner';             
//             insert lstAccounts;
            
//             lstAccounts[0].Status__c = 'Approved';
//             update lstAccounts;
            
//             list<contact> lstContact = TestDataUtil.createContacts(2, false, new map<String,Object>(), lstAccounts[0].Id);
//             insert lstContact;
//             Property__c p = new Property__c(Name = 'Test', Alternate_Name__c = 'Test Job', Address_Line_1__c = '15632 La Palma', City__c = 'Anaheim', State__c='CA');
//         insert p;
//         Master_Job__c mj = new Master_Job__c(Name = 'Test', property__c = p.Id, Stage__c = 'Pre-work', Credit_Request_Submitter_Email__c = 'sean.gray@atirestoration.com');
//         insert mj;
//             List<ATI_Job__c> jobs = new List<ATI_Job__c>();
//             Jobs = TestDataUtil.createJob(1, false, new map<String,Object>(), lstAccounts[0].Id);
    
//             Jobs[0].contact__c = lstContact[0].id;
//             Jobs[0].Project_Site_Contact_Name__c = lstContact[1].id;
//             Jobs[0].Insurance_Adjuster_Broker__c = lstContact[0].id;
//             Jobs[0].Primary_Account__c = 'Caller Account';
//             Jobs[0].Project_Site_Address__c = '7550 st. patrick way';
//             Jobs[0].Project_Site_Address_2__c = '';
//             Jobs[0].Project_Site_City__c = 'Dublin';
//             Jobs[0].Project_Site_State__c = 'CA';
//             Jobs[0].Project_Site_Zipcode__c = '94568';
//             Jobs[0].Project_Site_Contact_Account__c = lstAccounts[0].id;
//             Jobs[0].Project_Site_Record_Id__c = '12345';
//             Jobs[0].RecordTypeId = notApprovedId;
//             Jobs[0].Job_Name__c ='test';
//             jobs[0].Property_ID__c = p.Id;
//             jobs[0].Master_Job__c = mj.id;

//             insert Jobs; 
//             Master_Job__c m12 = new Master_Job__c(Name = 'test123', Id = Jobs[0].Master_Job__c, Date_Of_Loss__c = system.today() + 3);
//             update m12; 

        
//         system.debug('Property is ' + p);
        
//         Master_Job__c mj1 = new Master_Job__c(Name = 'Test', Address_Line_1__c = '123', State__c = 'CA', City__c = 'Whit', Stage__c = 'Pre-work', Credit_Request_Submitter_Email__c = 'sean.gray@atirestoration.com');
//         insert mj1;
        
//         system.debug('Master Job is ' + mj);
//         p.Alternate_Name__c = 'Test Job 1';
//         p.Address_Line_1__c = '3423';
//         update p;
//         system.debug('Job address is now ' + jobs[0].Project_Site_Address__c);
//         mj.Date_of_Loss__c = system.today() + 1;
//         mj.Credit_Request_Status__c = 'Approved';
        
//         update mj;
//         mj1.Property__c = p.Id;
//         update mj1;
//         mj1.Date_Of_Loss__c = system.today();
//         update mj1;
//     }
// }
    static testMethod void PropertyMassInsert() {
        List<Property__c> props = new List<Property__c>();
        for(Integer i = 0; i<5;i++){
            Property__c p = new Property__c(Name = 'Test' + i, Alternate_Name__c = 'Test Job' + i, Address_Line_1__c = '15632 La Palma' + i, City__c = 'Anaheim' + i, State__c='CA');
            Property__c p1 = new Property__c(Name = 'Test' + i,  Address_Line_1__c = '15632 La Palma' + i, City__c = 'Anaheim' + i, State__c='CA');
            props.add(p);
            props.add(p1);
        }
        insert props;
       
    }
}