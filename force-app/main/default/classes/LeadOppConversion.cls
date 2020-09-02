public with sharing class LeadOppConversion {
    @AuraEnabled 
    public static string ConvertLeadToOpp(Id recordId, string LeadData) 
    {
        try 
        {
        AccountRoleWrapper LeadIds = (AccountRoleWrapper)JSON.deserialize(LeadData, AccountRoleWrapper.class);
        Lead l = [SELECT Id, Name,Title, Phone, Major_Event__c, BD_Opportunity__c, Location_of_Interest__c, LeadSource, Lead_Notes__c, Email, Company,
                            Street, City, PostalCode, State
                FROM Lead
                WHERE Id =: recordId];
        // Map <String, Schema.RecordTypeInfo> oppRecordType = Schema.SObjectType.ATI_Job__c.RecordTypeInfosByName;
        Id recordtypeid = Schema.SObjectType.Opportunity.RecordTypeInfosByName.get('BD Opportunity').getRecordTypeId();
        Map<String, Id> officeName = new Map<String,Id>();
        List<Office__c> offices = [Select Id, Name FROM Office__c];
        for(Office__c o : offices)
        {
            officeName.put(o.Name, o.Id);
        }
        Id officeId;
        if(l.Location_of_Interest__c != null)
        {
            switch on l.Location_of_Interest__c 
            {
                when 'Boston' { officeId = officeName.get('New England');}
                when else {		  
                    officeId = officeName.get(l.Location_of_Interest__c);
                }
            }
        }
        NewJobController.PropertyAddresses prop = NewJobController.GoogleCallout(l.Street, l.City, l.PostalCode, l.State);
        String nameofOpp = l.Name;
        if(l.Company != null)
        {
            nameofOpp =+ ' - ' + l.Company;
        }
        Opportunity o = new Opportunity(Name = nameofOpp, Job_Name__c = nameofOpp, Title__c = l.Title, RecordTypeId = recordtypeid, Phone__c = l.Phone, Office2__c = officeId,
                                        Description = l.Lead_Notes__c, Email__c = l.Email, Account_Name__c = l.Company, Major_Event__c = l.Major_Event__c,
                                        Project_Site_Address__c = prop.Street, Project_Site_City__c = prop.City, Project_Site_Zipcode__c = prop.Zipcode, 
                                        Project_Site_State__c = prop.State, County__c = prop.County, StageName = 'Working', CloseDate = date.today().adddays(5),
                                        Lead_Converted_Opportunity__c = true);
        if(o.Job_name__c.length() > 29){
            o.Job_name__c = o.Job_name__c.substring(0, 29);
        }
        insert o;
        List<Lead> leadToUpdate = new List<Lead>();
        for(AccountRoleLineItems leadContainer : LeadIds.AccountRoleLineItems)
        {
            Lead ld = new Lead(Id = leadContainer.LeadId, BD_Opportunity__c = o.Id);
            leadToUpdate.add(ld);
        }
        update leadToUpdate;
        return o.Id;
        }
         catch (Exception e ) 
         {
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
                o.Contact_Info__c = 'Leads To Convert:';
                OppsToConvertToJob.put(o.Id, o);
            }
        }
        if(!OppsToConvertToJob.isEmpty())
        {
            for(Lead l : [Select Id, Name, BD_Opportunity__c  FROM Lead WHERE BD_Opportunity__c =: OppsToConvertToJob.keySet()])
            {
                OppsToConvertToJob.get(l.BD_Opportunity__c).Contact_Info__c += '\n' + l.Name  + '  ' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + l.Id;
                
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
                ATI_Job__c job = new ATI_Job__c(Name = 'Test Job 1',  Job_Name__c = o.Job_Name__c,Stage__c = 'Qualification', Taken_By__c = userId,
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
                l.Job__c = JobsToInsert.get(l.BD_Opportunity__c).Job__c;
                leadsToUpdate.add(l);
            }
            update LeadsToUPdate;
            
        }
    }
    public class AccountRoleWrapper{
        public List<AccountRoleLineItems> AccountRoleLineItems {get;set;}
    }
    public class AccountRoleLineItems{
        // public String Text {get;set;}
        public Id LeadId {get;set;}
        // public Id Contact {get;set;}
        // public List<AccountIds> Account {get;set;}
    }
   
}
