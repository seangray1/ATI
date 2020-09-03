/**
 * @File Name          : ATIJobTrigger.trigger
 * @Description        : 
 * @Author             : sean.gray@atirestoration.com
 * @Group              : 
 * @Last Modified By   : sean.gray@atirestoration.com
 * @Last Modified On   : 12/19/2019, 1:54:21 PM
 * @Modification Log   : 
 * Ver       Date            Author                 Modification
 * 1.0    12/19/2019   sean.gray@atirestoration.com     Initial Version
**/
trigger ATIJobTrigger on ATI_Job__c (before insert, before update,
                                     after insert,after update,
                                     before delete) {
                                     
                                         List<Profile> profileName = [SELECT Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
                                         if(profileName[0].Name != 'Restricted Process Execution' && !System.isFuture() && !System.isQueueable())
                                         {
                                            if(Trigger.isAfter && (Trigger.isInsert)){
                                                //XactFileReOpenedClass.TriggerMail(trigger.new, trigger.oldMap);
                                                XactFileReOpenedClass.TriggerMail(trigger.new);
                                            }
                                            if(Trigger.isAfter && (Trigger.isUpdate)){
                                                XactFileReOpenedClass.TriggerMail(trigger.new, trigger.oldMap);
                                            }
                                               if(TriggerFlagController.flag == true) {
                                             if(Trigger.isBefore && Trigger.isInsert){
                                                system.debug('The before Insert is called');
                                                 JobTriggerHandler.handleBeforeInsertOnly();
                                                 
                                             }}
                                             
                                             if(TriggerFlagController.flag == true) {
                                             if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
                                                system.debug('The before Update Insert is called');
                                                 JobTriggerHandler.handleBeforeInsertUpdate();
                                                 
                                             }}
                                             if(TriggerFlagController.flag == true) {
                                                if(Trigger.isAfter && Trigger.isInsert){
                                                    system.debug('The after Insert is called');
                                                    JobTriggerHandler.handleAfterInsertOnly();
                                                    //TriggerFlagController.flag = false;
                                                    efs__.EgnyteSyncQueueTrigger.onAfterInsert();
                                                    
                                                }}
                                             if(TriggerFlagController.flag == true) {
                                             if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)){
                                                system.debug('The after Update Insert is called');
                                                 JobTriggerHandler.handleAfterInsertUpdate();
                                                 
                                             }}
                                           
                                             if(TriggerFlagController.flag == true) {
                                             if(Trigger.isBefore && Trigger.isUpdate){
                                                system.debug('The before Update is called');
                                                 JobTriggerHandler.handleBeforeUpdatesOnly();
                                                
                                             }}
                                             
                                             if(TriggerFlagController.flag == true) {
                                             if(Trigger.isAfter && Trigger.isUpdate ){
                                                 TriggerFlagController.flag = false;
                                                 system.debug('The after Update is called');
                                                 JobTriggerHandler.handleAfterUpdatesOnly();
                                                 efs__.EgnyteSyncQueueTrigger.onAfterUpdate();
                                             } 
                                            }   
                                              
                                             if(Trigger.isBefore && (Trigger.isDelete)){
                                                 JobTriggerHandler.handleBeforeDelete();
                                                 system.debug('The delete is called');
                                             }          
                                     }
                                     else if(profileName[0].Name != 'Restricted Process Execution' && !System.isFuture() && System.isQueueable())
                                     {
                                         system.debug('Getting called');
                                         if(Trigger.isAfter)
                                         {
                                            JobTriggerHandlerWorkflow.JobTeamCreation(Trigger.new, (map<Id,ATI_Job__c>)Trigger.newMap, (map<Id,ATI_Job__c>)Trigger.oldMap);
                                         }
                                         if(Trigger.isAfter && Trigger.isUpdate)
                                         {
                                            JobAEBonusTriggerHandler.updateTeamMembersOnAEChange( (map<Id,ATI_Job__c>)Trigger.oldMap, (map<Id,ATI_Job__c>)Trigger.newMap );
                                         }
                                     }
    
}