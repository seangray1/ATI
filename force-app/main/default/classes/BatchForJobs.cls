global class BatchForJobs implements Database.Batchable<sObject> {
    global String Query;
    global final String Entity;
    global final String Field;
    global final String Value;
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<ATI_Job__c> scope)
    {
        Map<Id,ATI_Job__c> jobMap = new Map<Id,ATI_Job__c>();
        Map<Id,ATI_Job__c> jobMapUpdate = new Map<Id,ATI_Job__c>();
        jobMap.putall(scope);
        Map<Id, Account_Roles__c> accountRoleMap = 
        new Map<Id,Account_Roles__c>([Select Id, Account_Id__c, Contact_Id__c, Master_Job_ID__c, Multiple_Roles__c
                                    FROM Account_Roles__c
                                    Where Master_Job_ID__c =:jobMap.keyset() AND Multiple_Roles__c INCLUDES ('Insurance Adjuster/Company')]);

        for(Account_Roles__c a : accountRoleMap.values())
        {
            ATI_Job__c job = new ATI_Job__c(Id = a.Master_Job_Id__c, Insurance_Company__c = a.Account_Id__c, Insurance_Adjuster_Broker__c = a.Contact_Id__c);
            jobMapUpdate.put(job.Id, job);
        }
        
        update jobMapUpdate.values();
        
    }
            
        global void finish(Database.BatchableContext BC){
        }
        }
