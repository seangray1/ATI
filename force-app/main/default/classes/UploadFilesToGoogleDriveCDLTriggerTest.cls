/*******************************************************************************************
* @author           Suman
* @version          1.0 
* @date             01-Oct-2020
* @Status           In-Progress
* @Trigger Name     UploadFilesToGoogleDriveCDLTriggerTest
* @description      Test class for trigger -UploadFilesToGoogleDriveForSelObjects.
*********************************************************************************************
Version     Date      Team          Comments
*********************************************************************************************
* 1         Oct 2020    Suman        Initial Creation(JIRA AR-653)
*********************************************************************************************/
@isTest
public class UploadFilesToGoogleDriveCDLTriggerTest {
    
	@isTest
    static void testTrigger(){
        TestDataUtil.createCustomSettings_TriggerStatus();
        List<user> users = TestDataUtil.createUsersNew(2, true);
        
        //Google_Drive_Sync_Configuration__c
        Google_Drive_Sync_Configuration__c gdsc = new Google_Drive_Sync_Configuration__c(Name = 'Job', Object_API_Name__c = 'ATI_Job__c', Active__c = true, Upload_files_attachments__c= true, Folder_Name_for_Files__c='Google Docs,Notes & Attachments');
        insert gdsc;
        
        Account acc = new account(Name = 'Test Account');
        insert acc;
        
        ATI_Job__c job = new ATI_Job__c(Name = 'Test Job',Job_Name__c = 'Test Job',Stage__c = 'Qualification',XACT_File_Reopened__c = TRUE,Project_Manager__c =users[0].id, Google_Drive_Folder_Ref__c='188Hde_c_ZQiFQeSZX7IxCJGSWySWFOHn' );
        insert job; 
        
        //Create Document
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Document';
        cv.PathOnClient = 'TestDocument.pdf';
        cv.VersionData = Blob.valueOf('Test Content');
        cv.IsMajorVersion = true;
        Insert cv;
        
        //Get Content Documents
        Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
        
        //Create ContentDocumentLink 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = job.Id;
        cdl.ContentDocumentId = conDocId;
        cdl.shareType = 'V';
        Insert cdl;
    }
    
    @isTest
    static void testTrigger1(){
        TestDataUtil.createCustomSettings_TriggerStatus();
        List<user> users = TestDataUtil.createUsersNew(2, true);
        
        //Google_Drive_Sync_Configuration__c
        //Google_Drive_Sync_Configuration__c gdsc = new Google_Drive_Sync_Configuration__c(Name = 'Job', Object_API_Name__c = 'ATI_Job__c', Active__c = true);
        //insert gdsc;
        
        Account acc = new account(Name = 'Test Account');
        insert acc;
        
        ATI_Job__c job = new ATI_Job__c(Name = 'Test Job',Job_Name__c = 'Test Job',Stage__c = 'Qualification',XACT_File_Reopened__c = TRUE,Project_Manager__c =users[0].id, Google_Drive_Folder_Ref__c='188Hde_c_ZQiFQeSZX7IxCJGSWySWFOHn' );
        insert job; 
        
        //Create Document
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Document';
        cv.PathOnClient = 'TestDocument.pdf';
        cv.VersionData = Blob.valueOf('Test Content');
        cv.IsMajorVersion = true;
        Insert cv;
        
        //Get Content Documents
        Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
        
        //Create ContentDocumentLink 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = job.Id;
        cdl.ContentDocumentId = conDocId;
        cdl.shareType = 'V';
        Insert cdl;
    }
    
    @isTest
    static void testTrigger2(){
        TestDataUtil.createCustomSettings_TriggerStatus();
        List<user> users = TestDataUtil.createUsersNew(2, true);
        
        //Google_Drive_Sync_Configuration__c
        Google_Drive_Sync_Configuration__c gdsc = new Google_Drive_Sync_Configuration__c(Name = 'Job', Object_API_Name__c = 'ATI_Job__c', Active__c = true, Upload_files_attachments__c= true, Folder_Name_for_Files__c='Google Docs,Notes & Attachments');
        insert gdsc;
        
        ATI_Job__c job = new ATI_Job__c(Name = 'Test Job',Job_Name__c = 'Test Job',Stage__c = 'Qualification',XACT_File_Reopened__c = TRUE,Project_Manager__c =users[0].id, Google_Drive_Folder_Ref__c='188Hde_c_ZQiFQeSZX7IxCJGSWySWFOHn' );
        insert job; 
        ATI_Job__c job1 = new ATI_Job__c(Name = 'Test Job1',Job_Name__c = 'Test Job1',Stage__c = 'Qualification',XACT_File_Reopened__c = TRUE,Project_Manager__c =users[0].id, Google_Drive_Folder_Ref__c='188Hde_c_ZQiFQeSZX7IxCJGSWySWFOHn' );
        insert job1; 
        
        //Create Document
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Document';
        cv.PathOnClient = 'TestDocument.pdf';
        cv.VersionData = Blob.valueOf('Test Content');
        cv.IsMajorVersion = true;
        Insert cv;
        //Create Document
        ContentVersion cv2 = new ContentVersion();
        cv2.Title = 'Test Document';
        cv2.PathOnClient = 'TestDocument.pdf';
        cv2.VersionData = Blob.valueOf('Test Content');
        cv2.IsMajorVersion = true;
        Insert cv2;
        //Create Document
        ContentVersion cv3 = new ContentVersion();
        cv3.Title = 'Test Document';
        cv3.PathOnClient = 'TestDocument.pdf';
        cv3.VersionData = Blob.valueOf('Test Content');
        cv3.IsMajorVersion = true;
        Insert cv3;
        
        //Get Content Documents
        Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
        Id conDocId2 = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv2.Id].ContentDocumentId;
        Id conDocId3 = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv3.Id].ContentDocumentId;
        
        List<ContentDocumentLink> cdlList = new List<ContentDocumentLink>();
        //Create ContentDocumentLink 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = job.Id;
        cdl.ContentDocumentId = conDocId;
        cdl.shareType = 'V';
        cdlList.add(cdl);
        //Create ContentDocumentLink 
        ContentDocumentLink cdl2 = New ContentDocumentLink();
        cdl2.LinkedEntityId = job.Id;
        cdl2.ContentDocumentId = conDocId2;
        cdl2.shareType = 'V';
        cdlList.add(cdl2);
        //Create ContentDocumentLink 
        ContentDocumentLink cdl3 = New ContentDocumentLink();
        cdl3.LinkedEntityId = job1.Id;
        cdl3.ContentDocumentId = conDocId3;
        cdl3.shareType = 'V';
        cdlList.add(cdl3);
        
        Insert cdlList;
    }
    
}