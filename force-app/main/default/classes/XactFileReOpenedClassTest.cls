@isTest
public class XactFileReOpenedClassTest {
    @isTest
    public static void XactFileReOpened(){
        
        TestDataUtil.createCustomSettings_TriggerStatus();
        
        List<user> users = TestDataUtil.createUsersNew(2, true);
        Account acc = new account(Name = 'Test Account');
        insert acc;
        
        ATI_Job__c job = new ATI_Job__c(Name = 'Test Job',Job_Name__c = 'Test Job',Stage__c = 'Qualification',XACT_File_Reopened__c = TRUE,Project_Manager__c =users[0].id );
        job.XACT_File_Reopened__c = False;
        insert job;
        job.XACT_File_Reopened__c = True;
        job.SF_File__c = false;
        job.Project_Manager__c = users[0].id;
        update job;
        XactFileReOpenedClass.TriggerMail(new List<ATI_Job__c>{job});
        
        
    }
    @isTest
    public static void XactFileReOpened1(){
        
        TestDataUtil.createCustomSettings_TriggerStatus();
        
        List<user> users = TestDataUtil.createUsersNew(2, true);
        Account acc = new account(Name = 'Test Account');
        insert acc;
        
        ATI_Job__c job = new ATI_Job__c(Name = 'Test Job',Job_Name__c = 'Test Job',Stage__c = 'Qualification',XACT_File_Reopened__c = TRUE,Project_Manager__c =users[0].id );
        job.XACT_File_Reopened__c = True;
        insert job;
        
        job.XACT_File_Reopened__c = False;
        job.SF_File__c = True;
        update job;
        
    }

}