public with sharing class SharinPixTriggerHandler2 {
    private List<sharinpix__SharinPixImage__c> newRecords;
    private Map<Id, sharinpix__SharinPixImage__c> oldMap;
    
    public SharinPixTriggerHandler2(list<sharinpix__SharinPixImage__c> newRecords, map<Id, sharinpix__SharinPixImage__c> oldMap){
        this.newRecords = newRecords;
        this.oldMap = oldMap;
    }
    public void beforeInsert(){
        Set<String> UsersEmailsToSearch = new Set<String>();
        for(sharinpix__SharinPixImage__c sharinPixImage: newRecords){
            if (sharinPixImage.sharinpix__Metadatas__c != null){
                map<string, object> metadataMap = (map<string, object>) JSON.deserializeUntyped(sharinPixImage.sharinpix__Metadatas__c);

                if (!metadataMap.isEmpty() && metadataMap.containsKey('drive_id')){
                    // code to update fields here
                    sharinPixImage.Google_Drive_ID_Original__c = String.valueOf(metadataMap.get('drive_id'));
                    system.debug('Drive Id is ' + String.valueOf(metadataMap.get('drive_id')));
                    if(metadataMap.containsKey('uploadedById'))
                    {
                        if(string.valueOf(metadataMap.get('uploadedById')) != null)
                        {
                            UsersEmailsToSearch.add(string.valueOf(metadataMap.get('uploadedById')));
                        }
                    }
                }
            }
        }
        if(!UsersEmailsToSearch.isEmpty())
        {
            List<User> atiUsers = [Select Id, Name, Email FROM User WHERE Email IN:UsersEmailsToSearch];
            Map<String,Id> emailMap = new Map<String,Id>();
            for(User u : atiUsers)
            {
                emailMap.put(u.Email,u.Id);
            }
            if(!atiUsers.isEmpty())
            {
                for(sharinpix__SharinPixImage__c sharinPixImage: newRecords){
                    if (sharinPixImage.sharinpix__Metadatas__c != null){
                        map<string, object> metadataMap = (map<string, object>) JSON.deserializeUntyped(sharinPixImage.sharinpix__Metadatas__c);
        
                        if (!metadataMap.isEmpty() && metadataMap.containsKey('uploadedById')){
                            // code to update fields here
                            if(string.valueOf(metadataMap.get('uploadedById')) != null){
                                sharinPixImage.sharinpix__User__c = emailMap.get(string.valueOf(metadataMap.get('uploadedById')));
                            }
                        }
                    }
                }
            }
        }
        
    }
}