@isTest
public class BudgetLineItemFieldUpdateTest {

    public static TestMethod void runTestOnOffice()
    {
        TestDataUtil.createCustomSettings_TriggerStatus();
        
        List<user> users = TestDataUtil.createUsersNew(2, true);
         Account acc = new account(Name = 'Test Account');
        insert acc;
        
        ATI_Job__c job = new ATI_Job__c(Name = 'Test Job',Job_Name__c = 'Test Job',Stage__c = 'Qualification',XACT_File_Reopened__c = TRUE,Project_Manager__c =users[0].id );
        insert job;
        ATI_Job__c job2 = new ATI_Job__c(Name = 'Test Job',Job_Name__c = 'Test Job',Stage__c = 'Qualification',XACT_File_Reopened__c = FALSE,Project_Manager__c =users[0].id );
        insert job2;
        job2.XACT_File_Reopened__c = TRUE;
        update job2;
        
        Budget__c bud = new Budget__c(Name = 'Test Budget',ATI_Job__c = job.id);
        insert bud;
        
        Budget_Line_Item__c bli = new Budget_Line_Item__c(Budget__c = bud.id,Trade__c = 'FRM',Item_Description__c = '#2 &amp; better');
        insert bli;
        
        Budget_Line_Item__c bli1 = [Select id, Item_Description__c from Budget_Line_Item__c where id =: bli.id];
         System.assertEquals('#2 & better', bli1.Item_Description__c);
    }
    
     
    
}