@isTest
public class BudgetLineItemFieldUpdateTest {

/*    public static TestMethod void runTestOnOffice()
    {
        TestDataUtil.createCustomSettings_TriggerStatus();
        
        List<user> users = TestDataUtil.createUsersNew(2, true);
         Account acc = new account(Name = 'Test Account');
        insert acc;
        
        ATI_Job__c job = new ATI_Job__c(Name = 'Test Job',Job_Number__c = '1111-00',Job_Name__c = 'Test Job',Stage__c = 'Qualification',XACT_File_Reopened__c = TRUE,Project_Manager__c =users[0].id );
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
        
        Budget_Line_Item__c bli2 = new Budget_Line_Item__c(Budget__c = bud.id,Trade__c = 'FRM',Trade_Option__c = 'Others', Item_Description__c = '#2 &amp; better');
        insert bli2;
        
        BudgetLineItemFieldUpdate.InsertErrortLogForTrade(new List<Budget_Line_Item__c>{bli2});
        BudgetLineItemFieldUpdate.RecalconDelete(new List<Budget_Line_Item__c>{bli2});
        delete bli2;
    }
*/    
     public static TestMethod void UpdateOverheadProfitTest()
    {
         TestDataUtil.createCustomSettings_TriggerStatus();
        Map<id,Budget_Line_Item__c> budLineMap = new Map<Id,Budget_Line_Item__c>();
        
        List<user> users = TestDataUtil.createUsersNew(2, true);
         Account acc = new account(Name = 'Test Account');
        insert acc;
        
        ATI_Job__c job = new ATI_Job__c(Name = 'Test Job',Job_Number__c = '1111-00',Job_Name__c = 'Test Job',Stage__c = 'Qualification',XACT_File_Reopened__c = TRUE,Project_Manager__c =users[0].id );
        insert job;
        
        Budget__c bud = new Budget__c(Name = 'Test Budget',ATI_Job__c = job.id);
        insert bud;
        
        Budget_Line_Item__c bli = new Budget_Line_Item__c(Budget__c = bud.id,Trade__c = 'FRM',Item_Description__c = '#2 &amp; better');
        bli.X10_10_Allocation__c = true;
        bli.Revenue__c = 30.0;
        bli.Selector__c = null;
        insert bli;
        
        CheckRecursiveOnBLIUpdate.run = true;
        update bli; 
        budLineMap.put(bli.id,bli);
        BudgetLineItemFieldUpdate.UncheckBypass(new List<Budget_Line_Item__c>{bli},budLineMap);
        CheckRecursiveOnBLIUpdate.run = true;
        delete bli;
        
        
    }
    
