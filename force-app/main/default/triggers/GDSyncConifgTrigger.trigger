trigger GDSyncConifgTrigger on Google_Drive_Sync_Configuration__c (before insert, before update) {

    List<Google_Drive_Sync_Configuration__c> SyncList = new List<Google_Drive_Sync_Configuration__c>([SELECT Id, Object_API_Name__c from Google_Drive_Sync_Configuration__c]);
    for(Google_Drive_Sync_Configuration__c sc:trigger.new){
        for(Google_Drive_Sync_Configuration__c sl : SyncList ){
            if(sc.Object_API_Name__c == sl.Object_API_Name__c && sl.id != sc.id){
               sc.Object_API_Name__c.adderror('Duplicate record found for '+sc.Object_API_Name__c);
            }
 		}
 	}
    
}