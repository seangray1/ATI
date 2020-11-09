/*******************************************************************************************
* @author           Kevin & Suman
* @version          1.0 
* @date             12-AUG-2020
* @Status           In-Progress
* @Class Name       GoogleDriveIntegrationCompHelper
* @description      This apex class will be the helper class for - GoogleDriveIntegrationCompController.    
*********************************************************************************************
Version     Date      Team          Comments
*********************************************************************************************
* 1         Aug 2020    Suman        Initial Creation(JIRA AR-653)
*********************************************************************************************/
public with sharing class GoogleDriveIntegrationCompHelper {
    public class MulesoftAPIException extends Exception {} 
    
    @TestVisible 
    static Google_Drive_Integration_Configurations__mdt googleDriveConfigDetails { 
        get {
            if (null == googleDriveConfigDetails && 
                Schema.sObjectType.Google_Drive_Integration_Configurations__mdt.fields.Access_token__c.isAccessible())
                googleDriveConfigDetails = [SELECT Access_token__c FROM Google_Drive_Integration_Configurations__mdt LIMIT 1];
            return googleDriveConfigDetails;
        } set; 
    }
    
    @TestVisible 
    static List<GoogleDriveUploadMIMETypeConfigSetting__mdt> mimeTypeConfigDetails { 
        get {
            if (null == mimeTypeConfigDetails){
                mimeTypeConfigDetails = new List<GoogleDriveUploadMIMETypeConfigSetting__mdt>();
                mimeTypeConfigDetails = [SELECT MasterLabel,File_Type__c,MIME_Type__c,Group__c   FROM GoogleDriveUploadMIMETypeConfigSetting__mdt];
            }
            return mimeTypeConfigDetails;
        } set; 
    }
    
    @TestVisible 
    static Map<String,String> mimeTypeMap { 
        get {
            if ( mimeTypeMap == null ){
                mimeTypeMap = new Map<String,String>();
                for(GoogleDriveUploadMIMETypeConfigSetting__mdt item : mimeTypeConfigDetails)
                    mimeTypeMap.put(item.File_Type__c, item.MIME_Type__c);
            }
            return mimeTypeMap;
        } set; 
    }
    
    @TestVisible 
    static Map<String,String> SearchmimeTypeMap { 
        get {
            if ( SearchmimeTypeMap == null ){
                SearchmimeTypeMap = new Map<String,String>();
                List<GoogleDriveUploadMIMETypeConfigSetting__mdt> mimeTypeConfigList = new List<GoogleDriveUploadMIMETypeConfigSetting__mdt>();
                mimeTypeConfigList = mimeTypeConfigDetails;
                for(GoogleDriveUploadMIMETypeConfigSetting__mdt item : mimeTypeConfigDetails){
                    String MimeStringconcatenate = GDI_Constants.STRING_EMPTY;
                    for(integer i=0; i<mimeTypeConfigList.size(); i++){
                        if(item.Group__c == mimeTypeConfigList[i].Group__c && !MimeStringconcatenate.contains(mimeTypeConfigList[i].MIME_Type__c)){
                            MimeStringconcatenate = MimeStringconcatenate + mimeTypeConfigList[i].MIME_Type__c + ',';
                        }
                        //mimeTypeConfigList.remove(i);
                    }
                    SearchmimeTypeMap.put(item.Group__c, MimeStringconcatenate.removeEnd(','));
                }
            }
            system.debug('SearchmimeTypeMap------->'+SearchmimeTypeMap);
            return SearchmimeTypeMap;
        } set; 
    }
    
    public static String getSearchMimeTypeForFile(String fileType, String fileExtension){ 
        String mimeType = GDI_Constants.STRING_EMPTY;
        if(null == SearchmimeTypeMap && SearchmimeTypeMap.isEmpty())     
            return mimeType;
        system.debug('fileType----------->'+fileType);
        mimeType = SearchmimeTypeMap.get(fileType);
        system.debug('mimeType----------->'+mimeType);
        if(String.isBlank(mimeType)){
            System.debug('File type not recognized - ' + fileType);
            throw new MulesoftAPIException(GDI_Constants.EXTISSUE_UPLOAD);   
        }
        
        return mimeType;
    }
    
    public static List<GoogleDriveSubFolderFileDetail> getFolderFileDetailsFromGoogleDrive(String googleDriveFolderRef, String recordId, List<String> hiddenFolderList){
        List<GoogleDriveSubFolderFileDetail> folderFileList = new List<GoogleDriveSubFolderFileDetail>();
        System.debug('******* Inside ListFolder API function - ' + googleDriveFolderRef);
        String body = GDI_Constants.STRING_EMPTY;
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField(GDI_Constants.LISTFOLDER_ID, googleDriveFolderRef);
        gen.writeEndObject();
        body = gen.getAsString();        
        
        System.debug('******* Body ListFolder API function - ' + body);
        
        HttpResponse res1;
        res1 = ListFolderAPI(body);
        String str=res1.getbody();
        Integer Status = res1.getStatusCode();
        System.debug('******* Result ListFolder API function - ' + str);
        if(Status != 200 && Status != 201){
            GoogleDriveIntegrationAPILogData logData = new GoogleDriveIntegrationAPILogData(GDI_Constants.APIERROR_LISTFOLDER + GDI_Constants.STRING_SPACE + GDI_Constants.APIERROR_MESSAGE + Status,
                recordId, googleDriveFolderRef, Status, str, GDI_Constants.APILOGOPERATION_LISTFOLDER, body);
            throw new MulesoftAPIException(JSON.serialize(logData)); 
        }
        GoogleDriveFolderFileListWrapper obj = GoogleDriveFolderFileListWrapper.parse(str);
        
        for(integer i=0; i<obj.Result.size(); i++){
            if(hiddenFolderList.contains(obj.Result[i].name))
                continue;
            
            folderFileList.add(convertWrapperToRequiredFormat(obj.Result[i], obj.parentId, obj.webViewLink));
        }
        
        return folderFileList;
    }
    
    public static List<GoogleDriveSubFolderFileDetail> getFolderFileDetailsFromGoogleDriveForExistingRecs(String folderPath, String folderName, String mainSFFolderGoogleDriveRef, String recordId, List<String> hiddenFolderList){
        List<GoogleDriveSubFolderFileDetail> folderFileList = new List<GoogleDriveSubFolderFileDetail>();
        String body = GDI_Constants.STRING_EMPTY;
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField(GDI_Constants.LISTFOLDER_ROOTID, mainSFFolderGoogleDriveRef); 
        gen.writeStringField(GDI_Constants.LISTFOLDER_ROOTPATH, folderPath + '/' + folderName);
        gen.writeEndObject();
        body = gen.getAsString();
        System.debug('******* Body ListFolder API function - ' + body);
        HttpResponse res1;
        res1 = ListFolderAPI(body);
        
        String str=res1.getbody();
        System.debug('******* Result ListFolder API function - ' + str);
        Integer Status = res1.getStatusCode();
        if(Status != 200 && Status != 201){
            GoogleDriveIntegrationAPILogData logData = new GoogleDriveIntegrationAPILogData(GDI_Constants.APIERROR_LISTFOLDER + GDI_Constants.STRING_SPACE + GDI_Constants.APIERROR_MESSAGE + Status,
                recordId, GDI_Constants.STRING_EMPTY, Status, str, GDI_Constants.APILOGOPERATION_LISTFOLDEREXISTINGRECS, body);
            throw new MulesoftAPIException(JSON.serialize(logData)); 
        }
        
        GoogleDriveFolderFileListWrapper obj = GoogleDriveFolderFileListWrapper.parse(str);
        
        for(integer i=0; i<obj.Result.size(); i++){
            if(hiddenFolderList.contains(obj.Result[i].name))
                continue;
            folderFileList.add(convertWrapperToRequiredFormat(obj.Result[i], obj.parentId, obj.webViewLink));
        }
        
        if(String.isEmpty(obj.parentId))
            throw new MulesoftAPIException(GDI_Constants.ERROR_LISTFOLDER_NOFOLDERFOUND); 
        else
            updateParentRecDetails(recordId,obj.parentId, obj.webViewLink);
        
        return folderFileList;
    }
    
    private static void updateParentRecDetails(String recordId, String googleDriveFolderRef, String googleDriveFolderLink){
        Id idToUpdate = Id.valueOf(recordId);
        SObject recordToUpdate = idToUpdate.getSObjectType().newSObject(idToUpdate);
        recordToUpdate.put('Google_Drive_Folder_Ref__c', googleDriveFolderRef);
        recordToUpdate.put('Google_Drive_Link__c', googleDriveFolderLink);
        update recordToUpdate;
    }
    
    @TestVisible
    private static HttpResponse ListFolderAPI(String Body) {
        if(String.isBlank(Body))
            throw new MulesoftAPIException(GDI_Constants.APIERROR_BODYISEMPTY); 
        
        Http http = new Http();
        HttpRequest req1 = new HttpRequest();
        
        req1.setEndpoint(GDI_Constants.ENDPOINTURL + GDI_Constants.API_LISTFOLDER);
        req1.setmethod(GDI_Constants.HTTPREQMETHOD_POST);
        req1.setHeader('Content-Type', GDI_Constants.CONTENTTYPE_JSON); 
        if(null == googleDriveConfigDetails || String.isBlank(googleDriveConfigDetails.Access_token__c))
            throw new MulesoftAPIException(GDI_Constants.ERROR_ACCESSTOKEN_NOTFOUND); 
        req1.setHeader('x-authorization-token', googleDriveConfigDetails.Access_token__c);
        req1.setTimeout(20000);
        req1.setbody(body);
        
        HttpResponse res1;
        res1 = http.send(req1);
        
        return res1;
    }
    
    public static GoogleDriveSubFolderFileDetail createFolderFileInGoogleDrive(String googleDriveId, String name, String mimeType, String recordId){
        GoogleDriveSubFolderFileDetail folderFileDetail ;
        
        String Body = GDI_Constants.STRING_EMPTY;
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField(GDI_Constants.CREATE_NAME, name);
        gen.writeStringField(GDI_Constants.CREATE_MIMETYPE, mimeType);
        gen.writeStringField(GDI_Constants.CREATE_PARENTID, googleDriveId);
        gen.writeStringField(GDI_Constants.CREATE_MODIFIEDBY, UserInfo.getName()+ GDI_Constants.STRING_SQUAREBRACKETSTART +UserInfo.getUserEmail() + GDI_Constants.STRING_SQUAREBRACKETEND);
        gen.writeEndObject();
        Body = gen.getAsString();        
        
        HttpResponse res1;
        res1 = CreateAPI(Body);
        String str=res1.getbody();
        Integer Status = res1.getStatusCode();
        if(Status != 200 && Status != 201){
            GoogleDriveIntegrationAPILogData logData = new GoogleDriveIntegrationAPILogData(GDI_Constants.APIERROR_CREATE + GDI_Constants.STRING_SPACE + GDI_Constants.APIERROR_MESSAGE + Status,
                recordId, googleDriveId, Status, str, GDI_Constants.APILOGOPERATION_CREATE, body);
            throw new MulesoftAPIException(JSON.serialize(logData)); 
        }
            
        GoogleDriveNewFolderFileDetailsWrapper obj = GoogleDriveNewFolderFileDetailsWrapper.parse(str);
        folderFileDetail = convertWrapperToRequiredFormat(obj.result);
        
        return folderFileDetail;
    }
    
    @TestVisible
    private static HttpResponse CreateAPI(String Body) {
        if(String.isBlank(Body))
            throw new MulesoftAPIException(GDI_Constants.APIERROR_BODYISEMPTY); 
        
        Http http = new Http();
        HttpRequest req1 = new HttpRequest();
        
        req1.setEndpoint(GDI_Constants.ENDPOINTURL + GDI_Constants.API_CREATE);
        req1.setmethod(GDI_Constants.HTTPREQMETHOD_POST);
        req1.setHeader('Content-Type', GDI_Constants.CONTENTTYPE_JSON); 
        if(null == googleDriveConfigDetails || String.isBlank(googleDriveConfigDetails.Access_token__c))
            throw new MulesoftAPIException(GDI_Constants.ERROR_ACCESSTOKEN_NOTFOUND); 
        req1.setHeader('x-authorization-token', googleDriveConfigDetails.Access_token__c);
        req1.setTimeout(20000);
        req1.setbody(Body);
        
        HttpResponse res1;
        res1 = http.send(req1);
        
        return res1;
    }
    
    public static void deleteFolderFileInGoogleDrive(List<String> googleDriveRefList, String recordId){
        String Body = GDI_Constants.STRING_EMPTY;
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartArray();
        for(String gdId : googleDriveRefList){
            gen.writeStartObject();
            gen.writeStringField(GDI_Constants.LISTFOLDER_ID, gdId);
            gen.writeEndObject();
        }
        gen.writeEndArray();
        Body = gen.getAsString();        
        HttpResponse res1;
        res1 = DeleteAPI(Body);
        String str=res1.getbody();
        Integer Status = res1.getStatusCode();
        if(Status != 200 && Status != 201){
             GoogleDriveIntegrationAPILogData logData = new GoogleDriveIntegrationAPILogData(GDI_Constants.APIERROR_DELETE + GDI_Constants.STRING_SPACE + GDI_Constants.APIERROR_MESSAGE + Status,
                recordId, GDI_Constants.STRING_EMPTY, Status, str, GDI_Constants.APILOGOPERATION_DELETE, body);
            throw new MulesoftAPIException(JSON.serialize(logData));
        }
    }
    
    private static HttpResponse DeleteAPI(String Body) {
        if(String.isBlank(Body))
            throw new MulesoftAPIException(GDI_Constants.APIERROR_BODYISEMPTY); 
        
        Http http = new Http();
        HttpRequest req1 = new HttpRequest();
        req1.setEndpoint(GDI_Constants.ENDPOINTURL + GDI_Constants.API_DELETE);
        req1.setmethod(GDI_Constants.HTTPREQMETHOD_DELETE);
        req1.setHeader('Content-Type', GDI_Constants.CONTENTTYPE_JSON); 
        if(null == googleDriveConfigDetails || String.isBlank(googleDriveConfigDetails.Access_token__c))
            throw new MulesoftAPIException(GDI_Constants.ERROR_ACCESSTOKEN_NOTFOUND); 
        req1.setHeader('x-authorization-token', googleDriveConfigDetails.Access_token__c);
        req1.setTimeout(20000);
        req1.setbody(Body);
        HttpResponse res1;
        res1 = http.send(req1);
        
        return res1;
    }
    
    @TestVisible
    private static GoogleDriveSubFolderFileDetail convertWrapperToRequiredFormat(GoogleDriveFolderFileListWrapper.Result result, String parentId, String googleDriveLink){
        GoogleDriveSubFolderFileDetail folderFileDetail;
        
        boolean isFolder = false;
        if((result.mimeType).containsIgnoreCase(GDI_Constants.STRING_FOLDER)){
            isFolder = true;
        }
        //Datetime ModifiedDateGMT = DateTime.newInstance(result.modifiedTime.value);
        Datetime ModifiedDateGMT = result.modifiedTime;
        String ModifiedDateString = ModifiedDateGMT.format('MMM dd, yyyy hh:mm a');
        String size = GDI_Constants.STRING_EMPTY;
        if(isFolder)
            size = GDI_Constants.STRING_HYPHEN;
        else if(null != result.size){
            size = result.size;
        }
            
        
        String lastModifiedByUser = GDI_Constants.STRING_EMPTY;
        if(null == result.LastModifyingUser || String.isBlank(result.LastModifyingUser.displayName))
            lastModifiedByUser = GDI_Constants.STRING_EMPTY;
        else
            lastModifiedByUser = result.LastModifyingUser.displayName;
        
        String ownerDisplayName = GDI_Constants.STRING_EMPTY;
        String parentItem = GDI_Constants.STRING_EMPTY;
        String description = GDI_Constants.STRING_EMPTY;
        if(null != result.Owners && result.Owners.isEmpty())
            ownerDisplayName = result.Owners[0].displayName;
        if(null != result.parents && result.parents.isEmpty())
            parentItem = result.parents.get(0);
        if(!String.isBlank(result.description))
            description = result.description;
        folderFileDetail = new GoogleDriveSubFolderFileDetail(result.id, isFolder, result.filePath, result.name, result.fileExtension==null?GDI_Constants.STRING_EMPTY:result.fileExtension, result.iconLink, ownerDisplayName, lastModifiedByUser, result.webViewLink==null?result.mimeType:result.webViewLink, result.webContentLink==null?GDI_Constants.STRING_EMPTY:result.webContentLink,ModifiedDateString, size, result.mimeType==null?GDI_Constants.STRING_EMPTY:result.mimeType, parentItem, description, String.isBlank(parentId)?GDI_Constants.STRING_EMPTY:parentId, String.isBlank(googleDriveLink)?GDI_Constants.STRING_EMPTY:googleDriveLink);
        
        return folderFileDetail;
    }
    
    @TestVisible
    private static GoogleDriveSubFolderFileDetail convertWrapperToRequiredFormat(GoogleDriveNewFolderFileDetailsWrapper.Result result){
        GoogleDriveSubFolderFileDetail folderFileDetail;
        
        boolean isFolder = false;
        if((result.mimeType).containsIgnoreCase(GDI_Constants.STRING_FOLDER)){
            isFolder = true;
        }
        Datetime ModifiedDateGMT = DateTime.newInstance(result.modifiedTime.value);
        //Datetime ModifiedDateGMT = result.modifiedTime;
        String ModifiedDateString = ModifiedDateGMT.format('MMM')+' '+ModifiedDateGMT.day()+','+ModifiedDateGMT.year();// Format- Oct 16,2020
        String size;
        if(isFolder)
            size = GDI_Constants.STRING_HYPHEN;
        else{
            size = result.size;
        }
        
        String lastModifiedByUser = GDI_Constants.STRING_EMPTY;
        if(null == result.LastModifyingUser || String.isBlank(result.LastModifyingUser.displayName))
            lastModifiedByUser = GDI_Constants.STRING_EMPTY;
        else
            lastModifiedByUser = result.LastModifyingUser.displayName;
        
        String ownerDisplayName = GDI_Constants.STRING_EMPTY;
        String description = GDI_Constants.STRING_EMPTY;
        if(null != result.Owners && result.Owners.isEmpty())
            ownerDisplayName = result.Owners[0].displayName;
        if(!String.isBlank(result.description))
            description = result.description;
        
        folderFileDetail = new GoogleDriveSubFolderFileDetail(result.id, isFolder, result.filePath, result.name, result.fileExtension==null? GDI_Constants.STRING_EMPTY:result.fileExtension , result.iconLink==null? GDI_Constants.STRING_EMPTY:result.iconLink, ownerDisplayName, lastModifiedByUser, result.webViewLink==null? GDI_Constants.STRING_EMPTY:result.webViewLink, result.webContentLink==null? GDI_Constants.STRING_EMPTY:result.webContentLink, ModifiedDateString, size, result.mimeType==null? GDI_Constants.STRING_EMPTY:result.mimeType, GDI_Constants.STRING_EMPTY,description, GDI_Constants.STRING_EMPTY, GDI_Constants.STRING_EMPTY);
        
        return folderFileDetail;
    }
    
    public static String getMimeTypeForFile(String fileType, String fileExtension){ 
        String mimeType = GDI_Constants.STRING_EMPTY;
        if(null == mimeTypeMap && mimeTypeMap.isEmpty())     
            return mimeType;
        mimeType = mimeTypeMap.get(fileType);
        
        if(mimeType.equalsIgnoreCase('UNKNOWN'))
            mimeType = mimeTypeMap.get(fileExtension.toUpperCase());
        else if(String.isBlank(mimeType)){
            throw new MulesoftAPIException(GDI_Constants.EXTISSUE_UPLOAD);   
        }
        
        return mimeType;
    }
    
    public static List<GoogleDriveSubFolderFileDetail> getSearchResultListFromGoogleDrive(String searchKey, String googleDriveFolderRef, String fileType, String ModifiedDateFilterType, String StartDate, String EndDate){
        List<GoogleDriveSubFolderFileDetail> folderFileList = new List<GoogleDriveSubFolderFileDetail>();
        String Body = GDI_Constants.STRING_EMPTY;
        String mimeType = GDI_Constants.STRING_EMPTY;

        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        
        gen.writeStringField(GDI_Constants.CREATE_NAME, searchKey);
        gen.writeStringField(GDI_Constants.LISTFOLDER_ID, googleDriveFolderRef);

        if(fileType != GDI_Constants.STRING_ANYTYPE){
            mimeType = getSearchMimeTypeForFile(fileType , null);

            if(mimeType != GDI_Constants.STRING_EMPTY){
                gen.writeStringField(GDI_Constants.CREATE_MIMETYPE, mimeType);
            }
        }
        if(ModifiedDateFilterType != GDI_Constants.STRING_ANYTYPE){
            if(EndDate != null && StartDate != null){
                    gen.writeStringField(GDI_Constants.SEARCH_MODIFIEDFROM, StartDate);
                    gen.writeStringField(GDI_Constants.SEARCH_MODIFIEDTO, EndDate);
            }
        }
        //gen.writeStringField(GDI_Constants.CREATE_MODIFIEDBY, UserInfo.getName()+ GDI_Constants.STRING_SQUAREBRACKETSTART +UserInfo.getUserEmail() + GDI_Constants.STRING_SQUAREBRACKETEND);
        
        gen.writeEndObject();
        Body = gen.getAsString(); 
        System.debug('JSON \n '+body);
        
        HttpResponse res1;
        res1 = SearchAPI(Body);
        String str=res1.getbody();
        Integer Status = res1.getStatusCode();
        if(Status != 200 && Status != 201){
                 GoogleDriveIntegrationAPILogData logData = new GoogleDriveIntegrationAPILogData(GDI_Constants.APIERROR_SEARCH + GDI_Constants.STRING_SPACE + GDI_Constants.APIERROR_MESSAGE + Status,
                GDI_Constants.STRING_EMPTY, googleDriveFolderRef, Status, str, GDI_Constants.APILOGOPERATION_SEARCH, body);
            throw new MulesoftAPIException(JSON.serialize(logData)); 
        }
        
        GoogleDriveFolderFileListWrapper obj = GoogleDriveFolderFileListWrapper.parse(str);
        for(integer i=0; i<obj.Result.size(); i++)
            folderFileList.add(convertWrapperToRequiredFormat(obj.Result[i], GDI_Constants.STRING_EMPTY, GDI_Constants.STRING_EMPTY));
        
        return folderFileList;
    }
    
    @TestVisible
    private static HttpResponse SearchAPI(String Body) {
        if(String.isBlank(Body))
            throw new MulesoftAPIException(GDI_Constants.APIERROR_BODYISEMPTY); 
        
        Http http = new Http();
        HttpRequest req1 = new HttpRequest();
        
        req1.setEndpoint(GDI_Constants.ENDPOINTURL + GDI_Constants.API_SEARCH);
        req1.setmethod(GDI_Constants.HTTPREQMETHOD_POST);
        req1.setHeader('Content-Type', GDI_Constants.CONTENTTYPE_JSON); 
        if(null == googleDriveConfigDetails || String.isBlank(googleDriveConfigDetails.Access_token__c))
            throw new MulesoftAPIException(GDI_Constants.ERROR_ACCESSTOKEN_NOTFOUND); 
        req1.setHeader('x-authorization-token', googleDriveConfigDetails.Access_token__c);
        req1.setTimeout(120000);
        req1.setbody(Body);
        
        HttpResponse res1;
        res1 = http.send(req1);
        
        return res1;
    }
    
    public class GoogleDriveFolderInfoWrapper{
        public String total_files;
        public String total_File_Size;
        public GoogleDriveFolderInfoWrapper parse(String json) {
            return (GoogleDriveFolderInfoWrapper) System.JSON.deserialize(json, GoogleDriveFolderInfoWrapper.class);
        }
    }
    
    /*
    public static String downloadFolderFileInGoogleDrive(String rootId, String parentGoogleRef, String downloadFolderName,Map<String,List<String>> selectedFolderFiles, Boolean includeSubfolders, String recordId){
        String Body = GDI_Constants.STRING_EMPTY;
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField(GDI_Constants.LISTFOLDER_ROOTID, rootId);
        //gen.writeStringField(GDI_Constants.DOWNLOAD_JOBNAME, recordName);
        gen.writeStringField(GDI_Constants.DOWNLOAD_ZIPFOLDERNAME, downloadFolderName);
        gen.writeStringField(GDI_Constants.CREATE_PARENTID, parentGoogleRef);
        gen.writeStringField(GDI_Constants.DOWNLOAD_INCLUDESUBFOLDER, String.valueOf(includeSubfolders));
        
        gen.writeFieldName(GDI_Constants.DOWNLOAD_FILES);
        gen.writeStartArray();
        for(String fileGoogleRef : selectedFolderFiles.keySet()){
            gen.writeStartObject();
            gen.writeStringField(GDI_Constants.LISTFOLDER_ID, fileGoogleRef);
            gen.writeStringField(GDI_Constants.CREATE_NAME, selectedFolderFiles.get(fileGoogleRef).get(0));
            gen.writeStringField(GDI_Constants.CREATE_MIMETYPE, selectedFolderFiles.get(fileGoogleRef).get(1));
            gen.writeEndObject();    
        }
        gen.writeEndArray();
        gen.writeEndObject();
        
        Body = gen.getAsString();        
        HttpResponse res1;
        res1 = DownloadAPI(Body);
        String str=res1.getbody();
        Integer Status = res1.getStatusCode();
        if(Status != 200 && Status != 201){
             GoogleDriveIntegrationAPILogData logData = new GoogleDriveIntegrationAPILogData(GDI_Constants.APIERROR_DOWNLOAD + GDI_Constants.STRING_SPACE + GDI_Constants.APIERROR_MESSAGE + Status,
                recordId, parentGoogleRef, Status, str, GDI_Constants.APILOGOPERATION_DOWNLOAD, body);
            throw new MulesoftAPIException(JSON.serialize(logData));
        }
            
        String downloadLink = GDI_Constants.STRING_EMPTY;
        //Extract link from response
        Map<String,String> result = (Map<String,String>) System.JSON.deserialize(str, Map<String,String>.class);
        downloadLink = result.get((new List<String>(result.keySet()))[0]);
        
        return downloadLink;
    }
    
    private static HttpResponse DownloadAPI(String Body) {
        if(String.isBlank(Body))
            throw new MulesoftAPIException(GDI_Constants.APIERROR_BODYISEMPTY); 
        Http http = new Http();
        HttpRequest req1 = new HttpRequest();
        req1.setEndpoint(GDI_Constants.ENDPOINTURL + GDI_Constants.API_DOWNLOAD);
        req1.setmethod(GDI_Constants.HTTPREQMETHOD_POST);
        req1.setHeader('Content-Type', GDI_Constants.CONTENTTYPE_JSON); 
        if(null == googleDriveConfigDetails || String.isBlank(googleDriveConfigDetails.Access_token__c))
            throw new MulesoftAPIException(GDI_Constants.ERROR_ACCESSTOKEN_NOTFOUND); 
        req1.setHeader('x-authorization-token', googleDriveConfigDetails.Access_token__c);
        req1.setTimeout(60000);
        req1.setbody(Body);
        HttpResponse res1;
        res1 = http.send(req1);
        return res1;
    }


    public static List<String> getTotalSizeAndNoOfFiles(String parentGoogleRef,Map<String,List<String>> selectedFolderFiles, String recordId){
        System.debug('*******Inside getTotalSizeAndNoOfFiles()**********');
        String Body = GDI_Constants.STRING_EMPTY;
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartArray();
        for(String fileGoogleRef : selectedFolderFiles.keySet()){
            gen.writeStartObject();
            gen.writeStringField(GDI_Constants.LISTFOLDER_ID, fileGoogleRef);
            gen.writeEndObject();    
        }
        gen.writeEndArray();
        
        Body = gen.getAsString();        
        
        System.debug('*****************');
        System.debug(Body);
        
        HttpResponse res1;
        res1 = SizeAndNoOfFilesForDownloadAPI(Body);
        String str=res1.getbody();
        Integer Status = res1.getStatusCode();
        System.debug('*****************'+ str);
        if(Status != 200 && Status != 201){
            //GoogleDriveIntegrationAPILogHelper.addEntryToAPILog(recordId, parentGoogleRef, body, Status, str, GDI_Constants.APILOGOPERATION_CREATE);
            throw new MulesoftAPIException(GDI_Constants.APIERROR_DOWNLOAD + GDI_Constants.STRING_SPACE + GDI_Constants.APIERROR_MESSAGE + Status);
        }
        
        GoogleDriveFolderInfoWrapper wrapper = new GoogleDriveFolderInfoWrapper();
        wrapper = wrapper.parse(str);
        List<String> downloadDetails = new List<String>();
        downloadDetails.add(wrapper.total_files.toLowerCase());
        downloadDetails.add(wrapper.total_File_Size);
        System.debug('**********downloadDetails*******' + downloadDetails);
        return downloadDetails;
    }
    
    private static HttpResponse SizeAndNoOfFilesForDownloadAPI(String Body) {
        if(String.isBlank(Body))
            throw new MulesoftAPIException(GDI_Constants.APIERROR_BODYISEMPTY); 
        Http http = new Http();
        HttpRequest req1 = new HttpRequest();
        req1.setEndpoint(GDI_Constants.ENDPOINTURL + GDI_Constants.API_FOLDERINFO);
        req1.setmethod(GDI_Constants.HTTPREQMETHOD_POST);
        req1.setHeader('Content-Type', GDI_Constants.CONTENTTYPE_JSON); 
        req1.setTimeout(60000);
        req1.setbody(Body);
        HttpResponse res1;
        res1 = http.send(req1);
        System.debug('******* GetFolderInfo api response-' + res1);
        return res1;
    }*/
    
    /*
    @TestVisible 
    static Map<String,String> mimeTypeMap { 
        get {
            if ( mimeTypeMap == null ){
                mimeTypeMap = new Map<String,String>();
                
                mimeTypeMap.put('PDF','application/pdf');
                mimeTypeMap.put('WORD_X','application/vnd.openxmlformats-officedocument.wordprocessingml.document');
                mimeTypeMap.put('WORD','application/vnd.openxmlformats-officedocument.wordprocessingml.document');
                mimeTypeMap.put('EXCEL','application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
                mimeTypeMap.put('EXCEL_X','application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
                mimeTypeMap.put('POWER_POINT','application/vnd.openxmlformats-officedocument.presentationml.presentation');
                mimeTypeMap.put('POWER_POINT_X','application/vnd.openxmlformats-officedocument.presentationml.presentation');
                mimeTypeMap.put('JPG','image/jpeg');
                mimeTypeMap.put('TIF','image/tiff');
                mimeTypeMap.put('TIFF','image/tiff');
                mimeTypeMap.put('GIF','image/gif');
                mimeTypeMap.put('BMP','image/bmp');
                mimeTypeMap.put('PNG','image/png');
                mimeTypeMap.put('ICO','image/vnd.microsoft.icon');
                mimeTypeMap.put('CSV','text/csv');
                mimeTypeMap.put('CSS','text/css');
                mimeTypeMap.put('JSON','application/json');
                mimeTypeMap.put('TEXT','text/plain');
                mimeTypeMap.put('HTML','text/html');
                mimeTypeMap.put('HTM','text/html');
                mimeTypeMap.put('ZIP','application/zip');
                mimeTypeMap.put('GZ','application/gzip');
                mimeTypeMap.put('RTF','application/rtf');
                mimeTypeMap.put('SVG','image/svg+xml');
                mimeTypeMap.put('XML','application/xml');
                mimeTypeMap.put('JS','text/javascript');
                
                mimeTypeMap.put('ODP','application/vnd.oasis.opendocument.presentation');
                mimeTypeMap.put('ODS','application/vnd.oasis.opendocument.spreadsheet');
                mimeTypeMap.put('ODT','application/vnd.oasis.opendocument.text');
                
                mimeTypeMap.put('ARC','application/x-freearc');
                mimeTypeMap.put('ICS','text/calendar');
                mimeTypeMap.put('JAR','application/java-archive');
                
                mimeTypeMap.put('MP3','audio/mpeg');
                mimeTypeMap.put('MP2','audio/mpeg');
                mimeTypeMap.put('AU','audio/basic');
                mimeTypeMap.put('SND','audio/basic');
                mimeTypeMap.put('MID','audio/mid');
                mimeTypeMap.put('MIDI','audio/midi');
                mimeTypeMap.put('RMI','audio/mid');
                mimeTypeMap.put('AIF','audio/x-aiff');
                mimeTypeMap.put('AIFC','audio/x-aiff');
                mimeTypeMap.put('AIFF','audio/x-aiff');
                mimeTypeMap.put('M3U','audio/x-mpegurl');
                mimeTypeMap.put('AAC','audio/aac');
                mimeTypeMap.put('WAV','audio/wav');
                
                mimeTypeMap.put('OGG','audio/ogg');
                mimeTypeMap.put('OGA','audio/ogg');
                mimeTypeMap.put('SPX','audio/ogg');
                mimeTypeMap.put('OGV','video/ogg');
                mimeTypeMap.put('OGX','application/ogg');
                
                mimeTypeMap.put('MP4','video/mp4');
                mimeTypeMap.put('MPEG','video/mpeg');
                mimeTypeMap.put('FLV','video/x-flv');
                mimeTypeMap.put('M3U8','application/x-mpegURL');
                mimeTypeMap.put('TS','video/MP2T');
                mimeTypeMap.put('3GP','video/3gpp');
                mimeTypeMap.put('MOV','video/quicktime');
                mimeTypeMap.put('AVI','video/x-msvideo');
                mimeTypeMap.put('WMV','video/x-ms-wmv');
                
                mimeTypeMap.put('TAR','application/tar');
                mimeTypeMap.put('ARJ','application/arj');
                mimeTypeMap.put('CAB','application/cab');
                mimeTypeMap.put('SWF','application/application/x-shockwave-flash');
                mimeTypeMap.put('TMPL','text/plain');
                
                mimeTypeMap.put('UNKNOWN','unknown');//EPUG(application/epub+zip)
                mimeTypeMap.put('Folders',GDI_Constants.MIMETYPE_FOLDER);
                
                mimeTypeMap.put('Files','AllFiles');//To search any files in GDrive
            }
            return mimeTypeMap;
        } set; 
    }*/
   /* 
    @TestVisible 
    static Map<String,String> SearchmimeTypeMap { 
        get {
            if ( SearchmimeTypeMap == null ){
                SearchmimeTypeMap = new Map<String,String>();
                SearchmimeTypeMap.put('Folders',GDI_Constants.MIMETYPE_FOLDER);
                SearchmimeTypeMap.put('Files','AllFiles');//To search any files in GDrive
                SearchmimeTypeMap.put('PDF','application/pdf');
                SearchmimeTypeMap.put('AllDocuments','application/vnd.google-apps.document, application/vnd.openxmlformats-officedocument.wordprocessingml.document, application/vnd.oasis.opendocument.text');
                SearchmimeTypeMap.put('AllSpreadsheets','application/vnd.google-apps.spreadsheet, text/csv, application/vnd.openxmlformats-officedocument.spreadsheetml.sheet, application/vnd.oasis.opendocument.spreadsheet');
                SearchmimeTypeMap.put('AllPresentations','application/vnd.google-apps.presentation, application/vnd.openxmlformats-officedocument.presentationml.presentation, application/vnd.oasis.opendocument.presentation');
                SearchmimeTypeMap.put('AllImages','images');
                SearchmimeTypeMap.put('Allvideosaudios','videos&audios');
                SearchmimeTypeMap.put('Others','Others, images, videos&audios, application/pdf, application/vnd.openxmlformats-officedocument.wordprocessingml.document, application/vnd.oasis.opendocument.text, text/csv, application/vnd.openxmlformats-officedocument.spreadsheetml.sheet, application/vnd.oasis.opendocument.spreadsheet, application/vnd.openxmlformats-officedocument.presentationml.presentation, application/vnd.oasis.opendocument.presentation');
            }
            return SearchmimeTypeMap;
        } set; 
    }*/
    
}