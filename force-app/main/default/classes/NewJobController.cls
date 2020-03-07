/**
 * @File Name          : NewJobController.cls
 * @Description        : 
 * @Author             : sean.gray@atirestoration.com
 * @Group              : 
 * @Last Modified By   : sean.gray@atirestoration.com
 * @Last Modified On   : 3/3/2020, 11:37:29 AM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    1/28/2020   sean.gray@atirestoration.com     Initial Version
**/
public with sharing class NewJobController {
    @AuraEnabled
    public static string InsertContact(String FirstName, String LastName, String Email, String Phone, String Type, String PhoneExt,
                                         String MailingStreet, String MailingCity, String MailingState,
                                        String MailingPostalCode, String MailingCountry, String AccountId, Boolean AccountList){
                                            system.debug(FirstName +'     ' +LastName+ '      '+  Phone + '     ' +Type + '     ' +PhoneExt + '     ' +MailingStreet + '     ' +MailingCity+ '     ' +MailingState +'     ' + MailingPostalCode + '     ' +MailingCountry + '   ' + AccountId);
         //AccountList false if accountlist..
    //      Id conId;
    //      if(!AccountList){
    //     AccountWrapper accountWrap = (AccountWrapper)JSON.deserialize(AccountId, AccountWrapper.class);
       
    //     system.debug('Account Id ' + accountWrap.AccountId);
    //     for(Id ca : accountWrap.AccountId){
    //         conId = ca;
    //     }
    // }   
    //     if(AccountList){
    //         AccountId acctId = (AccountId)JSON.deserialize(AccountId, AccountId.class);
    //         conId = acctId.AccountId;
    //     }
        Contact cont = new Contact(AccountId = AccountId, Email = Email, FirstName = FirstName, LastName = LastName, Phone = Phone, Contact_Type__c =Type, Phone_Ext__c = PhoneExt,  MailingStreet = MailingStreet,
                                    MailingState = MailingState, MailingPostalCode = MailingPostalCode, MailingCity = MailingCity, MailingCountry = MailingCountry);
         
                                    //IsPersonType = PersonAccount,
        try {
            insert cont;
            return cont.id;
        } catch (Exception e) {
            return string.valueOf(e);
        }
       
        
        
    }
    @AuraEnabled
    public static Account InsertAccount(String Name, String Phone, String Type, String PhoneExt,
                                         String BillingStreet, String BillingCity, String BillingState,
                                        String BillingPostalCode, String BillingCountry){
                                            system.debug(Name +'     ' + Phone + '     ' +Type + '     ' +PhoneExt + '     ' +BillingStreet + '     ' +BillingCity+ '     ' +BillingState +'     ' + BillingPostalCode + '     ' +BillingCountry);
        Account acct = new Account(Name = Name, Phone = Phone, Type = Type, Phone_Ext__c = PhoneExt,  BillingStreet = BillingStreet,
                                    BillingState = BillingState, BillingPostalCode = BillingPostalCode, BillingCity = BillingCity, BillingCountry = BillingCountry);
                                    //IsPersonType = PersonAccount,
        
        try {
            insert acct;
        return acct;
        } catch (Exception e) {
            acct.name = string.valueOf(e);
            return acct;
        }
        
    }
    @AuraEnabled
    public static string InsertPersonAccount(String FirstName, String LastName, String Phone, String Type, String PhoneExt,
                                         String BillingStreet, String BillingCity, String BillingState,
                                        String BillingPostalCode, String BillingCountry){
                                            system.debug(FirstName + '     ' + LastName +'     ' + Phone + '     ' +Type + '     ' +PhoneExt + '     ' +BillingStreet + '     ' +BillingCity+ '     ' +BillingState +'     ' + BillingPostalCode + '     ' +BillingCountry);
        RecordType personAccountRecordType =  [SELECT Id FROM RecordType WHERE Name = 'Person Accounts' and SObjectType = 'Account'];
        Account acct = new Account(FirstName = FirstName, LastName= LastName,  Phone = Phone, Type = Type, Phone_Ext__c = PhoneExt, RecordType = personAccountRecordType,  BillingStreet = BillingStreet,
                                    BillingState = BillingState, BillingCity = BillingCity, BillingPostalCode = BillingPostalCode, BillingCountry = BillingCountry);
        try {
            insert acct;
            return acct.id;
        } catch (Exception e) {
            return String.valueOf(e);
        }                       //IsPersonType = PersonAccount,
        
        
        
    }
    @AuraEnabled
    public static List<Account_Roles__c> GetAccountRoless(String PropertyId) {
        Id PropertyIDFinal;
        system.debug('Property is ' + PropertyID);
        JSONWrapper PropertyIDs = (JSONWrapper)JSON.deserialize(PropertyId, JSONWrapper.class);
        // for(Id ca : PropertyIDs.PropertyID){
        // PropertyIDFinal = ca; }
        system.debug('PropertyID is ' + PropertyID);
        List<Account_Roles__c> a = [Select Name FROM Account_Roles__c Where Property_ID__c =: PropertyIDs.PropertyID];
        system.debug('Account roles are ' + a);
        return a;
    }
    public class JSONWrapper{
        public List<Id> PropertyId {get;set;}
    }
    @AuraEnabled(cacheable = true)
    public static List<Property__c> GetProperties(String searchKey) {
        
        system.debug('Property is ' + searchKey);
        //JSONWrapper PropertyIDs = (JSONWrapper)JSON.deserialize(PropertyId, JSONWrapper.class);
        // for(Id ca : PropertyIDs.PropertyID){
        // PropertyIDFinal = ca; }
        String searchLikeKey = searchKey + '%';
        List<Property__c> props = [Select Id, Name, State__c, City__c, Street__c, Address_Line_1__c, Zip__c FROM Property__c Where Address_Line_1__c Like : searchLikeKey LIMIT 5];
        system.debug('Properties are ' + props);
        return props;
    }
    @AuraEnabled(cacheable = true)
    public static List<Office__c> GetOffices(String searchKey) {
        String searchLikeKey = '%' + searchKey + '%';
        List<Office__c> off = [Select Id, Name FROM Office__c Where Name Like : searchLikeKey LIMIT 5];
        
        return off;
    }
    @AuraEnabled(cacheable = true)
    public static List<Contact> GetCustomers(String searchKey) {
        
        system.debug('Customer Key is ' + searchKey);
        //JSONWrapper PropertyIDs = (JSONWrapper)JSON.deserialize(PropertyId, JSONWrapper.class);
        // for(Id ca : PropertyIDs.PropertyID){
        // PropertyIDFinal = ca; }
        String searchLikeKey = '%' + searchKey + '%';
        List<Contact> conts = [Select Id, LastName, FirstName, Account.Name, Account.Id, Name FROM Contact Where Name Like : searchLikeKey Limit 10];
        system.debug('Contacts are ' + conts);
        return conts;
    }
    @AuraEnabled(cacheable = true)
    public static List<Account> GetContactAccounts(String searchKey) {
        
        system.debug('Customer Key is ' + searchKey);
        //JSONWrapper PropertyIDs = (JSONWrapper)JSON.deserialize(PropertyId, JSONWrapper.class);
        // for(Id ca : PropertyIDs.PropertyID){
        // PropertyIDFinal = ca; }
        String searchLikeKey = searchKey + '%';
        List<Account> accts = [Select Id,Name FROM Account Where Name Like : searchLikeKey Limit 6];
        system.debug('Contacts are ' + accts);
        return accts;
    }
    
    @AuraEnabled 
    public static list<Account_Roles__c> CheckId(string propId){
        List<Account_Roles__c> a = [Select Id, Name, Roles__c, Contact_ID__c, Multiple_Roles__c, Address__c, Text__c, Account_ID__c FROM Account_Roles__c Where Property_ID__c =: propId];
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        system.debug('Prop Id + ' + propId);
        system.debug('Contact ID is ' + a);
        return a;

    }
    @AuraEnabled 
    public static list<Master_Job__c> GetMasterJobs(string propId){
        List<Master_Job__c> mj = [Select Id, Name, Stage__c, Property__c, Cont_P_O_Client_Job__c, Claim__c,  Date_of_Loss__c, Deductible__c, Description_of_Loss__c,Lead_Source__c, Multiple_Divisions__c  FROM Master_Job__c Where Property__c =: propId AND Active__c = true];
        system.debug('Prop Id + ' + propId);
        
        return mj;

        
    }
    @AuraEnabled(cacheable = true)
    public static List<User> GetUsers(String searchKey) {
        system.debug('Customer Key is ' + searchKey);
        String searchLikeKey = searchKey + '%';
        List<User> users = [Select Id,Name FROM User Where Name Like : searchLikeKey Limit 5];
       
        return users;
    }
    @AuraEnabled  
    public static string GetUserName(){  
            String Name = UserInfo.getName();
                return Name;
            }
    @AuraEnabled  
    public static List<String> getPickListValuesIntoList(){  
               List<String> pickListValuesList= new List<String>(); 
                Schema.DescribeFieldResult fieldResult = Account_Roles__c.Roles__c.getDescribe();   
                List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();   
                for( Schema.PicklistEntry pickListVal : ple){  
                  pickListValuesList.add(pickListVal.getLabel());  
                }       
                return pickListValuesList;
            }
            
    @AuraEnabled  
    public static List<String> GetPropertyTypePicklist(){  
               List<String> pickListValuesList= new List<String>(); 
                Schema.DescribeFieldResult fieldResult = Property__c.Property_Type__c.getDescribe();   
                List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();   
                for( Schema.PicklistEntry pickListVal : ple){  
                  pickListValuesList.add(pickListVal.getLabel());  
                }       
                return pickListValuesList;
            }
    @AuraEnabled  
    public static List<String> GetDivisionPicklist(){  
        List<String> pickListValuesList= new List<String>(); 
         Schema.DescribeFieldResult fieldResult = ATI_Job__c.Division__c.getDescribe();   
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();   
             for( Schema.PicklistEntry pickListVal : ple){  
                    pickListValuesList.add(pickListVal.getLabel());  
                }       
                return pickListValuesList;
            }
        
    @AuraEnabled  
    public static List<String> GetJobClassPicklist(){  
        List<String> pickListValuesList= new List<String>(); 
         Schema.DescribeFieldResult fieldResult = ATI_Job__c.Job_Class__c.getDescribe();   
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();   
             for( Schema.PicklistEntry pickListVal : ple){  
                    pickListValuesList.add(pickListVal.getLabel());  
                }       
                return pickListValuesList;
            }
    
    @AuraEnabled  
    public static List<String> GetEsJobTypePicklist(){  
        List<String> pickListValuesList= new List<String>(); 
         Schema.DescribeFieldResult fieldResult = ATI_Job__c.Es_Job_Type__c.getDescribe();   
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();   
             for( Schema.PicklistEntry pickListVal : ple){  
                    pickListValuesList.add(pickListVal.getLabel());  
                }       
                return pickListValuesList;
            }
    @AuraEnabled  
    public static List<String> GetLeadSourcePicklist(){  
        List<String> pickListValuesList= new List<String>(); 
         Schema.DescribeFieldResult fieldResult = ATI_Job__c.Lead_Source__c.getDescribe();   
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();   
             for( Schema.PicklistEntry pickListVal : ple){  
                    pickListValuesList.add(pickListVal.getLabel());  
                }       
                return pickListValuesList;
            }  
                 
    @AuraEnabled  
    public static List<String> GetMultipleDivisionPicklist(){  
        List<String> pickListValuesList= new List<String>(); 
         Schema.DescribeFieldResult fieldResult = Master_Job__c.Multiple_Divisions__c.getDescribe();   
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();   
             for( Schema.PicklistEntry pickListVal : ple){  
                    pickListValuesList.add(pickListVal.getLabel());  
                }       
                return pickListValuesList;
            }  
    @AuraEnabled
    public static Id AfterHoursJobCreation(String JobName, String Division, String EsJobType, Id Office, String Street, String State, String City, String ZipCode, String Country,
    String AddressLine2, String Comments, String Description){
        //Create Master Job
        //a. Office goes on Master, State City Zip goes on job. Description goes on Master
        //Create Job, then future callout to update Master with job id?  job needs to have all fields, but also Account needs to be EsAccount to lookup
        // also set job record type to approved..
        system.debug('Before Master Job creation');
        try {
        Master_Job__c mj = new Master_Job__c(Office2__c = Office, Description_of_Loss__c = Description, Stage__c = 'Pre-work');
        insert mj;
        system.debug('After Master Job creation');
        Id userId = userinfo.getUserId();
        Map <String, Schema.RecordTypeInfo> jobRecordTypeMap = Schema.SObjectType.ATI_Job__c.RecordTypeInfosByName;
        Id recordtypeid = Schema.SObjectType.ATI_Job__c.RecordTypeInfosByName.get('Job (Approved)').getRecordTypeId();
            
       
        string address = Street + ' , ' + State + ' , ' + City + ' ' + ZipCode;
        system.debug('Before Job creation');
        ATI_Job__c job = new ATI_Job__c(Name = 'Test Job 1',  Job_Name__c = JobName, Stage__c = 'Qualification', Taken_By__c = userId,
        Office2__c = Office, Master_Job__c = mj.id, recordtypeId = recordtypeid, Description__c = Description, Project_Site_Address__c = address, Project_Site_Address_2__c = AddressLine2,
        Project_Site_City__c = City, Project_Site_State__c = State, Project_Site_Zipcode__c = ZipCode, Comments__c = Comments);
        insert job;
        system.debug('After Job creation');
        return job.id;
        }
        catch (Exception e) {
            return e.getMessage();
        }
    }                
    @AuraEnabled 
    public static Id CreateNewJob(string AccountRoleInfo,string PropertyInfo, string JobInfo, string MasterJobId){
        system.debug('AccountRole Info ' + AccountRoleInfo);
        system.debug('Master Job Id ' + MasterJobId);
        system.debug('Property Info ' + PropertyInfo);
        system.debug('Job Info ' + JobInfo);
        Master_Job__c masterJob = new Master_Job__c();
        Boolean NewProperty = false;
        List<Account_Roles__c> ARList = new List<Account_Roles__c>();
        List<Account_Roles__c> ARPropertyList = new List<Account_Roles__c>();
        Property__c prop = new Property__c();
        Id ProjectSiteContactAccount;
        Id ProjectSiteContactContact;
        Id PrimaryAccount;
        Id PrimaryContact;
        Id Referred;
        Id InsuranceAdjuster;
        
        //Property.. if PropertyID is empty, insert with the info given, then attach AR Roles to them. => relate Prop to Master job
        try {

        AccountRoleWrapper AR = (AccountRoleWrapper)JSON.deserialize(AccountRoleInfo, AccountRoleWrapper.class);
        PropertyWrapper Property = (PropertyWrapper)JSON.deserialize(PropertyInfo, PropertyWrapper.class);
        JobWrapper jobWrap = (JobWrapper)JSON.deserialize(jobInfo, JobWrapper.class);
        system.debug('JobWrap is ' + jobWrap);
        system.debug('PropertyWrap is ' + Property);
        system.debug('AccountWrap is ' + AR);
        for(AccountRoleLineItems accountRoles : AR.AccountRoleLineItems){
            if(accountRoles.Text.contains('Project Site Contact')){
                if(!String.isBlank(accountRoles.Account)){
                ProjectSiteContactAccount = accountRoles.Account;
                }
                if(!String.isBlank(accountRoles.Contact)){
                    ProjectSiteContactContact = accountRoles.Contact;
                }
            }
            if(accountRoles.Text.contains('Primary/Bill-to')){
                if(!String.isBlank(accountRoles.Account)){
                    PrimaryAccount = accountRoles.Account;
                }
                if(!String.isBlank(accountRoles.Contact)){
                    PrimaryContact = accountRoles.Contact;
                }
            }
            if(accountRoles.Text.contains('Referred By')|| accountRoles.Text.contains('Caller') ){
                if(!String.isBlank(accountRoles.Contact)){
                    Referred = accountRoles.Contact;
                }
            }

        }
        //system.debug('Master Job Id  is  ' + MasterJobId);
        if(String.isEmpty(Property.PropertyId)){
            prop.Property_Type__c = Property.PropertyType;
            prop.Street__c = Property.Street;
            prop.City__c = Property.City;
            prop.Zip__c = Property.Zip;
            prop.Country__c = Property.Country;
            prop.State__c = Property.State;
            prop.Address_Line_2__c = Property.AddressLine2;
            prop.Address_Line_1__c = Property.Street + ' , ' + Property.State + ' , ' + Property.City + ' ' + Property.Zip;
            NewProperty= true;
            insert prop;  
            
        }else{
            prop = [Select Street__c, City__c, Zip__c, State__c, Address_Line_1__c, Address_Line_2__c FROM Property__c Where Id =: Property.PropertyId LIMIT 1];
        }
        Id mJobId;
        //if Master Job is empty, create one. 
        if(string.isEmpty(MasterJobId)){
          // masterJob.Name = 'Test Master Job';
           masterJob.Claim__c = jobWrap.Claim;
           masterJob.Description_of_Loss__c = jobWrap.Description;
           masterJob.Stage__c = 'Pre-work';
           //masterJob.Deductible__c = Decimal.valueOf(jobWrap.Deductible);
           masterJob.Date_of_Loss__c = jobWrap.DateOfLoss;
           masterJob.Cont_P_O_Client_Job__c = jobWrap.ClientJob;
           masterJob.Lead_Source__c = jobWrap.LeadSource;
           masterJob.Taken_By__c = jobWrap.TakenBy;
           masterJob.Multiple_Divisions__c = jobWrap.MultipleDivisions;
           masterJob.office2__c = jobWrap.Office;
           if(NewProperty){
               masterJob.Property__c = prop.Id;
           }else{
               masterJob.Property__c = Property.PropertyId;
           }
           insert masterJob;
           mJobId = masterJob.id;
        
        }else{
            mJobId = MasterJobId;
        }
        //insert job, and relate to Master Job
        Id propId;
        if(NewProperty){
            propId = prop.Id;
        }else{
            propId = Property.PropertyId;
        }
       system.debug('Hitting before job insert, and MJobId is ' + mJobId );
        ATI_Job__c job = new ATI_Job__c(Name = 'Test Job 1',  Job_Name__c = jobWrap.JobName, Stage__c = 'Qualification',  
        Office2__c = jobWrap.Office, Claim__c = jobWrap.Claim, Master_Job__c = mJobId, division__c = jobWrap.division,
        Job_Class__c = jobWrap.JobClass, Lead_Source__c = jobWrap.LeadSource, property_Id__c = propId, Es_Job_Type__c = jobWrap.EsJobType,
        Date_Of_loss__c = jobWrap.DateOfLoss, Cont_P_O_Client_Job__c = jobWrap.ClientJob, Project_Manager__c = jobWrap.ProjectDirector, Taken_By__c = jobWrap.TakenBy,
        Referred_By__c = Referred, Account__c = PrimaryAccount, Contact__c = PrimaryContact, Project_Site_Contact_Account__c = ProjectSiteContactAccount, 
        Project_Site_Contact_Name__c = ProjectSiteContactContact, Project_Site_Address__c = prop.Address_Line_1__c, Project_Site_Address_2__c = prop.Address_Line_2__c,
        Project_Site_City__c = prop.City__c, Project_Site_State__c = prop.State__c, Project_Site_Zipcode__c = prop.Zip__c);
        insert job;
        system.debug('Hitting after job insert' );
        MasterJobUpdateJob(mJobId, job.Id);
        //insert AR's and relate to job
        Set<Id> ContactIdsSet = new Set<Id>();
        Map<Id,Contact> ContactMap = new Map<Id,Contact>();
        for(AccountRoleLineItems accountRoles : AR.AccountRoleLineItems){
            if(String.isNotEmpty(accountRoles.Contact) && String.isEmpty(accountRoles.Account)){
                ContactIdsSet.add(accountRoles.Contact);
            }
        }
        if(!ContactIdsSet.isEmpty()){
            for(Contact c : [Select Id, AccountId FROM Contact Where Id =: ContactIdsSet]){
                ContactMap.put(c.Id, c);
            }
        }
        for(AccountRoleLineItems accountRoles : AR.AccountRoleLineItems){
            system.debug('Account Roles are '  + accountRoles);
            system.debug('Text is ' + accountRoles.Text);
            if(String.isNotEmpty(accountRoles.Account)){
            Account_Roles__c ARRole = new Account_Roles__c(Account_ID__c = accountRoles.Account, Contact_ID__c = accountRoles.Contact, Master_Job_Id__c = job.Id,
            Multiple_Roles__c = accountRoles.Text);
            ARList.add(ARRole);
            }if(String.isEmpty(accountRoles.Account) && String.isNotEmpty(accountRoles.Contact)){
                Account_Roles__c ARRole = new Account_Roles__c(Account_ID__c = ContactMap.get(accountRoles.Contact).AccountId, Contact_ID__c = accountRoles.Contact, Master_Job_Id__c = job.Id,
                Multiple_Roles__c = accountRoles.Text);
                ARList.add(ARRole);
            }
            //if Prop is new, need to add a different set of Account Roles to property, unrelated to the Job Account roles. 
            if(NewProperty){
                if(String.isNotEmpty(accountRoles.Account)){
                    Account_Roles__c PropARRole = new Account_Roles__c(Account_ID__c = accountRoles.Account, Contact_ID__c = accountRoles.Contact, Property_ID__c = prop.Id,
                    Multiple_Roles__c = accountRoles.Text);
                    ARPropertyList.add(PropARRole);
                }
                if(String.isEmpty(accountRoles.Account) && String.isNotEmpty(accountRoles.Contact)){
                    Account_Roles__c PropARRole = new Account_Roles__c(Account_ID__c = ContactMap.get(accountRoles.Contact).AccountId, Contact_ID__c = accountRoles.Contact, Property_ID__c = prop.Id,
                    Multiple_Roles__c = accountRoles.Text);
                    ARPropertyList.add(PropARRole);
            } 
            }

        }
        if(!ARList.isEmpty()){
            insert ARList;
            if(NewProperty){
                insert ARPropertyList;
            }
        }
        return job.id;
    } catch (Exception e) {
            return string.valueOf(e);
    }
        

    }
    @future
    public static void MasterJobUpdateJob(Id MasterJobId, Id JobId){
        Master_Job__c mJob = new Master_Job__c(Id = MasterJobId, Job__c = JobId);
        update mJob;
    }
    
    public class ContactId {
        public Id ContactId {get;set;}
    
    }
    public class AccountId{
        public Id AccountId {get;set;}
    }
    
    public class AccountRoleWrapper{
        public List<AccountRoleLineItems> AccountRoleLineItems {get;set;}
    }
    public class AccountRoleLineItems{
        public String Text {get;set;}
        public Id Account {get;set;}
        public Id Contact {get;set;}
        // public List<AccountIds> Account {get;set;}
    }
    public class AccountIds{
        public Id Account {get;set;}
    }
    public class PropertyWrapper{
        public Id PropertyId {get;set;}
        public String Street {get;set;}
        public String City {get;set;}
        public String State {get;set;}
        public String Country {get;set;}
        public String Zip {get;set;}
        public String PropertyType {get;set;}
        public String AddressLine2 {get;set;}
    }

   

    public class JobWrapper{
        public Id Office {get;set;}
        public String Description {get;set;}
        public String Division {get;set;}
        public String JobClass {get;set;}
        public String Claim {get;set;}
        public String Deductible {get;set;}
        public String MultipleDivisions {get;set;}
        public String LeadSource {get;set;}
        public String JobName {get;set;}  
        public String ClientJob {get;set;}  
        public String EsJobType {get;set;}  
        public Id TakenBy {get;set;}  
        public Id ProjectDirector {get;set;}  
        public Date DateOfLoss {get;set;}  
    }
    public class AccountWrapper{
        //public List<Id> PropertyId {get;set;}
        
        
        public List<Id> AccountId {get;set;}
        public string AccountName {get;set;}
        public string BillingStreet {get;set;}
        public string BillingCity {get;set;}
        public string BillingState {get;set;}
        public string BillingPostalCode {get;set;}
        public string TypeChange {get;set;}
        public string BillingCountry {get;set;}
        public string AccountPhone {get;set;}
        public string AccountPhoneExt {get;set;}
    }
    public class ContactWrapper{
        public List<Id> ContactId {get;set;}
        public string ContactType {get;set;}
        public string FirstName {get;set;}
        public string LastName {get;set;}
        public string MailingStreet {get;set;}
        public string MailingCity {get;set;}
        public string MailingState {get;set;}
        public string MailingCounty {get;set;}
        public list<Id> AccountId {get;set;}
        public string Phone {get;set;}
        public string Email {get;set;}
        public string PhoneExt {get;set;}
        public string MailingPostalCode {get;set;}
    }
    
// @track AccountName;
// @track BillingStreet;
// @track BillingCity;
// @track BillingState;
// @track BillingPostalCode;
// @track TypeChange;
// @track BillingCountry;
// @track AccountPhone;
// @track AccountPhoneExt;
// @track City;
// @track Country;
// @track State;
// @track AddressLine1;
// @track PropertyType;
// @track Zip;
// @track Description;
// @track Division;
// @track Office;
// @track JobClass;
// @track EstimateType;
// @track Claim;
// @track Deductible;
}