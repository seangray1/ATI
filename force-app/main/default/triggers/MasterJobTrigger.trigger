trigger MasterJobTrigger on Master_Job__c (before insert, before update, after update) {
    List<Profile> profileName = [SELECT Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
                                         if(profileName[0].Name != 'Restricted Process Execution' && !System.isBatch())
                                         {
    if(Trigger.isBefore && Trigger.isInsert){
        MasterJobTriggerHandler.MasterJobNameFormat(trigger.new);
    }
    if(Trigger.isBefore && Trigger.isUpdate){
        MasterJobTriggerHandler.MasterJobNameUpdate(trigger.new, trigger.oldMap, trigger.newMap);
    }
    if(Trigger.isAfter && Trigger.isUpdate){
        MasterJobTriggerHandler.UpdateJobDetails(trigger.new, trigger.oldMap, trigger.newMap);
    }
}
}