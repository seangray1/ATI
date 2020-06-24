public with sharing class LargeLossUtility {
    
    @AuraEnabled
    public static string LargeLossApprovalSubmission(string recordId) 
    {
        try 
        {
            approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest(); 
            req1.setComments('Submitting request for approval');
            req1.setObjectId(recordId);
            req1.setSubmitterId(UserInfo.getUserId());
            req1.setProcessDefinitionNameOrId('Complex_Loss');
            req1.setSkipEntryCriteria(true);
            // Submit the approval request for the account
            Approval.ProcessResult result = Approval.process(req1);
            Approval.UnlockResult unlockedResults = Approval.unlock(recordId, false);
            return 'success';
        } 
        catch (Exception e) 
        {
            return e.getMessage();
        }
        
    }

    @AuraEnabled
    public static string ValidateRecord(String recordId)
    {
        //validate if user has access and return TRUE or FALSE
        ATI_Job__c job = [Select Id, Large_Loss_Flag__c, Stage__c
        FROM ATI_Job__c
        WHERE Id =:recordId];
        List<Large_Loss_Review__c> LLRelatedList = [Select Id 
        FROM Large_Loss_Review__c 
        WHERE Job__c =:recordId];
        
        if(!LLRelatedList.isEmpty())
        {
            return 'A Large Loss Review record already exists for this Loss.';
        }
        else if(!Job.Large_Loss_Flag__c)
        {
            //job.Large_Loss_Flag__c.addError('This Loss must be marked as "Large Loss"');
            return 'This Loss must be marked as "Large Loss"';
        }
        else if(Job.Stage__c == 'Lost' || Job.Stage__c == 'Billing Complete' || Job.Stage__c == 'Work Complete')
        {
            //job.addError('The Stage cannot be "Lost", "Billing Complete", or "Work Complete"');
            return 'The Stage cannot be "Lost", "Billing Complete", or "Work Complete"';
        }
        else
        {
            return 'Success';
        }
      
    }

}