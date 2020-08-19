public without sharing class BudgetLWCController {

    @AuraEnabled(cacheable=true)
    public static List<Budget__c> RetrieveBudget(Id budgetId) 
    {
        List<Budget__c> budgetRecord = [Select Id,Allocations__c,X3_Program_Fees__c,GP_Goal__c,Overhead__c,Profit__c,Sales_Tax__c,Overhead_Profit_Sales_Tax__c FROM Budget__c Where Id =: budgetId];
        return budgetRecord;
    }

    @AuraEnabled(cacheable=true)
    public static list<Budget_line_item__c> RetrieveBudgetLineItems(Id budgetId) 
    {
        system.debug('ID from LWC:'+budgetId);
        List<Budget_Line_Item__c> budgetRecord = [ Select Actual_Costs__c,Selector__c,Allocations__c,Allocation_Amount__c,Allocation_Overhead__c, Allocation_Percentage__c,Budget_Goal_Amount__c,Budget_Goal__c,Budget__c,Burden__c,CreatedById,CreatedDate, Estimated_Completion_Date__c,Fees__c,Gross_Profit__c,Id,In_House_Hours__c,In_House_Rate__c,In_House_Total__c, IsDeleted,LastModifiedById,LastModifiedDate,Materials__c,Name,OrderNumber__c,Profit__c,Program_Fees__c, Program_Fee_Amount__c,Revenue__c,Start_Date__c,Subcontractor_bid__c,Subcontractor__c,SystemModstamp,Trade_Option__c,Trade__c,X10_10_Allocation__c, Is_sub_Parent__c, Is_Parent__c, DonotDelete__c,GP__c,Equipment__c,Other_Costs__c,Item_Description__c FROM Budget_Line_Item__c Where Budget__c =: budgetId and (Is_sub_Parent__c=true or Is_Parent__c=true) ];
        return budgetRecord;
    }

    @AuraEnabled(cacheable=true)
    public static list<Budget_line_item__c> GetBudgetLineItemData(Id BLIId) 
    {
        system.debug('ID from LWC:'+BLIId);
        List<Budget_Line_Item__c> budgetRecord = [ Select Actual_Costs__c,Selector__c,Allocations__c,Allocation_Amount__c,Allocation_Overhead__c, Allocation_Percentage__c,Budget_Goal_Amount__c,Budget_Goal__c,Budget__c,Burden__c,CreatedById,CreatedDate, Estimated_Completion_Date__c,Fees__c,Gross_Profit__c,Id,In_House_Hours__c,In_House_Rate__c,In_House_Total__c, IsDeleted,LastModifiedById,LastModifiedDate,Materials__c,Name,OrderNumber__c,Profit__c,Program_Fees__c, Program_Fee_Amount__c,Revenue__c,Start_Date__c,Subcontractor_bid__c,Subcontractor__c,SystemModstamp,Trade_Option__c,Trade__c,X10_10_Allocation__c, Is_sub_Parent__c, Is_Parent__c, DonotDelete__c,GP__c,Equipment__c,Other_Costs__c,Item_Description__c FROM Budget_Line_Item__c Where Id =: BLIId ];
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

    // TO Upsert BLI -- By DemandBlue
    @AuraEnabled
    public static String UpdateBLI(List<Budget_Line_Item__c> UpdateBLIList){
        system.debug('!!!!!!!!!!!!!!!!'+UpdateBLIList);
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