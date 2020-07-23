@isTest(SeeAllData=true)
public with sharing class MicaSync_Test {
    static testmethod void MicaSyncTest(){
        List<ATI_Job__c> jobs = [Select Id FROM ATI_Job__c WHERE name = '000-00-00002 | Test Job 1'];
        MICASync.UpdateJob(jobs[0].id); 
 
    } 
}