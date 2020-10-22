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
    
    public static String ENDPOINTURL = 'callout:MulesoftGDriveIntegration/';
    public static String API_LISTFOLDER = 'ListFolder';
    public static String API_CREATE = 'Create';
    public static String API_DELETE = 'Delete';
    public static String API_DOWNLOAD = 'Download';
    public static String API_SEARCH = 'Search';
     public static String API_FOLDERINFO = 'GetFolderInfo';
    
    public static String STRING_EMPTY = '';
    public static String STRING_HYPHEN = '-';
    public static String STRING_SPACE = ' ';
    public static String STRING_SEMICOLON = ';';
    public static String STRING_SQUAREBRACKETSTART = '(';
    public static String STRING_SQUAREBRACKETEND = ')';
    public static String STRING_FOLDER = 'folder';
    public static String API_NAMETOBESHOWN = 'Mulesoft API';
    
    public static String OBJ_JOB = 'ATI_Job__c';
    public static String OBJ_ACCOUNT = 'Account';
    public static String OBJ_OPP = 'Opportunity';
    
    //Search Strings
    public static String STRING_ANYTYPE = 'ANY';
    public static String STRING_CUSTOM = 'Custom';    
    public static String STRING_24HOURS = 'Last 24 hours';
    public static String STRING_WEEK = 'Last week';
    public static String STRING_MONTH = 'Last month';
    public static String STRING_3MONTHS = 'Last 3 months';
    public static String STRING_6MONTHS = 'Last 6 months';
    public static String STRING_12MONTHS = 'Last 12 months';
    
    public static String FILETYPE_GDOC = 'googleDoc';
    public static String FILETYPE_GSHEET = 'googleSheet';
    public static String FILETYPE_GSLIDE = 'googleSlide';
    public static String FILETYPE_MSDOC = 'msDoc';
    public static String FILETYPE_MSEXCEL = 'msExcel';
    public static String FILETYPE_MSPPT = 'msPowerpoint';
    
    public static String MIMETYPE_FOLDER = 'application/vnd.google-apps.folder';
    public static String MIMETYPE_GDOC = 'application/vnd.google-apps.document';
    public static String MIMETYPE_GSHEET = 'application/vnd.google-apps.spreadsheet';
    public static String MIMETYPE_GSLIDE = 'application/vnd.google-apps.presentation';
    public static String MIMETYPE_MSDOC = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
    public static String MIMETYPE_MSEXCEL = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
    public static String MIMETYPE_MSPPT = 'application/vnd.openxmlformats-officedocument.presentationml.presentation';
    
    public static String DEFAULTNAME_GDOC = 'Untitled document';
    public static String DEFAULTNAME_GSHEET = 'Untitled spreadsheet';
    public static String DEFAULTNAME_GSLIDE = 'Untitled presentation';
    
    //API call parameters
    public static String HTTPREQMETHOD_GET = 'GET';
    public static String HTTPREQMETHOD_POST = 'POST';
    public static String HTTPREQMETHOD_DELETE = 'DELETE';
    public static String CONTENTTYPE_JSON = 'application/json';
    public static String CONTENTTYPE_MULTIPARTFORMDATA = 'multipart/form-data';
    
    public static String LISTFOLDER_ID = 'id';
    public static String LISTFOLDER_ROOTID = 'rootId';
    public static String LISTFOLDER_ROOTPATH = 'rootPath';
    public static String CREATE_NAME = 'name';
    public static String CREATE_MIMETYPE = 'mimeType';
    public static String CREATE_PARENTID = 'parentId';
    public static String CREATE_MODIFIEDBY = 'modifiedBy';
    public static String UPLOAD_SEPARATIONSTRING = 'WebKitFormBoundary7MA4YWxkTrZu0gW';
    public static String UPLOAD_PARENTS = 'parents';
    public static String UPLOAD_REQUESTJSON = 'request.json';
    public static String SEARCH_MODIFIEDFROM = 'modifiedFrom';
    public static String SEARCH_MODIFIEDTO = 'modifiedTo';
    public static String SEARCH_CONTENT = 'content';
    public static String DOWNLOAD_JOBNAME = 'jobName';
    public static String DOWNLOAD_ZIPFOLDERNAME = 'folderName';
    public static String DOWNLOAD_INCLUDESUBFOLDER = 'includeSubfolder';
    public static String DOWNLOAD_FILES = 'files';
    
    public static String APIERROR_CREATE = 'Folder/File could not be created in Google Drive.';
    public static String APIERROR_MESSAGE = 'Mulesoft response code - ';
    public static String APIERROR_LISTFOLDER = 'Folder contents could not be retrieved from Google Drive.';
    public static String APIERROR_BODYISEMPTY = 'Body is empty in the request.';
    
    public static String ERROR_LISTFOLDER_NOFOLDERFOUND = 'Folder not available in Google Drive for this record.';
    public static String ERROR_LISTFOLDER_NOCONFIGFOUND = 'This object is not part of Google Drive Sync Configurations.';
    public static String ERROR_LISTFOLDER_NOFOLDERPATH = '\'Google Drive Folder Path\' and \'Google Drive Folder Ref\' both are not available and hence subfolders/files could not be listed for this record.';
    public static String APIERROR_UPLOAD = 'Files could not be uploaded to Google Drive.';
    public static String EXTISSUE_UPLOAD = 'File extension not recognized. Hence file(s) could not be uploaded.';
    public static String APIERROR_DELETE = 'Folder(s)/File(s) could not be deleted from Google Drive.';
    public static String APIERROR_DOWNLOAD = 'Folder(s)/File(s) could not be downloaded from Google Drive.';
    public static String APIERROR_SEARCH = 'Folder/File could not be retrieved from Google Drive';
    
    public static String APILOGOPERATION_LISTFOLDER = 'ListFolder API';
    public static String APILOGOPERATION_LISTFOLDEREXISTINGRECS = 'ListFolder API(Existing records)';
    public static String APILOGOPERATION_CREATE = 'Create API';
    public static String APILOGOPERATION_DELETE = 'Delete API';
    public static String APILOGOPERATION_DOWNLOAD = 'Download API';
    
    //Dummy GD Id
    public static String TEST_GDID = '188Hde_c_ZQiFQeSZX7IxCJGSWySWFOHn';
}