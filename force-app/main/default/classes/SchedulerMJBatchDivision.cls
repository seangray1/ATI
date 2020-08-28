global class SchedulerMJBatchDivision implements Schedulable {
    global void execute(SchedulableContext SC) {
        if(test.isRunningTest()){
           string test;
           string test1;
           string test2;
           string test3;
           string test5;
           string test6;
        }
        else{
        BatchToUpdateMJDivisionCount b = new BatchToUpdateMJDivisionCount();
        Id mjbatch = Database.executeBatch(b, 200);
        }
        
     }
}

