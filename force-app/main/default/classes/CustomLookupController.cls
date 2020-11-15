/*******************************************************************************************
* @author           Suman
* @version          1.0 
* @date             20-OCT-2020
* @Status           In-Progress
* @Class Name       CustomLookupController
* @description      This is the controller for LWC - sharinPixSourceJobLookupComp.	
*********************************************************************************************
Version     Date      Team          Comments
*********************************************************************************************
* 1      	Oct 2020    Suman        Initial Creation(JIRA AR-694)
*********************************************************************************************/
public class CustomLookupController {
    @AuraEnabled(cacheable=true)
    public static List<sObject> search(String searchTerm, String objToBeSearched) {
        System.debug('****** objToBeSearched-' + objToBeSearched);
        System.debug('****** searchTerm-' + searchTerm);
        List<sObject> lookUpList = new List<sObject>();
        
        if(String.isBlank(objToBeSearched))
            return lookUpList;
        
        String queryString = null;
        if(String.isBlank(searchTerm))
            queryString = 'Select Id, Name from '+objToBeSearched+' Where LastViewedDate != NULL ORDER BY LastViewedDate DESC LIMIT  10';
        else if(objToBeSearched.equalsIgnoreCase(SharinPix_Constants.OBJ_USER))
            queryString = 'Select Id, Name from '+objToBeSearched+' Where Name Like  \'%' + searchTerm + '%\' OR' + ' Email Like  \'%' + searchTerm + '%\''+' LIMIT  50';
        else if(objToBeSearched.equalsIgnoreCase(SharinPix_Constants.OBJ_JOB))
            queryString = 'Select Id, Name from '+objToBeSearched+' Where Job_Name__c Like  \'%' + searchTerm + '%\' OR' + ' Job_Number__c Like  \'%' + searchTerm + '%\''+' LIMIT  50';
        else
            queryString = 'Select Id, Name from '+objToBeSearched+' Where Name Like  \'%' + searchTerm + '%\'' +' LIMIT  50';
        
        System.debug('****** queryString-' + queryString);
        lookUpList = database.query(queryString);
        System.debug('***** lookUpList size-' + lookUpList.size());
        return lookUpList;
    }
}