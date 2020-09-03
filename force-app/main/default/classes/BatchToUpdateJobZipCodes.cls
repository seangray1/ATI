global class BatchToUpdateJobZipCodes implements Database.Batchable<sObject> {
  
    global String Query;
    global final String Entity;
    global final String Field;
    global final String Value;
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        
        return Database.getQueryLocator(Query);
    }
    global void execute(Database.BatchableContext BC, List<ATI_Job__c> scope)
    {
        try{
            List<ATI_Job__c> jobsToUpdate = new List<ATI_Job__c>();
            Set<String> ZipSet = new Set<String>();
            Map<String,Office_Zip_Code__c> offMap = new Map<String,Office_Zip_Code__c>();
            for(ATI_Job__c j : scope)
            {
                if(j.Project_Site_Zipcode__c != null && j.Project_Site_Zipcode__c.length() > 4)
                {
                    string zip = j.Project_Site_Zipcode__c.substring(0, 5);
                    ZipSet.add(zip);
                }
            }
            List<Office_Zip_Code__c> zips = [SELECT Id, Office__c, Office__r.Name, Name
                                            FROM Office_Zip_Code__c 
                                            WHERE NAME =:ZipSet];
            for(Office_Zip_Code__c oz : zips)
            {
                offMap.put(oz.Name, oz);
            }
            for(ATI_Job__c j : scope)
            {
                if(j.Project_Site_Zipcode__c != null && j.Project_Site_Zipcode__c.length() > 4)
                {
                    string zip = j.Project_Site_Zipcode__c.substring(0, 5);
                    if(offMap.containsKey(zip))
                    {
                        Office_Zip_Code__c ozc = offMap.get(zip);
                        j.Office_By_Zip_Code__c = ozc.Office__r.Name;
                        jobsToUpdate.add(j);
                        
                    }
                }
            }
            update jobsToUpdate;
    }catch(Exception e){
        Log__c batcherror = new Log__c( Message__c = e.getMessage());
        insert batcherror;
    }
        
    }
            
        global void finish(Database.BatchableContext BC){
        }
        }