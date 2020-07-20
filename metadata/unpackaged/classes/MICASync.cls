/**
 * @File Name          : SyncMICA.cls
 * @Description        : 
 * @Author             : sean.gray@atirestoration.com
 * @Group              : 
 * @Last Modified By   : sean.gray@atirestoration.com
 * @Last Modified On   : 12/19/2019, 8:54:50 AM
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    7/23/2019, 9:21:21 AM   sean.gray@atirestoration.com     Initial Version
**/
public class MICASync {
    
    @AuraEnabled
    public static string UpdateJob(string recordId)
    {
        ATI_Job__c job = new ATI_Job__c(Id = recordId);
        job.mica_Integration__c = true;
        job.mica_last_successful_sync__c = system.now();
        // if(ESJobType == 'Smoke Cleaning')
        // {
        //     job.Es_Job_Type__c = ESJobType;
        // }
        update job;
        return 'success';
        
    }
//     public static String executeJobWithoutWater(String recordId, String classNum, String category, String ESJobType){
        
        
//        // Attachment a = [Select Id, createdDate FROM Attachment where parentId =: recordId ORDER BY createdDate DESC Limit 1];
//        // system.debug('The attachment that got returned was ' + a);
//         ATI_Job__c job = [select Id, Division__c, job_number_No_Dashes__c, Es_job_type__c from ATI_Job__c where Id =: recordId];
//         if(ESJobType == null)
//         {
//             ESJobType = job.ES_Job_Type__c;
//         }
//         if(job.division__c == 'Construction' || (job.division__c == 'Emergency Svces' && ESJobType != 'Smoke Cleaning') && !Test.isRunningTest()){
//            return MICA_Integration_Callout.invokeIntegration(recordId, classNum, category, ESJobType);
//         }else{
//            Integer countOfEstimates;
//         List<estimate__c> estimateLookup = [Select Id, Name, job__c, creation_date__c FROM Estimate__c Where job__c =: job.id ORDER BY Creation_Date__c DESC];
//         //List<estimate__c> estimateLookupSupplement = [Select Id, Name, job__c, creation_date__c FROM Estimate__c where Estimate_Type__c = 'Supplement' AND job__c =: job.id ORDER BY Creation_Date__c DESC];
//         //List<estimate__c> estimateLookupChangeOrder = [Select Id, Name, job__c, creation_date__c FROM Estimate__c where Estimate_Type__c = 'Change Order' AND job__c =: job.id ORDER BY Creation_Date__c DESC];
//         Estimate__c estimate = new Estimate__c(Name = 'Main', Estimate_type__c = 'Main', job__c = job.id, creation_date__c = system.now());
//         // if(EstimateTypeMethod == 'Main'){
//             countOfEstimates = estimateLookup.size();
//             countOfEstimates += 1;
//             estimate.name = 'EST-' + job.job_number_No_Dashes__c + '-'+ '0'+ countOfEstimates;
//             insert estimate;
//         List<contentdocumentlink> a = [Select Id,contentdocumentId FROM contentdocumentlink where LinkedEntityId =: job.id Order By SystemModStamp DESC Limit 1];
//         system.debug('Content documetn Link' + a[0]);
//         List<contentversion> ctv = [Select Id, Checksum, ContentDocumentId, ContentLocation, ContentModifiedById, 
//         ContentModifiedDate, ContentSize,  FileExtension, FileType, FirstPublishLocationId, 
//         IsAssetEnabled, IsLatest, IsMajorVersion, NegativeRatingCount, Origin, OwnerId, 
//         PathOnClient, PositiveRatingCount, PublishStatus, RatingCount, ReasonForChange, 
//         SharingOption, Title, VersionData, VersionNumber FROM ContentVersion Where contentdocumentId =: a[0].contentdocumentId];
        


//         ContentVersion conVer = new ContentVersion();
//         conVer.PathOnClient = '/' + ctv[0].PathOnClient; 
//         conVer.Title = ctv[0].title; 
//         conVer.VersionData = ctv[0].versionData; 
//         insert conVer;
//         ContentDocumentLink cDe = new ContentDocumentLink();
//         ContentVersion cdId = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :conVer.Id];
//         cDe.ContentDocumentId = cdId.contentdocumentId;
//         cDe.LinkedEntityId = estimate.id; // you can use objectId,GroupId etc
//         cDe.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details
//         cDe.Visibility = 'AllUsers';
//         insert cDe; 
//         if(ESJobType == 'Smoke Cleaning')
//         {
//             job.Es_Job_Type__c = ESJobType;
//         }
//         update job;
//         return 'true';
//         }
          
//     }
//     @AuraEnabled
//     public static String executeUploadEstimate(String recordId, String EstimateType, String classNum, String category, String ESJobType){
//          ATI_Job__c job = [select Id, Division__c, job_number_No_Dashes__c, mica_Integration__c, Mica_last_successful_sync__c, Class__c, Category__c, ES_job_Type__c from ATI_Job__c where Id =: recordId];
//          if(ESJobType == null)
//         {
//             ESJobType = job.ES_Job_Type__c;
//         }
//         if(job.division__c == 'Construction' || (job.division__c == 'Emergency Svces' && ESJobType != 'Smoke Cleaning') && !Test.isRunningTest()){
//            string method = 'UploadEstimate';
//             return MICA_Integration_Callout.invokeUploadEstimate(recordId, EstimateType, method, classNum, category, ESJobType);
//         }else{
//             Integer countOfEstimates;
//         List<estimate__c> estimateLookup = [Select Id, Name, job__c, creation_date__c FROM Estimate__c Where job__c =: job.id ORDER BY Creation_Date__c DESC];
       
//         Estimate__c estimate = new Estimate__c(Name = EstimateType, Estimate_type__c = EstimateType, job__c = job.id, creation_date__c = system.now());
       
//             countOfEstimates = estimateLookup.size();
//             countOfEstimates += 1;
//             estimate.name = 'EST-' + job.job_number_No_Dashes__c + '-'+ '0'+ countOfEstimates;
//             insert estimate;
//         List<contentdocumentlink> a = [Select Id,contentdocumentId FROM contentdocumentlink where LinkedEntityId =: job.id Order By SystemModStamp DESC Limit 1];
//         system.debug('Content documetn Link' + a[0]);
//         List<contentversion> ctv = [Select Id, Checksum, ContentDocumentId, ContentLocation, ContentModifiedById, 
//         ContentModifiedDate, ContentSize,  FileExtension, FileType, FirstPublishLocationId, 
//         IsAssetEnabled, IsLatest, IsMajorVersion, NegativeRatingCount, Origin, OwnerId, 
//         PathOnClient, PositiveRatingCount, PublishStatus, RatingCount, ReasonForChange, 
//         SharingOption, Title, VersionData, VersionNumber FROM ContentVersion Where contentdocumentId =: a[0].contentdocumentId];
        


//         ContentVersion conVer = new ContentVersion();
//         conVer.PathOnClient = '/' + ctv[0].PathOnClient; 
//         conVer.Title = ctv[0].title; 
//         conVer.VersionData = ctv[0].versionData; 
//         insert conVer;
//         ContentDocumentLink cDe = new ContentDocumentLink();
//         ContentVersion cdId = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :conVer.Id];
//         cDe.ContentDocumentId = cdId.contentdocumentId;
//         cDe.LinkedEntityId = estimate.id; // you can use objectId,GroupId etc
//         cDe.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details
//         cDe.Visibility = 'AllUsers';
//         insert cDe; 
//         job.mica_Integration__c = true;
//         job.mica_last_successful_sync__c = system.now();
//         if(ESJobType == 'Smoke Cleaning')
//         {
//             job.Es_Job_Type__c = ESJobType;
//         }
//         update job;
//         return 'true';
//         }
         
          
//     }
//      @AuraEnabled
//     public static string queryRecordType(String recordId){
//         ATI_Job__c job = [select Id, RecordTypeId from ATI_Job__c where Id =: recordId];
//         system.debug(job);
//         String RecordTypeId = job.RecordTypeId;  
//             return RecordTypeId;
//     }
//     @AuraEnabled(cacheable=true)
//     public static ATI_Job__c getClassCategory(String recordId){
//         ATI_Job__c job = [select Id, class__c, category__c from ATI_Job__c where Id =: recordId];
//         system.debug(job);
//         //String ClassCategory = '{"class":"'+ job.class__c +'", "category":"'+job.category__c+'"}';  
//             //return ClassCategory;
//             return job;
//     }
//     @AuraEnabled
//     public static String StartWithMain(String recordId){
//         ATI_Job__c job = [select Id, division__c, Mica_integration__c, ProjectGuid__c from ATI_Job__c where Id =: recordId];
//         system.debug(job);
//         String EmergencySvs;  
//         if (String.isEmpty(job.ProjectGuid__c) && job.division__c == 'Emergency Svces') {
//             EmergencySvs = '1';
//         }
//         if (!String.isEmpty(job.ProjectGuid__c)) {
//             EmergencySvs = '3';
            
//         } 
//         if (String.isEmpty(job.ProjectGuid__c) && job.division__c != 'Emergency Svces') {
//             EmergencySvs = '2';
//         }
        
//     return EmergencySvs;
// }

    
//      @AuraEnabled
//     public static String queryDivision(String recordId){
//         ATI_Job__c job = [select Id, division__c, Mica_integration__c,  ProjectGuid__c from ATI_Job__c where Id =: recordId];
//         system.debug(job);
//         String EmergencySvs;  
//         if (job.division__c != null && job.division__c == 'Emergency Svces'&& String.isEmpty(job.ProjectGuid__c)) {
//             EmergencySvs = '1';
//         }
//         if (job.division__c != null && job.division__c != 'Emergency Svces' && String.isEmpty(job.ProjectGuid__c)) {
//             EmergencySvs = '2';
            
//         }  
//         if (!String.isEmpty(job.ProjectGuid__c)) {
//             EmergencySvs = '3';

//             system.debug('Emergency Services is ' + EmergencySvs);
        
            
//     }
//     if (job.division__c != 'Emergency Svces' && !String.isEmpty(job.ProjectGuid__c)){
//             EmergencySvs = '4';
//         }
//     return EmergencySvs;
// }
}