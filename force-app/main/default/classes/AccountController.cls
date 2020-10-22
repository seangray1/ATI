public with sharing class AccountController {
    @AuraEnabled(cacheable=true)
    public static List<APIFields__mdt> getAPINamesFromMetadata() {
        system.debug('api names ' );
        system.debug([SELECT API_Names__c FROM APIFields__mdt]);
        return [SELECT API_Names__c FROM APIFields__mdt];
       
    }
}