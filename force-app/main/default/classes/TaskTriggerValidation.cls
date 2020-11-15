public with sharing class TaskTriggerValidation {
    public static void ValidateXactTask(List<Task> tasks) {
        Boolean checkForUserProfile = false;
        Map<Id,ATI_Job__c> jobs = new Map<Id,ATI_Job__c>();
        Set<Id> checkForTransactionId = new Set<Id>();
        List<Task> tasksPassed = new List<Task>();
        for(task t : tasks)
        {
            if(t.type =='XASP Program Note')
            {
                //check if admin and check if transaction ID is there
                if(t.whatId.getSobjectType().getDescribe().getName() == 'ATI_Job__c')
                {
                    checkForTransactionId.add(t.whatId);
                    checkForUserProfile = true;
                    tasksPassed.add(t);
                }
            }
        }
        if(!checkForTransactionId.isEmpty())
        {
            List<ATI_Job__c> jobList = [SELECT Id, XASP_Transaction_ID__c FROM ATI_Job__c WHERE Id =:checkForTransactionId];
            Id profileId = userInfo.getProfileId();
            Profile p = [SELECT Id, Name FROM Profile WHERE Id =:profileId];
            jobs.putAll(jobList);
            for(Task t : tasksPassed)
            {
                if(jobs.get(t.whatId).XASP_Transaction_ID__c == null)
                {
                    t.addError('Cannot create an activity with type Xact Note if the job does not have an Xact Transaction ID');
                }
                if(!p.Name.contains('Admin'))
                {
                    t.addError('Only Admins can create an Activity with an Xact Note type.');
                }
            }
        }
    }
}