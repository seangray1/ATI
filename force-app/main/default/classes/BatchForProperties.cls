global class BatchForProperties implements Database.Batchable<sObject> {
   global String Query;
   global final String Entity;
   global final String Field;
   global final String Value;


    
  
       global Database.QueryLocator start(Database.BatchableContext BC){
        //    string pn = 'PN-'+ '%';
           query = 'Select Id, Name, Alternate_Name__c, Address_Line_1__c, City__c, State__c, Job_State__c FROM Property__c' ;
    
        return Database.getQueryLocator(query);

       }
       global void execute(Database.BatchableContext BC, List<Property__c> scope){
        List<Property__c> props = new List<Property__c>();
         for(Property__c s : scope){
            s.State__c = s.Job_State__c;
                 if(s.Alternate_Name__c != null){
            s.Name = s.Address_Line_1__c + ' ' + s.City__c + ' ' + s.State__c + ' | ' + s.Alternate_Name__c;
            
            if(s.name.length() > 79){
                s.name = s.name.substring(0, 79);
            }
             }else{
                s.Name = s.Address_Line_1__c + ' ' + s.City__c + ' ' + s.State__c;
               
                if(s.name.length() > 79){
                    s.name = s.name.substring(0, 79);
                }
             }
           
            props.add(s);

         }
         if(!props.isEmpty()){
            update props; 
           }
        
        }
        
       global void finish(Database.BatchableContext BC){
       }
    }