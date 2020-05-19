public with sharing class PropertyTriggerHandler {
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
        for(Property__c prop : newProps){
            Property__c oldProp = oldProps.get(prop.id);
            if(prop.Address_line_1__c != oldProp.Address_line_1__c || prop.City__c != oldProp.City__c || prop.State__c != oldProp.State__c || 
            prop.Zip__c != oldProp.Zip__c || prop.Alternate_Name__c != oldProp.Alternate_Name__c){
                propSet.add(prop.id);
                if(prop.Alternate_Name__c == null){
                    prop.Name = prop.Address_Line_1__c + ' ' + prop.City__c + ' ' + prop.State__c;
                }else{
                    prop.Name = prop.Address_Line_1__c + ' ' + prop.City__c + ' ' + prop.State__c + ' | ' + prop.Alternate_Name__c;  
                }
                if(prop.name.length() > 79){
                    prop.name = prop.name.substring(0, 79);
            }
            
        }
    }
//     if(!propset.isEmpty()){
//         jobs = [Select Id, Project_Site_Address__c, Project_Site_City__c, Project_Site_State__c, Project_Site_Zipcode__c, Property_ID__c FROM 
//         ATI_Job__c WHere Property_Id__c =: propset];
//     }
//     if(!jobs.isEmpty()){
//     for(ATI_Job__c job: jobs){
//         Property__c prop = newPropMap.get(job.Property_ID__c);
//         job.Project_Site_Address__c = prop.Address_line_1__c;
//         job.Project_Site_City__c = prop.City__c;
//         job.Project_Site_State__c = prop.State__c;
//         job.Project_Site_Zipcode__c = prop.Zip__c;
//     }
//     update jobs;
// }
    
    }
}