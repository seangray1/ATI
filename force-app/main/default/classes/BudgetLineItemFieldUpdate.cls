public without sharing class BudgetLineItemFieldUpdate {

    public static void LineItemFieldUpdate(List<Budget_Line_Item__c> LineItem){
        
        for(Budget_Line_Item__c b: LineItem){
            
            String ItemDesc = b.Item_Description__c;
            ItemDesc = ItemDesc.replaceAll('&quot;','"');
            ItemDesc = ItemDesc.replaceAll('&amp;','&');
            ItemDesc = ItemDesc.replaceAll('&apos;','\'');
            b.Item_Description__c = ItemDesc;
            
        }
    
    }
}