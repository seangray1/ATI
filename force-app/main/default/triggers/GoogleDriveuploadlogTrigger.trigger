trigger GoogleDriveuploadlogTrigger on Google_Drive_File_Upload_log__c (after insert) {
	
    if( trigger.isInsert && trigger.isAfter ){
        GoogleDriveuploadLogTriggerHelper.createLogRecords( trigger.new );
    }

}