    @isTest
    Public static void CreateParentforEstimateItemTest(){
        
        TestDataUtil.createCustomSettings_TriggerStatus();
        Map<id,Budget_Line_Item__c> budLineMap = new Map<Id,Budget_Line_Item__c>();
        
        List<user> users = TestDataUtil.createUsersNew(2, true);
         Account acc = new account(Name = 'Test Account');
        insert acc;
        
        ATI_Job__c job = new ATI_Job__c(Name = 'Test Job',Job_Number__c = '1111-00',Job_Name__c = 'Test Job',Stage__c = 'Qualification',XACT_File_Reopened__c = TRUE,Project_Manager__c =users[0].id );
        insert job;
        
        Budget__c bud = new Budget__c(Name = 'Test Budget',ATI_Job__c = job.id);
        insert bud;
        
        Budget_Line_Item__c bli = new Budget_Line_Item__c(Budget__c = bud.id,Trade__c = 'FRM FRAMING & ROUGH CARPENTRY',Item_Description__c = '#2 &amp; better');
        bli.X10_10_Allocation__c = true;
        bli.Revenue__c = 30.0;
        bli.Selector__c = null;
        bli.Subcontractor_bid__c = 76;
        bli.In_House_Hours__c = 98;
        bli.Equipment__c = 53.0;
        bli.Materials__c = 80.0;
        bli.In_House_Rate__c = 98;
        bli.GP__c = 58;
        bli.Other_Costs__c = 70.0;
        
        insert bli;
        
        Map<Id,Budget_Line_Item__c> budLineItemMap = new Map<id,Budget_Line_Item__c>();
        budLineItemMap.put(bli.id,bli);
        
        Budget_Line_Item__c bli1 = new Budget_Line_Item__c();
        bli1 = bli;
        
        bli1.Is_sub_Parent__c = True;
        bli1.Bypass_Calculation__c = false;
        bli1.Equipment__c  = 35.0;
        bli1.In_House_Hours__c = 89;
        bli1.Subcontractor_bid__c = 67;
        bli1.Materials__c = 90.0;
        bli1.Actual_Costs_BL__c = 78;
        bli1.GP__c = 85;
        bli1.Other_Costs__c = 90.0;
        bli1.Trade__c = 'FRM FRAMING & ROUGH CARPENTRY';
        update bli1;
        
        BudgetLineItemFieldUpdate.CreateParentforEstimateItem(new List<Budget_Line_Item__c>{bli1},budLineItemMap);
        BudgetLineItemFieldUpdate.CreateParentforEstimateItem(new List<Budget_Line_Item__c>{bli1},null);
       

        
    }
    
    @isTest
    Public static void CreateSubParentforEstimateItemTest(){
        
        TestDataUtil.createCustomSettings_TriggerStatus();
        Map<id,Budget_Line_Item__c> budLineMap = new Map<Id,Budget_Line_Item__c>();
        
        List<user> users = TestDataUtil.createUsersNew(2, true);
         Account acc = new account(Name = 'Test Account');
        insert acc;
        
        ATI_Job__c job = new ATI_Job__c(Name = 'Test Job',Job_Number__c = '1111-00',Job_Name__c = 'Test Job',Stage__c = 'Qualification',XACT_File_Reopened__c = TRUE,Project_Manager__c =users[0].id );
        insert job;
        
        Budget__c bud = new Budget__c(Name = 'Test Budget',ATI_Job__c = job.id);
        insert bud;
        
        Budget_Line_Item__c bli = new Budget_Line_Item__c(Budget__c = bud.id,Trade__c = 'FRM FRAMING & ROUGH CARPENTRY',Item_Description__c = '#2 &amp; better');
        bli.X10_10_Allocation__c = true;
        bli.Revenue__c = 30.0;
        bli.Selector__c = null;
        bli.Subcontractor_bid__c = 76;
        bli.In_House_Hours__c = 98;
        bli.Equipment__c = 53.0;
        bli.Materials__c = 80.0;
        bli.In_House_Rate__c = 98;
        bli.GP__c = 58;
        bli.Other_Costs__c = 70.0;
        
        insert bli;
        
        Map<Id,Budget_Line_Item__c> budLineItemMap = new Map<id,Budget_Line_Item__c>();
        budLineItemMap.put(bli.id,bli);
        
        Budget_Line_Item__c bli1 = new Budget_Line_Item__c();
        bli1 = bli;
        
        bli1.Is_sub_Parent__c = True;
        bli1.Bypass_Calculation__c = false;
        bli1.Equipment__c  = 35.0;
        bli1.In_House_Hours__c = 89;
        bli1.Subcontractor_bid__c = 67;
        bli1.Materials__c = 90.0;
        bli1.Actual_Costs_BL__c = 78;
        bli1.GP__c = 85;
        bli1.Other_Costs__c = 90.0;
        bli1.Trade__c = 'FRM FRAMING & ROUGH CARPENTRY';
        bli1.From_Xact__c = True;
        bli1.Selector__c = 'Test';
        update bli1;
        
        BudgetLineItemFieldUpdate.CreateSubParentforEstimateItem(new List<Budget_Line_Item__c>{bli1});

        
    }
    
