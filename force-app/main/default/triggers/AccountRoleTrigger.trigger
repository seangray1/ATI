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
        //Sean Gray added
        //Updates Job send prelim - no if the account role Account name contains Vixxo, Facility, Farmers, Total Property Management
        if(Trigger.isAfter)
        {
            AccountRoleTriggerHandler.UpdateJobSendPrelim(Trigger.new, Trigger.oldMap);
        }

}