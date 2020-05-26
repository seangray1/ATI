trigger CaseTrigger on Case (before insert) {


        if(Trigger.isBefore && Trigger.isInsert){
        
        
             CaseTriggerHandler.PopulateCrisisInformationOnCase(Trigger.new);
        
             
             
        
        
        }

}