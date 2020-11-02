public without sharing class BudgetLWCController {

    @AuraEnabled(cacheable=true)
    public static List<Budget__c> RetrieveBudget(Id budgetId) 
    {
        List<Budget__c> budgetRecord = [Select Id,Allocation_Overhead__c,Budget_LineItem_Status__c,Allocations__c,X3_Program_Fees__c,GP_Goal__c,Overhead__c,Profit__c,Sales_Tax__c,Overhead_Profit_Sales_Tax__c,Tax_Exempt__c FROM Budget__c Where Id =: budgetId];
        return budgetRecord;
    }

    @AuraEnabled(cacheable=true)
    public static list<Budget_line_item__c> RetrieveBudgetLineItems(Id budgetId) 
    {
        system.debug('ID from LWC:'+budgetId);
        List<Budget_Line_Item__c> budgetRecord = [ Select Actual_Costs__c,Actual_Costs_BL__c,Selector__c,Allocations__c,Allocation_Amount__c,Allocation_Overhead__c, Allocation_Percentage__c,Budget_Goal_Amount__c,Budget_Goal__c,Budget__c,Burden__c,CreatedById,CreatedDate, Estimated_Completion_Date__c,Fees__c,Gross_Profit__c,Id,In_House_Hours__c,In_House_Rate__c,In_House_Total__c, IsDeleted,LastModifiedById,LastModifiedDate,Materials__c,Name,OrderNumber__c,Profit__c,Program_Fees__c, Program_Fee_Amount__c,Revenue__c,Start_Date__c,Subcontractor_bid__c,Subcontractor__c,SystemModstamp,Trade_Option__c,Trade__c,X10_10_Allocation__c, Is_sub_Parent__c, Is_Parent__c, DonotDelete__c,GP__c,Equipment__c,Other_Costs__c,Item_Description__c FROM Budget_Line_Item__c Where Budget__c =: budgetId and (Is_sub_Parent__c=true or Is_Parent__c=true) ORDER BY Trade__c ASC];
        return budgetRecord;
    }

    @AuraEnabled(cacheable=true)
    public static list<Budget_line_item__c> GetBudgetLineItemData(Id BLIId) 
    {
        system.debug('ID from LWC:'+BLIId);
        List<Budget_Line_Item__c> budgetRecord = [ Select Actual_Costs__c,Selector__c,Allocations__c,Allocation_Amount__c,Allocation_Overhead__c, Allocation_Percentage__c,Budget_Goal_Amount__c,Budget_Goal__c,Budget__c,Burden__c,CreatedById,CreatedDate, Estimated_Completion_Date__c,Fees__c,Gross_Profit__c,Id,In_House_Hours__c,In_House_Rate__c,In_House_Total__c, IsDeleted,LastModifiedById,LastModifiedDate,Materials__c,Name,OrderNumber__c,Profit__c,Program_Fees__c, Program_Fee_Amount__c,Revenue__c,Start_Date__c,Subcontractor_bid__c,Subcontractor__c,SystemModstamp,Trade_Option__c,Trade__c,X10_10_Allocation__c, Is_sub_Parent__c, Is_Parent__c, DonotDelete__c,GP__c,Equipment__c,Other_Costs__c,Item_Description__c FROM Budget_Line_Item__c Where Id =: BLIId ORDER BY Trade__c ASC];
        return budgetRecord;
    }

    // TO get Job Details -- By DemandBlue
    @AuraEnabled(cacheable=true)
    public static List<ATI_Job__c> RetrieveJob(Id jobId) 
    {
        system.debug('Test:'+jobId);
        return [Select Id,Job_Start_Date__c,Estimated_Completion_Date__c,Branch_Manager__c,Project_Manager__c,Project_Manager_new__c FROM ATI_Job__c Where Id =: jobId];
    }    

    // TO get the API for Budget from Metadata -- By DemandBlue
    @AuraEnabled(cacheable=true)
    public static List<BudgetLWCFields__mdt> getAPINamesFromMetadata() {
        return [SELECT Budget_API_Names__c, LWC_Section__c FROM BudgetLWCFields__mdt];
    }

    // To get All the Trade Option Pick Value -- By DemandBlue
    @AuraEnabled(cacheable=true)
    public static List<Map < String, String >> getTradeOptionPickValues(){   
        //List<string> TradePickValue = new List<string>();
        List < Map < String, String >> TradePickValue = new List < Map < String, String >> ();
        //Get the Picklist Values
        Schema.SObjectType s = Schema.getGlobalDescribe().get('Budget_Line_Item__c') ;
        Schema.DescribeSObjectResult r = s.getDescribe() ;
        Map<String,Schema.SObjectField> fields = r.fields.getMap() ;
        Schema.DescribeFieldResult fieldResult = fields.get('Trade_Option__c').getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            //TradePickValue.add(pickListVal.getValue());
            Map < String, String > values = new Map < String, String > {
                'label' => pickListVal.getLabel(),
                'value' => pickListVal.getValue()
            };
            TradePickValue.add(values);
        }
        return TradePickValue;
    }

    // TO Update Sales Tax -- Sean Gray
    @AuraEnabled
    public static String UpdateSalesTax(Id BudgetId, Decimal SalesTax){
        system.debug('Budget Id ' + BudgetId + ' Sales Tax ' + SalesTax);
        Budget__c b = new Budget__c(Id = BudgetId, Sales_Tax__c = SalesTax);
        update b;
        return b.Id;
    }
    // TO Upsert BLI -- By DemandBlue
    @AuraEnabled
    public static String UpdateBLI(List<Budget_Line_Item__c> UpdateBLIList, String OverheadProfit){
        system.debug('!!!!!!!!!!!!!!!!'+UpdateBLIList);
        system.debug('OverheadProfit ' + OverheadProfit);
        String status='';
        if(!UpdateBLIList.isEmpty()){
            try{
                upsert UpdateBLIList;
                status='Successfully Updated';
                
                
                system.debug('BL List ' + UpdateBLIList[0]);
                system.debug('BL List ' + UpdateBLIList[0].Id);
                Budget_Line_Item__c b1i = [SELECT Id,Allocation_Percentage__c, Budget__c, Revenue__c, X10_10_Allocation__c, Is_Parent__c,DonotDelete__c 
                FROM Budget_Line_Item__c 
                WHERE Id =: UpdateBLIList[0].Id];
                List<Budget_Line_Item__c> b1 = [SELECT Id,Allocation_Percentage__c,  Revenue__c, X10_10_Allocation__c, Selector__c, Is_Parent__c, DonotDelete__c
                FROM Budget_Line_Item__c 
                WHERE Budget__c =: b1i.Budget__c];
                system.debug(b1);
                Budget__c bud = [SELECT Id, Overhead__c, Profit__c, Budget_lineItem_Status__c, Allocation_Percentage__c, Allocation_Overhead__c
                FROM Budget__c
                WHERE Id =:b1i.Budget__c];
                system.debug(bud);
                
                // system.debug('B1 is ' + b1);
                // system.debug('B1 is ' + b1.Budget__c);
                if(bud.Budget_LineItem_Status__c == null)
                {
                    Decimal AllocationPercentage;
                    bud.Id = b1i.Budget__c;
                    bud.Overhead__c = 0;
                    bud.Profit__c = 0;
                        if(OverheadProfit == '5/5')
                        {
                            AllocationPercentage = .05;		
                            system.debug('Hitting ' + AllocationPercentage + ' Value is ' + bud.Allocation_Overhead__c);
                        }	
                        else if(OverheadProfit == '6/6'){
                            AllocationPercentage = .06;		
                            system.debug('Hitting ' + AllocationPercentage + ' Value is ' + bud.Allocation_Overhead__c);
                        }	 
                        else if(OverheadProfit == '7/7') {
                            AllocationPercentage = .07;		
                            system.debug('Hitting ' + AllocationPercentage + ' Value is ' + bud.Allocation_Overhead__c);
                        }	
                        else if(OverheadProfit == '8/8'){
                            AllocationPercentage = .08;	
                            system.debug('Hitting ' + AllocationPercentage + ' Value is ' + bud.Allocation_Overhead__c);	
                        }	
                        else if(OverheadProfit == '9/9') {
                            AllocationPercentage = .09;	
                            system.debug('Hitting ' + AllocationPercentage + ' Value is ' + bud.Allocation_Overhead__c);	
                        }	
                        else if(OverheadProfit == '10/10') {
                            AllocationPercentage = .1;
                            system.debug('Alocation percent10 ' + AllocationPercentage);	
                            system.debug('Hitting ' + AllocationPercentage + ' Value is ' + bud.Allocation_Overhead__c);	
                        }	
                        else if(OverheadProfit == '10/5') {
                            AllocationPercentage = .075;		
                            system.debug('Hitting ' + AllocationPercentage + ' Value is ' + bud.Allocation_Overhead__c);
                        }		
                        else if(OverheadProfit == '') {
                            AllocationPercentage = 0;	
                            system.debug('Hitting ' + AllocationPercentage + ' Value is ' + bud.Allocation_Overhead__c);	
                        }
                        if(OverheadProfit == null || OverheadProfit == '')
                        {
                            if(bud.Allocation_Overhead__c == '5/5')  
                            {
                                AllocationPercentage = .05;		
                                system.debug('Hitting ' + AllocationPercentage + ' Value is ' + bud.Allocation_Overhead__c);
                            }	
                            else if(bud.Allocation_Overhead__c == '6/6'){
                                AllocationPercentage = .06;		
                                system.debug('Hitting ' + AllocationPercentage + ' Value is ' + bud.Allocation_Overhead__c);
                            }	 
                            else if(bud.Allocation_Overhead__c == '7/7') {
                                AllocationPercentage = .07;		
                                system.debug('Hitting ' + AllocationPercentage + ' Value is ' + bud.Allocation_Overhead__c);
                            }	
                            else if(bud.Allocation_Overhead__c == '8/8'){
                                AllocationPercentage = .08;	
                                system.debug('Hitting ' + AllocationPercentage + ' Value is ' + bud.Allocation_Overhead__c);	
                            }	
                            else if(bud.Allocation_Overhead__c == '9/9') {
                                AllocationPercentage = .09;	
                                system.debug('Hitting ' + AllocationPercentage + ' Value is ' + bud.Allocation_Overhead__c);	
                            }	
                            else if(bud.Allocation_Overhead__c == '10/10') {
                                AllocationPercentage = .1;
                                system.debug('Alocation percent10 ' + AllocationPercentage);	
                                system.debug('Hitting ' + AllocationPercentage + ' Value is ' + bud.Allocation_Overhead__c);	
                            }	
                            else if(bud.Allocation_Overhead__c == '10/5') {
                                AllocationPercentage = .075;		
                                system.debug('Hitting ' + AllocationPercentage + ' Value is ' + bud.Allocation_Overhead__c);
                            }		
                            else if(bud.Allocation_Overhead__c == '') {
                                AllocationPercentage = 0;	
                                system.debug('Hitting ' + AllocationPercentage + ' Value is ' + bud.Allocation_Overhead__c);	
                            }
                        }
                    system.debug('Alocation percent ' + AllocationPercentage);
                    for(Budget_Line_Item__c b : b1)
                    {
                        // if(bud.Overhead__c == null || bud.Profit__c == null)
                        // {
                            
                        // }
                        if(b.X10_10_Allocation__c == true && b.Revenue__c != null && b.Revenue__c != 0 && b.DonotDelete__c == false)
                        // ((b.Selector__c == null && b.Is_Parent__c == true && b.DonotDelete__c == false) ||(b.Selector__c != null && b.Is_sub_Parent__c == true && b.DonotDelete__c == false))
                        {
                            if(AllocationPercentage != null)
                            {
                                bud.Overhead__c += b.Revenue__c * AllocationPercentage;
                                bud.Profit__c += b.Revenue__c * AllocationPercentage;
                            }else {
                                bud.Overhead__c += b.Revenue__c * b.Allocation_Percentage__c;
                                bud.Profit__c += b.Revenue__c *b.Allocation_Percentage__c;
                            }
                            system.debug('Revenue' + b.Revenue__c);
                            system.debug('Allocation Percentage is ' + b.Allocation_Percentage__c);
                            system.debug('New Allocation Percentage is ' + AllocationPercentage);
                            
                            
                            system.debug('Overhead is ' + bud.Overhead__c + '  Profit ' + bud.Profit__c);
                        }    
                    }
                    update bud;
                }


                status='Successfully Updated';
            } catch(Exception e){
                status = e.getMessage();
                throw new AuraHandledException(e.getMessage());
            }   
        }
        return null;
    }
    
    // TO Update BLI -- By DemandBlue
    @AuraEnabled
    public static String UpdateOnlyBLI(List<Budget_Line_Item__c> UpdateBLIList){
        system.debug('!!!!!!!!!!!!!!!!'+UpdateBLIList[0].Budget__c);
        List<Id> BLIIds = new List<Id>(); 
        for(Budget_Line_Item__c b : [select Id from Budget_Line_Item__c where Budget__c=:UpdateBLIList[0].Budget__c]){
            BLIIds.add(b.id);
        }
        for(Integer k=0; k<UpdateBLIList.size();k++){
            if(!BLIIds.contains(UpdateBLIList[k].id)){
                UpdateBLIList.remove(k);
            }
        }    
        system.debug('Count : '+BLIIds.size());
        String status='';
        if(!UpdateBLIList.isEmpty()){
            try{
                upsert UpdateBLIList;
                status='Successfully Updated';
            } catch(Exception e){
                status = e.getMessage();
                throw new AuraHandledException(e.getMessage());
            }   
        }
        return null;
    }

    // To Delete BLI --By DemandBlue
    @AuraEnabled
    public static void deleteBLI(list<Id> listBLI){
        try {
            list<Budget_Line_Item__c> ListToDelete = new list<Budget_Line_Item__c>();
            System.debug('ToBeDeleted ====> '+listBLI);
            for(Id idBLI : listBLI) {
                ListToDelete.add(new Budget_Line_Item__c(Id = idBLI));
            }
            System.debug('Deleted:'+ListToDelete);
            if(!ListToDelete.isEmpty()) {
                //delete ListToDelete;
            }
        }
        catch(Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

}