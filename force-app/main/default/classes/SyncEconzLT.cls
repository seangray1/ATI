public class SyncEconzLT {
    
    public static boolean isECONZCalloutsProcessed = false;
    public static dateTime startdate = null;
    @AuraEnabled
    public static String executeJob(String jobId){
        system.debug('jobId--'+jobId);
        ATI_Job__c job = [select Id, Stage__c from ATI_Job__c where Id =: jobId];
            return Econz_Integration_Callouts.invokeIntegration(jobId);
    }
    
    public static void AfterHourEconzCall(list<ATI_Job__c> newValues)
    {
        Id devRecordTypeId = Schema.SObjectType.ATI_Job__c.getRecordTypeInfosByName().get('Job (Approved)').getRecordTypeId();
        List<ATI_Job__c> JobsToQueue = new List<ATI_Job__c>();
           Map<Id, String> CalloutTypeMap = new Map<Id, String>();
           Map<Id, String> OldNameMap = new Map<Id, String>();
           Map<Id, Datetime> StartDateMap = new Map<Id, Datetime>();
           Map<Id,ATI_Job__c> oldMap = new Map<Id,ATI_Job__c>();
           Map<Id,ATI_Job__c> jobsCarriedOver = new Map<Id,ATI_Job__c>();
        for(ATI_Job__c job : newValues)
        {
            startdate = job.date_time_approved__c;
            if(job.RecordTypeID == devRecordTypeId && job.ECONZ_Task_Created__c == false)
            {
                //Econz_Integration_Callouts.ECONZ_Future_Call(job.Id,'addTask',null,startdate);
                CalloutTypeMap.put(job.Id, 'addTask');    
                //OldNameMap.put(job.Id, 'addTask');    
                StartDateMap.put(job.Id, startdate);    
                JobsToQueue.add(job);
            }  
        }
        Id queueId = System.enqueueJob(new Econz_Queueable_Integration(JobsToQueue, CalloutTypeMap, OldNameMap, StartDateMap, oldMap, jobsCarriedOver));
    }
}