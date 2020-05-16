public with sharing class MasterJobTriggerHandler {
    public static void MasterJobNameFormat(List<Master_Job__c> MasterJobs) {
        Set<Id> mjobids = new Set<Id>();
        for(Master_Job__c MasterJob : MasterJobs){
            if(MasterJob.Property__c != null){
                if(MasterJob.Date_Of_Loss__c != null){
                MasterJob.Name = MasterJob.Job_Address_Line_1__c + ' ' + MasterJob.Project_Site_City__c + ' ' + MasterJob.Project_Site_State__c ; 
                }else{
                MasterJob.Name = MasterJob.Job_Address_Line_1__c + ' ' + MasterJob.Project_Site_City__c + ' ' + MasterJob.Project_Site_State__c +' | ' + MasterJob.Date_Of_Loss__c;  
                }
                if(MasterJob.name.length() > 79){
                    MasterJob.name = MasterJob.name.substring(0, 79);
                }
                
            }
            if(MasterJob.Property__c == null){
                if(MasterJob.Date_Of_Loss__c != null){
                MasterJob.Name = MasterJob.Address_Line_1__c + ' ' + MasterJob.City__c + ' ' + MasterJob.State__c  + ' | ' + MasterJob.Date_Of_Loss__c;
                MasterJob.Name = MasterJob.Name.replace('00:00:00', '');     
                }else if(MasterJob.Address_Line_1__c != null && MasterJob.City__c != null && MasterJob.State__c != null){
                MasterJob.Name = MasterJob.Address_Line_1__c + ' ' + MasterJob.City__c + ' ' + MasterJob.State__c ; 

                }
                if(MasterJob.name.length() > 79){
                MasterJob.name = MasterJob.name.substring(0, 79);
                 }
        }
    }
    }
    public static void MasterJobNameUpdate(List<Master_Job__c> newMasterJobs, map<Id,Master_Job__c> oldMasterJobs){
        for(Master_Job__c MasterJob : newMasterJobs){
            if(MasterJob.Property__c != oldMasterJobs.get(MasterJob.Id).Property__c){
                if(MasterJob.Date_Of_Loss__c == oldMasterJobs.get(MasterJob.Id).Date_Of_Loss__c){
                    MasterJob.Name = MasterJob.Job_Address_Line_1__c + ' ' + MasterJob.Project_Site_City__c + ' ' + MasterJob.Project_Site_State__c; 
                }
                if(MasterJob.Date_Of_Loss__c != oldMasterJobs.get(MasterJob.Id).Date_Of_Loss__c){
                    MasterJob.Name = MasterJob.Job_Address_Line_1__c + ' ' + MasterJob.Project_Site_City__c + ' ' + MasterJob.Project_Site_State__c + ' | ' + MasterJob.Date_Of_Loss__c;
                }

            }
            if(MasterJob.Property__c == oldMasterJobs.get(MasterJob.Id).Property__c){
            if(MasterJob.Date_Of_Loss__c != oldMasterJobs.get(MasterJob.Id).Date_Of_Loss__c && MasterJob.Date_Of_Loss__c != null){
                MasterJob.Name = MasterJob.Job_Address_Line_1__c + ' ' + MasterJob.Project_Site_City__c + ' ' + MasterJob.Project_Site_State__c + ' | ' + MasterJob.Date_Of_Loss__c;
                MasterJob.Name = MasterJob.Name.replace('00:00:00', '');
                if(MasterJob.name.length() > 79){
                    MasterJob.name = MasterJob.name.substring(0, 79);
            }
        }
            
            }
        }
    }
}