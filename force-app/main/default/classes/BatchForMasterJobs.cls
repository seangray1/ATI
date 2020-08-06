global class BatchForMasterJobs implements Database.Batchable<sObject> {
    global String Query;
    global final String Entity;
    global final String Field;
    global final String Value;
    Map<Id,Master_Job__c> outscopeToUpdate = new Map<Id, Master_Job__c>();
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(query);
    }
    
  
    global void execute(Database.BatchableContext BC, List<ATI_Job__c> scope)
    {
        
        Set<Id> masterjobset = new Set<Id>(); 
        Map<Id,Master_Job__c> scopeToUpdate = new Map<Id, Master_Job__c>();
        for(ATI_Job__c s : scope)
        {
            Master_Job__c mj = new Master_Job__c(Id = s.Master_Job__c);
            scopeToUpdate.put(s.Master_Job__c, mj);
        }
        
        for(Id s : scopeToUpdate.keyset())
        {
            if(outscopeToUpdate.containsKey(s))
            {
                scopeToUpdate.get(s).Amount__c = outscopeToUpdate.get(s).Amount__c;
            }
        }
        for(ATI_Job__c s : scope)
        {
            if(s.Amount__c == null)
            {
                s.Amount__c = 0;
            }
            
            if(outscopeToUpdate.containsKey(s.Master_Job__c))
            {
                scopeToUpdate.get(s.Master_Job__c).Amount__c = scopeToUpdate.get(s.Master_Job__c).Amount__c + s.Amount__c;
                outscopeToUpdate.get(s.Master_Job__c).Amount__c = outscopeToUpdate.get(s.Master_Job__c).Amount__c;

            }
            if(scopeToUpdate.get(s.Master_Job__c).Amount__c == null)
            {
                scopeToUpdate.get(s.Master_Job__c).Amount__c = 0;
            }
            if(!outscopeToUpdate.containsKey(s.Master_Job__c))
            {
                
                scopeToUpdate.get(s.Master_Job__c).Amount__c = scopeToUpdate.get(s.Master_Job__c).Amount__c + s.Amount__c;
                outscopeToUpdate.put(s.Master_Job__c, scopeToUpdate.get(s.Master_Job__c));
            }
            
        }
        update scopeToUpdate.values();
         
    }     
         
        global void finish(Database.BatchableContext BC){
        }
     }

    //  if(s.Date_Of_Loss__c != null)
    //         {
    //         s.Name = s.Job_Address_Line_1__c + ' ' + s.Project_Site_City__c + ' ' + s.Project_Site_State__c + ' | ' + s.Date_Of_Loss__c;
    //         s.Name = s.Name.replace('00:00:00', '');
    //         if(s.name.length() > 79){
    //              s.name = s.name.substring(0, 79);
    //         }
    //           }else{
    //              s.Name = s.Job_Address_Line_1__c + ' ' + s.Project_Site_City__c + ' ' + s.Project_Site_State__c;
    //              s.Name = s.Name.replace('00:00:00', '');
    //              if(s.name.length() > 79){
    //                  s.name = s.name.substring(0, 79);
    //              }
    //           }
    //          props.add(s);
    //         }
    //       if(!props.isEmpty()){
    //          update props; 
    //         }