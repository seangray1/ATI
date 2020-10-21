public with sharing class LeadOppConversion {
    @AuraEnabled 
    public static string ConvertLeadToOpp(Id recordId, string LeadData, string ContactData, String Street, String City, String State, String Zipcode, String AddressLine2) 
    {
        
        AccountRoleWrapper ContactIds;
        AccountRoleWrapper LeadIds;
        if(LeadData != null)
        {
            LeadIds = (AccountRoleWrapper)JSON.deserialize(LeadData, AccountRoleWrapper.class);
        }
        if(ContactData != null)
        {
            ContactIds = (AccountRoleWrapper)JSON.deserialize(ContactData, AccountRoleWrapper.class);
        }
        
        string objectName = recordId.getSobjectType().getDescribe().getName();
        Lead l = new Lead();
        
        Contact c = new Contact();
        if(objectName == 'Lead')
        {
                l = [SELECT Id, Name,Title, Phone, Major_Event__c, BD_Opportunity__c, Location_of_Interest__c, LeadSource, Description, Email, Company,Rating,
                            Street, City, PostalCode, State
                FROM Lead
                WHERE Id =: recordId];
        }
        if(objectName == 'Contact')
        {
            c = [SELECT Id, Name,Title, Phone,  BD_Opportunity__c, Email, Lead_Status__c, Major_Event__c, Description,
                            MailingStreet, MailingCity, MailingPostalCode, MailingState, AccountId
                FROM Contact
                WHERE Id =: recordId];
        }
        NewJobController.PropertyAddresses prop = NewJobController.GoogleCallout(Street, City, Zipcode, State);
        Savepoint sp = Database.setSavepoint();
        try 
        {
        // Map <String, Schema.RecordTypeInfo> oppRecordType = Schema.SObjectType.ATI_Job__c.RecordTypeInfosByName;
        Id recordtypeid = Schema.SObjectType.Opportunity.RecordTypeInfosByName.get('BD Opportunity').getRecordTypeId();
        Map<String, Id> officeName = new Map<String,Id>();
        List<Office__c> offices = [Select Id, Name FROM Office__c];
        for(Office__c o : offices)
        {
            officeName.put(o.Name, o.Id);
        }
        Id officeId;
        if(objectName == 'Lead' && l.Location_of_Interest__c != null)
        {
            switch on l.Location_of_Interest__c 
            {
                when 'Boston' { officeId = officeName.get('New England');}
                when else {		  
                    officeId = officeName.get(l.Location_of_Interest__c);
                }
            }
        }
        
        String nameofOpp;
        if(objectName == 'Lead')
        {
            nameofOpp = l.Name;
            system.debug('Lead Name is ' + l.Name + nameofOpp);
            if(l.Company != null)
            {
                nameofOpp += ' - ' + l.Company;
                system.debug('Lead Name now  ' + l.Company + nameofOpp);
            }
            
        }
        if(objectName == 'Contact')
        {
            nameofOpp = c.Name;
            // if(l.Company != null)
            // {
            //     nameofOpp =+ ' - ' + l.Company;
            // }
            
        }
        
        Opportunity o = new Opportunity(Name = nameofOpp, Job_Name__c = nameofOpp, 
                                        Project_Site_Address__c = prop.Street, Project_Site_City__c = prop.City, Project_Site_Zipcode__c = prop.Zipcode, 
                                        Project_Site_State__c = prop.State, County__c = prop.County, StageName = 'Working', CloseDate = date.today().adddays(5),
                                        Lead_Converted_Opportunity__c = true);
        if(objectName == 'Lead')
        {
            o.Title__c = l.Title; o.RecordTypeId = recordtypeid; o.Phone__c = l.Phone; o.Office2__c = officeId;
            o.Description = l.Description; o.Email__c = l.Email; o.Account_Name__c = l.Company; o.Major_Event__c = l.Major_Event__c;o.Rating__c = l.Rating;
        }
        if(objectName == 'Contact')
        { 
            o.RecordTypeId = recordtypeid;o.Title__c = c.Title; o.RecordTypeId = recordtypeid; o.Phone__c = c.Phone;
            o.Description = c.Description; o.Email__c = c.Email; o.Major_Event__c = c.Major_Event__c; o.AccountId = c.AccountId;
        }
        if(o.Job_name__c.length() > 29){
            o.Job_name__c = o.Job_name__c.substring(0, 29);
        }
        insert o;
        List<Lead> leadToUpdate = new List<Lead>();
        if(LeadData != null)
        {
            for(AccountRoleLineItems leadContainer : LeadIds.AccountRoleLineItems)
        {
            if(leadContainer.LeadId != null)
            {
                Lead ld = new Lead(Id = leadContainer.LeadId, BD_Opportunity__c = o.Id);
                leadToUpdate.add(ld);
            }
            
        }
        }
        
        if(!leadToUpdate.isEmpty())
        {
            update leadToUpdate;
        }
       
        
        List<Contact> contactsToUpdate = new List<Contact>();
        if(ContactData != null)
        {
        for(AccountRoleLineItems leadContainer : ContactIds.AccountRoleLineItems)
        {
            if(leadContainer.ContactId != null)
            {
                Contact ld = new Contact(Id = leadContainer.ContactId, BD_Opportunity__c = o.Id);
                contactsToUpdate.add(ld);
            }
            
        }
        }
        if(!contactsToUpdate.isEmpty())
        {
            update contactsToUpdate;
        }
        return o.Id;
        }
         catch (Exception e ) 
         {
            Database.rollback(sp);
            return e.getMessage();
        }
    }
    // If Opportunity is converted from Lead, and changes to closed won, it will automatically create a job similar to the job request form. Contact Center will 
    //then finish
    public static void CreateJobFromOpp(List<Opportunity> opps, Map<Id,Opportunity> oldOpps, Map<Id,Opportunity> newMap)
    {
        Map<Id,ATI_Job__c> jobMap = new Map<Id,ATI_Job__c>();
        Map<Id,Lead> leadMap = new Map<Id,Lead>();
        Map<Id, Opportunity> OppsToConvertToJob = new Map<Id, Opportunity>();
        Map<Id, Master_Job__c> OppIdMasterJobMap = new Map<Id, Master_Job__c>();
        for(Opportunity o : opps)
        {
            if(o.StageName == 'Closed Won' && o.Lead_Converted_Opportunity__c == true && o.StageName != oldOpps.get(o.Id).StageName)
            {
                //create Job with opp info....
                //Need to carry over office, division, put notes in description, also link the related Contact leads in the description as well
                
                OppsToConvertToJob.put(o.Id, o);
            }
        }
        if(!OppsToConvertToJob.isEmpty())
        {
            List<Lead> lds = [Select Id, Name, BD_Opportunity__c  FROM Lead WHERE BD_Opportunity__c =: OppsToConvertToJob.keySet()];
            if(!lds.isEmpty())
            {
                
                for(Opportunity o:OppsToConvertToJob.values())
                {
                    o.Contact_Info__c = 'Leads To Convert:';
                }
                for(Lead l : lds)
                {
                    OppsToConvertToJob.get(l.BD_Opportunity__c).Contact_Info__c += '\n' + l.Name  + '  ' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + l.Id;
                    
                }
            }
            List<Contact> conts = [Select Id, Name,BD_Opportunity__c FROM Contact WHERE BD_Opportunity__c =: OppsToConvertToJob.keySet()];
            if(!conts.isEmpty())
            {
                for(Opportunity o:OppsToConvertToJob.values())
                {
                    o.Contact_Info__c += '\n' + 'Related Contacts: ';
                }
                
                for(Contact c : conts)
                {
                    OppsToConvertToJob.get(c.BD_Opportunity__c).Contact_Info__c += '\n' + c.Name  + '  ' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + c.Id;
                }
            }
            for(Opportunity o : OppsToConvertToJob.values())
            {
                Master_Job__c mj = new Master_Job__c(Office2__c = o.Office2__c, Description_of_Loss__c = o.Description, Stage__c = 'Pre-work');
                mj.City__c = o.Project_Site_City__c;
                mj.State__c = o.Project_Site_State__c;
                mj.Address_Line_1__c = o.Project_Site_Address__c;
                mj.Major_Event__c = o.Major_Event__c;
                OppIdMasterJobMap.put(o.Id, mj);
            }
            insert(OppIdMasterJobMap.values());
            Id userId = userinfo.getUserId();
            Map <String, Schema.RecordTypeInfo> jobRecordTypeMap = Schema.SObjectType.ATI_Job__c.RecordTypeInfosByName;
            Id recordtypeid = Schema.SObjectType.ATI_Job__c.RecordTypeInfosByName.get('Job (Approved)').getRecordTypeId();
            List<Account> account = [select id, PersonContactId, name from account where LastName =: 'ES Job Account'];
            Map<Id, ATI_Job__c> JobsToInsert = new Map<Id,ATI_Job__c>();
            for(Opportunity o : OppsToConvertToJob.values())
            {
                if(o.Job_name__c.length() > 29){
                    o.Job_name__c = o.Job_name__c.substring(0, 29);
                }
                ATI_Job__c job = new ATI_Job__c(Name = 'Test Job 1',  Job_Name__c = o.Job_Name__c,Stage__c = 'Qualification', Taken_By__c = userId, Project_Manager__c = o.Project_Manager__c,
                Office2__c = o.Office2__c, Master_Job__c = OppIdMasterJobMap.get(o.Id).Id, recordtypeId = recordtypeid, Division__c = o.Division__c, Description__c = o.Description, Project_Site_Address__c = o.Project_Site_Address__c,
                Project_Site_City__c = o.Project_Site_City__c, BD_Opportunity__c = o.Id, Project_Site_State__c = o.Project_Site_State__c, County__c= o.County__c, Date_Time_approved__c = system.now(), Project_Site_Zipcode__c = o.Project_Site_Zipcode__c, 
                 CloseDate__c = date.today().adddays(5), Major_Event__c = o.Major_Event__c, Contact_Info__c = o.Contact_Info__c, Intake_Status__c = 'Business Requested', Date_Time_Submitted__c = system.now(),
                Date_Time_Taken__c = system.now());
                system.debug('Job info is ' + job);
                // JobsToInsert.add(job);
                JobsToInsert.put(o.Id, job);
                
            }
            system.debug('JobsToInsert ' + JobsToInsert);
            insert JobsToInsert.values();
            system.debug('JobsToInsert ' + JobsToInsert);
            for(Id oppId : JobsToInsert.keyset())
            {
                newMap.get(oppId).Job__c = JobsToInsert.get(oppId).Id;
            }
            system.debug('NewMap ' + newMap);
            List<Lead> LeadsToUPdate = new List<Lead>();
            for(Lead l : [Select Id, Name, BD_Opportunity__c  FROM Lead WHERE BD_Opportunity__c =: OppsToConvertToJob.keySet()])
            {
                l.Job__c = JobsToInsert.get(l.BD_Opportunity__c).Id;
                leadsToUpdate.add(l);
            }
            if(LeadsToUPdate.isEmpty())
            {
            update LeadsToUPdate;
            }
            List<Contact> ContactsToUpdate = new List<Contact>();
            for(Contact l : [Select Id, Name, BD_Opportunity__c  FROM Contact WHERE BD_Opportunity__c =: OppsToConvertToJob.keySet()])
            {
                l.Job__c = JobsToInsert.get(l.BD_Opportunity__c).Id;
                ContactsToUpdate.add(l);
            }
            if(ContactsToUpdate.isEmpty())
            {
                update ContactsToUpdate;
            }
            
            
        }
    }
    @AuraEnabled
    public static string AddLeadContact(String recordId,string LeadData, string ContactData){
        Savepoint sp = Database.setSavepoint();
        try {
            
        
        AccountRoleWrapper ContactIds;
        AccountRoleWrapper LeadIds;
        if(LeadData != null)
        {
            LeadIds = (AccountRoleWrapper)JSON.deserialize(LeadData, AccountRoleWrapper.class);
        }
        if(ContactData != null)
        {
            ContactIds = (AccountRoleWrapper)JSON.deserialize(ContactData, AccountRoleWrapper.class);
        }
        List<Lead> leadToUpdate = new List<Lead>();
        if(LeadData != null)
        {
            for(AccountRoleLineItems leadContainer : LeadIds.AccountRoleLineItems)
        {
            if(leadContainer.LeadId != null)
            {
                Lead ld = new Lead(Id = leadContainer.LeadId, BD_Opportunity__c = recordId);
                leadToUpdate.add(ld);
            }
            
        }
        }
        
        if(!leadToUpdate.isEmpty())
        {
            update leadToUpdate;
        }
       
        
        List<Contact> contactsToUpdate = new List<Contact>();
        if(ContactData != null)
        {
        for(AccountRoleLineItems leadContainer : ContactIds.AccountRoleLineItems)
        {
            if(leadContainer.ContactId != null)
            {
                Contact ld = new Contact(Id = leadContainer.ContactId, BD_Opportunity__c = recordId);
                contactsToUpdate.add(ld);
            }
            
        }
        }
        if(!contactsToUpdate.isEmpty())
        {
            update contactsToUpdate;
        }
        return recordId;
        }
         catch (Exception e ) 
         {
            Database.rollback(sp);
            return e.getMessage();
        }
    }
    @AuraEnabled
    public static SObject GetAddress(Id recordId, string objectName)
    {
        if(objectName == 'Lead')
        {
            Lead l = [SELECT Id, Street, City, PostalCode, State FROM Lead WHERE Id =:recordId];
            return l;
        }
        else{
            Contact c = [SELECT Id, MailingState, MailingCity, MailingPostalCode, MailingStreet FROM Contact WHERE Id =:recordId];
            return c;
        }
    }
    @AuraEnabled
    public static String updateOpportunityAddress(Id recordId,  String Street, String City, String State, String Zipcode, String AddressLine2)
    {
        
        UpdateOppAddress(recordId, Street, City, State, Zipcode, AddressLine2);
        return 'Success';
        
    }
    @Future(Callout=true)
    public static void UpdateOppAddress(Id recordId,  String Street, String City, String State, String Zipcode, String AddressLine2)
    {
        NewJobController.PropertyAddresses prop = NewJobController.GoogleCallout(Street, City, Zipcode, State);
        Id recordtypeid = Schema.SObjectType.Opportunity.RecordTypeInfosByName.get('BD Opportunity').getRecordTypeId();
        Opportunity o = new Opportunity(Id = recordId,Project_Site_Address__c = prop.Street, Project_Site_City__c = prop.City, Project_Site_Zipcode__c = prop.Zipcode, 
        Project_Site_State__c = prop.State, County__c = prop.County);
        update o;
    }
    @AuraEnabled
    public static Id GetBDRecordTypeId(){
        Id recordtypeid = Schema.SObjectType.Opportunity.RecordTypeInfosByName.get('BD Opportunity').getRecordTypeId();
        return recordtypeid;
    }
    

    public class AccountRoleWrapper{
        public List<AccountRoleLineItems> AccountRoleLineItems {get;set;}
    }
    public class AccountRoleLineItems{
        // public String Text {get;set;}
        public Id LeadId {get;set;}
        public Id ContactId {get;set;}
        // public List<AccountIds> Account {get;set;}
    }
   
}
