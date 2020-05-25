trigger XactFileReOpened on ATI_Job__c (before insert, before update,after insert,after update,before delete) {
	system.debug('Inside Trigger');
    if(Trigger.isAfter && (Trigger.isUpdate || Trigger.isInsert)){
        system.debug('Inside Trigger Cond');
        //XactFileReOpenedClass.TriggerMail(trigger.new, trigger.oldMap);
        XactFileReOpenedClass.TriggerMail(trigger.new);
    }
}