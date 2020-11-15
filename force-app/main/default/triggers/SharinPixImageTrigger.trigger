trigger SharinPixImageTrigger on sharinpix__SharinPixImage__c (before delete, before insert) {

    if( trigger.isDelete && trigger.isBefore ){
        SharinPixImageTriggerHandler.createBackupRecords( trigger.old );
    }
    if (trigger.isBefore){
        if (Trigger.isInsert){
            SharinPixTriggerHandler2 handle = new SharinPixTriggerHandler2(trigger.new, trigger.oldMap);
            handle.beforeInsert();
        }
    }
}