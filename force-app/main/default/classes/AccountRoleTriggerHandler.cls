public class AccountRoleTriggerHandler {

    public Static Void InsertCampaignJunction(List < Account_Roles__c > accRoles) {

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
        List < CampaignMember > campMembers = [Select id, CampaignId, Contactid from CampaignMember where ContactId in: conids];
        
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
                    
                    insertCampJunctions.add(insertCampJunction);
                    
                   
                
                }
                
                   campaignMembers.clear();
                
            }

        }

    }

    if (insertCampJunctions.size() > 0) {
        insert insertCampJunctions;
    }

}
    public Static Void UpdateCampaignJunction(List < Account_Roles__c > accRolesNew, map<id, Account_Roles__c> oldAccRolesMap) {
        
    List < CampaignMember > campaignMembers = new List < CampaignMember > ();
    List < Contact > cons = new List < Contact > ();
    List < Account_Roles__c > accRoles = new List < Account_Roles__c > ();
    List < Campaign_Junction__c > insertCampJunctions = new List < Campaign_Junction__c > ();
    Set < Id > conIds = new Set < Id > ();
    Set < Id > campIds = new Set < Id > ();
        
        
        
        for (Account_Roles__c ar: accRolesNew) {
        
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

        List < CampaignMember > campMembers = [Select id, CampaignId, Contactid from CampaignMember where ContactId in: conids];
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
                    
                    insertCampJunctions.add(insertCampJunction);
                
                }
                
                campaignMembers.clear();
            }

        }

    }

    if (insertCampJunctions.size() > 0) {
        insert insertCampJunctions;
    }

}
    
    
    
    public Static Void DeleteCampaignJunction(List < Account_Roles__c > accRoles) {

        List < Campaign_Junction__c > RectobeDeleted = new List < Campaign_Junction__c > ([Select id from Campaign_Junction__c
            where Account_Roles__c in: accRoles
        ]);
        

        if (RectobeDeleted.size() > 0) {
            database.delete(RectobeDeleted);
        }
    }

}