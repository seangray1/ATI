public with sharing class MasterJobTriggerHandler {
    public static void MasterJobNameFormat(List<Master_Job__c> MasterJobs) {
        Set<Id> mjobids = new Set<Id>();
        for(Master_Job__c MasterJob : MasterJobs){

            if(MasterJob.Address_Line_1__c != null && MasterJob.City__c != null && MasterJob.State__c != null){
                MasterJob.Name = MasterJob.Address_Line_1__c + ' ' + MasterJob.City__c + ' ' + MasterJob.State__c ; 
            }
            if(MasterJob.Date_Of_Loss__c != null){
                MasterJob.Name = MasterJob.Name + ' || ' + MasterJob.Date_Of_Loss__c;
            }
        }

    }
    public static void MasterJobNameUpdate(List<Master_Job__c> newMasterJobs, map<Id,Master_Job__c> oldMasterJobs){
        for(Master_Job__c MasterJob : newMasterJobs){
            if(MasterJob.Date_Of_Loss__c != oldMasterJobs.get(MasterJob.Id).Date_Of_Loss__c && MasterJob.Date_Of_Loss__c != null){
                MasterJob.Name = MasterJob.Address_Line_1__c + ' ' + MasterJob.City__c + ' ' + MasterJob.State__c + ' || ' + MasterJob.Date_Of_Loss__c;
            }
        }
    }
}
