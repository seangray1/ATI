/*******************************************************************************************
    * @author           Vignesh & SUman
    * @version          1.0 
    * @date             02-NOV-2020
    * @Status           In-Progress
    * @Class Name       CustomLookupControllerTest
    * @description      This is the test class for  - CustomLookupController.	
    *********************************************************************************************
    Version     Date      Team          Comments
    *********************************************************************************************
    * 1      	Oct 2020    Suman        Initial Creation(JIRA AR-694)
    *********************************************************************************************/
    @isTest
    public class CustomLookupControllerTest {
       @isTest
        static void testSearch(){
            User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
            System.runAs (thisUser){
                //Create a user
                Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
                User u = new User(Alias = 'moveTest', Email='moveUserTestDB@testorg.com', 
                                  EmailEncodingKey='UTF-8', LastName='TestDB', FirstName='Move User', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p.Id, 
                                  TimeZoneSidKey='America/Los_Angeles', UserName='moveUserTestDB@testorg.com');
                insert u;
            }
           
            String searchTerm = 'Move User';
            String searchTermJob = '%DB Test%';
            String searchTermEmpty = '';
            String jobObj = SharinPix_Constants.OBJ_JOB;
            String userObj = SharinPix_Constants.OBJ_USER;
            String objEmpty = '';
            
            List<sObject> userLookUpList = CustomLookupController.search(searchTerm,userObj);
            System.assertEquals(1, userLookUpList.size()); 
            
            List<ATI_Job__c> jobList = [Select Id, Name from ATI_Job__c Where Job_Name__c Like : searchTermJob OR Job_Number__c Like : searchTermJob];
            List<sObject> jobLookUpList = CustomLookupController.search(searchTermJob,jobObj);
            System.assertEquals(jobList.size() ,jobLookUpList.size()); 
            
            List<sObject> jobLookUpList1 = CustomLookupController.search(searchTermEmpty,jobObj);
            System.assertEquals(0, jobLookUpList1.size()); 
            
            List<sObject> lookupList = CustomLookupController.search(searchTermEmpty,objEmpty);
            System.assert(lookupList.size() == 0); 
            
            List<sObject> accLookupList = CustomLookupController.search(searchTerm,'Account');
        }
    }