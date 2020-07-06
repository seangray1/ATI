global class AccountRoleInsertBatch implements Database.Batchable<sObject> {

// Start Method

    global Database.QueryLocator start(Database.BatchableContext BC) {

        String query = 'SELECT Id,Name,CreatedDate,Contact_ID__c,Master_Job_ID__r.Date_Time_Taken__c,Master_Job_ID__c FROM Account_Roles__c';

        return Database.getQueryLocator(query);

    }

   // Execute method

    global void execute(Database.BatchableContext BC, List<Account_Roles__c> scope) {
    
    
    List< Campaign_Junction__c> campJunctions = [Select id,name, Account_Roles__c from Campaign_Junction__c where Account_Roles__c in:scope];
    Set<Id> accRoleIds = new Set<Id>();

    
    for(Campaign_Junction__c campJunction: campJunctions){
    
                 accRoleIds.add(campJunction.Account_Roles__c);
            
    
    }
    
    List<Account_Roles__c> accRoles = new List<Account_Roles__c>();
    
    if(accRoleIds.size() > 0){
    
    accRoles = [Select id,name,CreatedDate,Contact_ID__c,Master_Job_ID__c, Master_Job_ID__r.Date_Time_Taken__c from Account_Roles__c where id not in:accRoleIds];
    
    }
    
    else{
    
     
     accRoles.addall(scope);
     
    
    
    }
    
   
    List < CampaignMember > campaignMembers = new List < CampaignMember > ();
    List < Campaign_Junction__c > insertCampJunctions = new List < Campaign_Junction__c > ();
    Set < Id > conIds = new Set < Id > ();
    Set < Id > campIds = new Set < Id > ();

    for (Account_Roles__c accRole: accRoles) {
        
        if ((accRole.Contact_ID__c != null) && (accRole.Master_Job_ID__c != null)) {
            conIds.add(accRole.Contact_ID__c);
        }
    }


    if (conIds.size() > 0) {

        List < CampaignMember > campMembers = [Select id,name, CampaignId,Contactid,campaign.StartDate,campaign.EndDate  from CampaignMember where ContactId in: conids];
        Map < id, List < CampaignMember >> conCampMap = new Map < id, List < CampaignMember >> ();

        for (CampaignMember campMember: campMembers) {
            campIds.add(campMember.CampaignId);
        }
        

        Map < Id, Campaign > campaignMap = new Map < Id, Campaign > ([Select id, name from Campaign where id in: campIds and isActive = True and enddate>=2020-01-01]);

        for (CampaignMember campMember: campMembers) {

            if (campaignMap.containsKey(campMember.CampaignId)) {

                if (conCampMap.containskey(campMember.Contactid)) {

                    List < CampaignMember > camMembers = new List < CampaignMember > ();
                    camMembers = conCampMap.get(campMember.Contactid);
                    camMembers.add(campMember);
                    conCampMap.put(campMember.Contactid, camMembers);

                } else {

                    conCampMap.put(campMember.Contactid, new List < CampaignMember > {
                        campMember
                    });

                }

            }

        }
        

        for (Account_Roles__c accRole: accRoles) {

            if (conCampMap.containsKey(accRole.Contact_ID__c)) {
                         
             
                campaignMembers.addAll(conCampMap.get(accRole.Contact_ID__c));
                
                for(CampaignMember campMember:campaignMembers){
                
                    
                    Campaign_Junction__c insertCampJunction = new Campaign_Junction__c();
                    insertCampJunction.Account_Roles__c = accRole.Id;
                    insertCampJunction.Campaign__c = campMember.CampaignId;
                    insertCampJunction.Contact__c = campMember.ContactId;
                    insertCampJunction.Job__c = accRole.Master_Job_ID__c;
                    
                    


                    if(accRole.Master_Job_ID__r.Date_Time_Taken__c >= campMember.campaign.StartDate && accRole.Master_Job_ID__r.Date_Time_Taken__c <= (campMember.campaign.EndDate).AddDays(1)){
                    
                    insertCampJunctions.add(insertCampJunction);
                    
                    }
                   
                
                }
                
                campaignMembers.clear();
                
            }

        }

        
    }

    if (insertCampJunctions.size() > 0) {
        insert insertCampJunctions;
    }

         

  }   

    // Finish Method

    global void finish(Database.BatchableContext BC) {

    }

}