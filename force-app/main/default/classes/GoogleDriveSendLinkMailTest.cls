/*******************************************************************************************
* @author           Suman
* @version          1.0 
* @date             19-Oct-2020
* @Status           In-Progress
* @Trigger Name     UploadFilesToGoogleDriveCDLTriggerTest
* @description      Test class for trigger class -GoogleDriveSendLinkMail.
*********************************************************************************************
Version     Date      Team          Comments
*********************************************************************************************
* 1         Oct 2020    Suman        Initial Creation(JIRA AR-653)
*********************************************************************************************/
@isTest
public class GoogleDriveSendLinkMailTest {
    
    @isTest
    static void testTrigger(){
        String toAddresses = 'sfadmin@demandblue.com';
        String Subject = 'Test Email';
        String htmlBody = 'Test';
        GoogleDriveSendLinkMail.sendEmail(toAddresses,Subject, htmlBody);
    }

}