     @isTest
    Public static void RollDownCalcforEstimateItemTest(){
        
        TestDataUtil.createCustomSettings_TriggerStatus();
        Map<id,Budget_Line_Item__c> budLineMap = new Map<Id,Budget_Line_Item__c>();
        
        List<user> users = TestDataUtil.createUsersNew(2, true);
         Account acc = new account(Name = 'Test Account');
        insert acc;
        
        ATI_Job__c job = new ATI_Job__c(Name = 'Test Job',Job_Number__c = '1111-00',Job_Name__c = 'Test Job',Stage__c = 'Qualification',XACT_File_Reopened__c = TRUE,Project_Manager__c =users[0].id );
        insert job;
        
        Budget__c bud = new Budget__c(Name = 'Test Budget',ATI_Job__c = job.id);
        insert bud;
        
        List<Budget_Line_Item__c> blis = new List<Budget_Line_Item__c>();
        List<Budget_Line_Item__c> updblis = new List<Budget_Line_Item__c>();

        
        Budget_Line_Item__c bl = new Budget_Line_Item__c(Budget__c = bud.id,Trade__c = 'FRM FRAMING & ROUGH CARPENTRY',Item_Description__c = '#2 &amp; better');
        blis.add(bl);
        
        Budget_Line_Item__c bli = new Budget_Line_Item__c(Budget__c = bud.id,Trade__c = 'FRM FRAMING & ROUGH CARPENTRY',Item_Description__c = '#2 &amp; better');
        bli.X10_10_Allocation__c = true;
        bli.Revenue__c = 30.0;
        bli.Selector__c = null;
        bli.Subcontractor_bid__c = 76;
        bli.In_House_Hours__c = 98;
        bli.Equipment__c = 53.0;
        bli.Materials__c = 80.0;
        bli.In_House_Rate__c = 98;
        bli.GP__c = 58;
        bli.Other_Costs__c = 70.0;
        
        blis.add(bli);
        
        insert blis;
        
        Map<Id,Budget_Line_Item__c> budLineItemMap = new Map<id,Budget_Line_Item__c>();
        budLineItemMap.put(blis[0].id,blis[0]);
        budLineItemMap.put(blis[1].id,blis[1]);
        
        Budget_Line_Item__c bli1 = new Budget_Line_Item__c();
        bli1 = blis[0];
        
        Budget_Line_Item__c bli2 = new Budget_Line_Item__c();
        bli2 = blis[1];
        
        bli1.Is_Parent__c = True;
        bli1.Is_sub_Parent__c = True;
        bli1.Bypass_Calculation__c = false;
        bli1.Equipment__c  = 35.0;
        bli1.In_House_Hours__c = 89;
        bli1.Subcontractor_bid__c = 67;
        bli1.Materials__c = 90.0;
        bli1.Actual_Costs_BL__c = 78;
        bli1.GP__c = 85;
        bli1.Other_Costs__c = 90.0;
        bli1.Trade__c = 'FRM FRAMING & ROUGH CARPENTRY';
        updblis.add(bli1);
        
        bli2.Is_Parent__c = True;
        bli2.Is_sub_Parent__c = True;
        bli2.Bypass_Calculation__c = false;
        bli2.Equipment__c  = 38.0;
        bli2.In_House_Hours__c = 109;
        bli2.Subcontractor_bid__c = 47;
        bli2.Materials__c = 20.0;
        bli2.Actual_Costs_BL__c = 38;
        bli2.GP__c = 55;
        bli2.Other_Costs__c = 10.0;
        bli2.Trade__c = 'FRM FRAMING & ROUGH CARPENTRY';
        
        updblis.add(bli2);

        update updblis;
        
        BudgetLineItemFieldUpdate.RollDownCalcforEstimateItem(updblis,budLineItemMap);       

        
    }
    
}