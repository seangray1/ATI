public class AccountRoleTriggerHandler {

    public static void InsertCampaignJunction(List < Account_Roles__c > accRoles1) {

    List < Account_Roles__c > accRoles = new List < Account_Roles__c > ([Select id, Name, Contact_ID__c,Master_Job_ID__c, Master_Job_ID__r.Date_Time_Taken__c from Account_Roles__c where id =: accRoles1  ]);
        
    List < CampaignMember > campaignMembers = new List < CampaignMember > ();
    List < Contact > cons = new List < Contact > ();
    List < Campaign_Junction__c > insertCampJunctions = new List < Campaign_Junction__c > ();
    Set < Id > conIds = new Set < Id > ();
    Set < Id > campIds = new Set < Id > ();

    for (Account_Roles__c accRole: accRoles) {
        if (accRole.Contact_ID__c != null) {
            conIds.add(accRole.Contact_ID__c);
            
        }
    }


    if (conIds.size() > 0) {
        List < CampaignMember > campMembers = [Select id, CampaignId, Contactid, campaign.StartDate, campaign.Enddate from CampaignMember where ContactId in: conids];
        
        Map < id, List < CampaignMember >> conCampMap = new Map < id, List < CampaignMember >> ();

        for (CampaignMember campMember: campMembers) {
            campIds.add(campMember.CampaignId);
        }

        Map < Id, Campaign > campaignMap = new Map < Id, Campaign > ([Select id, name from Campaign where id in: campIds and isActive = True and EndDate >= Today and StartDate <= Today]);

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
                    
                    System.debug('Job '+accRole.Master_Job_ID__c);
                    System.debug('Job Taken date'+accRole.Master_Job_ID__r.Date_Time_Taken__c);
                    System.debug('StartDate---->'+campMember.campaign.StartDate);
                    System.debug('EndDate------>'+(campMember.campaign.EndDate).AddDays(1));
                    
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
    public static void UpdateCampaignJunction(List < Account_Roles__c > accRolesNew, map<id, Account_Roles__c> oldAccRolesMap) {

	List < Account_Roles__c > accRoles1 = new List < Account_Roles__c > ([Select id, Name, Contact_ID__c,Master_Job_ID__c, Master_Job_ID__r.Date_Time_Taken__c from Account_Roles__c where id =: accRolesNew  ]);        
    List < CampaignMember > campaignMembers = new List < CampaignMember > ();
    List < Contact > cons = new List < Contact > ();
    List < Account_Roles__c > accRoles = new List < Account_Roles__c > ();
    List < Campaign_Junction__c > insertCampJunctions = new List < Campaign_Junction__c > ();
    Set < Id > conIds = new Set < Id > ();
    Set < Id > campIds = new Set < Id > ();
        
        
        
        for (Account_Roles__c ar: accRoles1) {
        
            Account_Roles__c oldAccountRole = oldAccRolesMap.get(ar.ID);
        
            if (ar.Contact_ID__c != oldAccountRole.Contact_ID__c || ar.Contact_ID__c != oldAccountRole.Contact_ID__c) {
        
                accRoles.add(ar);
            }
        }
        
        //Deletion piece for Old contact
    List < Campaign_Junction__c > RectobeDeleted = new List < Campaign_Junction__c > ([Select id from Campaign_Junction__c
            where Account_Roles__c =: accRoles
        ]);
        

        if (RectobeDeleted.size() > 0) {
            database.delete(RectobeDeleted);
        }

    

    for (Account_Roles__c accRole: accRoles) {

        if (accRole.Contact_ID__c != null) {
            conIds.add(accRole.Contact_ID__c);
        }
    }


    if (conIds.size() > 0) {

        List < CampaignMember > campMembers = [Select id, CampaignId, Contactid, campaign.StartDate, campaign.EndDate from CampaignMember where ContactId in: conids];
        Map < id, List < CampaignMember >> conCampMap = new Map < id, List < CampaignMember >> ();

        for (CampaignMember campMember: campMembers) {
            campIds.add(campMember.CampaignId);
        }

        Map < Id, Campaign > campaignMap = new Map < Id, Campaign > ([Select id, name from Campaign where id in: campIds and isActive = True and EndDate >= Today and StartDate <= Today]);

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
    
    
    
    public static void DeleteCampaignJunction(List < Account_Roles__c > accRoles) {

        List < Campaign_Junction__c > RectobeDeleted = new List < Campaign_Junction__c > ([Select id from Campaign_Junction__c
            where Account_Roles__c in: accRoles
        ]);
        

        if (RectobeDeleted.size() > 0) {
            database.delete(RectobeDeleted);
        }
    }
//Checks account name if it contains a certain text, it will mark Send PRelim on job to No
    public static void UpdateJobSendPrelim(List<Account_Roles__c> accRoles, Map<Id,Account_Roles__c> oldAccRolesMap)
    {
        Set<Id> JobIdSet = new Set<Id>();
        Map<Id,Account_Roles__c> JobMapToUpdate = new Map<Id,Account_Roles__c>();
        for(Account_Roles__c a : accRoles)
        {
            
            if(a.Account_Name_Lookup__c != null && a.Master_Job_ID__c != null && (a.Account_Name_Lookup__c.contains('Vixxo') || a.Account_Name_Lookup__c.contains('Total Property Management') || 
            a.Account_Name_Lookup__c.contains('Facility Source') || a.Account_Name_Lookup__c.contains('Farmers Insurance')))
            {
                if(Trigger.isInsert)
                {
                    JobIdSet.add(a.Master_Job_ID__c);
                    // ATI_Job__c job = new ATI_Job__c(Id = a.Master_Job_ID__c, Send_Prelim__c = 'No');
                    JobMapToUpdate.put(a.Master_Job_ID__c, a);
                }
                if(Trigger.isUpdate && a.Account_Name_Lookup__c != oldAccRolesMap.get(a.Id).Account_Name_Lookup__c)
                {
                    JobIdSet.add(a.Master_Job_ID__c);
                    // ATI_Job__c job = new ATI_Job__c(Id = a.Master_Job_ID__c, Send_Prelim__c = 'No');
                    JobMapToUpdate.put(a.Master_Job_ID__c, a);
                } 
            }
        }
        if(!JobMapToUpdate.isEmpty())
        {
            Map<Id,ATI_Job__c> JobMap = new Map<Id,ATI_Job__c>([SELECT Id, Send_Prelim__c,Lead_source__c 
                                    FROM ATI_Job__c 
                                    WHERE Id=:JobIdSet AND Send_Prelim__c = null]);
            if(!JobMap.isEmpty())
            {
                for(ATI_Job__c job : JobMap.values())
                {
                    if((JobMapToUpdate.get(job.Id).Account_Name_Lookup__c.contains('Farmers Insurance') && job.Lead_Source__c.contains('Program')))
                    {
                        job.Send_Prelim__c = 'No';
                    }
                    if(!JobMapToUpdate.get(job.Id).Account_Name_Lookup__c.contains('Farmers Insurance'))
                    {
                        job.Send_Prelim__c = 'No';
                    }
                    
                }
                update JobMap.values();
            }
        }
    }
}