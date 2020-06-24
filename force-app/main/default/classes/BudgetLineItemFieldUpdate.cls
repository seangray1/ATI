public without sharing class BudgetLineItemFieldUpdate {

    public static void LineItemFieldUpdate(List<Budget_Line_Item__c> LineItem){
        
        List<string> TradePickValue = new List<string>();
        //Get the Picklist Values
        Schema.SObjectType s = Schema.getGlobalDescribe().get('Budget_Line_Item__c') ;
        Schema.DescribeSObjectResult r = s.getDescribe() ;
        Map<String,Schema.SObjectField> fields = r.fields.getMap() ;
        Schema.DescribeFieldResult fieldResult = fields.get('Trade_Option__c').getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            TradePickValue.add(pickListVal.getValue());
        }
        
        for(Budget_Line_Item__c b: LineItem){
            String TradeValue = '';
            
            if(String.isNotBlank(b.Item_Description__c)){
                String ItemDesc = b.Item_Description__c;
                ItemDesc = ItemDesc.replaceAll('&quot;','"');
                ItemDesc = ItemDesc.replaceAll('&amp;','&');
                ItemDesc = ItemDesc.replaceAll('&apos;','\'');
                b.Item_Description__c = ItemDesc;
            }
            if(String.isNotBlank(b.Trade__c)){
                String SearchValue = b.Trade__c;
                for(string bp: TradePickValue){
                    if(bp.contains(SearchValue.toUpperCase())){
                       TradeValue = bp;
                    }
                }
                if(String.isNotBlank(TradeValue)){
                b.Trade_Option__c  = TradeValue;
                    b.Trade__c = TradeValue;
                }
            }
        }
    
    }
    
    public static void InsertErrortLogForTrade(List<Budget_Line_Item__c> BugetLineItem){
        List<Jitterbit_Log__c> JitLogList = new List<Jitterbit_Log__c>();
        for(Budget_Line_Item__c Bl: BugetLineItem){
            if(bl.Trade_Option__c  =='Others'){
                Jitterbit_Log__c Jl = new Jitterbit_Log__c();
                Jl.Status__c='Warning';
                Jl.Name = 'Estimate - Buget Line Item Trade Option mismatch';
                Jl.Error_Warning_Details__c = 'There is a mismatch value coming from Xact for Trade - '+bl.Trade__c;
                Jl.XASP_Transaction_ID__c = '';
                Jl.Record_ID__c =bl.id;
                Jl.Source_System__c = 'XASP';
                Jl.Destination_System__c ='ATI Salesforce'; 
                JitLogList .add(Jl);               
            }
        }
        if(JitLogList.size() > 0){
            insert JitLogList;
        }
    }
    
}