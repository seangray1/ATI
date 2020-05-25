public with sharing class JobTriggerHandlerWorkflow {
    public static void MasterJobAmountRollup(List<ATI_Job__c> jobs, Map<Id,ATI_Job__c> newJobMap, Map<Id,ATI_Job__c> oldJobMap) {
        Set<Id> NewJobMasterSet = new Set<Id>();
        Set<Id> OldJobMasterSet = new Set<Id>();
        Map<Id, Master_Job__c> MasterJobs = new Map<Id, Master_Job__c>();
        List<Master_Job__c> MasterJobToUpdate = new List<Master_Job__c>();
        for(ATI_Job__c job : jobs){
            NewJobMasterSet.add(job.Master_Job__c);
        }
        if(!NewJobMasterSet.isEmpty()){
           List<Master_Job__c> MasterJobsList = [Select Id, Amount__c FROM Master_Job__c WHere Id =:NewJobMasterSet];
           MasterJobs.putall(MasterJobsList);
        }
        if(!MasterJobs.isEmpty()){
        for(ATI_Job__c job : jobs){
            ATI_Job__c oldJob = oldJobMap.get(job.Id);
            if(oldJob != null && job.Amount__c != oldJob.Amount__c){
                system.debug('Master job map contains ' +  MasterJobs.get(job.Master_Job__c));
                if(MasterJobs.get(job.Master_Job__c).Amount__c  == null){
                    MasterJobs.get(job.Master_Job__c).Amount__c = 0;
                }
                MasterJobs.get(job.Master_Job__c).Amount__c = MasterJobs.get(job.Master_Job__c).Amount__c + job.Amount__c;
                Master_Job__c mj = new Master_Job__c(Id = job.master_job__c, Amount__c = MasterJobs.get(job.Master_job__c).Amount__c);
                MasterJobToUpdate.add(mj);
            }
            if(oldJob != null && job.Amount__c == oldJob.Amount__c && job.Master_Job__c != oldJob.Master_Job__c){
                if(MasterJobs.get(job.Master_Job__c).Amount__c  == null){
                    MasterJobs.get(job.Master_Job__c).Amount__c = 0;
                }
                MasterJobs.get(job.Master_Job__c).Amount__c = MasterJobs.get(job.Master_Job__c).Amount__c + job.Amount__c;
                Master_Job__c mj = new Master_Job__c(Id = job.master_job__c, Amount__c = MasterJobs.get(job.Master_job__c).Amount__c);
                MasterJobToUpdate.add(mj);
            }
        }
    }
        if(!MasterJobToUpdate.isEmpty()){
            update MasterJobToUpdate;
        }
    }
}
