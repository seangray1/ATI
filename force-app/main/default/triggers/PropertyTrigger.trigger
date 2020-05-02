trigger PropertyTrigger on Property__c (before insert, before update) {
    if(Trigger.isBefore && Trigger.isInsert){
        PropertyTriggerHandler.PropertyNameFormat(trigger.new);
    }
    if(Trigger.isBefore && Trigger.isUpdate){
        PropertyTriggerHandler.PropertyNameUpdate(trigger.new, trigger.oldMap);
    }
}