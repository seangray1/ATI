/*******************************************************************************************
* @author           Suman
* @version          1.0 
* @date             02-Nov-2020
* @Status           In-Progress
* @Class Name       SharinPix_Constants
* @description      This apex class will contain all constants for SharinPix project.	
*********************************************************************************************
Version     Date      Team          Comments
*********************************************************************************************
* 1      	Aug 2020    Suman        Initial Creation(JIRA AR-653)
*******************************************************************************************/
public class SharinPix_Constants {

    public static String STRING_EMPTY = '';
    
    public static String OBJ_USER = 'User';
    public static String OBJ_JOB = 'ATI_Job__c';
    
    public static final String ENDPOINTURL = 'callout:MulesoftSharinPix/';
    public static final String API_RESYNC = 'resync';
    //public static final String STRING_EMPTY = '';
    public static final String HTTPREQMETHOD_POST = 'POST';
    public static final String CONTENTTYPE_JSON = 'application/json';
    public static final String APIERROR_BODYISEMPTY = 'Body is empty in the request.';
}