public class XactFileReOpenedClass {
    
    //public static void TriggerMail(List<ATI_Job__c> Jobs, Map<id, ATI_Job__c> oldMaps){
    public static void TriggerMail(List<ATI_Job__c> Jobs){
        system.debug('!!!!!!!'+Jobs);
        Set<Id> ATIId = new Set<Id>();
        List<ATI_Job__c> JobRecord = new List<ATI_Job__c>([Select Id,Name,XACT_File_Reopened__c, Project_Manager__r.email, Office2__r.Project_Coordinator__r.email from ATI_Job__c where ID IN: Jobs]);
        system.debug('@@'+JobRecord);
        for(ATI_Job__c job: JobRecord){
            //ATI_Job__c oldMap = oldMaps.get(job.Id);
            //system.debug('OldMap'+oldMap);
            //if(oldMap.XACT_File_Reopened__c!=job.XACT_File_Reopened__c && job.XACT_File_Reopened__c==true){
            if(job.XACT_File_Reopened__c==true){
                system.debug('Inside If mail'+job.Project_Manager__r.email);
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[] {};
                if(job.Project_Manager__r.email!=null){toAddresses.add(job.Project_Manager__r.email);}
                if(job.Office2__r.Project_Coordinator__r.email!=null){toAddresses.add(job.Office2__r.Project_Coordinator__r.email);}
                String RecordURL = URL.getSalesforceBaseUrl().toExternalForm()+'/'+job.Id;
                //Send Email
                system.debug('Send Emails:'+toAddresses);
                mail.setToAddresses(toAddresses);
                mail.setSubject('Job Re-opened in XactAnalysis');
                mail.setHtmlBody('Hi,<br/><br/> This is to inform you that the Job <a href='+RecordURL+'>'+job.Name+'</a> has been re-opened in Xact Analysis. Please review this job in Salesforce and make any necessary changes.');
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                
            }//EOF IF
        }//EOF For Loop
    }
    
}