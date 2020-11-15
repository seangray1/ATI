/*******************************************************************************************
* @author           Suman
* @version          1.0 
* @date             01-Oct-2020
* @Status           In-Progress
* @Trigger Name     UploadFilesToGoogleDriveForSelObjects
* @description      This trigger will create Platform event for each file uploaded to Job,Account.
*********************************************************************************************
Version     Date      Team          Comments
*********************************************************************************************
* 1         Sep 2020    Suman        Initial Creation(JIRA AR-653)
*********************************************************************************************/
trigger UploadFilesToGoogleDriveForSelObjects on ContentDocumentLink (after insert) {
    System.debug('$$$$$$ Inside UploadFilesToGoogleDriveForSelObjects Trigger');
    
    List<Upload_files_to_GoogleDrive__e > uploadFilesToGoogleDriveEventList = new List<Upload_files_to_GoogleDrive__e >();
    try{
        //Get the objects which are part of Google Drive Sync Configurations(bcoz event is to created only if file is uploaded to these objects)
        Map<String,Google_Drive_Sync_Configuration__c> objectNameMap = GoogleDriveIntegrationCompController.getObjectDetailsFromGDSyncConfig();
        if(null == objectNameMap || objectNameMap.isEmpty())
            return;
        System.debug('$$$$$$ objectNameMap - ' + objectNameMap);
        
        //Group the configured object and all linked(job/account) records for that object
        //[This will be used later on to fetch details(Google Drive ref, Folder Path etc) from those linked records]
        Map<String,Set<Id>> objectNameAndItsRecsMap = new Map<String,Set<Id>>();//Get linked record ids for each object(to which files have been attached)
        List<Id> contentDocIdList = new List<Id>();
        for(Id cdlId : trigger.newMap.keySet()){
            contentDocIdList.add(trigger.newMap.get(cdlId).ContentDocumentId);
            String linkedObjName = trigger.newMap.get(cdlId).LinkedEntityId.getSObjectType().getDescribe().getName();
            System.debug('$$$$$ linkedObjName - ' + linkedObjName);
            if(objectNameMap.keySet().contains(linkedObjName)){
                System.debug('$$$$$ Already key exists');
                Set<Id> recList;
                if(objectNameAndItsRecsMap.containsKey(linkedObjName)){
                    recList = objectNameAndItsRecsMap.get(linkedObjName);
                    if(!recList.contains(trigger.newMap.get(cdlId).LinkedEntityId))
                        recList.add(trigger.newMap.get(cdlId).LinkedEntityId);
                }
                else{
                    System.debug('$$$$$ New key ');
                    recList = new Set<Id>();
                    recList.add(trigger.newMap.get(cdlId).LinkedEntityId);
                }
                objectNameAndItsRecsMap.put(linkedObjName,recList);
            }
        }
        
        if(null == objectNameAndItsRecsMap || objectNameAndItsRecsMap.isEmpty())
            return; 
        
        if(objectNameAndItsRecsMap.size()>10) //Added to avoid governer limit exception(as SOQL query is used in for loop)
            return;
        
        //Get details of linked records such as Google Drive ref, path , name etc to be used in creating event
        Map<Id,sObject> parentRecMap = new Map<Id,sObject>();
        for(String objName : objectNameAndItsRecsMap.keySet()){
            Set<Id> parentRecIdList = objectNameAndItsRecsMap.get(objName);//Get linked(job/account) record Id's
            List<sObject> parentRecList = new List<sObject>();
            parentRecList = Database.query('SELECT Id,Google_Drive_Folder_Ref__c,Google_Drive_Folder_Path__c,Google_Drive_Folder_Name__c FROM ' + String.escapeSingleQuotes(objName) + ' WHERE Id IN :parentRecIdList');
            for(sObject recItem : parentRecList)
                parentRecMap.put(recItem.Id, recItem);
        }
		
        //Get details of linked records such as Google Drive ref, path , name etc to be used in creating event
        Map<Id,ContentDocument> docIdAndDetailMap = new Map<Id,ContentDocument>([SELECT Id,FileExtension,FileType FROM ContentDocument WHERE Id IN:contentDocIdList]);
        
        for(Id cdlId: trigger.newMap.keySet()){
            Id contentDocId = trigger.newMap.get(cdlId).ContentDocumentId;
            Id linkedRecId = trigger.newMap.get(cdlId).LinkedEntityId;
            String linkedObjName = linkedRecId.getSObjectType().getDescribe().getName();
            sObject linkedRec = parentRecMap.get(linkedRecId);
            if(null == linkedRec)
                continue;
            
            String googleDriveRef = GDI_Constants.STRING_EMPTY;
            if(null != linkedRec.get('Google_Drive_Folder_Ref__c') && !String.isBlank(linkedRec.get('Google_Drive_Folder_Ref__c').toString()))
                googleDriveRef = linkedRec.get('Google_Drive_Folder_Ref__c').toString();
            String linkedRecURL = URL.getSalesforceBaseUrl().toExternalForm()+ '/'+linkedRecId;
            System.debug('$$$$$$$ linkedRecURL-' + linkedRecURL);
            uploadFilesToGoogleDriveEventList.add(new Upload_files_to_GoogleDrive__e(GoogleDriveFolderRefForRecord__c =googleDriveRef, Google_Drive_Folder_Path__c =linkedRec.get('Google_Drive_Folder_Path__c').toString() + '/' +linkedRec.get('Google_Drive_Folder_Name__c').toString(), 
                                                                                     SF_DocumentID__c =contentDocId, MIME_Type__c =GoogleDriveIntegrationCompHelper.getMimeTypeForFile(docIdAndDetailMap.get(contentDocId).FileType, docIdAndDetailMap.get(contentDocId).FileExtension),
                                                                                     UploadToGoogleDocsNotesAndAttachments__c=true, Folder_Name_for_Files__c=objectNameMap.get(linkedObjName).Folder_Name_for_Files__c ,ToBeDeletedFromSF__c =objectNameMap.get(linkedObjName).Delete_files_attachments__c,
                                                                                     Logged_in_user_details__c=UserInfo.getName()+ GDI_Constants.STRING_SQUAREBRACKETSTART +UserInfo.getUserEmail() + GDI_Constants.STRING_SQUAREBRACKETEND,
                                                                                     SF_record_URL__c = linkedRecURL));
        }
        
        if(uploadFilesToGoogleDriveEventList.isEmpty())
            return;
        
        System.debug('$$$$$$ uploadFilesToGoogleDriveEventList - ' + uploadFilesToGoogleDriveEventList);
        
        
        List<Database.SaveResult> results = EventBus.publish(uploadFilesToGoogleDriveEventList);
        // Inspect publishing result for each event
        for (Database.SaveResult sr : results) {
            if (sr.isSuccess()) {
                System.debug('Successfully published event.');
            } else {
                for(Database.Error err : sr.getErrors()) {
                    System.debug('Error returned: ' +
                                 err.getStatusCode() +
                                 ' - ' +
                                 err.getMessage());
                }
            }       
        }
        
    }catch(Exception e){
        System.debug('System Exception occurred : ' + e.getTypeName());
        System.debug(e.getMessage());
        System.debug(e.getStackTraceString());
        throw new AuraHandledException(e.getMessage());   
    }
        
}