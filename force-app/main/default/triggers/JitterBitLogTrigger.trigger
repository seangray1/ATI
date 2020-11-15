trigger JitterBitLogTrigger on Jitterbit_Log__c (after insert) {
     System.debug('$$$$$$$$ Inside JitterBitLogTrigger');	
     if( trigger.isInsert && trigger.isAfter ){
         System.debug('$$$$$$$$ Inside JitterBitLogTrigger 1');
        JitterBitLogTriggerHelper.createLogRecords( trigger.new );
    }

}