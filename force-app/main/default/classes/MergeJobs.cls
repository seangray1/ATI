public with sharing class MergeJobs {
    public MergeJobs() {

    }
    @AuraEnabled
    public static List<ATI_Job__c> searchJobs(String searchKey){
        try {
            String searchLikeKey1 =  '%' + searchKey + '%';
            String searchLikeKey = searchLikeKey1.normalizeSpace();
            List<ATI_Job__c> jobs = 
            [SELECT Id, Name, Date_of_Loss__c, Claim__c, Project_Site_Address__c, Project_Site_City__c, 
            Project_Site_State__c, Project_Site_Zipcode__c, XASP_Transaction_ID__c
            FROM ATI_Job__c
            WHERE Name Like : searchLikeKey 
            ORDER BY CreatedDate DESC LIMIT 5];
            
            return jobs;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}