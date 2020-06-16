trigger AccountRoleTrigger on Account_Roles__c (after insert,after update,before delete) {

        if(Trigger.isAfter && Trigger.isInsert){
            AccountRoleTriggerHandler.InsertCampaignJunction(Trigger.new);            
        }
        if(Trigger.isAfter && Trigger.isUpdate){
                AccountRoleTriggerHandler.UpdateCampaignJunction(Trigger.new, Trigger.oldMap);            
        }
        if (Trigger.isbefore && Trigger.isDelete) {
            AccountRoleTriggerHandler.DeleteCampaignJunction(Trigger.old);
        }

}