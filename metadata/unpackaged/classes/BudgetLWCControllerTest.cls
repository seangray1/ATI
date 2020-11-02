@isTest
Public Class BudgetLWCControllerTest{

 public static TestMethod void BudgetLwcTest()
 
 {
    
        TestDataUtil.createCustomSettings_TriggerStatus();
        
        List<user> users = TestDataUtil.createUsersNew(2, true);
        Account acc = new account(Name = 'Test Account');
        insert acc;
        List<ATI_Job__c> jobList = new List<ATI_Job__c>();
        ATI_Job__c job = new ATI_Job__c(Name = 'Test Job',Job_Name__c = 'Test Job',Job_Number__c = '1111-00',Stage__c = 'Qualification',XACT_File_Reopened__c = TRUE,Project_Manager__c =users[0].id );
        jobList.add(job);
        ATI_Job__c job2 = new ATI_Job__c(Name = 'Test Job',Job_Name__c = 'Test Job',Stage__c = 'Qualification',XACT_File_Reopened__c = FALSE,Project_Manager__c =users[0].id );
        jobList.add(job2);
        insert jobList;
        jobList[1].XACT_File_Reopened__c = TRUE;
        update jobList;
        
        Budget__c bud = new Budget__c(Name = 'Test Budget',ATI_Job__c = job.id);
        insert bud;
        
        Budget_Line_Item__c bli = new Budget_Line_Item__c(Budget__c = bud.id,Trade__c = 'FRM',Item_Description__c = '#2 &amp; better');
        insert bli;
        
        Budget_Line_Item__c bli1 = [Select id, Item_Description__c from Budget_Line_Item__c where id =: bli.id];
        
        List<Budget_Line_Item__c> blis = new List<Budget_Line_Item__c>();
        List<Id> blisIds = new List<Id>();
        blis.add(bli);
        blisIds.add(bli.id);
        blisIds.add(bli1.id);
     
        BudgetLWCController.RetrieveBudget(bud.Id);
        BudgetLWCController.RetrieveBudgetLineItems(bud.Id);
        BudgetLWCController.GetBudgetLineItemData(bli.Id);
        BudgetLWCController.RetrieveJob(bud.Id);
        BudgetLWCController.getAPINamesFromMetadata();
        BudgetLWCController.getTradeOptionPickValues();
        BudgetLWCController.UpdateBLI(blis,'10/10');
        BudgetLWCController.UpdateBLI(blis,null);
        BudgetLWCController.UpdateOnlyBLI(blis);
        BudgetLWCController.UpdateSalesTax(bud.Id, 1);
        BudgetLWCController.deleteBLI(blisIds);
        
        
    }
    
 }