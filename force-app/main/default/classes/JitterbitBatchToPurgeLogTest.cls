/**
 * @Author: DemandBlue
 * @Description: Test Class for JitterbitBatchToPurgeLog Batch Class to Delete the Records in Jitterbit Logs object 
 * @Ver: 1.0 
**/
@isTest
Public Class JitterbitBatchToPurgeLogTest{

@isTest
Static Void testJitterBitPurge(){

       List<Jitterbit_Log__c> jitLogs = new List<Jitterbit_Log__c>();
       
       for(Integer i = 0; i<10; i++){
             
           Jitterbit_Log__c jitLog = new Jitterbit_Log__c();
           jitLog.Name = 'Log'+ i;
           jitLog.Log_Name__c  = 'Jitterbit' + i;
           jitLog.Request_Body__c = 'Test Jitterbit' + i;
           jitLog.Request_Method__c = 'GET';
           jitLog.Response__c = 'Operation has been successful';
           jitLog.Success__c = True; 
           jitLogs.add(jitLog);     
       
       }
       
       insert jitLogs;
       
       for(Jitterbit_Log__c jitLog: jitLogs){
       
           Datetime jitLogDate = Datetime.now().addDays(-120);
           Test.setCreatedDate(jitLog.Id, jitLogDate);
       } 
       
       Test.startTest();

            JitterbitBatchToPurgeLog testPurge = new JitterbitBatchToPurgeLog();
            DataBase.executeBatch(testPurge); 
            
        Test.stopTest();

  }

}