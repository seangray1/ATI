@istest
public class BatchToUpdateBudgetLineItemsTest {
    
        static List<ATI_Job__c> jobs;
    public testmethod static void BatchToUpdateBudgetLineItemsTest(){    
    TestDataUtil.createCustomSettings_TriggerStatus();
    List<user> users = TestDataUtil.createUsersNew(2, true);
    Account acc = new account(Name = 'Test Account');
    insert acc;
    List<ATI_Job__c> jobList = new List<ATI_Job__c>();
    ATI_Job__c job = new ATI_Job__c(Name = 'Test Job',Job_Name__c = 'Test Job',Job_Number__c = '1111-00',Stage__c = 'Qualification',XACT_File_Reopened__c = TRUE,Project_Manager__c =users[0].id );
    jobList.add(job);
 
    insert jobList;
    
    Budget__c bud = new Budget__c(Name = 'Test Budget',ATI_Job__c = job.id, GP_Goal__c = '30');
    insert bud;
    
    Budget_Line_Item__c bli = new Budget_Line_Item__c(Budget__c = bud.id,Trade__c = 'FRM',Revenue__c=100,X10_10_Allocation__c= true,DonotDelete__c = false, Item_Description__c = '#2 &amp; better');
    insert bli;
    
    Budget_Line_Item__c bli1 = [Select id, Item_Description__c from Budget_Line_Item__c where id =: bli.id];
    
    List<Budget_Line_Item__c> blis = new List<Budget_Line_Item__c>();
    List<Id> blisIds = new List<Id>();
    blis.add(bli);
    blisIds.add(bli.id);
    blisIds.add(bli1.id);
        
    BatchToUpdateBudgetLineItems c = new BatchToUpdateBudgetLineItems();
        c.query = 'Select Id FROM Budget__c';
        Database.executeBatch(c);
    }
    }