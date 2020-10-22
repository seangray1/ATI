@isTest(SeeAllData=true)
public with sharing class BudgetCloneController_Test2 {
  
    static testmethod void budgetTest()
     {
    ATI_Job__c jobs = [Select Id, amount__c,stage__c,total_billing_forecast_amount__c, Insurance_Adjuster_Broker__c, contact__c,office2__c, Project_Manager__c, Project_manager_new__c, Name, Percent_Complete__c, Estimated_Completion_Date__c, completion_date__c FROM ATI_Job__c WHERE name = '000-00-00002 | Test Job 1'];
    List<Budget__c> bud = [Select Name, Total_Allocations__c, Total_Program_Fees_New__c, Total_Budget_Goal__c, ATI_Job__c FROM Budget__c Where ATI_Job__c =:jobs.id Order By createdDate DESC Limit 2];
    ApexPages.StandardController controller = new ApexPages.standardController(bud[0]);
        BudgetCloneController UnitTest = new BudgetCloneController(controller);
        PageReference pr = Page.BudgetSheet;
        test.setCurrentPage(pr);
        pr.getParameters().put('id', bud[0].id);
        ApexPages.currentPage().getParameters().put('Id', bud[0].id);
        UnitTest.saveBudget();
        UnitTest.cloneLineItem(bud[1].id, bud[0].id);
}
}
