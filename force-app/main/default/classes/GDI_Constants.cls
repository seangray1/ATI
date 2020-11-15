/*******************************************************************************************
* @author           Suman
* @version          1.0 
* @date             24-AUG-2020
* @Status           In-Progress
* @Class Name       GDI_Constants
* @description      This apex class will contain all constants for Google drive integration project.	
*********************************************************************************************
Version     Date      Team          Comments
*********************************************************************************************
* 1      	Aug 2020    Suman        Initial Creation(JIRA AR-653)
*********************************************************************************************/
public class GDI_Constants {
    
    public static final String ENDPOINTURL = 'callout:MulesoftGDriveIntegration/';
    public static final String API_LISTFOLDER = 'ListFolder';
    public static final String API_CREATE = 'Create';
    public static final String API_DELETE = 'Delete';
    public static final String API_DOWNLOAD = 'Download';
    public static final String API_SEARCH = 'Search';
     public static final String API_FOLDERINFO = 'GetFolderInfo';
    
    public static final String STRING_EMPTY = '';
    public static final String STRING_HYPHEN = '-';
    public static final String STRING_SPACE = ' ';
    public static final String STRING_SEMICOLON = ';';
    public static final String STRING_SQUAREBRACKETSTART = '(';
    public static final String STRING_SQUAREBRACKETEND = ')';
    public static final String STRING_FOLDER = 'folder';
    public static final String API_NAMETOBESHOWN = 'Mulesoft API';
    
    public static final String OBJ_JOB = 'ATI_Job__c';
    public static final String OBJ_ACCOUNT = 'Account';
    public static final String OBJ_OPP = 'Opportunity';
    
    //Search Strings
    public static final String STRING_ANYTYPE = 'ANY';
    public static final String STRING_CUSTOM = 'Custom';    
    public static final String STRING_24HOURS = 'Last 24 hours';
    public static final String STRING_WEEK = 'Last week';
    public static final String STRING_MONTH = 'Last month';
    public static final String STRING_3MONTHS = 'Last 3 months';
    public static final String STRING_6MONTHS = 'Last 6 months';
    public static final String STRING_12MONTHS = 'Last 12 months';
    
    public static final String FILETYPE_GDOC = 'googleDoc';
    public static final String FILETYPE_GSHEET = 'googleSheet';
    public static final String FILETYPE_GSLIDE = 'googleSlide';
    public static final String FILETYPE_MSDOC = 'msDoc';
    public static final String FILETYPE_MSEXCEL = 'msExcel';
    public static final String FILETYPE_MSPPT = 'msPowerpoint';
    
    public static final String MIMETYPE_FOLDER = 'application/vnd.google-apps.folder';
    public static final String MIMETYPE_GDOC = 'application/vnd.google-apps.document';
    public static final String MIMETYPE_GSHEET = 'application/vnd.google-apps.spreadsheet';
    public static final String MIMETYPE_GSLIDE = 'application/vnd.google-apps.presentation';
    public static final String MIMETYPE_MSDOC = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
    public static final String MIMETYPE_MSEXCEL = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
    public static final String MIMETYPE_MSPPT = 'application/vnd.openxmlformats-officedocument.presentationml.presentation';
    
    public static final String DEFAULTNAME_GDOC = 'Untitled document';
    public static final String DEFAULTNAME_GSHEET = 'Untitled spreadsheet';
    public static final String DEFAULTNAME_GSLIDE = 'Untitled presentation';
    
    //API call parameters
    public static final String HTTPREQMETHOD_GET = 'GET';
    public static final String HTTPREQMETHOD_POST = 'POST';
    public static final String HTTPREQMETHOD_DELETE = 'DELETE';
    public static final String CONTENTTYPE_JSON = 'application/json';
    public static final String CONTENTTYPE_MULTIPARTFORMDATA = 'multipart/form-data';
    
    public static final String LISTFOLDER_ID = 'id';
    public static final String LISTFOLDER_ROOTID = 'rootId';
    public static final String LISTFOLDER_DRIVE = 'drive';
    public static final String LISTFOLDER_ROOTPATH = 'rootPath';
    public static final String CREATE_NAME = 'name';
    public static final String CREATE_MIMETYPE = 'mimeType';
    public static final String CREATE_PARENTID = 'parentId';
    public static final String CREATE_MODIFIEDBY = 'modifiedBy';
    public static final String UPLOAD_SEPARATIONSTRING = 'WebKitFormBoundary7MA4YWxkTrZu0gW';
    public static final String UPLOAD_PARENTS = 'parents';
    public static final String UPLOAD_REQUESTJSON = 'request.json';
    public static final String SEARCH_MODIFIEDFROM = 'modifiedFrom';
    public static final String SEARCH_MODIFIEDTO = 'modifiedTo';
    public static final String SEARCH_CONTENT = 'content';
    public static final String DOWNLOAD_JOBNAME = 'jobName';
    public static final String DOWNLOAD_ZIPFOLDERNAME = 'folderName';
    public static final String DOWNLOAD_INCLUDESUBFOLDER = 'includeSubfolder';
    public static final String DOWNLOAD_FILES = 'files';
    
    public static final String APIERROR_CREATE = 'Folder/File could not be created in Google Drive.';
    public static final String APIERROR_MESSAGE = 'Mulesoft response code - ';
    public static final String APIERROR_LISTFOLDER = 'Folder contents could not be retrieved from Google Drive.';
    public static final String APIERROR_BODYISEMPTY = 'Body is empty in the request.';
    
    public static final String ERROR_DRIVELINK_NOTFOUND = 'Google Drive link is empty for the record.';
    public static final String ERROR_ACCESSTOKEN_NOTFOUND = 'Access token to connect to Mulesoft not found';
    public static final String ERROR_LISTFOLDER_NOFOLDERFOUND = 'Folder not available in Google Drive for this record.';
    public static final String ERROR_LISTFOLDER_NOCONFIGFOUND = 'This object is not part of Google Drive Sync Configurations.';
    public static final String ERROR_LISTFOLDER_NOFOLDERPATH = '\'Google Drive Folder Path\' and \'Google Drive Folder Ref\' both are not available and hence subfolders/files could not be listed for this record.';
    public static final String APIERROR_UPLOAD = 'Files could not be uploaded to Google Drive.';
    public static final String EXTISSUE_UPLOAD = 'File extension not recognized. Hence file(s) could not be uploaded.';
    public static final String APIERROR_DELETE = 'Folder(s)/File(s) could not be deleted from Google Drive.';
    public static final String APIERROR_DOWNLOAD = 'Folder(s)/File(s) could not be downloaded from Google Drive.';
    public static final String APIERROR_SEARCH = 'Folder/File could not be retrieved from Google Drive';
    
    
    
    public static final String APILOGOPERATION_LISTFOLDER = 'ListFolder API';
    public static final String APILOGOPERATION_LISTFOLDEREXISTINGRECS = 'ListFolder API(Existing records)';
    public static final String APILOGOPERATION_CREATE = 'Create API';
    public static final String APILOGOPERATION_DELETE = 'Delete API';
    public static final String APILOGOPERATION_DOWNLOAD = 'Download API';
    public static final String APILOGOPERATION_SEARCH = 'Search API';
    
    //Dummy GD Id
    public static final String TEST_GDID = '188Hde_c_ZQiFQeSZX7IxCJGSWySWFOHn';
}