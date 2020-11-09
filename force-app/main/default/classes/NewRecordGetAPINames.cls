public with sharing class NewRecordGetAPINames 
{
    @AuraEnabled(cacheable=true)
    public static List<APIFields__mdt> getAPINames(string objectName) 
    {
        return [SELECT API_Names__c FROM APIFields__mdt WHERE Object_Name__c =: objectName];
    }
}