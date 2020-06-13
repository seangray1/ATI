/**
 * @File Name          : NewJobController.cls
 * @Description        : 
 * @Author             : sean.gray@atirestoration.com
 * @Group              : 
 * @Last Modified By   : sean.gray@atirestoration.com
 * @Last Modified On   : 3/18/2020, 8:13:36 AM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    1/28/2020   sean.gray@atirestoration.com     Initial Version
**/
public without sharing class NewJobController {
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
public static String ApproveSelectedItems(String ItemsToApproveReject, String Comments, String Decision)
{
    try 
    {
        system.debug('Items before ' + ItemsToApproveReject);
        Set<Id> pInstanceWorkitems = new Set<Id>();
        //JSONWrapper projectWrap = (JSONWrapper)JSON.deserialize(ProjectJSON, JSONWrapper.class);
        ItemListToApproveReject itemstoapproverejectlist = (ItemListToApproveReject)JSON.deserialize(ItemsToApproveReject, ItemListToApproveReject.class);
        system.debug('Items to Approve/reject ' + itemstoapproverejectlist);
        List<string> iList = new List<string>();
        for(ItemToApprove i : itemstoapproverejectlist.ItemsToApproveReject)
        {
            system.debug('i is ' + i);
            iList.add(i.id);
            pInstanceWorkitems.add(i.processId);
        }
        List<Approval.ProcessWorkitemRequest> allReq = new List<Approval.ProcessWorkitemRequest>(); 
        for (Id pInstanceWorkitemsId:pInstanceWorkitems)
        {
            system.debug(pInstanceWorkitemsId);
            Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
            req2.setComments(Comments);
            req2.setAction(Decision); //to approve use 'Approve'
            req2.setWorkitemId(pInstanceWorkitemsId);
            system.debug('req 2 ' + req2);
            allReq.add(req2);
        }
        //Approval.ProcessResult[] result2 =  Approval.process(allReq);
        return '200';
    } catch (Exception e) 
    {
        return e.getMessage();
    }
}
    @AuraEnabled
    public static List<ItemToApprove> GetAccountData(String objectName){
        Set<Id> userSet = new Set<Id>();
        Set<Id> ProcessInstanceId = new Set<Id>();
        Map<Id, ProcessInstance> processInstanceMap = new Map<Id, ProcessInstance>();
        Map<Id, ProcessInstanceWorkitem> processJobMap = new Map<Id, ProcessInstanceWorkitem>();
        Map<Id, ProcessInstance> processMJobMap = new Map<Id, ProcessInstance>();
        Map<Id, ProcessInstanceWorkitem> processuserMap = new Map<Id, ProcessInstanceWorkitem>();
        Map<Id, String> processuserMap1 = new Map<Id, string>();
        
        Set<Id> mjobids = new Set<Id>();
        List<ProcessInstanceWorkitem> piwi = [Select Id, ProcessInstanceId, CreatedById, ActorId FROM ProcessInstanceWorkitem Where ActorId =: userInfo.getUserId()];
    //   if(objectName == 'Master Job')
    //   {   
        for(ProcessInstanceWorkitem p : piwi)
        {
            processJobMap.put(p.ProcessInstanceId, p);
            userset.add(p.CreatedById);
            processUserMap.put(p.CreatedById, p);
            ProcessInstanceId.add(p.ProcessInstanceId);
        }
        List<user> usersList = [Select Id, Name FROM User Where Id=:userSet];
        for(user u : usersList)
        {
            processUserMap1.put(u.Id, u.Name);
        }
        List<ProcessInstance> processInstanceList = [Select Id, targetObjectId FROM ProcessInstance Where Id =: ProcessInstanceId];
        for(ProcessInstance p : processInstanceList)
        {
            if(p.targetobjectId.getSObjectType().getDescribe().getName() == 'Master_Job__c')
            {
                processInstanceMap.put(p.Id, p);
                processMJobMap.put(p.targetObjectId, p);
                
                mjobids.add(p.targetObjectId);
            }
        }
        Map<Id, ATI_Job__c> mjobMap = new Map<Id,ATI_Job__c>();
        system.debug('mjob ids ' + mjobids);
        List<ATI_Job__c> mjoblist = [Select Id, Name, Contact__c, Contact__r.Name, Account__c, Account__r.Name, Referred_By__c, Referred_By__r.Name, Master_Job__c, Master_Job__r.Name FROM ATI_Job__c Where Master_Job__c =: mjobids];
        for(ATI_Job__c job : mjoblist)
        {
            system.debug('job is ' + job);
            mjobMap.put(job.Master_Job__c, job);
        }
        List<ItemToapprove> ItemsToApproveClass = new List<ItemToapprove>();
        // system.debug('Items To Approve Class ' + ItemsToApproveClass);
        // ItemToApprove ia = new ItemToApprove();
        // ia.processId = 'Test';
        // ItemsToApproveClass.items.add(ia);
        // system.debug('Items To Approve Class ' + ItemsToApproveClass.items);
        //system.debug('Items To Approve Class ' + ItemsToApproveClass);
        
        for(ProcessInstance p : processInstanceMap.values())
        {
            ItemToApprove i = new ItemToApprove();
            i.processId = processJobMap.get(p.Id).Id;
            i.processinstanceId = p.Id;
            i.createdByName = processuserMap1.get(processJobMap.get(p.Id).createdById);
            system.debug('i is ' + i );
            i.MasterJob = mjobMap.get(p.targetObjectId).Master_Job__r.Name;
            i.MasterJobId = mjobMap.get(p.targetObjectId).Master_Job__c;
            i.Account = mjobMap.get(p.targetObjectId).Account__r.Name;
            i.AccountId = mjobMap.get(p.targetObjectId).Account__c;
            i.Contact = mjobMap.get(p.targetObjectId).Contact__r.Name;
            i.ContactId = mjobMap.get(p.targetObjectId).Contact__c;
            i.ReferredBy = mjobMap.get(p.targetObjectId).Referred_By__r.Name;
            i.ReferredById = mjobMap.get(p.targetObjectId).Referred_By__c;
            system.debug('i is ' + i );

            ItemsToApproveClass.add(i);
        }
        system.debug('ItemsToApproveClass is ' + ItemsToApproveClass);
        system.debug('Jobs Class is ' + mjoblist);
        
        return ItemsToApproveClass;
    }
    // if(objectName == 'All')
    //   {   
    //     for(ProcessInstanceWorkitem p : piwi)
    //     {
    //         processJobMap.put(p.ProcessInstanceId, p);
    //         userset.add(p.CreatedById);
    //         processUserMap.put(p.CreatedById, p);
    //         ProcessInstanceId.add(p.ProcessInstanceId);
    //     }
    //     List<user> usersList = [Select Id, Name FROM User Where Id=:userSet];
    //     for(user u : usersList)
    //     {
    //         processUserMap1.put(u.Id, u.Name);
    //     }
    //     List<ProcessInstance> processInstanceList = [Select Id, targetObjectId FROM ProcessInstance Where Id =: ProcessInstanceId];
    //     for(ProcessInstance p : processInstanceList)
    //     {
    //         // if(p.targetobjectId.getSObjectType().getDescribe().getName() == 'Master_Job__c')
    //         // {
    //             processInstanceMap.put(p.Id, p);
    //             processMJobMap.put(p.targetObjectId, p);
                
    //             // mjobids.add(p.targetObjectId);
    //         // }
    //     }
    //     // Map<Id, ATI_Job__c> mjobMap = new Map<Id,ATI_Job__c>();
    //     // system.debug('mjob ids ' + mjobids);
    //     // List<ATI_Job__c> mjoblist = [Select Id, Name, Contact__c, Contact__r.Name, Account__c, Account__r.Name, Referred_By__c, Referred_By__r.Name, Master_Job__c, Master_Job__r.Name FROM ATI_Job__c Where Master_Job__c =: mjobids];
    //     // for(ATI_Job__c job : mjoblist)
    //     // {
    //     //     system.debug('job is ' + job);
    //     //     mjobMap.put(job.Master_Job__c, job);
    //     // }
    //     List<ItemToapprove> ItemsToApproveClass = new List<ItemToapprove>();
    //     // system.debug('Items To Approve Class ' + ItemsToApproveClass);
    //     // ItemToApprove ia = new ItemToApprove();
    //     // ia.processId = 'Test';
    //     // ItemsToApproveClass.items.add(ia);
    //     // system.debug('Items To Approve Class ' + ItemsToApproveClass.items);
    //     //system.debug('Items To Approve Class ' + ItemsToApproveClass);
        
    //     for(ProcessInstance p : processInstanceMap.values())
    //     {
    //         ItemToApprove i = new ItemToApprove();
    //         i.processId = processJobMap.get(p.Id).Id;
    //         i.processinstanceId = p.Id;
    //         i.createdByName = processuserMap1.get(processJobMap.get(p.Id).createdById);
    //         i.ObjectName =  p.TargetObjectId;
          
    //         system.debug('i is ' + i );
    //         // i.MasterJob = mjobMap.get(p.targetObjectId).Master_Job__r.Name;
    //         // i.MasterJobId = mjobMap.get(p.targetObjectId).Master_Job__c;
    //         // i.Account = mjobMap.get(p.targetObjectId).Account__r.Name;
    //         // i.AccountId = mjobMap.get(p.targetObjectId).Account__c;
    //         // i.Contact = mjobMap.get(p.targetObjectId).Contact__r.Name;
    //         // i.ContactId = mjobMap.get(p.targetObjectId).Contact__c;
    //         // i.ReferredBy = mjobMap.get(p.targetObjectId).Referred_By__r.Name;
    //         // i.ReferredById = mjobMap.get(p.targetObjectId).Referred_By__c;
    //         system.debug('i is ' + i );

    //         ItemsToApproveClass.add(i);
    //     }
        
    //     return ItemsToApproveClass;
    // }
    // List<ItemToApprove> ita = new list<ItemToApprove>();
    // return ita;


    
    
//    @AuraEnabled
//     public class JSONWrapper{
//         public List<ItemToApprove> items;
//     }
    public class ItemListToApproveReject
    {
    @AuraEnabled
    public List<ItemToApprove> ItemsToApproveReject {get;set;}
    }
    public class ItemToApprove{
        @AuraEnabled
        public string processId {get;set;}
        @AuraEnabled
        public string processinstanceId {get;set;}
        @AuraEnabled
        public string createdByName {get;set;}
        @AuraEnabled
        public string MasterJob {get;set;}
        @AuraEnabled
        public string MasterJobId {get;set;}
        @AuraEnabled
        public string Account {get;set;}
        @AuraEnabled
        public string AccountId {get;set;}
        @AuraEnabled
        public string Contact {get;set;}
        @AuraEnabled
        public string ContactId {get;set;}
        @AuraEnabled
        public string ReferredBy {get;set;}
        @AuraEnabled
        public string ReferredById {get;set;}
        @AuraEnabled
        public string ObjectName {get;set;}
        @AuraEnabled
        public string id {get;set;}
    }
    @AuraEnabled
    public static string UpdateProperty(string recordId, string Street,string City,string State,string Zip, string Country){
        try {
            PropertyAddresses propAddress = GoogleCallout(Street, City, Zip, State);
            // Http h = new Http();
            // HttpRequest req = new HttpRequest();
            //  String address = Street + ', ' + State + ', ' + City + ' ' + Zip;
            //  system.debug('Address is ' + address);
            //  req.setEndpoint('https://maps.googleapis.com/maps/api/geocode/json?key=AIzaSyBuE7iBv1fugjx2Az7h-bCwJCoWOadglz8&address='+
            //  EncodingUtil.urlEncode(address, 'UTF-8')+'&sensor=false');
            //  req.setMethod('GET');
            //  req.setTimeout(60000);
            //  string county;
            //  string streetnumber1;
            //  string street1;
            //  if(!Test.isRunningTest()){
            // HttpResponse res = h.send(req);
            // system.debug('Response is ' + res.getBody());
            // resultswrapper result = (resultswrapper)JSON.deserialize(res.getBody(), resultswrapper.class);
            // system.debug('results are ' + result);
            
            // for(results a: result.results){
            //     system.debug('a ' + a);
            //     for(address_components ad : a.address_components){
            //         system.debug('ad ' + ad.types[0]);
            //         if(ad.types[0] == 'administrative_area_level_2'){
            //             county = ad.long_name.replace('County', '');
            //         }
                    
            //         if(ad.types[0] == 'locality'){
            //             City = ad.short_name;
            //            // system.debug('state is  ' + state);
            //         }
            //         if(ad.types[0] == 'administrative_area_level_1'){
            //             State = ad.short_name;
            //          //   system.debug('city is  ' + city);
            //         }
            //         if(ad.types[0] == 'street_number'){
            //             streetnumber1 = ad.short_name;
            //             //system.debug('street # is  ' + streetnumber);
            //         }
            //         if(ad.types[0] == 'route'){
            //             street1 = ad.short_name;
            //           //  system.debug('Street is  ' + street);
            //         }
            //         if(ad.types[0] == 'postal_code'){
            //             Zip = ad.short_name;
            //           //  system.debug('Postal # is  ' + postalcode);
            //         }

            //     }  
            // }
            // street = streetnumber1 +' ' + street1;
        // }


            Property__c prop = new Property__c(Id = recordId, Address_Line_1__c = propAddress.Street, City__c = propAddress.City, Zip__c = propAddress.Zipcode, State__c = propAddress.State, County__c = propAddress.county);
            update prop;
            List<ATI_Job__c> jobs = [Select ID, Project_Site_Address__c, Project_Site_CIty__c, Project_Site_State__c, Project_Site_Zipcode__c FROM ATI_Job__c WHere Property_Id__c =: prop.Id];
            for(ATI_Job__c job: jobs){
                job.Project_Site_Address__c = propAddress.Street;
                job.Project_Site_City__c = propAddress.City;
                job.Project_Site_State__c = propAddress.State;
                job.Project_Site_Zipcode__c = propAddress.Zipcode;
                job.County__c = propAddress.county;
            }
            if(!jobs.isEmpty()){
                update jobs;
            }
            return 'SUCCESS';

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
    public static string InsertPersonAccount(String FirstName, String LastName, String Phone, String Email, String Type, String PhoneExt,
                                         String BillingStreet, String BillingCity, String BillingState,
                                        String BillingPostalCode, String BillingCountry){
                                            system.debug(FirstName + '     ' + LastName +'     ' + Phone + Email + '     ' +Type + '     ' +PhoneExt + '     ' +BillingStreet + '     ' +BillingCity+ '     ' +BillingState +'     ' + BillingPostalCode + '     ' +BillingCountry);
        RecordType personAccountRecordType =  [SELECT Id FROM RecordType WHERE Name = 'Person Accounts' and SObjectType = 'Account'];
        Account acct = new Account(FirstName = FirstName, LastName= LastName,  Phone = Phone, PersonEmail = Email, Type = Type, Phone_Ext__c = PhoneExt, RecordType = personAccountRecordType,  BillingStreet = BillingStreet,
                                    BillingState = BillingState, BillingCity = BillingCity, BillingPostalCode = BillingPostalCode, BillingCountry = BillingCountry);
        try {
            insert acct;
            return acct.id;
        } catch (Exception e) {
            return String.valueOf(e);
        }                       //IsPersonType = PersonAccount,
        
        
        
    }
    // @AuraEnabled
    // public static List<Account_Roles__c> GetAccountRoless(String PropertyId) {
    //     Id PropertyIDFinal;
    //     system.debug('Property is ' + PropertyID);
    //     JSONWrapper PropertyIDs = (JSONWrapper)JSON.deserialize(PropertyId, JSONWrapper.class);
    //     // for(Id ca : PropertyIDs.PropertyID){
    //     // PropertyIDFinal = ca; }
    //     system.debug('PropertyID is ' + PropertyID);
    //     List<Account_Roles__c> a = [Select Name FROM Account_Roles__c Where Property_ID__c =: PropertyIDs.PropertyID];
    //     system.debug('Account roles are ' + a);
    //     return a;
    // }
    // public class JSONWrapper{
    //     public List<Id> PropertyId {get;set;}
    // }
    @AuraEnabled(cacheable = true)
    public static List<Property__c> GetProperties(String searchKey) {
        
        system.debug('Property is ' + searchKey);
        //JSONWrapper PropertyIDs = (JSONWrapper)JSON.deserialize(PropertyId, JSONWrapper.class);
        // for(Id ca : PropertyIDs.PropertyID){
        // PropertyIDFinal = ca; }

        String searchLikeKey1 =  '%' + searchKey + '%';
        String searchLikeKey = searchLikeKey1.normalizeSpace();
        List<Property__c> props = [Select Id, Name, State__c, City__c, Street__c, Address_Line_1__c, Zip__c, Market_Class__c, Market_Segment__c, Market_Segment_Sub_Class__c FROM Property__c Where Full_Address__c Like : searchLikeKey LIMIT 5];
        system.debug('Properties are ' + props);
        return props;
    }
    @AuraEnabled(cacheable = true)
    public static List<Office__c> GetOffices(String searchKey) {
        String searchLikeKey = searchKey + '%';
        List<Office__c> off = [Select Id, Name FROM Office__c Where Name Like : searchLikeKey LIMIT 5];
        
        return off;
    }
   
    @AuraEnabled(cacheable = true)
    public static List<Contact> GetCustomers(String searchKey) {
        
        system.debug('Customer Key is ' + searchKey);
        //JSONWrapper PropertyIDs = (JSONWrapper)JSON.deserialize(PropertyId, JSONWrapper.class);
        // for(Id ca : PropertyIDs.PropertyID){
        // PropertyIDFinal = ca; }
        String searchLikeKey = searchKey + '%';
        List<Contact> conts = [Select Id, LastName, FirstName, Account_Name__c, AccountId, Phone,  Account.Name, Account.Id, Name FROM Contact Where Name Like : searchLikeKey Limit 3];
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
        List<Account_Roles__c> a = [Select Id, Name, Roles__c, Contact_ID__c, Multiple_Roles__c, Address__c, Text__c, Account_ID__c FROM Account_Roles__c Where Property_ID__c =: propId LIMIT 5];
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        system.debug('Prop Id + ' + propId);
        system.debug('Contact ID is ' + a);
        return a;

    }
    @AuraEnabled 
    public static list<Account_Roles__c> GetJobAccountRoles(string recordId){
        List<Account_Roles__c> a = [Select Id, Name, Roles__c, Contact_ID__c, Master_Job_Id__c, Multiple_Roles__c, Address__c, Text__c, Account_ID__c FROM Account_Roles__c Where Master_Job_Id__c =: recordId LIMIT 5];
        system.debug('Account Roles are ' + a.size() + ' and record Id is ' + recordId);
        return a;

    }
    
    @AuraEnabled 
    public static list<Account_Roles__c> CheckId6(string propId){
        List<Account_Roles__c> a = [Select Id, Name, Roles__c, Contact_ID__c, Multiple_Roles__c, Address__c, Text__c, Account_ID__c FROM Account_Roles__c Where Property_ID__c =: propId];
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        

        system.debug('Prop Id + ' + propId);
        system.debug('Contact ID is ' + a);
        return a;

    }
    
    @AuraEnabled 
    public static list<Master_Job__c> GetMasterJobs(string propId){
        List<Master_Job__c> mj = [Select Id, Name, Stage__c, Property__c, Cont_P_O_Client_Job__c, Claim__c, Office2__c, Office2__r.Name, Policy__c, Date_of_Loss__c, Deductible__c, Description_of_Loss__c,Lead_Source__c, Multiple_Divisions__c  FROM Master_Job__c Where Property__c =: propId AND Stage__c != 'Closed' LIMIT 5];
        system.debug('Prop Id + ' + propId);
        system.debug(mj.size());
        
        return mj;

        
    }
    @AuraEnabled 
    public static Property__c GetPropertyInfo(String City, String Address, String State, String Zipcode){
        String searchLikeKey1 = Address + City +  State +Zipcode;
        String searchLikeKey = searchLikeKey1.normalizeSpace();
        system.debug('SearchLikeKey is ' + searchLikeKey);
        // try {
        List<Property__c> props = [Select Id, Market_Class__c, Market_Segment__c, Market_Segment_Sub_Class__c, Year_Structure_Built__c, County__c, Job_Class__c, Name, State__c, City__c, Street__c, Address_Line_1__c, Zip__c FROM Property__c Where Full_Address__c Like : searchLikeKey LIMIT 1];
        system.debug('Properties are ' + props);
        if(!props.isEmpty()){
        Property__c prop1 = props[0];
        prop1.County__c = 'Same Property';
        system.debug('Properties1 are ' + props);
        return prop1;
        }else{
            Property__c prop = new Property__c(County__c = 'Not Same Property');
            system.debug('Properties2 are ' + props);
            return prop;
        }  
    // }
        // catch (Exception e) {
        //     return string.valueof(e);
        // }  
    }
    @AuraEnabled 
    public static ATI_Job__c GetJobInfo(string recordId){
        ATI_Job__c job = [Select Id, Name, Property_Id__c, County__c, Project_Site_Address__c, CloseDate__c, Policy__c, Cont_P_O_Client_Job__c, PO__c, Send_prelim__c, Deductible__c, Claim__c, Project_Site_Contact_Account__c, Lead_Source__c, contact__c,Project_Site_Contact_Name__c,Contact_Information__c, Customer__c,Account__c, Project_Site_City__c, Contact_Info__c, Project_Site_State__c, Project_Site_Zipcode__c,
        Project_Site_Address_2__c, Job_Name__c, Stage__c, Master_Job__c, Referred_by__c,  Division__c,  Date_of_Loss__c, Description__c, Taken_By__c, Taken_By__r.Name,
        Office2__c,  Office2__r.Name, Project_Manager__c, Project_Manager__r.name, Major_Event__c, Major_Event__r.Name, Market_Class__c, Market_Segment__c,
        Market_Segment_Sub_Class__c, Account_Executive_1__c, Account_Executive_2__c, PN_Request_Date__c,
        PN_Amount__c, ML_amount__c, PN_Recording_Number__c, ML_Recording_Number__c,
        ML_Request_Date__c,ML_Release_Recording_Date__c, 
        Send_Prelim_Last_Modified_Date_Time__c, Send_Prelim_Last_Modified_By__c,
        ML_Recording_Date__c, National_Project_Manager__c
         FROM ATI_Job__c Where Id =: recordId];
        return job;
    }
    @AuraEnabled
    public static string GetUserInfo(){
        id id1 = UserInfo.getProfileId();
        Profile p = [Select Name FROM Profile WHere Id =: id1];
        return p.Name;
    }
    @AuraEnabled
    public static userInfoWrapper GetUserInfoAndIntakeStatus(string recordId){
        id id1 = UserInfo.getProfileId();
        Profile p = [Select Name FROM Profile WHere Id =: id1];
        ATI_Job__c job = [Select Id, Intake_Status__c FROM ATI_Job__c WHere Id =: recordId];
        userInfoWrapper u = new userInfoWrapper();
        u.ProfileName = p.Name;
        u.IntakeStatus = job.Intake_Status__c;
        system.debug(u);
        return u;
    }
   
    public class userInfoWrapper{
        @AuraEnabled 
        public string ProfileName {get;set;}
        @AuraEnabled 
        public string IntakeStatus {get;set;}
    }
    @AuraEnabled(cacheable = true)
    public static List<User> GetUsers(String searchKey) {
        system.debug('Customer Key is ' + searchKey);
        String searchLikeKey = searchKey + '%';
        List<User> users = [Select Id,Name FROM User Where Name Like : searchLikeKey Limit 5];
       
        return users;
    }
    @AuraEnabled(cacheable = true)
    public static List<Major_Event__c> GetMajorEvents(String searchKey) {
        system.debug('Customer Key is ' + searchKey);
        String searchLikeKey = '%' +searchKey + '%';
        List<Major_Event__c> majorevent = [Select Id,Name FROM Major_Event__c Where Status__c != 'Inactive' AND NAME Like : searchLikeKey Limit 5];
       
        return majorevent;
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
    public static List<String> GetDivisionPicklist1(){  
        List<String> pickListValuesList= new List<String>(); 
         Schema.DescribeFieldResult fieldResult = ATI_Job__c.Division__c.getDescribe();   
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();   
             for( Schema.PicklistEntry pickListVal : ple){  
                    pickListValuesList.add(pickListVal.getLabel());  
                }       
                return pickListValuesList;
            }
    @AuraEnabled  
    public static List<String> GetDivisionPicklist2(){  
        List<String> pickListValuesList= new List<String>(); 
         Schema.DescribeFieldResult fieldResult = ATI_Job__c.Division__c.getDescribe();   
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();   
             for( Schema.PicklistEntry pickListVal : ple){  
                    pickListValuesList.add(pickListVal.getLabel());  
                }       
                return pickListValuesList;
            }
    @AuraEnabled  
    public static List<String> GetDivisionPicklist3(){  
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
    public static List<String> GetJobClassPicklist1(){  
        List<String> pickListValuesList= new List<String>(); 
         Schema.DescribeFieldResult fieldResult = ATI_Job__c.Job_Class__c.getDescribe();   
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();   
             for( Schema.PicklistEntry pickListVal : ple){  
                    pickListValuesList.add(pickListVal.getLabel());  
                }       
                return pickListValuesList;
            }
    @AuraEnabled  
    public static List<String> GetJobClassPicklist2(){  
        List<String> pickListValuesList= new List<String>(); 
         Schema.DescribeFieldResult fieldResult = ATI_Job__c.Job_Class__c.getDescribe();   
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();   
             for( Schema.PicklistEntry pickListVal : ple){  
                    pickListValuesList.add(pickListVal.getLabel());  
                }       
                return pickListValuesList;
            }
    @AuraEnabled  
    public static List<String> GetJobClassPicklist3(){  
        List<String> pickListValuesList= new List<String>(); 
         Schema.DescribeFieldResult fieldResult = ATI_Job__c.Job_Class__c.getDescribe();   
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();   
             for( Schema.PicklistEntry pickListVal : ple){  
                    pickListValuesList.add(pickListVal.getLabel());  
                }       
                return pickListValuesList;
            }
    @AuraEnabled  
    public static List<String> GetJobClassPicklist4(){  
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
    public static string CreateNewProp(string AccountRoleInfo,string PropertyInfo){
        // try {
                
        system.debug('AR ' + AccountRoleInfo + 'Property  ' + PropertyInfo);
        AccountRoleWrapper AR = (AccountRoleWrapper)JSON.deserialize(AccountRoleInfo, AccountRoleWrapper.class);
        PropertyWrapper Property = (PropertyWrapper)JSON.deserialize(PropertyInfo, PropertyWrapper.class);
        PropertyAddresses propAddress = GoogleCallout(Property.Street, Property.City, Property.Zip, Property.State);
        
        //     Http h = new Http();
        //     HttpRequest req = new HttpRequest();
        //      String address = Property.Street + ', ' + Property.State + ', ' + Property.City + ' ' + Property.Zip;
        //      req.setEndpoint('https://maps.googleapis.com/maps/api/geocode/json?key=AIzaSyBuE7iBv1fugjx2Az7h-bCwJCoWOadglz8&address='+
        //      EncodingUtil.urlEncode(address, 'UTF-8')+'&sensor=false');
        //      req.setMethod('GET');
        //      req.setTimeout(60000);
        //      string county;
        //      string streetnumber;
        //      string street;
        //      if(!Test.isRunningTest()){
        //     HttpResponse res = h.send(req);
        //     system.debug('Response is ' + res.getBody());
        //     resultswrapper result = (resultswrapper)JSON.deserialize(res.getBody(), resultswrapper.class);
        //     system.debug('results are ' + result);
            
        //     for(results a: result.results){
        //         system.debug('a ' + a);
        //         for(address_components ad : a.address_components){
        //             system.debug('ad ' + ad.types[0]);
        //             if(ad.types[0] == 'administrative_area_level_2'){
        //                 county = ad.long_name.replace('County', '');
        //             }
                    
        //             if(ad.types[0] == 'locality'){
        //                 Property.city = ad.short_name;
        //                // system.debug('state is  ' + state);
        //             }
        //             if(ad.types[0] == 'administrative_area_level_1'){
        //                 Property.state = ad.short_name;
        //              //   system.debug('city is  ' + city);
        //             }
        //             if(ad.types[0] == 'street_number'){
        //                 streetnumber = ad.short_name;
        //                 //system.debug('street # is  ' + streetnumber);
        //             }
        //             if(ad.types[0] == 'route'){
        //                 street = ad.short_name;
        //               //  system.debug('Street is  ' + street);
        //             }
        //             if(ad.types[0] == 'postal_code'){
        //                 Property.Zip = ad.short_name;
        //               //  system.debug('Postal # is  ' + postalcode);
        //             }

        //         }  
        //     }
        //     property.street = streetnumber +' ' + street;
        // }
        //     system.debug('county ' + county);
        Boolean NewProperty;
        Property__c prop = new Property__c();
        List<Account_Roles__c> ARPropertyList = new List<Account_Roles__c>();
        if(String.isEmpty(Property.PropertyId)){
            //prop.Property_Type__c = Property.PropertyType;
            prop.Street__c = Property.Street;
            prop.City__c = propAddress.City;
            prop.Zip__c = propAddress.Zipcode;
            prop.Country__c = Property.Country;
            prop.State__c = propAddress.State;
            // prop.Address_Line_2__c = Property.AddressLine2;
            prop.Address_Line_1__c = propAddress.Street;
            prop.County__c = propAddress.county;
            NewProperty= true;
            // prop.Year_Structure_Built__c = Decimal.valueOf(jobWrap.YearBuilt);
            // prop.Job_Class__c = jobWrap.JobClass;
            insert prop;  
            
        }else{
            prop = [Select Street__c, City__c, Zip__c, State__c, County__c, Address_Line_1__c, Address_Line_2__c FROM Property__c Where Id =: Property.PropertyId LIMIT 1];
        }
        Id propId;
        if(NewProperty){
            propId = prop.Id;
        }else{
            propId = Property.PropertyId;
        }
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
            if(NewProperty && !ARPropertyList.isEmpty()){
                insert ARPropertyList;
            }
            return propId;
        // } catch (Exception e) {
        //    return e.getMessage(); 
        // }
    }  
@AuraEnabled
public static String AfterHoursJobCreation(String JobName, String Division, String EsJobType, Id Office, String Street, String State, String City, String ZipCode, String Country,
String AddressLine2, String ContactInfo, String Description, String MajorEvent, String ProjectDirector, String recordId)
{

    PropertyAddresses propAddress = GoogleCallout(Street,  City, Zipcode, State);
  
    Savepoint sp = Database.setSavepoint();
    try 
    {
        if(recordId == null)
        {    
            Master_Job__c mj = new Master_Job__c(Office2__c = Office, Description_of_Loss__c = Description, Stage__c = 'Pre-work');
            mj.City__c = propAddress.City;
            mj.State__c = propAddress.State;
            mj.Address_Line_1__c = propAddress.Street;
            insert mj;
            system.debug('After Master Job creation');
            Id userId = userinfo.getUserId();
            Map <String, Schema.RecordTypeInfo> jobRecordTypeMap = Schema.SObjectType.ATI_Job__c.RecordTypeInfosByName;
            Id recordtypeid = Schema.SObjectType.ATI_Job__c.RecordTypeInfosByName.get('Job (Approved)').getRecordTypeId();
            
            List<Account> account = [select id, PersonContactId, name from account where LastName =: 'ES Job Account'];
            //date_time_approved__c = datetime.now(),    changed 4/14/20 since Nat wanted it removed for reporting purporses
            ATI_Job__c job = new ATI_Job__c(Name = 'Test Job 1',  Job_Name__c = JobName, Es_Job_Type__c= EsJobType, Stage__c = 'Qualification', Taken_By__c = userId,
            Office2__c = Office, Master_Job__c = mj.id, recordtypeId = recordtypeid, Division__c = Division, Description__c = Description, Project_Site_Address__c = propAddress.Street, Project_Site_Address_2__c = AddressLine2,
            Project_Site_City__c = propAddress.City, Project_Site_State__c = propAddress.State, Date_Time_approved__c = system.now(), Project_Site_Zipcode__c = propAddress.ZipCode, Contact_Info__c = ContactInfo, County__c = propAddress.county, CloseDate__c = date.today().adddays(5), Major_Event__c = MajorEvent, Intake_Status__c = 'Business Requested', Project_Manager__c = ProjectDirector, Date_Time_Submitted__c = datetime.now(),
            Date_Time_Taken__c = datetime.now());
            system.debug('Job info is ' + job);
            if(!account.isempty())
            {
                job.Account__c = account[0].id;
                job.Project_site_Contact_Name__c = account[0].PersonContactId;
                job.Project_site_Contact_Account__c = account[0].id;
            } 
            insert job;
            return job.id;
        }

        if(recordId != null)
        {
            Id recordtypeid = Schema.SObjectType.ATI_Job__c.RecordTypeInfosByName.get('Job (Approved)').getRecordTypeId();
            Id notApprovedId = Schema.SObjectType.ATI_job__c.RecordTypeInfosByName.get('New Job (Not Approved)').getRecordTypeId();
            ATI_Job__c jobdata = GetJobInfo(recordId);
            ATI_Job__c job = new ATI_Job__c(Name = 'Test Job 1',  Job_Name__c = JobName, Es_Job_Type__c= EsJobType, Stage__c = 'Qualification', Taken_By__c = jobdata.Taken_By__c,
            Office2__c = Office, Master_Job__c = jobdata.Master_Job__c, Property_Id__c = jobdata.Property_Id__c, recordtypeId = notApprovedId, Division__c = Division, Description__c = Description, Project_Site_Address__c = propAddress.Street, Project_Site_Address_2__c = AddressLine2,
            Project_Site_City__c = propAddress.City, Project_Site_State__c = propAddress.State, Date_Time_approved__c = system.now(), Project_Site_Zipcode__c = propAddress.ZipCode, Contact_Info__c = ContactInfo, County__c = propAddress.county, CloseDate__c = jobdata.CloseDate__c, Major_Event__c = MajorEvent, Project_Manager__c = ProjectDirector, Date_Time_Submitted__c = datetime.now(),
            Date_Time_Taken__c = datetime.now(),  Policy__c = jobdata.Policy__c, Deductible__c = jobdata.Deductible__c,Account_Executive_1__c = jobdata.Account_Executive_1__c, Account_Executive_2__c = jobdata.Account_Executive_2__c,
            Claim__c = jobdata.Claim__c, Cont_P_O_Client_Job__c = jobdata.Cont_P_O_Client_Job__c, PO__c = jobdata.PO__c,  Account__c = jobdata.Account__c,
            Contact__c = jobdata.Contact__c, Lead_Source__c = jobdata.Lead_Source__c, Market_Class__c = jobdata.Market_Class__c, Market_Segment__c = jobdata.Market_Segment__c,
            Market_Segment_Sub_Class__c = jobdata.Market_Segment_Sub_Class__c, Date_of_Loss__c = jobdata.Date_of_Loss__c, Project_Site_Contact_Name__c = jobdata.Project_Site_Contact_Name__c,
            Project_Site_Contact_Account__c = jobdata.Project_Site_Contact_Account__c, Intake_Status__c = 'Cloned - Pending Review', 
             National_Project_Manager__c = jobdata.National_Project_Manager__c );
        
            // Send_Prelim__c = jobdata.Send_Prelim__c,PN_Request_Date__c = jobdata.PN_Request_Date__c,
            // PN_Amount__c = jobdata.PN_Amount__c, ML_amount__c = jobdata.ML_amount__c, PN_Recording_Number__c = jobdata.PN_Recording_Number__c, ML_Recording_Date__c = jobdata.ML_Recording_Date__c,
            // ML_Recording_Number__c = jobdata.ML_Recording_Number__c, ML_Request_Date__c = jobdata.ML_Request_Date__c, ML_Release_Recording_Date__c = jobdata.ML_Release_Recording_Date__c,
            // Send_Prelim_Last_Modified_Date_Time__c = jobdata.Send_Prelim_Last_Modified_Date_Time__c, Send_Prelim_Last_Modified_By__c = jobdata.Send_Prelim_Last_Modified_By__c,
            system.debug('Job contains ' + job);
            insert job;
            List<Account_Roles__c> ARs = new List<Account_Roles__c>();

            for(Account_Roles__c a : [Select Id, Account_ID__c, Contact_ID__c, Multiple_Roles__c FROM Account_Roles__c Where Master_Job_Id__c =: recordId limit 10])
            {
                Account_Roles__c ar = new Account_Roles__c(Master_Job_Id__c = job.Id, Account_ID__c = a.Account_ID__c, Contact_ID__c = a.Contact_ID__c, Multiple_Roles__c = a.Multiple_Roles__c);
                ARs.add(ar);
            }
            insert ARs;
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setComments('Submitting request for approval.');
            req1.setSubmitterId(UserInfo.getUserId());      
            req1.setProcessDefinitionNameOrId('ATI_Jobs_Job_Approval_Process');
            req1.setObjectId(job.Id);
            req1.setskipentrycriteria(true);   
            Approval.ProcessResult result = Approval.process(req1);           
            Approval.Unlock(job.Id);
            return job.Id;
        }
    }
    catch (Exception e) 
    {
    Database.rollback(sp);
    return e.getMessage();
    }
    return 'Job failed to create';
}   
    @AuraEnabled
    public static string EditAccountRoles(string AccountRoleInfo, string recordId){
        List<Account_Roles__c> ARList = new List<Account_Roles__c>();
        List<Account_Roles__c> ARPropertyList = new List<Account_Roles__c>();
        Id ProjectSiteContactAccount;
        Id ProjectSiteContactContact;
        Id PrimaryAccount;
        Id PrimaryContact;
        Id Referred;
        Id InsuranceAdjuster;
        AccountRoleWrapper AR = (AccountRoleWrapper)JSON.deserialize(AccountRoleInfo, AccountRoleWrapper.class);
        Savepoint sp = Database.setSavepoint();
        //Property.. if PropertyID is empty, insert with the info given, then attach AR Roles to them. => relate Prop to Master job
        try {

        
           
           
            Set<Id> ContactIdsSet = new Set<Id>();
            Set<Id> PersonAccountIdSet = new Set<Id>();
            Map<Id,Contact> ContactMap = new Map<Id,Contact>();
            Map<Id,Account> PersonAccountMap = new Map<Id,Account>();
            Map<Id, string> AEMContactSearchMap = new Map<id,string>();
            
            for(AccountRoleLineItems accountRoles : AR.AccountRoleLineItems)
            {
                system.debug('Account Roles are : ' + accountRoles);
                if(String.isNotEmpty(accountRoles.Contact) && String.isEmpty(accountRoles.Account))
                {
                    ContactIdsSet.add(accountRoles.Contact);
                    system.debug('1');
                }
                if(String.isEmpty(accountRoles.Contact))
                {
                    PersonAccountIdSet.add(accountRoles.Account);
                }
            }
            if(!PersonAccountIdSet.isEmpty())
            {
                for(Account a : [Select Id, PersonContactId FROM Account Where Id =: PersonAccountIdSet])
                {
                    if(String.isNotEmpty(a.PersonContactId))
                    {
                    PersonAccountMap.put(a.Id, a);
                    system.debug('2');
                    }
                }
            }
            if(!ContactIdsSet.isEmpty())
            {
                for(Contact c : [Select Id, AccountId FROM Contact Where Id =: ContactIdsSet])
                {
                    ContactMap.put(c.Id, c);
                    system.debug('2');
                }
            }
            
            for(AccountRoleLineItems accountRoles : AR.AccountRoleLineItems)
            {
        
                if(String.isEmpty(accountRoles.Account))
                {
                    accountRoles.Account = ContactMap.get(accountRoles.Contact).AccountId;
                    system.debug('3');
                }

                if(accountRoles.Text.contains('Project Site Contact'))
                {
                    if(!String.isBlank(accountRoles.Account))
                    {
                        ProjectSiteContactAccount = accountRoles.Account;
                        system.debug('4 ' + ProjectSiteContactAccount);
                        if(PersonAccountMap.containsKey(accountRoles.Account))
                        {
                            ProjectSiteContactContact = PersonAccountMap.get(accountRoles.Account).PersonContactId;
                        }
                    }
                    if(!String.isBlank(accountRoles.Contact))
                    {
                        ProjectSiteContactContact = accountRoles.Contact;
                        system.debug('5');
                    }
                    if(ProjectSiteContactContact == null)
                    {
                        return 'The Project Site Contact must be a Person Account or have a Contact';
                    }
                }
                if(accountRoles.Text.contains('Primary/Bill-to'))
                {
                    if(!String.isBlank(accountRoles.Account))
                    {
                        PrimaryAccount = accountRoles.Account;
                        if(PersonAccountMap.containsKey(accountRoles.Account))
                        {
                            PrimaryContact = PersonAccountMap.get(accountRoles.Account).PersonContactId;
                        }
                    }
                    if(!String.isBlank(accountRoles.Contact))
                    {
                        PrimaryContact = accountRoles.Contact;
                        system.debug('7');
                    }
                }
                if(accountRoles.Text.contains('Referred By')|| accountRoles.Text.contains('Caller') )
                {
                    if(!String.isBlank(accountRoles.Account))
                    {
                        Referred = accountRoles.Contact;
                        system.debug('9');
                        if(PersonAccountMap.containsKey(accountRoles.Account))
                        {
                            Referred = PersonAccountMap.get(accountRoles.Account).PersonContactId;
                        }
                    }
                    if(!String.isBlank(accountRoles.Contact))
                    {
                        Referred = accountRoles.Contact;
                        system.debug('8');
                    }
                    if(accountRoles.Text.contains('Referred By') && !String.isBlank(accountRoles.Contact))
                    {
                        AEMContactSearchMap.put(accountRoles.Contact,'Referred By');
                        

                    }else if(accountRoles.Text.contains('Insurance Adjuster/Company') && !String.isBlank(accountRoles.Contact))
                        {
                            AEMContactSearchMap.put(accountRoles.Contact,'Insurance Adjuster/Company');
                        }
                        else if(accountRoles.Text.contains('Property/Facility Manager') && !String.isBlank(accountRoles.Contact))
                            {
                                AEMContactSearchMap.put(accountRoles.Contact, 'Property/Facility Manager');
                            }
                }

            }
            List<Account_Roles__c> ARsToDelete = [Select Id FROM Account_Roles__c Where Master_Job_Id__c =:recordId];
            ATI_Job__c job = new ATI_Job__c(Id = recordId, Referred_By__c = Referred, Account__c = PrimaryAccount, Contact__c = PrimaryContact, Project_Site_Contact_Account__c = ProjectSiteContactAccount, 
            Project_Site_Contact_Name__c = ProjectSiteContactContact);
            update job;
            
            for(AccountRoleLineItems accountRoles : AR.AccountRoleLineItems)
            {
                system.debug('Account Roles are '  + accountRoles);
                system.debug('Text is ' + accountRoles.Text);
                if(String.isNotEmpty(accountRoles.Account))
                {
                    Account_Roles__c ARRole = new Account_Roles__c(Account_ID__c = accountRoles.Account, Contact_ID__c = accountRoles.Contact, Master_Job_Id__c = job.Id,
                    Multiple_Roles__c = accountRoles.Text);
                    ARList.add(ARRole);
                }
                if(String.isEmpty(accountRoles.Account) && String.isNotEmpty(accountRoles.Contact))
                {
                    Account_Roles__c ARRole = new Account_Roles__c(Account_ID__c = ContactMap.get(accountRoles.Contact).AccountId, Contact_ID__c = accountRoles.Contact, Master_Job_Id__c = job.Id,
                    Multiple_Roles__c = accountRoles.Text);
                    ARList.add(ARRole);
                }
            }
            if(!ARList.isEmpty())
            {
                insert ARList;
                delete ARsToDelete;
            }
            
                return recordId;
    } catch (Exception e) 
    {
    system.debug('Exception is ' + e + '         Whats being return with string is ' + string.valueof(e));
        Database.rollback(sp);
        return string.valueOf(e);
    }
}             
    @AuraEnabled 
    public static string CreateNewJob(string AccountRoleInfo,string PropertyInfo, string JobInfo, string MasterJobId, string JobEntryType, string jobrecordId, boolean ExistingMasterJob){
        system.debug('Existing mster job' + ExistingMasterJob);
        system.debug('AccountRole Info ' + AccountRoleInfo);
        system.debug('Master Job Id ' + MasterJobId);
        system.debug('Property Info ' + PropertyInfo);
        system.debug('Job Info ' + JobInfo);
        system.debug('Job Entry Type ' + JobEntryType);
        system.debug('Job record Id ' + jobrecordId);
        Master_Job__c masterJob = new Master_Job__c();
        Master_Job__c MjobExisting = new Master_Job__c();
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
        
        
        AccountRoleWrapper AR = (AccountRoleWrapper)JSON.deserialize(AccountRoleInfo, AccountRoleWrapper.class);
        PropertyWrapper Property = (PropertyWrapper)JSON.deserialize(PropertyInfo, PropertyWrapper.class);
        JobWrapper jobWrap = (JobWrapper)JSON.deserialize(jobInfo, JobWrapper.class);
        PropertyAddresses propAddress = GoogleCallout(Property.Street,  Property.City, Property.Zip, Property.State);
        
        Savepoint sp = Database.setSavepoint();
        //Property.. if PropertyID is empty, insert with the info given, then attach AR Roles to them. => relate Prop to Master job
        try {

        
            system.debug('JobWrap is ' + jobWrap);
            system.debug('PropertyWrap is ' + Property);
            system.debug('AccountWrap is ' + AR);
            Set<Id> ContactIdsSet = new Set<Id>();
            Set<Id> PersonAccountIdSet = new Set<Id>();
            Map<Id,Contact> ContactMap = new Map<Id,Contact>();
            Map<Id,Account> PersonAccountMap = new Map<Id,Account>();
            Map<Id, string> AEMContactSearchMap = new Map<id,string>();
            
            for(AccountRoleLineItems accountRoles : AR.AccountRoleLineItems)
            {
                system.debug('Account Roles are : ' + accountRoles);
                if(String.isNotEmpty(accountRoles.Contact) && String.isEmpty(accountRoles.Account))
                {
                    ContactIdsSet.add(accountRoles.Contact);
                    system.debug('1');
                }
                if(String.isEmpty(accountRoles.Contact))
                {
                    PersonAccountIdSet.add(accountRoles.Account);
                }
            }
            if(!PersonAccountIdSet.isEmpty())
            {
                for(Account a : [Select Id, PersonContactId FROM Account Where Id =: PersonAccountIdSet])
                {
                    if(String.isNotEmpty(a.PersonContactId))
                    {
                    PersonAccountMap.put(a.Id, a);
                    system.debug('2');
                    }
                }
            }
            if(!ContactIdsSet.isEmpty())
            {
                for(Contact c : [Select Id, AccountId FROM Contact Where Id =: ContactIdsSet])
                {
                    ContactMap.put(c.Id, c);
                    system.debug('2');
                }
            }
            
            for(AccountRoleLineItems accountRoles : AR.AccountRoleLineItems)
            {
        
                if(String.isEmpty(accountRoles.Account))
                {
                    accountRoles.Account = ContactMap.get(accountRoles.Contact).AccountId;
                    system.debug('3');
                }

                if(accountRoles.Text.contains('Project Site Contact'))
                {
                    if(!String.isBlank(accountRoles.Account))
                    {
                        ProjectSiteContactAccount = accountRoles.Account;
                        system.debug('4 ' + ProjectSiteContactAccount);
                        if(PersonAccountMap.containsKey(accountRoles.Account))
                        {
                            ProjectSiteContactContact = PersonAccountMap.get(accountRoles.Account).PersonContactId;
                        }
                    }
                    if(!String.isBlank(accountRoles.Contact))
                    {
                        ProjectSiteContactContact = accountRoles.Contact;
                        system.debug('5');
                    }
                    if(ProjectSiteContactContact == null)
                    {
                        return 'The Project Site Contact must be a Person Account or have a Contact';
                    }
                }
                if(accountRoles.Text.contains('Primary/Bill-to'))
                {
                    if(!String.isBlank(accountRoles.Account))
                    {
                        PrimaryAccount = accountRoles.Account;
                        if(PersonAccountMap.containsKey(accountRoles.Account))
                        {
                            PrimaryContact = PersonAccountMap.get(accountRoles.Account).PersonContactId;
                        }
                    }
                    if(!String.isBlank(accountRoles.Contact))
                    {
                        PrimaryContact = accountRoles.Contact;
                        system.debug('7');
                    }
                }
                if(accountRoles.Text.contains('Referred By')|| accountRoles.Text.contains('Caller') )
                {
                    if(!String.isBlank(accountRoles.Account))
                    {
                        Referred = accountRoles.Contact;
                        system.debug('9');
                        if(PersonAccountMap.containsKey(accountRoles.Account))
                        {
                            Referred = PersonAccountMap.get(accountRoles.Account).PersonContactId;
                        }
                    }
                    if(!String.isBlank(accountRoles.Contact))
                    {
                        Referred = accountRoles.Contact;
                        system.debug('8');
                    }
                    if(accountRoles.Text.contains('Referred By') && !String.isBlank(accountRoles.Contact))
                    {
                        AEMContactSearchMap.put(accountRoles.Contact,'Referred By');
                        

                    }else if(accountRoles.Text.contains('Insurance Adjuster/Company') && !String.isBlank(accountRoles.Contact))
                        {
                            AEMContactSearchMap.put(accountRoles.Contact,'Insurance Adjuster/Company');
                        }
                        else if(accountRoles.Text.contains('Property/Facility Manager') && !String.isBlank(accountRoles.Contact))
                            {
                                AEMContactSearchMap.put(accountRoles.Contact, 'Property/Facility Manager');
                            }
                }

            }
            Id AEContactToUse;
            Boolean ReferredByAEToggled = false;
            
            if(!AEMContactSearchMap.isEmpty())
            {
                system.debug('AEMValues is ' + AEMContactSearchMap.values());
                Map<Id, Contact> contactOwners = new Map<Id, Contact>([Select Id, Owner.Id, Owner.Profile.Name FROM Contact Where Id =:AEMContactSearchMap.keySet()]);
                system.debug('contact owners is ' + contactOwners);
                for(Id cid : AEMContactSearchMap.keyset())
                {
                    if(AEMContactSearchMap.get(cid) == 'Referred By' && contactOwners.get(cid).Owner.Profile.Name == 'Marketing Representative'
                    && ReferredByAEToggled == false)
                    {
                        AEContactToUse = contactOwners.get(cid).Owner.Id;
                        ReferredByAEToggled = true;
                    }
                    if(AEMContactSearchMap.get(cid) == 'Insurance Adjuster/Company' && contactOwners.get(cid).Owner.Profile.Name == 'Marketing Representative'
                    && ReferredByAEToggled == false)
                    {
                        AEContactToUse = contactOwners.get(cid).Owner.Id;
                    }
                    if(AEMContactSearchMap.get(cid) == 'Property/Facility Manager' && contactOwners.get(cid).Owner.Profile.Name == 'Marketing Representative'
                    && ReferredByAEToggled == false)
                    {
                        AEContactToUse = contactOwners.get(cid).Owner.Id;
                    }
                }
            }
            ATI_Job__c jobToRemoveMJ = new ATI_Job__c();
            Master_Job__c mjToDelete = new Master_Job__c();
            double YearBuilt;
            if(!String.isBlank(jobWrap.YearBuilt)){
                YearBuilt = double.valueOf(jobWrap.YearBuilt);
            }
            //system.debug('Master Job Id  is  ' + MasterJobId);
            if(String.isEmpty(Property.PropertyId)){
            // prop.Property_Type__c = Property.PropertyType;
                // prop.Street__c = Property.Street;
                prop.City__c = propAddress.City;
                prop.Zip__c = propAddress.Zipcode;
                prop.Country__c = Property.Country;
                prop.State__c = propAddress.State;
                // prop.Address_Line_2__c = Property.AddressLine2;
                prop.Name = 'Test';
                // prop.Address_Line_1__c = Property.Street + ', ' + Property.State + ', ' + Property.City + ' ' + Property.Zip;
                prop.Address_Line_1__c = propAddress.Street;
                NewProperty= true;
                prop.Year_Structure_Built__c = YearBuilt;
                // prop.Job_Class__c = jobWrap.JobClass;
                prop.Market_Class__c = jobWrap.MarketClass;
                prop.Market_Segment__c = jobWrap.MarketSegment;
                prop.Market_Segment_Sub_Class__c = jobWrap.MarketSegmentSubClass;
                prop.Alternate_Name__c = Property.AlternateName;
                
                prop.County__c = propAddress.county;
                insert prop;  
                
            }else{
                prop = [Select Street__c, City__c, County__c, Zip__c, State__c, Address_Line_1__c, Address_Line_2__c FROM Property__c Where Id =: Property.PropertyId LIMIT 1];
            }
            Id mJobId;
            
            //if Master Job is empty, create one. 
            if(string.isEmpty(MasterJobId))
            {
                system.debug('Master job is null.. Existing job in if statement ' + ExistingMasterJob);
                if(AEContactToUse != null)
                {
                    masterJob.Account_Executive_1__c = AEContactToUse;
                }
                masterJob.Claim__c = jobWrap.Claim;
                masterJob.Policy__c = jobWrap.Policy;
                masterJob.Description_of_Loss__c = jobWrap.Description;
                masterJob.Stage__c = 'Pre-work';
                //masterJob.Deductible__c = Decimal.valueOf(jobWrap.Deductible);
                masterJob.Date_of_Loss__c = jobWrap.DateOfLoss;
                masterJob.Cont_P_O_Client_Job__c = jobWrap.ClientJob;
                masterJob.Lead_Source__c = jobWrap.LeadSource;
                masterJob.Taken_By__c = jobWrap.TakenBy;
                masterJob.Multiple_Divisions__c = jobWrap.MultipleDivisions;
                masterJob.office2__c = jobWrap.Office;
                masterJob.City__c = propAddress.City;
                masterJob.State__c = propAddress.State;
                masterJob.Address_Line_1__c = propAddress.Street;
                if(NewProperty)
                {
                    masterJob.Property__c = prop.Id;
                }else
                    {
                        masterJob.Property__c = Property.PropertyId;
                    }
                insert masterJob;
                mJobId = masterJob.id;
            }
            else if(!string.isEmpty(MasterJobId) && JobEntryType == 'NewJobEntry')
            {
                mJobId = MasterJobId;
                //PO__c, Send_prelim__c, PN_Request_Date__c,
                // PN_Amount__c, ML_amount__c, PN_Recording_Number__c, PN_Recording_Date__c,ML_Recording_Number__c,
                // ML_Request_Date__c,ML_Release_Recording_Date__c, 
                // Send_Prelim_Last_Modified_Date_Time__c, Send_Prelim_Last_Modified_Date_Time1__c,
                // ML_Recording_Date__c
                MjobExisting = [Select Id, Name,Policy__c, Cont_P_O_Client_Job__c,  Deductible__c, Claim__c,
                   Date_of_Loss__c, Major_Event__c, Major_Event__r.Name, Account_Executive_1__c, Account_Executive_2__c FROM Master_Job__c Where Id =:masterJobId];
                if(AEContactToUse != null && MjobExisting.Account_Executive_1__c == null)
                {
                MjobExisting.Account_Executive_1__c = AEContactToUse;
                }
                update MjobExisting;

            }
            else if(JobEntryType == 'AfterHoursJobEntry' && ExistingMasterJob == false)
            {
                system.debug('Existing job in if false statement ' + ExistingMasterJob);
                masterJob.Id = masterJobId;
                masterJob.Claim__c = jobWrap.Claim;
                masterJob.Description_of_Loss__c = jobWrap.Description;
                // masterJob.Stage__c = 'Pre-work';
                //masterJob.Deductible__c = Decimal.valueOf(jobWrap.Deductible);
                if(AEContactToUse != null)
                {
                    masterJob.Account_Executive_1__c = AEContactToUse;
                }
                masterJob.Date_of_Loss__c = jobWrap.DateOfLoss;
                masterJob.Cont_P_O_Client_Job__c = jobWrap.ClientJob;
                masterJob.Lead_Source__c = jobWrap.LeadSource;
                masterJob.Taken_By__c = jobWrap.TakenBy;
                masterJob.Multiple_Divisions__c = jobWrap.MultipleDivisions;
                masterJob.office2__c = jobWrap.Office;
                masterJob.AfterHoursUpdate__c = true;
                if(NewProperty)
                {
                    masterJob.Property__c = prop.Id;
                }else
                    {
                    masterJob.Property__c = Property.PropertyId;
                    }
            
                update masterJob;
                mJobId = MasterJobId;
            }
            else if(JobEntryType == 'AfterHoursJobEntry' && ExistingMasterJob == true)
            {
                jobToRemoveMJ = [Select Id, Master_Job__c FROM ATI_Job__c Where Id =:jobrecordId];
                MjobExisting = [Select Id, Name, Policy__c, Cont_P_O_Client_Job__c, PO__c,  Deductible__c, Claim__c,
                Date_of_Loss__c, Major_Event__c, Major_Event__r.Name, Account_Executive_1__c, Account_Executive_2__c FROM Master_Job__c Where Id =:masterJobId];
                if(AEContactToUse != null && MjobExisting.Account_Executive_1__c == null)
                {
                MjobExisting.Account_Executive_1__c = AEContactToUse;
                }
                // if(AEContactToUse != null && MjobExisting.Account_Executive_1__c != null && MjobExisting.Account_Executive_2__c == null)
                // {
                //     masterJob.Account_Executive_2__c = AEContactToUse;
                // }
                //MjobExisting.AfterHoursUpdate__c = true;
                mjToDelete.Id = JobToRemoveMJ.Master_Job__c;
                system.debug('Existing job in if statement ' + ExistingMasterJob);
                mJobId = MasterJobId;
                update masterJob;
            }
            
            //insert job, and relate to Master Job
            Id propId;
            if(NewProperty){
                propId = prop.Id;
            }else{
                propId = Property.PropertyId;
            }
            system.debug('NewJobEntry?? ' + JobEntryType);
            system.debug('Hitting before job insert, and MJobId is ' + mJobId );
            // if(prop.City__c.length() > 15){
            //     prop.City__c = prop.City__c.substring(0, 15);
            // }
            // if(prop.county__c != null && prop.County__c.length() > 15){
            //     prop.County__c = prop.County__c.substring(0, 15);
            // }
            //Job_Class__c = jobWrap.JobClass,
            
            ATI_Job__c job = new ATI_Job__c(Job_Name__c = jobWrap.JobName, Job_Request_Completed_By__c = UserInfo.getUserId(), Market_Class__c = jobWrap.MarketClass, Market_Segment__c = jobWrap.MarketSegment, 
            Market_Segment_Sub_Class__c = jobWrap.MarketSegmentSubClass, Office2__c = jobWrap.Office, Claim__c = jobWrap.Claim, Policy__c = jobWrap.Policy, Master_Job__c = mJobId, division__c = jobWrap.division,
            Lead_Source__c = jobWrap.LeadSource, property_Id__c = propId, Es_Job_Type__c = jobWrap.EsJobType, description__c = jobWrap.Description,
            Date_Of_loss__c = jobWrap.DateOfLoss, Cont_P_O_Client_Job__c = jobWrap.ClientJob, Project_Manager__c = jobWrap.ProjectDirector, Taken_By__c = jobWrap.TakenBy,
            Referred_By__c = Referred, Account__c = PrimaryAccount, Contact__c = PrimaryContact, Project_Site_Contact_Account__c = ProjectSiteContactAccount, 
            Project_Site_Contact_Name__c = ProjectSiteContactContact, county__c = propAddress.county, Project_Site_Address__c = prop.Address_Line_1__c, Project_Site_Address_2__c = Property.AddressLine2,
            Project_Site_City__c = prop.City__c, Project_Site_State__c = prop.State__c, Project_Site_Zipcode__c = prop.Zip__c, Year_Structure_Built__c = YearBuilt, Major_Event__c = jobWrap.MajorEvent);
            // List<ATI_Job__c> jobsas = [Select Id from ATI_Job__c where Id =: 'a4asd2f3asdfasd'];
            // jobsas[0].name = 'test';
           
                system.debug('Job date of loss is ' + job.Date_of_loss__c + ' jobwrap dol is ' + jobWrap.DateOfLoss);
            if(JobEntryType == 'NewJobEntry')
            {
                job.Name = jobWrap.JobName;
                job.Stage__c = 'Qualification';
                if(MjobExisting.Name != null)
                {
                    system.debug('mjob Exists ' + MjobExisting.date_of_Loss__c);
                    job.Account_Executive_1__c = MjobExisting.Account_Executive_1__c;
                    job.Account_Executive_2__c = MjobExisting.Account_Executive_2__c;
                    job.Date_of_loss__c = MjobExisting.Date_of_loss__c;
                    job.Deductible__c = MjobExisting.Deductible__c;
                    // job.Send_Prelim__c = MjobExisting.Send_Prelim__c;
                    // job.Send_Prelim_Last_Modified_Date_Time__c = MjobExisting.Send_Prelim_Last_Modified_Date_Time1__c;
                    // job.Send_Prelim_Last_Modified_By__c = MjobExisting.Send_Prelim_Last_Modified_Date_Time__c;
                    // job.PN_Request_Date__c = MjobExisting.PN_Request_Date__c;
                    // job.PN_Amount__c = MjobExisting.PN_Amount__c;
                    // job.PN_Recording_Number__c = MjobExisting.PN_Recording_Number__c;
                    // job.PN_Recording_Date__c = MjobExisting.PN_Recording_Date__c;
                    // job.ML_amount__c = MjobExisting.ML_amount__c;
                    // job.ML_Recording_Number__c = MjobExisting.ML_Recording_Number__c;
                    // job.ML_Recording_Date__c = MjobExisting.ML_Recording_Date__c;
                    // job.ML_Release_Recording_Date__c = MjobExisting.ML_Release_Recording_Date__c;
                    // job.ML_Request_Date__c = MjobExisting.ML_Request_Date__c;
                }else{
                    job.Account_Executive_1__c = AEContactToUse;
                }
            insert job;
            system.debug('Job date of loss is ' + job.Date_of_loss__c + ' jobwrap dol is ' + jobWrap.DateOfLoss);
            }
            if(JobEntryType =='AfterHoursJobEntry'){
                job.Name = jobWrap.JobRealName;
                job.Id = jobrecordId;
                job.Intake_Status__c = 'Reviewed/Completed';
                job.Date_Time_Completed__c = system.now();
                system.debug('Before update' + job.Master_Job__c);
                if(ExistingMasterJob == false)
                {
                    job.Account_Executive_1__c = AEContactToUse;
                   
                }
                if(ExistingMasterJob == true)
                {
                    job.Account_Executive_1__c = MjobExisting.Account_Executive_1__c;
                    job.Account_Executive_2__c = MjobExisting.Account_Executive_2__c;
                    job.Date_of_loss__c = MjobExisting.Date_of_loss__c;
                    job.Deductible__c = MjobExisting.Deductible__c;
                    // job.Send_Prelim__c = MjobExisting.Send_Prelim__c;
                    // job.Send_Prelim_Last_Modified_Date_Time__c = MjobExisting.Send_Prelim_Last_Modified_Date_Time1__c;
                    // job.Send_Prelim_Last_Modified_By__c = MjobExisting.Send_Prelim_Last_Modified_Date_Time__c;
                    // job.PN_Request_Date__c = MjobExisting.PN_Request_Date__c;
                    // job.PN_Amount__c = MjobExisting.PN_Amount__c;
                    // job.PN_Recording_Number__c = MjobExisting.PN_Recording_Number__c;
                    // job.PN_Recording_Date__c = MjobExisting.PN_Recording_Date__c;
                    // job.ML_amount__c = MjobExisting.ML_amount__c;
                    // job.ML_Recording_Number__c = MjobExisting.ML_Recording_Number__c;
                    // job.ML_Recording_Date__c = MjobExisting.ML_Recording_Date__c;
                    // job.ML_Release_Recording_Date__c = MjobExisting.ML_Release_Recording_Date__c;
                    // job.ML_Request_Date__c = MjobExisting.ML_Request_Date__c;
                }
            update job;
            system.debug('After update' + job.Master_Job__c);
            if(ExistingMasterJob == true && mjToDelete.Id != job.Master_Job__c){
                system.debug('MjJob To delete ' + mjToDelete);
            
            delete mjToDelete;
            }
            List<ATI_Job__c> jobs = new List<ATI_Job__c>();
            jobs.add(job);
            Create_Opportunity_Handler.createOpportunity(jobs);
            }
            // if(JobEntryType == 'NewJobEntry'){
            // MasterJobUpdateJob(mJobId, job.Id);
            // }
            //insert AR's and relate to job
            
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
            system.debug('Job Id ' + job.id);
            
            if(JobEntryType == 'AfterHoursJobEntry'){
                return jobrecordId;
            }else{
                return job.id;
            }
            
        } catch (Exception e) {
            system.debug('Exception is ' + e + '         Whats being return with string is ' + string.valueof(e));
                Database.rollback(sp);
                return string.valueOf(e);
        }
        

    }
    // @future
    // public static void MasterJobUpdateJob(Id MasterJobId, Id JobId){
    //     Master_Job__c mJob = new Master_Job__c(Id = MasterJobId, Job__c = JobId);
    //     update mJob;
    // }
    private static PropertyAddresses GoogleCallout(String Street, String City, String Zipcode, String State)
    {
    string county;
    string street1;
    string streetnumber;
    string localityCity;
    string sublocalityCity;
    string neighborhoodCity;
    string adminlevel3City;
    String address = Street + ', ' + State + ', ' + City + ' ' + Zipcode;
    PropertyAddresses propertyAddress = new PropertyAddresses();
    Http h = new Http();
    HttpRequest req = new HttpRequest();
    req.setEndpoint('https://maps.googleapis.com/maps/api/geocode/json?key=AIzaSyBuE7iBv1fugjx2Az7h-bCwJCoWOadglz8&address='+
    EncodingUtil.urlEncode(address, 'UTF-8')+'&sensor=false');
    req.setMethod('GET');
    req.setTimeout(60000);
    if(!Test.isRunningTest())
    {
        HttpResponse res = h.send(req);
        system.debug('Response is ' + res.getBody());
        resultswrapper result = (resultswrapper)JSON.deserialize(res.getBody(), resultswrapper.class);
        system.debug('results are ' + result);
        for(results a: result.results)
        {
            system.debug('a ' + a);
            for(address_components ad : a.address_components)
            {
                system.debug('ad ' + ad.types[0]);
                if(ad.types[0] == 'administrative_area_level_2')
                {
                    propertyAddress.county = ad.long_name.replace('County', '');
                }
                if(ad.types[0] == 'administrative_area_level_3')
                {
                    adminlevel3City = ad.short_name;
                }
                if(ad.types[0] == 'route')
                {
                    street1 = ad.short_name;
                }
                if(ad.types[0] == 'locality')
                {
                    localityCity = ad.short_name;
                }

                if(ad.types[0] == 'political')
                {
                    sublocalityCity = ad.short_name;
                    system.debug('Hitting 1 ' + sublocalityCity);

                }
                if(ad.types[0] == 'neighborhood')
                {
                    neighborhoodCity = ad.short_name;
                }
                if(ad.types[0] == 'administrative_area_level_1')
                {
                    propertyAddress.state = ad.short_name;
                }
                if(ad.types[0] == 'street_number')
                {
                    streetnumber = ad.short_name;
                //system.debug('street # is  ' + streetnumber);
                }
                if(ad.types[0] == 'postal_code')
                {
                    propertyAddress.ZipCode = ad.short_name;
                //  system.debug('Postal # is  ' + postalcode);
                }

            }  
        }
        if(streetnumber != null)
        {
            propertyAddress.street = streetnumber +' '+ street1;
        }
        else{
            propertyAddress.Street = street1;
        }
    }
    if(adminlevel3City != null)
    {
        propertyAddress.City = adminlevel3City;
    }
    if(neighborhoodCity != null)
    {
        propertyAddress.City = neighborhoodCity;
    }
    if(sublocalityCity != null)
    {
        propertyAddress.City = sublocalityCity;
    }
    if(localityCity != null)
    {
        propertyAddress.City = localityCity;
    }
    return propertyAddress;
}

    public class PropertyAddresses {
        public string Street {get;set;}
        public string City {get;set;}
        public string Zipcode {get;set;}
        public string State {get;set;}
        public string County {get;set;}
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
        public String AlternateName {get;set;}
    }
    
    public class resultswrapper{
        public list<results> results {get;set;}
    }
    public class results{
        public list<address_components> address_components{get;set;}
    }
    public class address_components{
        public String long_name {get;set;}
        public String short_name {get;set;}
        public list<String> types {get;set;}
    }
   

    public class JobWrapper{
        public Id Office {get;set;}
        public String Description {get;set;}
        public String Division {get;set;}
        public String JobClass {get;set;}
        public String Policy {get;set;}
        public String Claim {get;set;}
        public String Deductible {get;set;}
        public String MultipleDivisions {get;set;}
        public String LeadSource {get;set;}
        public String JobName {get;set;}  
        public String ClientJob {get;set;}  
        public String EsJobType {get;set;}  
        public String YearBuilt {get;set;}  
        public Id TakenBy {get;set;}  
        public Id ProjectDirector {get;set;}  
        public Date DateOfLoss {get;set;}  
        public Id MajorEvent {get;set;}
        public String JobRealName {get;set;}
        public String MarketClass {get;set;}
        public String MarketSegment {get;set;}
        public String MarketSegmentSubClass {get;set;}
        public Boolean ExistingMasterJob {get;set;}

    }
    // public class AccountWrapper{
    //     //public List<Id> PropertyId {get;set;}
        
        
    //     public List<Id> AccountId {get;set;}
    //     public string AccountName {get;set;}
    //     public string BillingStreet {get;set;}
    //     public string BillingCity {get;set;}
    //     public string BillingState {get;set;}
    //     public string BillingPostalCode {get;set;}
    //     public string TypeChange {get;set;}
    //     public string BillingCountry {get;set;}
    //     public string AccountPhone {get;set;}
    //     public string AccountPhoneExt {get;set;}
    // }
    // public class ContactWrapper{
    //     public List<Id> ContactId {get;set;}
    //     public string ContactType {get;set;}
    //     public string FirstName {get;set;}
    //     public string LastName {get;set;}
    //     public string MailingStreet {get;set;}
    //     public string MailingCity {get;set;}
    //     public string MailingState {get;set;}
    //     public string MailingCounty {get;set;}
    //     public list<Id> AccountId {get;set;}
    //     public string Phone {get;set;}
    //     public string Email {get;set;}
    //     public string PhoneExt {get;set;}
    //     public string MailingPostalCode {get;set;}
    // }
    
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