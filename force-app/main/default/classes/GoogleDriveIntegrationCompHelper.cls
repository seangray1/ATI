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
* 1      	Aug 2020    Suman        Initial Creation(JIRA AR-653)
*********************************************************************************************/
public with sharing class GoogleDriveIntegrationCompHelper {
    public class MulesoftAPIException extends Exception {} 
    
    public String parentRecGDId = GDI_Constants.STRING_EMPTY;
    public String parentRecGDLink = GDI_Constants.STRING_EMPTY;
    
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
                        //Added by Suman as part of Code Scan suggestion
                        if(String.isBlank(mimeTypeConfigList[i].Group__c) || String.isBlank(mimeTypeConfigList[i].MIME_Type__c))
                            continue;
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
        gen.writeStringField(GDI_Constants.LISTFOLDER_DRIVE, folderPath); 
        gen.writeStringField(GDI_Constants.LISTFOLDER_ROOTPATH, '/' + folderName);
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
        if(!String.isEmpty(googleDriveFolderLink))
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
        if(ModifiedDateFilterType != GDI_Constants.STRING_ANYTYPE && (EndDate != null && StartDate != null)){
            gen.writeStringField(GDI_Constants.SEARCH_MODIFIEDFROM, StartDate);
            gen.writeStringField(GDI_Constants.SEARCH_MODIFIEDTO, EndDate);
        }        
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
}