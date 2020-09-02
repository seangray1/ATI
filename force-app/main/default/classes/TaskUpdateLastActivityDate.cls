public with sharing class TaskUpdateLastActivityDate {
    public static void TaskUpdateLastActivityDate(List<Task> tasks) 
    {
        // check for whether parent Id is Lead or Job, then check for Type = Marketing note or Project Note
        List<ATI_Job__c> jobsToUpdate = new List<ATI_Job__c>();
        List<Lead> leadsToUpdate = new List<Lead>();
        for(Task t : tasks)
        {
            if(t.whoId != null && t.WhoId.getSObjectType().getDescribe().getName() == 'Lead')
            {
                if(t.Type == 'Marketing Note')
                {
                    //Add Lead fields to update: Last Marketing Note Date, Comments, CreatedBy
                    Lead ld = new Lead(Id = t.WhoId, Last_Lead_Marketing_Note_Comment__c = t.Description,Last_Lead_Marketing_Note_Date_Time__c = t.CreatedDate, Last_Lead_Marketing_Note_By__c = t.CreatedById );
                    leadsToUpdate.add(ld);
                }
            }
            if(t.WhatId != null && t.WhatId.getSObjectType().getDescribe().getName() == 'ATI_Job__c')
            {
                if(t.Type == 'Marketing Note')
                {
                    //Add Lead fields to update: Last Marketing Note Date, Comments, CreatedBy
                    ATI_Job__c ld = new ATI_Job__c(Id = t.WhatId, Last_Marketing_Note_Comment__c = t.Description,Last_Marketing_Note_Date_Time__c = t.CreatedDate, Last_Marketing_Note_By__c = t.CreatedById);
                    jobsToUpdate.add(ld);
                }
                if(t.Type == 'Project Note')
                {
                    //Add Lead fields to update: Last Marketing Note Date, Comments, CreatedBy
                    ATI_Job__c ld = new ATI_Job__c(Id = t.WhatId, Last_Project_Note_Comment__c = t.Description,Last_Project_Note_Date_Time__c = t.CreatedDate, Last_Project_Note_By__c = t.CreatedById );
                    jobsToUpdate.add(ld);
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
}
