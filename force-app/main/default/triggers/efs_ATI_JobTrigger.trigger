trigger efs_ATI_JobTrigger on ATI_Job__c (after update, after insert) 
{
    List<Profile> profileName = [SELECT Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
                                         if(profileName[0].Name != 'Restricted Process Execution'){
    if(trigger.isAfter && trigger.isInsert)
        efs__.EgnyteSyncQueueTrigger.onAfterInsert();
    else if(trigger.isAfter && trigger.isUpdate)
        efs__.EgnyteSyncQueueTrigger.onAfterUpdate();
                                         }
}