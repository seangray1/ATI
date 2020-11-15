public with sharing class JitterBitLogTriggerHelper {
    
    @AuraEnabled    
    public static void createLogRecords( List<Jitterbit_Log__c> jitterBitLogRecordList){
        List<Jitterbit_Log__c> FileUploadLogList = new List<Jitterbit_Log__c>();
        try{
            for(Jitterbit_Log__c jitterbit : jitterBitLogRecordList){
                String jitterBitName = jitterbit.Name;
                String check = 'Upload via MuleSoft';
                if(jitterBitName.contains(check)){
                    FileUploadLogList.add(jitterbit);
                }
            }
            
            List<Google_Drive_File_Upload_log__c> newFUlogListToInsert = new List<Google_Drive_File_Upload_log__c>();
            for(Jitterbit_Log__c  jbRec: FileUploadLogList){
                
                Google_Drive_File_Upload_log__c FileUploadLog = new Google_Drive_File_Upload_log__c();
                FileUploadLog.Upload_Status__c = jbRec.Status__c;
                if(jbRec.Error_Warning_Details__c != null){
                    FileUploadLog.Error_Description__c = jbRec.Error_Warning_Details__c;
                }
                FileUploadLog.File_ID__c = jbRec.Source_System__c;
                FileUploadLog.File_Name__c = jbRec.Log_Name__c;
                FileUploadLog.Success__c = jbRec.Success__c;
                FileUploadLog.UploadedBy_Email__c = jbRec.UploadedBy_Email__c.substringBetween('(',')');
                FileUploadLog.SF_Source_Record_URL__c = jbRec.SF_Source_Record_URL__c ;//Added by Suman [To include SF source record view link]
                
                newFUlogListToInsert.add(FileUploadLog);
                
            }
            
            if(newFUlogListToInsert.size() > 0){
                insert newFUlogListToInsert;
            }
        }catch(Exception e){
            System.debug('System Exception occurred : ' + e.getTypeName());
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());   
        }
        
        
    }
    
}