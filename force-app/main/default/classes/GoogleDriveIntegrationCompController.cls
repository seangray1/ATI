/*******************************************************************************************
* @author           Suman
* @version          1.0 
* @date             10-AUG-2020
* @Status           In-Progress
* @Class Name       GoogleDriveIntegratonCompController
* @description      This is the controller for GoogleDriveIntegrationComp.	
*********************************************************************************************
Version     Date      Team          Comments
*********************************************************************************************
* 1      	Aug 2020    Suman        Initial Creation(JIRA AR-653)
*********************************************************************************************/
public with sharing class GoogleDriveIntegrationCompController {
    public class GoogleDriveException extends Exception {} 
    
    @TestVisible 
    static List<Google_Drive_Sync_Configuration__c> objectTemplatesList { 
        get {
            if ( objectTemplatesList == null ){
                objectTemplatesList = new List<Google_Drive_Sync_Configuration__c>();
                if (Schema.sObjectType.Google_Drive_Sync_Configuration__c.fields.Object_API_Name__c.isAccessible() && 
                    Schema.sObjectType.Google_Drive_Sync_Configuration__c.fields.Parent_Folder_Google_Drive_Ref__c.isAccessible() && 
                    Schema.sObjectType.Google_Drive_Sync_Configuration__c.fields.Upload_files_attachments__c.isAccessible() &&
                    Schema.sObjectType.Google_Drive_Sync_Configuration__c.fields.Delete_files_attachments__c.isAccessible() &&
                    Schema.sObjectType.Google_Drive_Sync_Configuration__c.fields.Folder_Name_for_Files__c.isAccessible() &&
                    Schema.sObjectType.Google_Drive_Sync_Configuration__c.fields.Active__c.isAccessible()) {
                        objectTemplatesList = [SELECT Object_API_Name__c, Parent_Folder_Google_Drive_Ref__c, Upload_files_attachments__c, Delete_files_attachments__c,Folder_Name_for_Files__c FROM Google_Drive_Sync_Configuration__c WHERE Active__c = true LIMIT 100];
                    }
            }
            return objectTemplatesList;
        } set; 
    }
    
    @TestVisible 
    static Google_Drive_Integration_Configurations__mdt googleDriveConfigDetails { 
        get {
            if (null == googleDriveConfigDetails &&
                Schema.sObjectType.Google_Drive_Integration_Configurations__mdt.fields.Mulesoft_API_Email_Address__c.isAccessible() && 
                Schema.sObjectType.Google_Drive_Integration_Configurations__mdt.fields.Mulesoft_API_Name__c.isAccessible() && 
                Schema.sObjectType.Google_Drive_Integration_Configurations__mdt.fields.Read_only_folders__c.isAccessible() &&
                Schema.sObjectType.Google_Drive_Integration_Configurations__mdt.fields.Read_only_folders_Account__c.isAccessible() &&
                Schema.sObjectType.Google_Drive_Integration_Configurations__mdt.fields.Read_only_folders_Opp__c.isAccessible()) 
                googleDriveConfigDetails = [SELECT Mulesoft_API_Email_Address__c ,Mulesoft_API_Name__c,Read_only_folders__c,Read_only_folders_Account__c,Read_only_folders_Opp__c FROM Google_Drive_Integration_Configurations__mdt LIMIT 1];
            return googleDriveConfigDetails;
        } set; 
    }
    
    @TestVisible 
    static List<String> hiddenFolderListForJob{
        get {
            if(null == hiddenFolderListForJob){
                hiddenFolderListForJob = new List<String>();
                if(!String.isBlank(googleDriveConfigDetails.Read_only_folders__c))
                    hiddenFolderListForJob = googleDriveConfigDetails.Read_only_folders__c.split(GDI_Constants.STRING_SEMICOLON);
            }
            return hiddenFolderListForJob;
        } set; 
    }
    @TestVisible 
    static List<String> hiddenFolderListForAcc{
        get {
            if(null == hiddenFolderListForAcc){
                hiddenFolderListForAcc = new List<String>();
                if(!String.isBlank(googleDriveConfigDetails.Read_only_folders_Account__c))
                    hiddenFolderListForAcc = googleDriveConfigDetails.Read_only_folders_Account__c.split(GDI_Constants.STRING_SEMICOLON);
            }
            return hiddenFolderListForAcc;
        } set; 
    }
    @TestVisible 
    static List<String> hiddenFolderListForOpp{
        get {
            if(null == hiddenFolderListForOpp){
                hiddenFolderListForOpp = new List<String>();
                if(!String.isBlank(googleDriveConfigDetails.Read_only_folders_Opp__c))
                    hiddenFolderListForOpp = googleDriveConfigDetails.Read_only_folders_Opp__c.split(GDI_Constants.STRING_SEMICOLON);
            }
            return hiddenFolderListForOpp;
        } set; 
    }
    
    public static Map<String,Google_Drive_Sync_Configuration__c> getObjectDetailsFromGDSyncConfig(){
        Map<String,Google_Drive_Sync_Configuration__c> objectNameMap = new Map<String,Google_Drive_Sync_Configuration__c>();
        if(null == objectTemplatesList || objectTemplatesList.isEmpty())
            return objectNameMap;
        
        for(Google_Drive_Sync_Configuration__c template : objectTemplatesList){
            if(template.Upload_files_attachments__c)
                objectNameMap.put(template.Object_API_Name__c.trim(), template);
        }
        return objectNameMap;
    }
    
    //(Added by Suman) This method is called when "Google Drive" tab is clicked on the Job/Acc record page.
    @AuraEnabled    
    public static List<GoogleDriveSubFolderFileDetail> getFolderFilesList(Id recordId, String sObjectName){
        List<GoogleDriveSubFolderFileDetail> folderFileList = new List<GoogleDriveSubFolderFileDetail>();
        List<String> hiddenFolderList = new List<String>();
        String SFMainFolderGoogleDriveRef = GDI_Constants.STRING_EMPTY;//To be used for fetching existing job/account record folders
        
        if(null == recordId || String.isBlank(sObjectName) || null == objectTemplatesList || objectTemplatesList.isEmpty())
            return folderFileList;
        
        //Check if the object is part of Google Drive Sync Config, else return empty list
        Boolean objectExistsInGDSyncConfig = false;
        for(Google_Drive_Sync_Configuration__c template : objectTemplatesList){
            if(sObjectName.equalsIgnoreCase(template.Object_API_Name__c)){
                objectExistsInGDSyncConfig = true;
                SFMainFolderGoogleDriveRef = template.Parent_Folder_Google_Drive_Ref__c;
                break;
            }
        }
        if(!objectExistsInGDSyncConfig)
            throw new GoogleDriveException(GDI_Constants.ERROR_LISTFOLDER_NOCONFIGFOUND);   
        
        if(sObjectName.equalsIgnoreCase(GDI_Constants.OBJ_JOB))
            hiddenFolderList = hiddenFolderListForJob;
        else if(sObjectName.equalsIgnoreCase(GDI_Constants.OBJ_ACCOUNT))
            hiddenFolderList = hiddenFolderListForAcc;
        else if(sObjectName.equalsIgnoreCase(GDI_Constants.OBJ_OPP))
            hiddenFolderList = hiddenFolderListForOpp;
        try{
            //Get Google drive Ref(or GD Id) for the existing record's main folder
            sObject currentRecord= Database.query('SELECT Id,Google_Drive_Folder_Ref__c,Google_Drive_Folder_Path__c,Google_Drive_Folder_Name__c, Google_Drive_Link__c FROM ' + sObjectName + ' WHERE Id = :recordId');
            
            String googleDriveFolderRef = GDI_Constants.STRING_EMPTY;
            //String googleDriveFolderLink = GDI_Constants.STRING_EMPTY;
            
            //Added to handle existing records where Google drive folder ref is not present
            if(null == currentRecord.get('Google_Drive_Folder_Ref__c')){
                if(null == currentRecord.get('Google_Drive_Folder_Path__c'))
                    throw new GoogleDriveException(GDI_Constants.ERROR_LISTFOLDER_NOFOLDERPATH);   
                
                folderFileList = GoogleDriveIntegrationCompHelper.getFolderFileDetailsFromGoogleDriveForExistingRecs(currentRecord.get('Google_Drive_Folder_Path__c').toString(), currentRecord.get('Google_Drive_Folder_Name__c').toString(), SFMainFolderGoogleDriveRef, recordId, hiddenFolderList);
                
                /*
                googleDriveFolderRef = folderFileList.get(0).parentFolderGDId;
                googleDriveFolderLink = folderFileList.get(0).parentFolderGDLink;
                
                if(String.isEmpty(googleDriveFolderRef))
                    throw new GoogleDriveException(GDI_Constants.ERROR_LISTFOLDER_NOFOLDERFOUND); 
                     
                Id idToUpdate = Id.valueOf(currentRecord.get('Id').toString());
                SObject recordToUpdate = idToUpdate.getSObjectType().newSObject(idToUpdate);
                recordToUpdate.put('Google_Drive_Folder_Ref__c', googleDriveFolderRef);
                recordToUpdate.put('Google_Drive_Link__c', googleDriveFolderLink);
                update recordToUpdate;*/
            }
            else{
                googleDriveFolderRef = currentRecord.get('Google_Drive_Folder_Ref__c').toString(); 
                //Fetch details from Mulesoft using googleDriveID
                folderFileList = GoogleDriveIntegrationCompHelper.getFolderFileDetailsFromGoogleDrive(googleDriveFolderRef, recordId, hiddenFolderList);
            }
            
        }catch(Exception e){
            System.debug('System Exception occurred : ' + e.getTypeName());
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());   
        }
        return folderFileList;
    } 
    
    //(Added by Suman)
    @AuraEnabled    
    public static String getGoogleDriveLinkForTheRecord(Id recordId, String sObjectName){
        String googleDriveLink = GDI_Constants.STRING_EMPTY;
        
        if(null == recordId || String.isBlank(sObjectName))
            return GDI_Constants.STRING_EMPTY;
        try{
            //Get Google drive Ref(or GD Id) and name for the existing record's main folder
            sObject currentRecord= Database.query('SELECT Google_Drive_Link__c  FROM ' + sObjectName + ' WHERE Id = :recordId');
            //If there ais no folder present in Google drive for Job/Account
            if(null == currentRecord.get('Google_Drive_Link__c'))
                throw new GoogleDriveException(GDI_Constants.ERROR_DRIVELINK_NOTFOUND);   
            else
                googleDriveLink = currentRecord.get('Google_Drive_Link__c').toString(); 
        }catch(Exception e){
            System.debug('System Exception occurred : ' + e.getTypeName());
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());   
        }
        return googleDriveLink;
    } 
    
    //(Added by Suman) This method is called when "Google Drive" tab is clicked on the Job/Acc record page.
    @AuraEnabled    
    public static Map<String, String> createNavPathMap(Id recordId, String sObjectName){
        Map<String, String> navPathMap = new Map<String, String>();
        
        if(null == recordId || String.isBlank(sObjectName))
            return navPathMap;
        
        try{
            //Get Google drive Ref(or GD Id) and name for the existing record's main folder
            sObject currentRecord= Database.query('SELECT Google_Drive_Folder_Ref__c,Google_Drive_Folder_Name__c  FROM ' + sObjectName + ' WHERE Id = :recordId');
            
            String googleDriveFolderRef = GDI_Constants.STRING_EMPTY;
            //If there ais no folder present in Google drive for Job/Account
            if(null == currentRecord.get('Google_Drive_Folder_Ref__c'))
                throw new GoogleDriveException(GDI_Constants.ERROR_LISTFOLDER_NOFOLDERFOUND);   
            else
                googleDriveFolderRef = currentRecord.get('Google_Drive_Folder_Ref__c').toString(); 
            
            navPathMap.put(googleDriveFolderRef, currentRecord.get('Google_Drive_Folder_Name__c').toString());
        }catch(Exception e){
            System.debug('System Exception occurred : ' + e.getTypeName());
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());   
        }
        return navPathMap;
    } 
    
    //(Added by Suman) This method is called when a sub-folder is clicked and the contents inside the sub-folder has to be listed/shown.
    @AuraEnabled    
    public static List<GoogleDriveSubFolderFileDetail> getSubFolderFilesList(Id recordId, String sObjectName, String googleDriveId){
        List<GoogleDriveSubFolderFileDetail> folderFileList = new List<GoogleDriveSubFolderFileDetail>();
        List<String> hiddenFolderList = new List<String>();
        if(null == recordId || String.isBlank(sObjectName) || String.isBlank(googleDriveId))
            return folderFileList;
        
        if(sObjectName.equalsIgnoreCase(GDI_Constants.OBJ_JOB))
            hiddenFolderList = hiddenFolderListForJob;
        else if(sObjectName.equalsIgnoreCase(GDI_Constants.OBJ_ACCOUNT))
            hiddenFolderList = hiddenFolderListForAcc;
        else if(sObjectName.equalsIgnoreCase(GDI_Constants.OBJ_OPP))
            hiddenFolderList = hiddenFolderListForOpp;
        
        try{
            /*Fetch details from Mulesoft using googleDriveID*/
            Map<String, List<GoogleDriveSubFolderFileDetail>> folderFileMap = new Map<String, List<GoogleDriveSubFolderFileDetail>>();
            folderFileList = GoogleDriveIntegrationCompHelper.getFolderFileDetailsFromGoogleDrive(googleDriveId, recordId, hiddenFolderList);
        }catch(Exception e){
            System.debug('System Exception occurred : ' + e.getTypeName());
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());   
        }
        return folderFileList;
    } 
    
    //(Added by Suman) This method called when new folder is to be created.
    @AuraEnabled    
    public static GoogleDriveSubFolderFileDetail createNewFolderInGoogleDrive(String sObjectName, Id recordId, String googleDriveId, String newFolderName){
        GoogleDriveSubFolderFileDetail newfolderFileDetails;
        
        if(null == recordId || String.isBlank(sObjectName) || String.isBlank(googleDriveId))
            return newfolderFileDetails;
        
        try{
            newfolderFileDetails = GoogleDriveIntegrationCompHelper.createFolderFileInGoogleDrive(googleDriveId, newFolderName, GDI_Constants.MIMETYPE_FOLDER, recordId);
        }catch(Exception e){
            System.debug('System Exception occurred : ' + e.getTypeName());
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());   
        }
        return newfolderFileDetails;
    } 
    
    //(Added by Suman) This method called when new file is to be created.
    @AuraEnabled    
    public static GoogleDriveSubFolderFileDetail createNewFileInGoogleDrive(String sObjectName, Id recordId, String googleDriveId, String fileType, String fileName){
        GoogleDriveSubFolderFileDetail newfolderFileDetails;
        
        if(null == recordId || String.isBlank(sObjectName) || String.isBlank(googleDriveId))
            return newfolderFileDetails;
        
        String mimeType = GDI_Constants.STRING_EMPTY;
        if(fileType.equalsIgnoreCase(GDI_Constants.FILETYPE_GDOC)){
            mimeType = GDI_Constants.MIMETYPE_GDOC;
        }
        else if(fileType.equalsIgnoreCase(GDI_Constants.FILETYPE_GSHEET)){
            mimeType = GDI_Constants.MIMETYPE_GSHEET;
        }
        else if(fileType.equalsIgnoreCase(GDI_Constants.FILETYPE_GSLIDE)){
            mimeType = GDI_Constants.MIMETYPE_GSLIDE;
        }
        
        else if(fileType.equalsIgnoreCase(GDI_Constants.FILETYPE_MSDOC)){
            mimeType = GDI_Constants.MIMETYPE_MSDOC;
        }
        else if(fileType.equalsIgnoreCase(GDI_Constants.FILETYPE_MSEXCEL)){
            mimeType = GDI_Constants.MIMETYPE_MSEXCEL;
        }
        else if(fileType.equalsIgnoreCase(GDI_Constants.FILETYPE_MSPPT)){
            mimeType = GDI_Constants.MIMETYPE_MSPPT;
        }
        
        try{
            newfolderFileDetails = GoogleDriveIntegrationCompHelper.createFolderFileInGoogleDrive(googleDriveId, fileName, mimeType, recordId);
            
        }catch(Exception e){
            System.debug('System Exception occurred : ' + e.getTypeName());
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());   
        }
        return newfolderFileDetails;
    } 
    
    //(Added by Suman) This method is called when user clicks on 'Upload' button
    @AuraEnabled    
    public static void uploadFilesToGoogleDrive(String recordId, String googleDriveId, String fileList){
        if(String.isBlank(recordId) || String.isBlank(fileList) || String.isBlank(googleDriveId))
            return;
        
        List<String> uploadedFileList = (List<String>)JSON.deserialize(fileList, List<String>.class);
        
        List<ContentDocument> documentList = new List<ContentDocument>();
        try{
            if (Schema.sObjectType.ContentDocument.fields.Id.isAccessible() && 
                Schema.sObjectType.ContentDocument.fields.Title.isAccessible() && 
                Schema.sObjectType.ContentDocument.fields.FileType.isAccessible() &&
                Schema.sObjectType.ContentDocument.fields.FileExtension.isAccessible()) {
                    documentList = [SELECT Id,Title,FileType,FileExtension FROM ContentDocument WHERE Id IN: uploadedFileList LIMIT 100];
                }
            if(documentList.isEmpty())
                return;
            
            List<Upload_files_to_GoogleDrive__e > uploadFilesToGoogleDriveEventList = new List<Upload_files_to_GoogleDrive__e >();
            for(ContentDocument docItem : documentList){
                String linkedRecURL = URL.getSalesforceBaseUrl().toExternalForm()+ '/'+recordId;
                System.debug('$$$$$$$ linkedRecURL-' + linkedRecURL);
                uploadFilesToGoogleDriveEventList.add(new Upload_files_to_GoogleDrive__e(GoogleDriveFolderRefForRecord__c =googleDriveId, SF_DocumentID__c =docItem.Id,
                                                                                         MIME_Type__c  =GoogleDriveIntegrationCompHelper.getMimeTypeForFile(docItem.FileType,docItem.FileExtension), 
                                                                                         UploadToGoogleDocsNotesAndAttachments__c= false, ToBeDeletedFromSF__c=true,
                                                                                         Logged_in_user_details__c=UserInfo.getName()+ GDI_Constants.STRING_SQUAREBRACKETSTART +UserInfo.getUserEmail() + GDI_Constants.STRING_SQUAREBRACKETEND,
                                                                                         SF_record_URL__c = linkedRecURL));
            }
            if(uploadFilesToGoogleDriveEventList.isEmpty())
                return;
            
            System.debug('***** uploadFilesToGoogleDriveEventList - ' + uploadFilesToGoogleDriveEventList);
            
            List<Database.SaveResult> results = EventBus.publish(uploadFilesToGoogleDriveEventList);
            // Inspect publishing result for each event
            for (Database.SaveResult sr : results) {
                if (sr.isSuccess()) {
                    System.debug('Successfully published event.');
                } else {
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('Error returned: ' +
                                     err.getStatusCode() +
                                     ' - ' +
                                     err.getMessage());
                    }
                }       
            }
        }catch(Exception e){
            System.debug('System Exception occurred : ' + e.getTypeName());
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());   
        }
    }
    
    //(Added by Suman) This method is called when user selects files/folders and clicks on 'Delete' button
    @AuraEnabled    
    public static void deleteSelectedFolderFiles(String googleDriveRefListString, String recordId){
        if(String.isBlank(googleDriveRefListString))
            return;
        List<String> googleDriveRefList = (List<String>)JSON.deserialize(googleDriveRefListString, List<String>.class);
        try{
            GoogleDriveIntegrationCompHelper.deleteFolderFileInGoogleDrive(googleDriveRefList, recordId);
        }catch(Exception e){
            System.debug('System Exception occurred : ' + e.getTypeName());
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());   
        }
    } 
    
    @AuraEnabled
    public static List<GoogleDriveSubFolderFileDetail> getSearchResultList(String searchKey, String googleDriveFolderRef, String mimeType, String ModifiedDateFilterType, Date StartDate, Date EndDate){
        List<GoogleDriveSubFolderFileDetail> folderFileList = new List<GoogleDriveSubFolderFileDetail>();
        System.debug('searchKey ============>'+searchKey );
        System.debug('googleDriveFolderRef ============>'+googleDriveFolderRef );
        System.debug('mimeType ============>'+mimeType );
        System.debug('ModifiedDateFilterType ============>'+ModifiedDateFilterType );
        System.debug('StartDate ============>'+StartDate );
        System.debug('EndDate============>'+EndDate);
        
        String StartdateJSON = null;
        String EnddateJSON = null;
        
        if(String.isBlank(searchKey) || String.isBlank(googleDriveFolderRef)){
            System.debug('Inside if');
            return folderFileList;
        }
        if((ModifiedDateFilterType == GDI_Constants.STRING_CUSTOM) && ((StartDate == null) || (EndDate == null))){
            System.debug('NEW IF');
            return folderFileList;
        }
        if(ModifiedDateFilterType != GDI_Constants.STRING_ANYTYPE && ModifiedDateFilterType != GDI_Constants.STRING_CUSTOM){
            System.debug('Inside 2nd if');
            StartDate = DateCalculation(ModifiedDateFilterType);
            EndDate = date.today().addDays(1);
            System.debug('StartDate-------------->'+StartDate);
            System.debug('EndDate-------------->'+EndDate);
        }
        if(ModifiedDateFilterType == GDI_Constants.STRING_CUSTOM){
            EndDate = EndDate.addDays(1);
        }
        if(StartDate != null && EndDate != null){
            StartdateJSON = DateformatforJSON(StartDate);
            EnddateJSON = DateformatforJSON(EndDate);
            
        }
        
        
        
        try{  
            System.debug('Inside try');
            folderFileList = GoogleDriveIntegrationCompHelper.getSearchResultListFromGoogleDrive(searchKey, googleDriveFolderRef,mimeType,ModifiedDateFilterType,StartdateJSON,EnddateJSON );
            //Update GD ref in record so that in future it can be used
            
        }
        catch(Exception e){
            System.debug('Inside Catch');
            System.debug('System Exception occurred : ' + e.getTypeName());
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());   
        }
        return folderFileList;
    }
    
    public static date DateCalculation(String ModifiedDateFilterType){
        System.debug('Inside DateCalculation');
        if(ModifiedDateFilterType == GDI_Constants.STRING_24HOURS){
            datetime myDate = system.now();
            datetime Startdatetime = myDate.addHours(-24);
            date StartdateValue = date.newinstance(Startdatetime.year(), Startdatetime.month(), Startdatetime.day());
            return StartdateValue;
        }
        else if(ModifiedDateFilterType == GDI_Constants.STRING_WEEK){
            date myDate = date.today();
            date StartdateValue = myDate.toStartofWeek();
            return StartdateValue.addDays(-7);
        }
        else if(ModifiedDateFilterType == GDI_Constants.STRING_MONTH){
            date myDate = date.today();
            date StartdateValue = myDate.toStartofMonth();
            return StartdateValue.addMonths(-1);
        }
        else if(ModifiedDateFilterType == GDI_Constants.STRING_3MONTHS){
            date myDate = date.today();
            date StartdateValue = myDate.toStartofMonth();
            return StartdateValue.addMonths(-3);
        }
        else if(ModifiedDateFilterType == GDI_Constants.STRING_6MONTHS){
            date myDate = date.today();
            date StartdateValue = myDate.toStartofMonth();
            return StartdateValue.addMonths(-6);
        }
        else if(ModifiedDateFilterType == GDI_Constants.STRING_12MONTHS){
            date myDate = date.today();
            date StartdateValue = myDate.toStartofMonth();
            return StartdateValue.addMonths(-12);
        }
        return null;
    }
    
    public static string DateformatforJSON(Date JSONDate){
        
        String test = string.valueof(JSONDate.year())+'-'+string.valueof(JSONDate.month())+'-'+string.valueof(JSONDate.day());
        
        return test;
    }
    
    //(Added by Suman) This method gives the list of folders which need to be read only in lightning comp
    @AuraEnabled  
    public static void addAPILogInDB(String apiLogData){
        System.debug('***** Inside addAPILogInDB()');
        GoogleDriveIntegrationAPILogData apiLog = (GoogleDriveIntegrationAPILogData)JSON.deserialize(apiLogData, GoogleDriveIntegrationAPILogData.class);
        System.debug('****** Inside addAPILogInDB()');
        System.debug(apiLog);
        
        GoogleDriveIntegrationCompController.addEntryToAPILog(apiLog.recordId, apiLog.googleDriveRef, apiLog.requestBody, apiLog.mulesoftResponseCode, apiLog.mulesoftResponse, apiLog.operationDetails);
    } 
    
    private static void addEntryToAPILog(String recordId, String googleDriveRef, String requestBody, Integer mulesoftResponseCode, String mulesoftResponse, String operationDetails){
        Jitterbit_Log__c logEntry = new Jitterbit_Log__c(Name='SalesforceToMulesoftConnection', Source_System__c='Salesforce', Destination_System__c='GoogleDrive', Status__c ='Failure', Request_Method__c ='API',
                                                         Error_Warning_Details__c=mulesoftResponse, Response__c=operationDetails, XASP_Transaction_ID__c =recordId, Record_ID__c = googleDriveRef, HTTP_Response_Code__c= String.valueOf(mulesoftResponseCode),
                                                         Request_Body__c =requestBody);
        Database.insert(logEntry,false);
        System.debug('****** Inside addEntryToAPILog()' + logEntry.Id);
    }
    
    /********************  Commented as per CSM comments for Sprint 5 Demo*************************/
    
    //(Added by Suman) This method is called when user selects files/folders and clicks on 'Download' button
    /*
@AuraEnabled    
public static String getDownloadPageLink(String sObjectName, Id recordId, String downloadFolderName, Map<String,List<String>> selectedFolderFiles, Boolean includeSubFolders){
String downloadLink = GDI_Constants.STRING_EMPTY;

if(String.isBlank(sObjectName) || null == selectedFolderFiles || selectedFolderFiles.size()==0)
return downloadLink;

//Find the root id(Parent folder for all SF job/account folders)
String SFMainFolderGoogleDriveRef = GDI_Constants.STRING_EMPTY;//To be used for fetching existing job/account record folders
//Check if the object is part of Google Drive Sync Config, else return empty list
Boolean objectExistsInGDSyncConfig = false;
for(Google_Drive_Sync_Configuration__c template : objectTemplatesList){
if(sObjectName.equalsIgnoreCase(template.Object_API_Name__c)){
objectExistsInGDSyncConfig = true;
SFMainFolderGoogleDriveRef = template.Parent_Folder_Google_Drive_Ref__c;
break;
}
}
if(!objectExistsInGDSyncConfig)
return downloadLink;

try{
//Get Google drive Ref(or GD Id), Name for the main Job/Account folder
sObject parentRecord= Database.query('SELECT Id,Google_Drive_Folder_Ref__c,Google_Drive_Folder_Name__c FROM ' + sObjectName + ' WHERE Id = :recordId');
downloadLink = GoogleDriveIntegrationCompHelper.downloadFolderFileInGoogleDrive(SFMainFolderGoogleDriveRef, parentRecord.get('Google_Drive_Folder_Ref__c').toString(), downloadFolderName, selectedFolderFiles, includeSubFolders,recordId);

}catch(Exception e){
System.debug('System Exception occurred : ' + e.getTypeName());
System.debug(e.getMessage());
System.debug(e.getStackTraceString());
throw new AuraHandledException(e.getMessage());   
}
return downloadLink;
} */
    
    
    /* 
//This method is called when user selects files/folders and clicks on 'Download' button.
@AuraEnabled    
public static List<String> getNoOfFilesAndTotalSizeForDownload(String sObjectName, Id recordId, Map<String,List<String>> selectedFolderFiles){
System.debug('***** Inside getNoOfFilesAndTotalSizeForDownload()');
List<String> downloadDetails = new List<String>();

if(String.isBlank(sObjectName) || null == selectedFolderFiles || selectedFolderFiles.size()==0)
return downloadDetails;

System.debug('****' + selectedFolderFiles);

try{
//Get Google drive Ref(or GD Id), Name for the main Job/Account folder
sObject parentRecord= Database.query('SELECT Id,Google_Drive_Folder_Ref__c FROM ' + sObjectName + ' WHERE Id = :recordId');
downloadDetails = GoogleDriveIntegrationCompHelper.getTotalSizeAndNoOfFiles(parentRecord.get('Google_Drive_Folder_Ref__c').toString(), selectedFolderFiles,recordId);

}catch(Exception e){
System.debug('System Exception occurred : ' + e.getTypeName());
System.debug(e.getMessage());
System.debug(e.getStackTraceString());
throw new AuraHandledException(e.getMessage());   
}
return downloadDetails;
}*/
    
    /**********Commented as per the requirement change- Read only not needed instead the "Photo" folder shall be hidden ***************/
    /*This method gives the list of folders which need to be read only in lightning comp
@AuraEnabled  
public static List<String> getReadOnlyFolderListFromMetadataConfig(String sObjectName){
System.debug('***** Inside getReadOnlyFolderListFromMetadataConfig()');
List<String> folderList = new List<String>();
if(String.isBlank(sObjectName) || null == googleDriveConfigDetails || null == objectTemplatesList || objectTemplatesList.size() == 0)
return folderList;
System.debug('######2' + sObjectName);
String folderListString = GDI_Constants.STRING_EMPTY;
try{
if(sObjectName.equalsIgnoreCase(GDI_Constants.OBJ_JOB))
folderListString = googleDriveConfigDetails.Read_only_folders__c;
else if(sObjectName.equalsIgnoreCase(GDI_Constants.OBJ_ACCOUNT))
folderListString = googleDriveConfigDetails.Read_only_folders_Account__c;
else if(sObjectName.equalsIgnoreCase(GDI_Constants.OBJ_OPP))
folderListString = googleDriveConfigDetails.Read_only_folders_Opp__c;
else
return folderList;
System.debug('######1' + folderListString);
if(String.isBlank(folderListString))
return folderList;

folderList = folderListString.split(GDI_Constants.STRING_SEMICOLON);
}catch(Exception e){
System.debug('System Exception occurred : ' + e.getTypeName());
System.debug(e.getMessage());
System.debug(e.getStackTraceString());
throw new AuraHandledException(e.getMessage());   
}
return folderList;
} */
}