trigger BudgetLineItemTrigger on Budget_Line_Item__c (before insert, before update, before delete, after insert, after update, after delete) {
    List<Profile> profileName = [SELECT Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
    if(profileName[0].Name != 'Restricted Process Execution' || Test.isRunningTest())
    {
    if (System.Label.BudgetLineItem_Trigger_IsActive == '1') { //Validation of Custom Label value to Activate/De-active the Trigger execution.
        
        if (Trigger.isBefore && (Trigger.isUpdate || Trigger.isInsert)){
            BudgetLineItemFieldUpdate.LineItemFieldUpdate(trigger.new);
            //BudgetLineItemFieldUpdate.CreateSubparentforEstimateItem(trigger.new);
        }
        
        if (Trigger.isAfter && Trigger.isDelete){
            if(CheckRecursiveOnBLIUpdate.runOnce()){
            BudgetLineItemFieldUpdate.RecalconDelete(trigger.old);
            BudgetLineItemFieldUpdate.UpdateOverheadProfit(Trigger.old, null);
            }
        }
        
        if (Trigger.isAfter && Trigger.isUpdate){
            //if(CheckRecursiveOnBLIUpdate.runOnce()){BudgetLineItemFieldUpdate.CreateSubParentforEstimateItem(trigger.new);}
            //BudgetLineItemFieldUpdate.EstimateLineItemCalculationUpdate(trigger.new);
            if(CheckRecursiveOnBLIUpdate.runOnce()){
                BudgetLineItemFieldUpdate.CreateParentforEstimateItem(trigger.new,Trigger.oldMap);
                BudgetLineItemFieldUpdate.RollDownCalcforEstimateItem(trigger.new,Trigger.oldMap);
                //BudgetLineItemFieldUpdate.UncheckBypass(trigger.new,Trigger.oldMap);  
            }
            
        }
        if (Trigger.isAfter && Trigger.isInsert){
            BudgetLineItemFieldUpdate.InsertErrortLogForTrade(trigger.new);
            if(CheckRecursiveOnBLIUpdate.runOnce()){BudgetLineItemFieldUpdate.CreateSubParentforEstimateItem(trigger.new);}
            //BudgetLineItemFieldUpdate.CreateSubparentforEstimateItem(trigger.new);
            //BudgetLineItemFieldUpdate.EstimateLineItemCalculationUpdate(trigger.new);
        }
        if(Trigger.isAfter)
        {
            if(Trigger.isUpdate)
            {
                // BudgetLineItemFieldUpdate.UpdateOverheadProfit(trigger.new, Trigger.oldMap);
            }
            if(Trigger.isInsert)
            {
                // BudgetLineItemFieldUpdate.UpdateOverheadProfit(trigger.new, null);
            }
            
        }

     }
}
}