trigger LargeLossTrigger on Large_Loss_Review__c (before insert, before update, after update) {
    List<Profile> profileName = [SELECT Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
    if(profileName[0].Name != 'Restricted Process Execution')
    {
        if(Trigger.isBefore && Trigger.isUpdate){
            LargeLossUtility.AutoCreateNewLargeLoss(Trigger.oldMap, Trigger.new);
        }
        if(Trigger.isBefore && Trigger.isInsert){
            LargeLossUtility.LargeLossNameFormat(Trigger.new);
        } 
    }
}