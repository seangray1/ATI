global class BatchToUpdateBudgetLineItems implements Database.Batchable<sObject> {
  
    global String Query;
    global final String Entity;
    global final String Field;
    global final String Value;
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        
        return Database.getQueryLocator(Query);
    }
    global void execute(Database.BatchableContext BC, List<Budget__c> scope)
    {
        try{
            
            //Getting budget line items
            system.debug('Scope size ' + scope.size());
            // system.debug('Budgets are ' + scope);
            List<Budget__c> budgets = 
            [SELECT Id,Allocation_Overhead__c,Budget_LineItem_Status__c,Allocations__c,X3_Program_Fees__c,GP_Goal__c,Overhead__c,Profit__c,
            Sales_Tax__c,Overhead_Profit_Sales_Tax__c,Tax_Exempt__c, Allocation_Percentage__c,
            (SELECT Actual_Costs__c,Actual_Costs_BL__c,Selector__c,Allocations__c,Allocation_Amount__c,Allocation_Overhead__c, Allocation_Percentage__c,
            Budget_Goal_Amount__c,Budget_Goal__c,Budget__c,Burden__c,CreatedById,CreatedDate, Estimated_Completion_Date__c,Fees__c,Gross_Profit__c,Id,
            In_House_Hours__c,In_House_Rate__c,In_House_Total__c, IsDeleted,LastModifiedById,LastModifiedDate,Materials__c,Name,OrderNumber__c,Profit__c,
            Program_Fees__c, Program_Fee_Amount__c,Revenue__c,Start_Date__c,Subcontractor_bid__c,Subcontractor__c,SystemModstamp,Trade_Option__c,Trade__c,
            X10_10_Allocation__c, Is_sub_Parent__c, Is_Parent__c, DonotDelete__c,GP__c,Equipment__c,Other_Costs__c,Item_Description__c 
            FROM Budget_Line_Items__r)
            FROM Budget__c
            WHERE Budget_LineItem_Status__c = null AND Id =: scope];
            
            List<Budget_Line_Item__c> budLinesToUpdate = new  List<Budget_Line_Item__c>();
            for(Budget__c bud : budgets)
            {
                bud.Overhead__c = 0;
                bud.Profit__c = 0;
                for(Budget_Line_Item__c budLI : bud.Budget_Line_Items__r)
                {
                    if(budLI.GP__c == 0 || budLI.GP__c == null)
                    {
                        Budget_Line_Item__c bl = new Budget_Line_Item__c(GP__c = Decimal.valueOf(bud.GP_Goal__c), Id = budLI.Id);
                        // budLI.GP__c = bud.GP_Goal__c;
                        budLinesToUpdate.add(bl);
                        
                    }
                    if(budLI.X10_10_Allocation__c == true && budLI.Revenue__c != null && budLI.Revenue__c != 0 && budLI.DonotDelete__c == false)
                    {
                        bud.Overhead__c += budLI.Revenue__c * bud.Allocation_Percentage__c;
                        bud.Profit__c += budLI.Revenue__c * bud.Allocation_Percentage__c;
                    }
                }
            }
            if(!budLinesToUpdate.isEmpty())
            {
                update budLinesToUpdate;
            }
            update budgets;
    }catch(Exception e){
        Log__c batcherror = new Log__c( Message__c = e.getMessage());
        insert batcherror;
    }
        
    }
            
        global void finish(Database.BatchableContext BC){
        }
        }
