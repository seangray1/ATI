trigger CreateOpportunity on ATI_Job__c (after insert) 
{
    Create_Opportunity_Handler.createOpportunity(trigger.new);
}