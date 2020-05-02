trigger MasterJobTrigger on Master_Job__c (before insert, before update) {
    if(Trigger.isBefore && Trigger.isInsert){
        MasterJobTriggerHandler.MasterJobNameFormat(trigger.new);
    }
    if(Trigger.isBefore && Trigger.isUpdate){
        MasterJobTriggerHandler.MasterJobNameUpdate(trigger.new, trigger.oldMap);
    }
}