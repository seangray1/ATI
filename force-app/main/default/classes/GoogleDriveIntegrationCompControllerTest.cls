@isTest
public class GoogleDriveIntegrationCompControllerTest {
    
    @isTest
    static void testIntailization(){
        List<GoogleDriveSubFolderFileDetail> folderFileList = new List<GoogleDriveSubFolderFileDetail>();
        GoogleDriveSubFolderFileDetail newfolderFileDetails;
        Map<String, String> navPathMap = new Map<String, String>();
        
        TestDataUtil.createCustomSettings_TriggerStatus();
        String GDID = GDI_Constants.TEST_GDID;
        List<user> users = TestDataUtil.createUsersNew(2, true);
        Account acc = new account(Name = 'Test Account', Google_Drive_Folder_Ref__c=GDI_Constants.TEST_GDID);
        insert acc;
        //Google_Drive_Sync_Configuration__c
        Google_Drive_Sync_Configuration__c gdsc = new Google_Drive_Sync_Configuration__c(Name = 'Job', Object_API_Name__c = GDI_Constants.OBJ_JOB, Active__c = true, Upload_files_attachments__c= true, Folder_Name_for_Files__c='Google Docs,Notes & Attachments');
        insert gdsc;
        Google_Drive_Sync_Configuration__c gdsc1 = new Google_Drive_Sync_Configuration__c(Name = 'Account', Object_API_Name__c = GDI_Constants.OBJ_ACCOUNT, Active__c = true, Upload_files_attachments__c= true, Folder_Name_for_Files__c='Google Docs,Notes & Attachments');
        insert gdsc1;
        Google_Drive_Sync_Configuration__c gdsc2 = new Google_Drive_Sync_Configuration__c(Name = 'Opp', Object_API_Name__c = GDI_Constants.OBJ_OPP, Active__c = true, Upload_files_attachments__c= true, Folder_Name_for_Files__c='Google Docs,Notes & Attachments');
        insert gdsc2;
        
        ATI_Job__c job = new ATI_Job__c(Name = 'Test Job',Job_Name__c = 'Test Job',Stage__c = 'Qualification',XACT_File_Reopened__c = TRUE,Project_Manager__c =users[0].id, Google_Drive_Folder_Ref__c=GDI_Constants.TEST_GDID, Google_Drive_Link__c='https://drive.google.com/drive/u/1/shared-drives' );
        insert job; 
        ATI_Job__c job_old = new ATI_Job__c(Name = 'Test Job 1',Job_Name__c = 'Test Job',Stage__c = 'Qualification',XACT_File_Reopened__c = TRUE,Project_Manager__c =users[0].id);
        insert job_old; 
        
        String Body = '';
        Test.startTest();
        MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
        multimock.setStaticResource(GDI_Constants.ENDPOINTURL+GDI_Constants.API_LISTFOLDER, 'GoogleDriveListAPIMock');
        //multimock.setStaticResource('callout:MulesoftGDriveIntegration/ListFolder', 'GoogleDriveListAPIMock');
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');
        
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, multimock);
        
        //1. When Body is empty for ListFolder API
        try{
            HttpResponse response = GoogleDriveIntegrationCompHelper.ListFolderAPI(Body);
        }catch(Exception e){
            System.debug('System Exception occurred : ' + e.getTypeName());
            System.assertEquals(GDI_Constants.APIERROR_BODYISEMPTY, e.getMessage()); 
        }
        
        //2. Get folder/file list when GD ref is present
        folderFileList = GoogleDriveIntegrationCompController.getFolderFilesList(job.id, GDI_Constants.OBJ_JOB);
        System.assertEquals(36, folderFileList.size()); 
        
        //2. Get folder/file list when GD ref is present
        folderFileList = GoogleDriveIntegrationCompController.getFolderFilesList(acc.id, GDI_Constants.OBJ_ACCOUNT);
        System.assertEquals(36, folderFileList.size()); 
        
        //2.1 Get folder/file list when GD ref is not present
        folderFileList = GoogleDriveIntegrationCompController.getFolderFilesList(job_old.id, GDI_Constants.OBJ_JOB);
        System.assertEquals(36, folderFileList.size()); 
        
        //2.2 Get folder/file list when input is empty
        folderFileList = GoogleDriveIntegrationCompController.getFolderFilesList(job.id, '');
        System.assertEquals(0, folderFileList.size()); 
        
        //2.3 Get folder/file list when obj not present in Sync Config
        try{
            folderFileList = GoogleDriveIntegrationCompController.getFolderFilesList(job_old.id, 'Account1');
        }catch(Exception e){
            System.debug('System Exception occurred : ' + e.getTypeName());
            System.assertEquals(GDI_Constants.ERROR_LISTFOLDER_NOCONFIGFOUND, e.getMessage()); 
        }
        System.assertEquals(0, folderFileList.size()); 
        
