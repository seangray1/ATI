global class BatchToUpdateLastActivity implements Database.Batchable<sObject> {
    global String Query;
    global final String Entity;
    global final String Field;
    global final String Value;
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<SObject> scope)
    {
        List<ATI_Job__c> jobsToUpdate = new List<ATI_Job__c>();
        List<ATI_Job__c> jobsWithTasks = new List<ATI_Job__c>();
        List<Lead> leadsToUpdate = new List<Lead>();
        List<Lead> leadsWithTasks = new List<Lead>();
        if(scope[0].Id.getSObjectType().getDescribe().getName() == 'Lead')
        {
            leadsWithTasks = [SELECT Id, (SELECT Id, Type, CreatedDate,CreatedById,WhoId, Description 
                                                        FROM Tasks 
                                                        WHERE Type = 'Marketing Note' 
                                                        ORDER BY CreatedDate DESC ) 
                                            FROM Lead 
                                            WHERE Id =:scope];
        }
        if(scope[0].Id.getSObjectType().getDescribe().getName() == 'ATI_Job__c')
        {
            jobsWithTasks = [SELECT Id, (SELECT Id, Type, CreatedDate,CreatedById,WhoId, Description 
                                                        FROM Tasks 
                                                        WHERE Type = 'Marketing Note' OR Type = 'Project Note' 
                                                        ORDER BY CreatedDate DESC ) 
                                            FROM ATI_Job__c 
                                            WHERE Id =:scope];
        }
        system.debug('JobsWithTasks Count is ' + jobsWithTasks.size());
        if(!leadsWithTasks.isEmpty())
        {
            for(Lead obj : leadsWithTasks)
            {
                if(!obj.Tasks.isEmpty())
                {
                    
                        if(obj.Tasks[0].Type == 'Marketing Note')
                        {
                            Lead ld = new Lead(Id = obj.Id,Last_Lead_Marketing_Note_Comment__c = obj.Tasks[0].Description,Last_Lead_Marketing_Note_Date_Time__c = obj.Tasks[0].CreatedDate, Last_Lead_Marketing_Note_By__c = obj.Tasks[0].CreatedById );
                            leadsToUpdate.add(ld);
                        }
            
                }
            }
        }
        if(!jobsWithTasks.isEmpty())
        {
            for(ATI_Job__c obj : jobsWithTasks)
            {
                system.debug('Obj ' + obj);
                if(!obj.Tasks.isEmpty())
                {
                    system.debug('Obj tasks' + obj.Tasks[0]);
                    
                        system.debug('Obj is Job');
                            if(obj.Tasks[0].Type == 'Marketing Note')
                            {
                                ATI_Job__c ld = new ATI_Job__c(Id = obj.Id,Last_Marketing_Note_Comment__c = obj.Tasks[0].Description,Last_Marketing_Note_Date_Time__c = obj.Tasks[0].CreatedDate, Last_Marketing_Note_By__c = obj.Tasks[0].CreatedById);
                                jobsToUpdate.add(ld);
                            }
                            if(obj.Tasks[0].Type == 'Project Note')
                            {
                                ATI_Job__c ld = new ATI_Job__c(Id = obj.Id,Last_Project_Note_Comment__c = obj.Tasks[0].Description,Last_Project_Note_Date_Time__c = obj.Tasks[0].CreatedDate, Last_Project_Note_By__c = obj.Tasks[0].CreatedById );
                                jobsToUpdate.add(ld);
                            }
                }   
            }
        } 
        if(!jobsToUpdate.isEmpty())
        {
            update jobsToUpdate;
        }
        if(!leadsToUpdate.isEmpty())
        {
            update leadsToUpdate;
        }
    }   
    
    global void finish(Database.BatchableContext BC){
    }
}