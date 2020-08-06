trigger PropertyTrigger on Property__c (before insert, before update) {
    List<Profile> profileName = [SELECT Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
                                         if(profileName[0].Name != 'Restricted Process Execution')
                                         {
    if(Trigger.isBefore && Trigger.isInsert){
        PropertyTriggerHandler.PropertyNameFormat(trigger.new);
    }
    if(Trigger.isBefore && Trigger.isUpdate){
        PropertyTriggerHandler.PropertyNameUpdate(trigger.new, trigger.oldMap, trigger.newMap);
    }
}
}