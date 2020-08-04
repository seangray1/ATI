//ECONZ_Integration_RetryBatch

global class ECONZ_Integration_RetryBatch implements Database.Batchable<SObject>,Database.AllowsCallouts{
    global string strQuery;
    
    global ECONZ_Integration_RetryBatch(string condition){
        strQuery = 'SELECT Id, Name, Stage__c, Recordtype.id, Job_Name__c, Project_Manager_New__r.Email, Project_Manager_New__r.Name, Project_Manager__r.Name, Division__c, Office__c, Job_Start_Date__c, Date_Time_Approved__c, Job_Prev_Name__c,Project_Site_Address_2__c, Project_Site_Address__c, Project_Site_City__c, Project_Site_State__c, Completion_Date__c, Project_Manager_New__r.EConz_Primary_Key__c,Project_Site_Zipcode__c, ECONZ_Error_Message__c, ECONZ_Integration_Error__c, ECONZ_Last_Callout_Time__c, ECONZ_Task_Created__c, Project_Site_Name_Fotoin__c,Project_Site_Record_Id__c, Project_Site_Call_Result_Message__c, Last_Successful_FotoIn_Update__c, Last_FotoIn_Update__c, Project_Site_Name__c, year__c, job_number__c FROM ATI_Job__c WHERE (ECONZ_Integration_Error__c = true AND Job_Start_Date__c != NULL) OR (Job_Start_Date__c != NULL AND ECONZ_Task_Created__c = false AND Stage__c = \'Won\')';
                        system.debug('----Query---'+strQuery);

        if(!string.isEmpty(condition))
            strQuery = strQuery +  ' AND ' + condition;
    }
    
    global database.Querylocator start(Database.batchableContext bc){   
                system.debug('----Query---'+strQuery);

        return Database.getQueryLocator(strQuery);
    }
            
    global void execute(Database.BatchableContext BC, list<ATI_JOb__c> sobjlist){ 
        for(ATI_Job__c obj : sobjlist){
            //ATI_Job__c Job = (ATI_Job__c) obj;
            if(!Test.isRunningTest())
                Econz_Integration_Callouts.invokeIntegration(obj.Id);
        }
    }
                
    global void finish(Database.BatchableContext BC){ 
                        
    }

}