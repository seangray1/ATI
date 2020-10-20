global class BatchToUpdateMJDivisionCount implements Database.Batchable<sObject> {
  
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        
        return Database.getQueryLocator('Select Id, Construction_Job_Count__c, ES_Job_Count__c, Consulting_Job_Count__c, ' +
        'Contents_Job_Count__c, Asbestos_Job_Count__c, Biohazard_Job_Count__c, Catastrophes_Job_Count__c,'
        +'Demolition_Job_Count__c,Marketing_Job_Count__c, Microbial_Job_Count__c, Technical_Services_Job_Count__c, Lead_Job_Count__c'
        + ' FROM Master_Job__c' );
    }
    global void execute(Database.BatchableContext BC, List<Master_Job__c> scope)
    {
        try{
            List<Master_Job__c> masterjobs = [SELECT Id, Construction_Job_Count__c, ES_Job_Count__c, Consulting_Job_Count__c,
            Contents_Job_Count__c, Asbestos_Job_Count__c, Biohazard_Job_Count__c, Catastrophes_Job_Count__c,
            Demolition_Job_Count__c,Marketing_Job_Count__c, Microbial_Job_Count__c, Technical_Services_Job_Count__c,Lead_Job_Count__c,
            (SELECT Id, Division__c FROM Jobs__r)
            FROM Master_Job__c
            WHERE Id =:scope];
        for(Master_Job__c mj : masterjobs)
        {
            mj.Lead_Job_Count__c = 0;
            mj.Construction_Job_Count__c = 0;
            mj.Consulting_Job_Count__c = 0;
            mj.Contents_Job_Count__c = 0;
            mj.ES_Job_Count__c = 0;
            mj.Asbestos_Job_Count__c = 0;
            mj.Biohazard_Job_Count__c = 0;
            mj.Catastrophes_Job_Count__c = 0;
            mj.Demolition_Job_Count__c = 0;
            mj.Marketing_Job_Count__c = 0;
            mj.Microbial_Job_Count__c = 0;
            mj.Technical_Services_Job_Count__c = 0;
            for(ATI_Job__c job : mj.Jobs__r)
            {
                if(job.Division__c == 'Construction')
                {
                    mj.Construction_Job_Count__c += 1;
                }
                if(job.Division__c == 'Consulting')
                {
                    mj.Consulting_Job_Count__c += 1;
                }
                if(job.Division__c == 'Contents')
                {
                    mj.Contents_Job_Count__c += 1;
                }
                if(job.Division__c == 'Emergency Svces')
                {
                    mj.ES_Job_Count__c += 1;
                }
                if(job.Division__c == 'Lead')
                {
                    mj.Lead_Job_Count__c += 1;
                }
                if(job.Division__c == 'Asbestos')
                {
                    mj.Asbestos_Job_Count__c += 1;
                }
                if(job.Division__c == 'Biohazard')
                {
                    mj.Biohazard_Job_Count__c += 1;
                }
                if(job.Division__c == 'Catastrophes')
                {
                    mj.Catastrophes_Job_Count__c += 1;
                }
                if(job.Division__c == 'Demolition')
                {
                    mj.Demolition_Job_Count__c += 1;
                }
                if(job.Division__c == 'Marketing')
                {
                    mj.Marketing_Job_Count__c += 1;
                }
                if(job.Division__c == 'Microbial')
                {
                    mj.Microbial_Job_Count__c += 1;
                }
                if(job.Division__c == 'Technical Svces')
                {
                    mj.Technical_Services_Job_Count__c += 1;
                }
            }
        }
        update masterjobs;
    }catch(Exception e){
        Log__c batcherror = new Log__c( Message__c = e.getMessage());
        insert batcherror;
    }
        
    }
            
        global void finish(Database.BatchableContext BC){
        }
        }