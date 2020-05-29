/**
* @File Name          : Create_Opportunity_Handler.cls
* @Description        : 
* @Author             : sean.gray@atirestoration.com
* @Group              : 
* @Last Modified By   : sean.gray@atirestoration.com
* @Last Modified On   : 3/18/2020, 7:35:16 AM
* @Modification Log   : 

* Ver       Date            	Author      		    			Modification
* 1.0    	3/18/2020   		sean.gray@atirestoration.com     	Initial Version
**/


//Create Opportunity when a job record is created
public without sharing class Create_Opportunity_Handler 
{
    public static void createOpportunity(ATI_Job__c[] listJobs)
    {
        system.debug('JobList is ' + listJobs);
        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Job Opportunity').getRecordTypeId();
        List<Opportunity> listInsertOpportunity= new List<Opportunity>();
        List<Account_Roles__c> fetchBillToAccountRoles = new List<Account_Roles__c>();
        set<id> setJobsPropertyIds = new Set<id>();
        set<id> jobIds = new Set<id>();

        for(ATI_Job__c newJob: listJobs) {
            system.debug('Property Id is ' + newJob.Property_ID__c);
            if(newJob.Property_ID__c <> null) {
                setJobsPropertyIds.add(newJob.Property_ID__c) ; 
                jobIds.add(newjob.id);
                
            }
        }
        
        if(!jobIds.isEmpty()) {
        //     system.debug('Jobids ' + jobIds);
        //     fetchBillToAccountRoles = [select id,name, Multiple_Roles__c, Property_ID__c from Account_Roles__c where Master_Job_ID__c =: jobIds AND Multiple_Roles__c includes('Primary/Bill-to') LIMIT 1];  
        //     system.debug('Account Roles are ' + fetchBillToAccountRoles);
        //     //fetchBillToAccountRoles = [select id,name, Roles__c, Property_ID__c from Account_Roles__c where Property_ID__c IN: jobIds AND Multiple_Roles__c includes('Primary/Bill-to') LIMIT 1];  
        // }
        // system.debug('Account Roles are ' + fetchBillToAccountRoles);
        // if(!fetchBillToAccountRoles.isEmpty()){
            Opportunity newOpportunity = new Opportunity ();
            for(ATI_Job__c eachjob: listJobs) {
                newOpportunity.Job__c = eachjob.id;
                newOpportunity.RecordTypeId = recordTypeId;
                newOpportunity.StageName = 'Prospecting';
                //newOpportunity.Property__c = Fetch_BillTo_AccountRoles[0].Property_ID__c;
                newOpportunity.Property__c=eachjob.Property_ID__c;
                newOpportunity.Contact__c = eachjob.Contact__c;
                newOpportunity.Project_Site_Contact_Name__c = eachjob.Project_Site_Contact_Name__c;
                newOpportunity.Project_Site_Contact_Account__c = eachjob.Project_Site_Contact_Account__c;
                newOpportunity.Owner__c = eachjob.Owner__c;
                newOpportunity.Insurance_Adjuster_Broker__c = eachjob.Insurance_Adjuster_Broker__c;
                newOpportunity.Office2__c = eachjob.Office2__c;
                system.debug('Job Name is ' + eachjob.Name);
                newOpportunity.Name = eachjob.Name;
                system.debug('Job Name is ' + eachjob.Name);
                newOpportunity.Division__c = eachjob.Division__c;
                newOpportunity.Major_Event__c = eachjob.Major_Event__c;
                system.debug('Job Name is ' + eachjob.Name);
                newOpportunity.Job_Name__c= eachjob.Job_Name__c;
                newOpportunity.Project_Site_State__c= eachjob.Project_Site_State__c;
                newOpportunity.Project_Site_Address__c= eachjob.Project_Site_Address__c;
                newOpportunity.Project_Site_Zipcode__c= eachjob.Project_Site_Zipcode__c;
                newOpportunity.County__c=eachjob.County__c;
                newOpportunity.Project_Site_City__c= eachjob.Project_Site_City__c;
                newOpportunity.CloseDate = date.today();
                newOpportunity.AccountId = eachjob.Account__c;
                system.debug('Job Name is ' + eachjob.Name);
                if(eachjob.Referred_by__c <> null) {
                    newOpportunity.Contact__c=eachjob.Referred_by__c;
                } else {
                    newOpportunity.Contact__c=eachjob.Contact__c; 
                }
            }
            system.debug('Job Name is ');
            listInsertOpportunity.add(newOpportunity);
        }
       
        if(!listInsertOpportunity.isEmpty()){
            insert listInsertOpportunity;
        }
    }
    
    
    // Update opportunity record when Referred_by__c field is changed
    public static void updateOpportunity(ATI_Job__c[]  newJobsList,Map<id,ATI_Job__c> oldJobsList, Map<Id, ATI_Job__c> newJobMap){
        Map<Id,Opportunity> OppMap =new Map<Id,Opportunity>();
        Boolean Changed = false;
        set<id> setJobIds = new Set<id>();
        
        for(ATI_Job__c newJob: newJobsList) {
            if(newJob.Property_ID__c <> null) {
                setJobIds.add(newJob.Id) ; 
            }
        }
        if(!setJobIds.isEmpty()){
            system.debug('Number of job ids' + setJobIds);
            List<Opportunity> Opp = [Select Id, Job__c from Opportunity where Job__c =:setJobIds];
            if(!Opp.isEmpty())
            {
                for(Opportunity o: opp)
                {
                    OppMap.put(o.Id, o);
                }
            }
        // ID OpportunityID = (ID) [Select ID from Opportunity where Job__c =:setJobIds Limit 1].ID;
        system.debug('Number of Opps ' + Opp);
        if(!OppMap.isEmpty()){
        for(Id o:OppMap.keyset()){
            Opportunity oppInLoop = OppMap.get(o);
            ATI_Job__c jobInOpp = newJobMap.get(oppInLoop.Job__c);
             
            if(oldJobsList.containsKey(jobInOpp.Id)){
                ATI_Job__c jobRecord = oldJobsList.get(jobInOpp.id);
                if(jobRecord.Referred_by__c <> jobInOpp.Referred_by__c || jobRecord.Name != jobInOpp.Name || jobRecord.Division__c != jobInOpp.Division__c
                || jobRecord.Amount__c != jobInOpp.Amount__c || jobRecord.Office2__c != jobInOpp.Office2__c){
                    OppMap.get(o).Division__c = jobInOpp.Division__c;
                    OppMap.get(o).Office2__c = jobInOpp.Office2__c;
                    OppMap.get(o).Amount = jobInOpp.Amount__c;
                    OppMap.get(o).Name = jobInOpp.Name;
                    Changed = true;
                    if(jobInOpp.Referred_by__c <> null){
                        OppMap.get(o).Contact__c=jobInOpp.Referred_by__c;
                    } else {
                        OppMap.get(o).Contact__c=jobInOpp.Contact__c;                           
                    }
                }                   
            }
        }
    }
}
        
        if(Changed)
        {
            update OppMap.values();
        }
    }
}