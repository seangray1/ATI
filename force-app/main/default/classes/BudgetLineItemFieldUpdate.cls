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
                	b.Trade_Option__c = TradeValue;
                }
            }
        }
    
    }
}