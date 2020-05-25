trigger BudgetLineItemTrigger on Budget_Line_Item__c (before insert, before update) {

    if (Trigger.isBefore)
    {
        BudgetLineItemFieldUpdate.LineItemFieldUpdate(trigger.new);
    }
    
}