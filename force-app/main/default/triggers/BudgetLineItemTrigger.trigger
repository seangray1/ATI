trigger BudgetLineItemTrigger on Budget_Line_Item__c (before insert, before update, after insert) {

    if (Trigger.isBefore)
    {
        BudgetLineItemFieldUpdate.LineItemFieldUpdate(trigger.new);
    }
    if (Trigger.isAfter && Trigger.isInsert){
        BudgetLineItemFieldUpdate.InsertErrortLogForTrade(trigger.new);
    }
    
}