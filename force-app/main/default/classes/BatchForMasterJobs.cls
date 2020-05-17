global class BatchForMasterJobs implements Database.Batchable<sObject> {
    global String Query;
    global final String Entity;
    global final String Field;
    global final String Value;
        global Database.QueryLocator start(Database.BatchableContext BC){
         //    string pn = 'PN-'+ '%';
            query = 'Select Id, Name, Date_Of_Loss__c, Job_Address_Line_1__c, Project_Site_City__c, Project_Site_State__c FROM Master_Job__c' ;
     
         return Database.getQueryLocator(query);
 
        }
        global void execute(Database.BatchableContext BC, List<Master_Job__c> scope){
         List<Master_Job__c> props = new List<Master_Job__c>();
          for(Master_Job__c s : scope){
            
              if(s.Date_Of_Loss__c != null){
             s.Name = s.Job_Address_Line_1__c + ' ' + s.Project_Site_City__c + ' ' + s.Project_Site_State__c + ' | ' + s.Date_Of_Loss__c;
             s.Name = s.Name.replace('00:00:00', '');
             if(s.name.length() > 79){
                 s.name = s.name.substring(0, 79);
             }
              }else{
                 s.Name = s.Job_Address_Line_1__c + ' ' + s.Project_Site_City__c + ' ' + s.Project_Site_State__c;
                 s.Name = s.Name.replace('00:00:00', '');
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