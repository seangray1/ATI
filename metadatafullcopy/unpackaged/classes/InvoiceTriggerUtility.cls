// trigger utility class for invoice
public without sharing class InvoiceTriggerUtility {
    public static void beforeInvoiceInsert( List<Invoice__c> newInvoices ){
        populateAEsOnInvoices( newInvoices );
    }
        
    public static void populateAEsOnInvoices( List<Invoice__c> newInvoices ){
        Set<Id> JobIds = new Set<Id>();
        Map<Id, ATI_Job__c> JobsMap = new Map<Id, ATI_Job__c>();
        for( Invoice__c inv : newInvoices ){
            if( inv.ATI_Job__c != null ){
                JobIds.add( inv.ATI_Job__c );
            }
        }
        if( !JobIds.isEmpty() ){
            JobsMap = new Map<id, ATI_Job__c>( [ SELECT Id, AE_1_Bonus__c, AE_2_Bonus__c, Account__r.Type 
                                                  FROM ATI_Job__c 
                                                  WHERE Id IN: JobIds ] );
            for( Invoice__c inv : newInvoices ){
                if( inv.ATI_Job__c != null ){
                    inv.AE_1_Bonus__c = JobsMap.get( inv.ATI_Job__c ).AE_1_Bonus__c;
                    inv.AE_2_Bonus__c = JobsMap.get( inv.ATI_Job__c ).AE_2_Bonus__c;
                }
            }
        }
    }
    public static void CloseRelatedCases(list<Invoice__c> invoices, Map<Id, Invoice__c> oldInvoice)
    {
        Map<Id, Invoice__c> invoicesPassed = new Map<Id, Invoice__c>();
        for(invoice__c inv : invoices)
        {
            if(inv.Net_Due__c == 0 && oldInvoice.get(inv.Id).Net_Due__c > 0)
            {
                invoicesPassed.put(inv.Id, inv);
            }
        }
        if(!invoicesPassed.isEmpty())
        {
            List<Case> invCases = [Select Id, status, Related_Invoice__c FROM 
                                Case Where Related_Invoice__c =: oldInvoice.keyset()];
            for(Case cse : invCases)
            {
                cse.Status = 'Closed';
                
            }
            if(invCases.isEmpty())
            {
                update invCases;
            }
        }
    }
}