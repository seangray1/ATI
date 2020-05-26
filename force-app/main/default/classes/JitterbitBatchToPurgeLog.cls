global class JitterbitBatchToPurgeLog implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        Datetime dtTime=System.now();
        date dt= date.newinstance(dtTime.year(), dtTime.month(), dtTime.day());
        date DateToDelete=dt.addMonths(-3);
        return Database.getQueryLocator('select id  from Jitterbit_Log__c where CreatedDate < :DateToDelete');
    }
    
    // Execute Logic
    global void execute(Database.BatchableContext BC, List<Jitterbit_Log__c> scope){
         if(scope.size()>0)
            delete scope;
    }
    
    global void finish(Database.BatchableContext BC){
        // Logic to be Executed at finish
    }

}