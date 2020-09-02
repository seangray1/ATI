/*
 *@Auhtor: Narasimha (Perficient)
 *@Created: 17.MAR.2015 
 *@Desc: Single Trigger for Opportunity Object
 */

trigger OpportunityTrigger on Opportunity (before update) {                
                                           
        // if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
        //     OpportunityTriggerHandler.handleBeforeInsertUpdate();
        // }
        
        // if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)){
        //     OpportunityTriggerHandler.handleAfterInsertUpdate();
        // }
                
        // if(Trigger.isBefore && Trigger.isInsert){
        //     OpportunityTriggerHandler.handleBeforeInsertOnly();
        // }
        
        // if(Trigger.isBefore && Trigger.isUpdate){
        //     OpportunityTriggerHandler.handleBeforeUpdatesOnly();
        // }
        
        // if(Trigger.isAfter && Trigger.isInsert){
        //     OpportunityTriggerHandler.handleAfterInsertOnly();
        // }
        
        if(Trigger.isBefore && Trigger.isUpdate){
            LeadOppConversion.CreateJobFromOpp(Trigger.new, Trigger.oldMap, Trigger.newMap);            
        }      
                
}