        //3.1 Create nav path 
        navPathMap = GoogleDriveIntegrationCompController.createNavPathMap(job.id, GDI_Constants.OBJ_JOB);
        System.assertEquals(1, navPathMap.size()); 
        
        //3.2 Create nav path when Google drive ref is empty
        navPathMap = GoogleDriveIntegrationCompController.createNavPathMap(job_old.id, '');
        System.assertEquals(0, navPathMap.size());
        
        //3.3 Create nav path when object name is empty
        navPathMap = GoogleDriveIntegrationCompController.createNavPathMap(job.id, '');
        System.assertEquals(0, navPathMap.size()); 
        
        //4.1 Get link
        String googleDriveLink = GoogleDriveIntegrationCompController.getGoogleDriveLinkForTheRecord(job.id, GDI_Constants.OBJ_JOB);
        System.assertEquals('https://drive.google.com/drive/u/1/shared-drives', googleDriveLink); 
        //4.2 Get link
        try{
            String googleDriveLink1 = GoogleDriveIntegrationCompController.getGoogleDriveLinkForTheRecord(job_old.id, GDI_Constants.OBJ_JOB);
        }catch(Exception e){
            System.assert(e.getMessage().contains('Script-thrown exception')); 
        }
        
        Test.stopTest();
    }
    
    @isTest
    static void testListFolderAndCreateAPI(){
        List<GoogleDriveSubFolderFileDetail> folderFileList = new List<GoogleDriveSubFolderFileDetail>();
        GoogleDriveSubFolderFileDetail newfolderFileDetails;
        Map<String, String> navPathMap = new Map<String, String>();
        TestDataUtil.createCustomSettings_TriggerStatus();
        String GDID = GDI_Constants.TEST_GDID;
        List<user> users = TestDataUtil.createUsersNew(2, true);
        Account acc = new account(Name = 'Test Account');
        insert acc;
        //Google_Drive_Sync_Configuration__c
        Google_Drive_Sync_Configuration__c gdsc = new Google_Drive_Sync_Configuration__c(Name = 'Job', Object_API_Name__c = GDI_Constants.OBJ_JOB, Active__c = true, Upload_files_attachments__c= true, Folder_Name_for_Files__c='Google Docs,Notes & Attachments');
        insert gdsc;
        Google_Drive_Sync_Configuration__c gdsc1 = new Google_Drive_Sync_Configuration__c(Name = 'Account', Object_API_Name__c = GDI_Constants.OBJ_ACCOUNT, Active__c = true, Upload_files_attachments__c= true, Folder_Name_for_Files__c='Google Docs,Notes & Attachments');
        insert gdsc1;
        
        ATI_Job__c job = new ATI_Job__c(Name = 'Test Job',Job_Name__c = 'Test Job',Stage__c = 'Qualification',XACT_File_Reopened__c = TRUE,Project_Manager__c =users[0].id );
        insert job; 
        
        Test.startTest();
        MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
        multimock.setStaticResource(GDI_Constants.ENDPOINTURL+GDI_Constants.API_LISTFOLDER, 'GoogleDriveListAPIMock');
        multimock.setStaticResource(GDI_Constants.ENDPOINTURL+GDI_Constants.API_CREATE, 'GoogleDriveCreateAPIMock');
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');
        
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, multimock);
        
        //1.1 Get Sub folders/files list
        folderFileList = GoogleDriveIntegrationCompController.getSubFolderFilesList(job.id, GDI_Constants.OBJ_JOB, GDID);
        System.assertEquals(36, folderFileList.size());  
        folderFileList = GoogleDriveIntegrationCompController.getSubFolderFilesList(acc.id, GDI_Constants.OBJ_ACCOUNT, GDID);
        System.assertEquals(36, folderFileList.size());  
        
        //1.2 Get Sub folders/files list when rec id is null
        folderFileList = GoogleDriveIntegrationCompController.getSubFolderFilesList(job.Id, '', GDID);
        System.assertEquals(0, folderFileList.size());  
        
        //2.1
        newfolderFileDetails = GoogleDriveIntegrationCompController.createNewFolderInGoogleDrive(GDI_Constants.OBJ_JOB, job.id, GDID, 'Foldername');
        System.assertEquals('TestingforTestclass', newfolderFileDetails.name);
        
        //2.2
        newfolderFileDetails = GoogleDriveIntegrationCompController.createNewFolderInGoogleDrive('', job.id, GDID, 'Foldername');
        System.assert(null == newfolderFileDetails);
        
        //3.1
        newfolderFileDetails = GoogleDriveIntegrationCompController.createNewFileInGoogleDrive(GDI_Constants.OBJ_JOB, job.id, GDID, 'googleDoc','Test Doc');
        System.assertEquals('TestingforTestclass', newfolderFileDetails.name);
        
        //3.2
        newfolderFileDetails = GoogleDriveIntegrationCompController.createNewFileInGoogleDrive(GDI_Constants.OBJ_JOB, job.id, GDID, 'googleSheet', 'Test Sheet');
        System.assertEquals('TestingforTestclass', newfolderFileDetails.name);
        
        //3.3
        newfolderFileDetails = GoogleDriveIntegrationCompController.createNewFileInGoogleDrive(GDI_Constants.OBJ_JOB, job.id, GDID, 'googleSlide', 'Test PPT');
        System.assertEquals('TestingforTestclass', newfolderFileDetails.name);
        
        //3.4
        newfolderFileDetails = GoogleDriveIntegrationCompController.createNewFileInGoogleDrive(GDI_Constants.OBJ_JOB, job.id, GDID, GDI_Constants.FILETYPE_MSDOC, 'Test MS Doc');
        System.assertEquals('TestingforTestclass', newfolderFileDetails.name);
        
        //3.5
        newfolderFileDetails = GoogleDriveIntegrationCompController.createNewFileInGoogleDrive(GDI_Constants.OBJ_JOB, job.id, GDID, GDI_Constants.FILETYPE_MSEXCEL, 'Test MS Excel');
        System.assertEquals('TestingforTestclass', newfolderFileDetails.name);
        
        //3.6
        newfolderFileDetails = GoogleDriveIntegrationCompController.createNewFileInGoogleDrive(GDI_Constants.OBJ_JOB, job.id, GDID, GDI_Constants.FILETYPE_MSPPT, 'Test MS PPT');
        System.assertEquals('TestingforTestclass', newfolderFileDetails.name);
        
        //3.7
        newfolderFileDetails = GoogleDriveIntegrationCompController.createNewFileInGoogleDrive('', job.id, GDID, GDI_Constants.FILETYPE_MSDOC, 'Test Doc');
        System.assert(null == newfolderFileDetails);
        
        Test.stopTest();
    }
    
    @isTest
    static void testDeleteAPI(){
        //List<GoogleDriveSubFolderFileDetail> folderFileList = new List<GoogleDriveSubFolderFileDetail>();
        //GoogleDriveSubFolderFileDetail newfolderFileDetails;
        //Map<String, String> navPathMap = new Map<String, String>();
        TestDataUtil.createCustomSettings_TriggerStatus();
        String GDID = GDI_Constants.TEST_GDID;
        List<user> users = TestDataUtil.createUsersNew(2, true);
        Account acc = new account(Name = 'Test Account');
        insert acc;
        //Google_Drive_Sync_Configuration__c
        Google_Drive_Sync_Configuration__c gdsc = new Google_Drive_Sync_Configuration__c(Name = 'Job', Object_API_Name__c = GDI_Constants.OBJ_JOB, Active__c = true, Upload_files_attachments__c= true, Folder_Name_for_Files__c='Google Docs,Notes & Attachments');
        insert gdsc;
        
        ATI_Job__c job = new ATI_Job__c(Name = 'Test Job',Job_Name__c = 'Test Job',Stage__c = 'Qualification',XACT_File_Reopened__c = TRUE,Project_Manager__c =users[0].id );
        insert job; 
        
        Test.startTest();
        MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
        multimock.setStaticResource(GDI_Constants.ENDPOINTURL+GDI_Constants.API_LISTFOLDER, 'GoogleDriveListAPIMock');
        multimock.setStaticResource(GDI_Constants.ENDPOINTURL+GDI_Constants.API_DELETE, 'GoogleDriveDeleteAPIMock');
        
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');
        
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, multimock);
        
        //1.1 Get Sub folders/files list
        GoogleDriveIntegrationCompController.deleteSelectedFolderFiles('["1EKOV5c8orKRbz_Hiso_uDwMPU6MXoS0k"]', job.Id);
        //1.2
        GoogleDriveIntegrationCompController.deleteSelectedFolderFiles('',job.Id);
        
        Test.stopTest();
    }
    /*
@isTest
static void testDownloadAPI(){
//List<GoogleDriveSubFolderFileDetail> folderFileList = new List<GoogleDriveSubFolderFileDetail>();
//GoogleDriveSubFolderFileDetail newfolderFileDetails;
//Map<String, String> navPathMap = new Map<String, String>();
TestDataUtil.createCustomSettings_TriggerStatus();
String GDID = GDI_Constants.TEST_GDID;
List<user> users = TestDataUtil.createUsersNew(2, true);
Account acc = new account(Name = 'Test Account');
insert acc;
//Google_Drive_Sync_Configuration__c
Google_Drive_Sync_Configuration__c gdsc = new Google_Drive_Sync_Configuration__c(Name = 'Job', Object_API_Name__c = GDI_Constants.OBJ_JOB, Active__c = true, Upload_files_attachments__c= true, Folder_Name_for_Files__c='Google Docs,Notes & Attachments');
insert gdsc;

ATI_Job__c job = new ATI_Job__c(Name = 'Test Job',Job_Name__c = 'Test Job',Stage__c = 'Qualification',XACT_File_Reopened__c = TRUE,Project_Manager__c =users[0].id,Google_Drive_Folder_Ref__c='1EKOV5c8orKRbz_Hiso_uDwMPU6MXoS0k' );
insert job; 

Test.startTest();
MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
multimock.setStaticResource(GDI_Constants.ENDPOINTURL+GDI_Constants.API_LISTFOLDER, 'GoogleDriveListAPIMock');
multimock.setStaticResource(GDI_Constants.ENDPOINTURL+GDI_Constants.API_DOWNLOAD, 'GoogleDriveDownloadAPIMock');

multimock.setStatusCode(200);
multimock.setHeader('Content-Type', 'application/json');

// Set the mock callout mode
Test.setMock(HttpCalloutMock.class, multimock);

Map<String,List<String>> selectedFolderFiles = new Map<String,List<String>>();
List<String> fileFolderDetails = new List<String>();
fileFolderDetails.add('Test 123');
fileFolderDetails.add('application/pdf');
fileFolderDetails.add('true');
selectedFolderFiles.put('1EKOV5c8orKRbz_Hiso_uDwMPU6MXoS0k',fileFolderDetails);

//1.1 Get Sub folders/files list
String downloadLink = GoogleDriveIntegrationCompController.getDownloadPageLink(GDI_Constants.OBJ_JOB, job.Id, 'Test' ,selectedFolderFiles, true);
System.assertEquals('https://drive.google.com/file/d/185KcN7BM40ETvd7blI8uScEI83a7xWaD/view?usp=sharing', downloadLink);

//1.2
String downloadLink1 = GoogleDriveIntegrationCompController.getDownloadPageLink('', job.Id,'Test' ,selectedFolderFiles, true);
System.assertEquals('', downloadLink1);

//1.3
String downloadLink2 = GoogleDriveIntegrationCompController.getDownloadPageLink('DBTest', job.Id,'Test' ,selectedFolderFiles, true);
System.assertEquals('', downloadLink2);

Test.stopTest();
}*/
    
    @isTest
    static void testUploadAPI(){
        //List<GoogleDriveSubFolderFileDetail> folderFileList = new List<GoogleDriveSubFolderFileDetail>();
        //GoogleDriveSubFolderFileDetail newfolderFileDetails;
        //Map<String, String> navPathMap = new Map<String, String>();
        TestDataUtil.createCustomSettings_TriggerStatus();
        String GDID = GDI_Constants.TEST_GDID;
        List<user> users = TestDataUtil.createUsersNew(2, true);
        Account acc = new account(Name = 'Test Account');
        insert acc;
        //Google_Drive_Sync_Configuration__c
        Google_Drive_Sync_Configuration__c gdsc = new Google_Drive_Sync_Configuration__c(Name = 'Job', Object_API_Name__c = GDI_Constants.OBJ_JOB, Active__c = true, Upload_files_attachments__c= true, Folder_Name_for_Files__c='Google Docs,Notes & Attachments');
        insert gdsc;
        
        ATI_Job__c job = new ATI_Job__c(Name = 'Test Job',Job_Name__c = 'Test Job',Stage__c = 'Qualification',XACT_File_Reopened__c = TRUE,Project_Manager__c =users[0].id,Google_Drive_Folder_Ref__c='1EKOV5c8orKRbz_Hiso_uDwMPU6MXoS0k' );
        insert job; 
        
        ContentVersion contentVersionInsert = new ContentVersion(
            Title = 'Test',
            PathOnClient = 'Test.jpg',
            VersionData = Blob.valueOf('Test Content Data'),
            IsMajorVersion = true
        );
        insert contentVersionInsert;
        
        ContentVersion uploadedFile = [SELECT ContentDocumentId FROM ContentVersion WHERE ID=:contentVersionInsert.Id];
        
        String files = '["' + uploadedFile.ContentDocumentId +'"]';
        
        //1.1 Create platfrom event
        GoogleDriveIntegrationCompController.uploadFilesToGoogleDrive(job.Id,'1EKOV5c8orKRbz_Hiso_uDwMPU6MXoS0k',files);
        
        //1.2
        GoogleDriveIntegrationCompController.uploadFilesToGoogleDrive(job.Id,'',files);
    }
    
    @isTest
    static void testHiddenFolderOpp(){
        List<GoogleDriveSubFolderFileDetail> folderFileList = new List<GoogleDriveSubFolderFileDetail>();
        GoogleDriveSubFolderFileDetail newfolderFileDetails;
        Map<String, String> navPathMap = new Map<String, String>();
        
        TestDataUtil.createCustomSettings_TriggerStatus();
        String GDID = GDI_Constants.TEST_GDID;
        List<user> users = TestDataUtil.createUsersNew(2, true);
        Id oppId='006V000000CIhHsIAL';
        //Google_Drive_Sync_Configuration__c
        Google_Drive_Sync_Configuration__c gdsc = new Google_Drive_Sync_Configuration__c(Name = 'Job', Object_API_Name__c = GDI_Constants.OBJ_JOB, Active__c = true, Upload_files_attachments__c= true, Folder_Name_for_Files__c='Google Docs,Notes & Attachments');
        insert gdsc;
        Google_Drive_Sync_Configuration__c gdsc1 = new Google_Drive_Sync_Configuration__c(Name = 'Account', Object_API_Name__c = GDI_Constants.OBJ_ACCOUNT, Active__c = true, Upload_files_attachments__c= true, Folder_Name_for_Files__c='Google Docs,Notes & Attachments');
        insert gdsc1;
        Google_Drive_Sync_Configuration__c gdsc2 = new Google_Drive_Sync_Configuration__c(Name = 'Opp', Object_API_Name__c = GDI_Constants.OBJ_OPP, Active__c = true, Upload_files_attachments__c= true, Folder_Name_for_Files__c='Google Docs,Notes & Attachments');
        insert gdsc2;
        
        String Body = '';
        Test.startTest();
        MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
        multimock.setStaticResource(GDI_Constants.ENDPOINTURL+GDI_Constants.API_LISTFOLDER, 'GoogleDriveListAPIMock');
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');
        
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, multimock);
        try{
            folderFileList = GoogleDriveIntegrationCompController.getFolderFilesList(oppId, GDI_Constants.OBJ_OPP);
        }catch(Exception e){
            //System.assertEquals(36, folderFileList.size()); 
        }
        
        try{
            folderFileList = GoogleDriveIntegrationCompController.getSubFolderFilesList(oppId, GDI_Constants.OBJ_OPP,GDI_Constants.TEST_GDID);
        }catch(Exception e){
            //System.assertEquals(36, folderFileList.size()); 
        }
    }
    
    @isTest
    static void testSearchAPI(){
        List<GoogleDriveSubFolderFileDetail> folderFileList = new List<GoogleDriveSubFolderFileDetail>();
        
        TestDataUtil.createCustomSettings_TriggerStatus();
        String GDID = GDI_Constants.TEST_GDID;
        
        String Body = '';
        Test.startTest();
        MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
        multimock.setStaticResource(GDI_Constants.ENDPOINTURL+GDI_Constants.API_SEARCH, 'GoogleDriveSearchAPIMock');
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');
        
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, multimock);
        
        //1.1
        folderFileList = GoogleDriveIntegrationCompController.getSearchResultList('Test',GDID, 'ANY', 'ANY', null, null);
        System.assertEquals(5, folderFileList.size()); 
        
        //1.2
        folderFileList = GoogleDriveIntegrationCompController.getSearchResultList('',GDID, 'ANY', 'ANY', null, null);
        System.assertEquals(0, folderFileList.size()); 
        
        //1.3
        folderFileList = GoogleDriveIntegrationCompController.getSearchResultList('Test',GDID, 'ANY', GDI_Constants.STRING_CUSTOM, null, null);
        System.assertEquals(0, folderFileList.size()); 
        
        //1.4
        folderFileList = GoogleDriveIntegrationCompController.getSearchResultList('Test',GDID, 'ANY', GDI_Constants.STRING_24HOURS, null, null);
        System.assertEquals(5, folderFileList.size()); 
        //1.5
        folderFileList = GoogleDriveIntegrationCompController.getSearchResultList('Test',GDID, 'ANY', GDI_Constants.STRING_WEEK, null, null);
        System.assertEquals(5, folderFileList.size()); 
        //1.6
        folderFileList = GoogleDriveIntegrationCompController.getSearchResultList('Test',GDID, 'ANY', GDI_Constants.STRING_MONTH, null, null);
        System.assertEquals(5, folderFileList.size()); 
        //1.7
        folderFileList = GoogleDriveIntegrationCompController.getSearchResultList('Test',GDID, 'ANY', GDI_Constants.STRING_3MONTHS, null, null);
        System.assertEquals(5, folderFileList.size()); 
        //1.8
        folderFileList = GoogleDriveIntegrationCompController.getSearchResultList('Test',GDID, 'ANY', GDI_Constants.STRING_3MONTHS, null, null);
        System.assertEquals(5, folderFileList.size()); 
        //1.9
        folderFileList = GoogleDriveIntegrationCompController.getSearchResultList('Test',GDID, 'ANY', GDI_Constants.STRING_6MONTHS, null, null);
        System.assertEquals(5, folderFileList.size()); 
        //1.10
        folderFileList = GoogleDriveIntegrationCompController.getSearchResultList('Test',GDID, 'ANY', GDI_Constants.STRING_12MONTHS, null, null);
        System.assertEquals(5, folderFileList.size()); 
        //1.11
        folderFileList = GoogleDriveIntegrationCompController.getSearchResultList('Test',GDID, 'ANY', GDI_Constants.STRING_CUSTOM, Date.newInstance(2020, 6, 17), System.today());
        System.assertEquals(5, folderFileList.size());
        
        //1.12
        folderFileList = GoogleDriveIntegrationCompController.getSearchResultList('Test',GDID, 'Document', 'ANY', null, null);
        System.assertEquals(5, folderFileList.size()); 
        
        Test.stopTest();
    }
    
    @isTest
    static void testListFolderAPIFailure(){
        List<GoogleDriveSubFolderFileDetail> folderFileList = new List<GoogleDriveSubFolderFileDetail>();
        Map<String, String> navPathMap = new Map<String, String>();
        
        TestDataUtil.createCustomSettings_TriggerStatus();
        String GDID = GDI_Constants.TEST_GDID;
        List<user> users = TestDataUtil.createUsersNew(2, true);
        //Google_Drive_Sync_Configuration__c
        Google_Drive_Sync_Configuration__c gdsc = new Google_Drive_Sync_Configuration__c(Name = 'Job', Object_API_Name__c = GDI_Constants.OBJ_JOB, Active__c = true, Upload_files_attachments__c= true, Folder_Name_for_Files__c='Google Docs,Notes & Attachments');
        insert gdsc;
        
        ATI_Job__c job = new ATI_Job__c(Name = 'Test Job',Job_Name__c = 'Test Job',Stage__c = 'Qualification',XACT_File_Reopened__c = TRUE,Project_Manager__c =users[0].id, Google_Drive_Folder_Ref__c=GDI_Constants.TEST_GDID);
        insert job; 
        ATI_Job__c job_old = new ATI_Job__c(Name = 'Test Job 1',Job_Name__c = 'Test Job',Stage__c = 'Qualification',XACT_File_Reopened__c = TRUE,Project_Manager__c =users[0].id);
        insert job_old; 
        
        String Body = '';
        Test.startTest();
        MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
        multimock.setStaticResource(GDI_Constants.ENDPOINTURL+GDI_Constants.API_LISTFOLDER, 'GoogleDriveListAPIMock');
        multimock.setStatusCode(500);
        multimock.setHeader('Content-Type', 'application/json');
        
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, multimock);
        
        //1.ListFolder API
        try{
            folderFileList = GoogleDriveIntegrationCompController.getFolderFilesList(job.id, GDI_Constants.OBJ_JOB);
        }catch(Exception e){
            System.assert(e.getMessage().contains('Script-thrown exception')); 
        }
        
        //1.1 ListFolder API
        try{
            folderFileList = GoogleDriveIntegrationCompController.getFolderFilesList(job_old.id, GDI_Constants.OBJ_JOB);
        }catch(Exception e){
            System.assert(e.getMessage().contains('Script-thrown exception')); 
        }
        
        Test.stopTest();
    }
    
    @isTest
    static void testCreateAPIFailure(){
        GoogleDriveSubFolderFileDetail newfolderFileDetails;
        
        TestDataUtil.createCustomSettings_TriggerStatus();
        String GDID = GDI_Constants.TEST_GDID;
        List<user> users = TestDataUtil.createUsersNew(2, true);
        Account acc = new account(Name = 'Test Account');
        insert acc;
        //Google_Drive_Sync_Configuration__c
        Google_Drive_Sync_Configuration__c gdsc = new Google_Drive_Sync_Configuration__c(Name = 'Job', Object_API_Name__c = GDI_Constants.OBJ_JOB, Active__c = true, Upload_files_attachments__c= true, Folder_Name_for_Files__c='Google Docs,Notes & Attachments');
        insert gdsc;
        
        ATI_Job__c job = new ATI_Job__c(Name = 'Test Job',Job_Name__c = 'Test Job',Stage__c = 'Qualification',XACT_File_Reopened__c = TRUE,Project_Manager__c =users[0].id );
        insert job; 
        
        Test.startTest();
        MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
        multimock.setStaticResource(GDI_Constants.ENDPOINTURL+GDI_Constants.API_CREATE, 'GoogleDriveCreateAPIMock');
        multimock.setStatusCode(500);
        multimock.setHeader('Content-Type', 'application/json');
        
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, multimock);
        
        //1.
        try{
            newfolderFileDetails = GoogleDriveIntegrationCompController.createNewFolderInGoogleDrive(GDI_Constants.OBJ_JOB, job.id, GDID, 'Foldername');
        }catch(Exception e){
            System.assert(e.getMessage().contains('Script-thrown exception')); 
        }
        
        Test.stopTest();
    }
    
    @isTest
    static void testDeleteAPIFailure(){
        TestDataUtil.createCustomSettings_TriggerStatus();
        String GDID = GDI_Constants.TEST_GDID;
        List<user> users = TestDataUtil.createUsersNew(2, true);
        Account acc = new account(Name = 'Test Account');
        insert acc;
        //Google_Drive_Sync_Configuration__c
        Google_Drive_Sync_Configuration__c gdsc = new Google_Drive_Sync_Configuration__c(Name = 'Job', Object_API_Name__c = GDI_Constants.OBJ_JOB, Active__c = true, Upload_files_attachments__c= true, Folder_Name_for_Files__c='Google Docs,Notes & Attachments');
        insert gdsc;
        
        ATI_Job__c job = new ATI_Job__c(Name = 'Test Job',Job_Name__c = 'Test Job',Stage__c = 'Qualification',XACT_File_Reopened__c = TRUE,Project_Manager__c =users[0].id );
        insert job; 
        
        Test.startTest();
        MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
        multimock.setStaticResource(GDI_Constants.ENDPOINTURL+GDI_Constants.API_DELETE, 'GoogleDriveDeleteAPIMock');
        
        multimock.setStatusCode(500);
        multimock.setHeader('Content-Type', 'application/json');
        
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, multimock);
        
        try{
            GoogleDriveIntegrationCompController.deleteSelectedFolderFiles('["1EKOV5c8orKRbz_Hiso_uDwMPU6MXoS0k"]', job.Id);
        }catch(Exception e){
            System.assert(e.getMessage().contains('Script-thrown exception')); 
        }
        
        Test.stopTest();
    }
    
    @isTest
    static void testaddAPILogInDB(){
        String apiLogData = '{"uiMessage":"Folder contents could not be retrieved from Google Drive. Mulesoft response code - 500","recordId":"123456a12345","operationDetails":"ListFolder API","mulesoftResponseCode":500,"mulesoftResponse":"Error"}';
        Test.startTest();
        GoogleDriveIntegrationCompController.addAPILogInDB(apiLogData);
        Test.stopTest();
    }

    
    @isTest
    static void testSearchAPIFailure(){
        List<GoogleDriveSubFolderFileDetail> folderFileList = new List<GoogleDriveSubFolderFileDetail>();
        
        TestDataUtil.createCustomSettings_TriggerStatus();
        String GDID = GDI_Constants.TEST_GDID;
        
        String Body = '';
        Test.startTest();
        MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
        multimock.setStaticResource(GDI_Constants.ENDPOINTURL+GDI_Constants.API_SEARCH, 'GoogleDriveSearchAPIMock');
        multimock.setStatusCode(500);
        multimock.setHeader('Content-Type', 'application/json');
        
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, multimock);
        
        try{
            folderFileList = GoogleDriveIntegrationCompController.getSearchResultList('Test',GDID, 'ANY', 'ANY', null, null);
        }catch(Exception e){
            System.assert(e.getMessage().contains('Script-thrown exception')); 
        }
        
        Test.stopTest();
    }
    
    @isTest
    static void testMethodToCoverExtraLines(){
        Date returnedDate = GoogleDriveIntegrationCompController.DateCalculation('');
        System.assertEquals(null, returnedDate);
    }
    
        /*
@isTest
static void testDownloadAPIFailure(){
TestDataUtil.createCustomSettings_TriggerStatus();
String GDID = GDI_Constants.TEST_GDID;
List<user> users = TestDataUtil.createUsersNew(2, true);
Account acc = new account(Name = 'Test Account');
insert acc;
//Google_Drive_Sync_Configuration__c
Google_Drive_Sync_Configuration__c gdsc = new Google_Drive_Sync_Configuration__c(Name = 'Job', Object_API_Name__c = GDI_Constants.OBJ_JOB, Active__c = true, Upload_files_attachments__c= true, Folder_Name_for_Files__c='Google Docs,Notes & Attachments');
insert gdsc;

ATI_Job__c job = new ATI_Job__c(Name = 'Test Job',Job_Name__c = 'Test Job',Stage__c = 'Qualification',XACT_File_Reopened__c = TRUE,Project_Manager__c =users[0].id,Google_Drive_Folder_Ref__c='1EKOV5c8orKRbz_Hiso_uDwMPU6MXoS0k' );
insert job; 

Test.startTest();
MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
multimock.setStaticResource(GDI_Constants.ENDPOINTURL+GDI_Constants.API_DOWNLOAD, 'GoogleDriveDownloadAPIMock');

multimock.setStatusCode(500);
multimock.setHeader('Content-Type', 'application/json');

// Set the mock callout mode
Test.setMock(HttpCalloutMock.class, multimock);

Map<String,List<String>> selectedFolderFiles = new Map<String,List<String>>();
List<String> fileFolderDetails = new List<String>();
fileFolderDetails.add('Test 123');
fileFolderDetails.add('application/pdf');
fileFolderDetails.add('true');
selectedFolderFiles.put('1EKOV5c8orKRbz_Hiso_uDwMPU6MXoS0k',fileFolderDetails);

try{
String downloadLink = GoogleDriveIntegrationCompController.getDownloadPageLink(GDI_Constants.OBJ_JOB, job.Id, 'Test' ,selectedFolderFiles, true);
}catch(Exception e){
System.assert(e.getMessage().contains('Script-thrown exception')); 
}

Test.stopTest();
}*/
    
    /*
@isTest
static void testGetReadOnlyFolderListFromMetadataConfig(){
//Google_Drive_Sync_Configuration__c
Google_Drive_Sync_Configuration__c gdsc = new Google_Drive_Sync_Configuration__c(Name = 'Job', Object_API_Name__c = 'ATI_Job__c', Active__c = true);
insert gdsc;

Google_Drive_Integration_Configurations__mdt googleDriveConfigDetails = [SELECT Read_only_folders__c,Read_only_folders_Account__c,Read_only_folders_Opp__c FROM Google_Drive_Integration_Configurations__mdt LIMIT 1]; 

List<String> folderList = GoogleDriveIntegrationCompController.getReadOnlyFolderListFromMetadataConfig('ATI_Job__c');
System.assertEquals(googleDriveConfigDetails.Read_only_folders__c.split(GDI_Constants.STRING_SEMICOLON), folderList);

List<String> folderList1 = GoogleDriveIntegrationCompController.getReadOnlyFolderListFromMetadataConfig('Account');
System.assertEquals(googleDriveConfigDetails.Read_only_folders_Account__c.split(GDI_Constants.STRING_SEMICOLON), folderList1);

List<String> folderList2 = GoogleDriveIntegrationCompController.getReadOnlyFolderListFromMetadataConfig('Opportunity');
System.assertEquals(googleDriveConfigDetails.Read_only_folders_Opp__c.split(GDI_Constants.STRING_SEMICOLON), folderList2);
}*/
    /*
@isTest
static void testGetFolderInfoAPI(){
//List<GoogleDriveSubFolderFileDetail> folderFileList = new List<GoogleDriveSubFolderFileDetail>();
//GoogleDriveSubFolderFileDetail newfolderFileDetails;
//Map<String, String> navPathMap = new Map<String, String>();
TestDataUtil.createCustomSettings_TriggerStatus();
String GDID = GDI_Constants.TEST_GDID;
List<user> users = TestDataUtil.createUsersNew(2, true);
Account acc = new account(Name = 'Test Account');
insert acc;
//Google_Drive_Sync_Configuration__c
Google_Drive_Sync_Configuration__c gdsc = new Google_Drive_Sync_Configuration__c(Name = 'Job', Object_API_Name__c = 'ATI_Job__c', Active__c = true);
insert gdsc;

ATI_Job__c job = new ATI_Job__c(Name = 'Test Job',Job_Name__c = 'Test Job',Stage__c = 'Qualification',XACT_File_Reopened__c = TRUE,Project_Manager__c =users[0].id,Google_Drive_Folder_Ref__c='1EKOV5c8orKRbz_Hiso_uDwMPU6MXoS0k' );
insert job; 

Test.startTest();
MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
multimock.setStaticResource('callout:MulesoftGDriveIntegration/ListFolder', 'GoogleDriveListAPIMock');
multimock.setStaticResource('callout:MulesoftGDriveIntegration/'+GDI_Constants.API_FOLDERINFO, 'GoogleDriveGetFolderInfoAPIMock');

multimock.setStatusCode(200);
multimock.setHeader('Content-Type', 'application/json');

// Set the mock callout mode
Test.setMock(HttpCalloutMock.class, multimock);

Map<String,List<String>> selectedFolderFiles = new Map<String,List<String>>();
List<String> fileFolderDetails = new List<String>();
fileFolderDetails.add('Test 123');
fileFolderDetails.add('application/pdf');
fileFolderDetails.add('true');
selectedFolderFiles.put('1EKOV5c8orKRbz_Hiso_uDwMPU6MXoS0k',fileFolderDetails);

//1.1 
List<String> downloadDetails = GoogleDriveIntegrationCompController.getNoOfFilesAndTotalSizeForDownload('ATI_Job__c', job.Id,selectedFolderFiles);
System.assertEquals('5 files', downloadDetails.get(0));
System.assertEquals('8 MB', downloadDetails.get(1));

//1.2
List<String> downloadDetails2 = GoogleDriveIntegrationCompController.getNoOfFilesAndTotalSizeForDownload('', job.Id,selectedFolderFiles);
System.assertEquals(0, downloadDetails2.size());

Test.stopTest();
}*/
}