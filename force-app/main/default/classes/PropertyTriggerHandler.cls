public without sharing class PropertyTriggerHandler {
    public static void PropertyNameFormat(List<Property__c> props) {
        
        for(property__c prop : props){
            if(prop.Address_Line_1__c != null && prop.City__c != null && prop.State__c != null){
                prop.Name = prop.Address_Line_1__c + ' ' + prop.City__c + ' ' + prop.State__c; 
            
            if(prop.Alternate_Name__c != null){
                prop.Name = prop.Name + ' | ' + prop.Alternate_Name__c;
            }
            if(prop.name.length() > 79){
                prop.name = prop.name.substring(0, 79);
        }
    }
        }

    }
    public static void PropertyNameUpdate(List<Property__c> newProps, map<Id,Property__c> oldProps, Map<Id,Property__c> newPropMap){
        Set<Id> propset = new Set<Id>();
        List<ATI_Job__c> jobs = new List<ATI_Job__c>();
        Boolean MasterJobNameChange = false;
        String Type;
        for(Property__c prop : newProps){
            Property__c oldProp = oldProps.get(prop.id);
            if(prop.Address_line_1__c != oldProp.Address_line_1__c || prop.City__c != oldProp.City__c || prop.State__c != oldProp.State__c || 
            prop.Zip__c != oldProp.Zip__c || prop.Alternate_Name__c != oldProp.Alternate_Name__c)
            {
                
                if(prop.Alternate_Name__c == null)
                {
                    prop.Name = prop.Address_Line_1__c + ' ' + prop.City__c + ' ' + prop.State__c;
                }else
                {
                    prop.Name = prop.Address_Line_1__c + ' ' + prop.City__c + ' ' + prop.State__c + ' | ' + prop.Alternate_Name__c;  
                }
                if(prop.name.length() > 79)
                {
                    prop.name = prop.name.substring(0, 79);
                }
            if(prop.Address_line_1__c != oldProp.Address_line_1__c || prop.City__c != oldProp.City__c || prop.State__c != oldProp.State__c || 
            prop.Zip__c != oldProp.Zip__c)
            {
                MasterJobNameChange = true;
                propSet.add(prop.id);
                type = 'AddressChange';
            }
            
            }
            if(prop.Market_Class__c != oldProp.Market_Class__c ||
                prop.Market_Segment__c != oldProp.Market_Segment__c || prop.Market_Segment_Sub_Class__c != oldProp.Market_Segment_Sub_Class__c )
            {
                propset.add(prop.Id);
                type = 'MarketChange';
            }
    }
    if(!propset.isEmpty()){
        jobs = [Select Id, Project_Site_Address__c, Project_Site_City__c, Project_Site_State__c, Market_Class__c, Market_Segment__c, Market_Segment_Sub_Class__c, Project_Site_Zipcode__c, Property_ID__c FROM 
        ATI_Job__c WHere Property_Id__c =: propset];
    }
    if(MasterJobNameChange)
    {
        system.debug('Type is ' + type + '  size of Property Ids is ' + propset.size());
        List<Master_Job__c> mjobs = [Select Id, Name, Date_of_loss__c, Property__c FROM Master_Job__c Where Property__c =: propset LIMIT 200];
        for(Master_Job__c m : mjobs)
        {
            property__c prop = newPropMap.get(m.Property__c);
            if(m.Date_Of_Loss__c == null){
                m.Name = prop.Address_line_1__c + ' ' + prop.City__c + ' ' + prop.STate__c; 
            }
            if(m.Date_Of_Loss__c != null){
                m.Name = prop.Address_line_1__c + ' ' + prop.City__c + ' ' + prop.STate__c + ' | ' + m.Date_Of_Loss__c;
                m.Name = m.Name.replace('00:00:00', ''); 
            }
        }
        update mjobs;
    }
    
    // if(!jobs.isEmpty() && jobs.size() < 10){
    // for(ATI_Job__c job: jobs){
    //     Property__c prop = newPropMap.get(job.Property_ID__c);
    //     job.Project_Site_Address__c = prop.Address_line_1__c;
    //     job.Project_Site_City__c = prop.City__c;
    //     job.Project_Site_State__c = prop.State__c;
    //     job.Project_Site_Zipcode__c = prop.Zip__c;
    //     job.Market_Class__c = prop.Market_Class__c;
    //     job.Market_Segment__c = prop.Market_Segment__c;
    //     job.Market_Segment_Sub_Class__c = prop.Market_Segment_Sub_Class__c;
    // }
    // update jobs;
    // }
    // else 
    if(!jobs.isEmpty())
    {
        
        System.debug('Htting queuable and jbo size is ' + jobs.size());
        Id b = System.enqueueJob(new Property_Queueable_Update(jobs, newPropMap, type));
    }
    
    
    }
}