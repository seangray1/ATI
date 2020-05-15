public with sharing class MasterJobTriggerHandler {
    public static void MasterJobNameFormat(List<Master_Job__c> MasterJobs) {
        Set<Id> mjobids = new Set<Id>();
        for(Master_Job__c MasterJob : MasterJobs){
            if(MasterJob.Property__c != null){
                if(MasterJob.Date_Of_Loss__c == null){
                MasterJob.Name = MasterJob.Job_Address_Line_1__c + ' ' + MasterJob.Project_Site_City__c + ' ' + MasterJob.Project_Site_State__c ; 
                }else{
                MasterJob.Name = MasterJob.Job_Address_Line_1__c + ' ' + MasterJob.Project_Site_City__c + ' ' + MasterJob.Project_Site_State__c +' | ' + MasterJob.Date_Of_Loss__c;  
                }
                if(MasterJob.name.length() > 79){
                    MasterJob.name = MasterJob.name.substring(0, 79);
                }
                
            }
            if(MasterJob.Property__c == null){
                if(MasterJob.Address_Line_1__c != null && MasterJob.City__c != null && MasterJob.City__c != null && MasterJob.State__c != null){
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
    public static void UpdateJobDetails(List<Master_Job__c> newMasterJobs, map<Id,Master_Job__c> oldMasterJobs, map<Id,Master_Job__c> newMasterJobsMap){
        Set<Id> MasterJobIdSet = new Set<Id>();
        List<ATI_Job__c> JobList = new List<ATI_Job__c>();
        for(Master_Job__c MasterJob : newMasterJobs){
            Master_Job__c oldJob = oldMasterJobs.get(MasterJob.Id);
            if(MasterJob.Date_of_loss__c != oldJob.Date_of_loss__c || MasterJob.Claim__c != oldJob.Claim__c || 
            MasterJob.Policy__c != oldJob.Policy__c || MasterJob.Deductible__c != oldJob.Deductible__c ||
            MasterJob.Date_of_loss__c != oldJob.Date_of_loss__c || MasterJob.Description_Of_Loss__c != oldJob.Description_Of_Loss__c ||
            MasterJob.Property__c != oldJob.Property__c){
                MasterJobIdSet.add(MasterJob.Id);
            }
        }
        //remember to do if statements to check if blank
        //query for jobs that need to be updated
        if(!MasterJobIdSet.isEmpty()){
        JobList = [Select Id, Date_Of_Loss__c, Claim__c, Deductible__c, Policy__c, Master_Job__c, Property_ID__c, Description_Of_Loss__c FROM ATI_Job__c Where Master_Job__c =: MasterJobIdSet];
        if(!JobList.isEmpty()){
        for(ATI_Job__c job : JobList){
            Master_job__c newMasterJob = newMasterJobsMap.get(job.Master_job__c);
            job.Date_Of_Loss__c = newMasterJob.Date_of_Loss__c;
            job.Claim__c = newMasterJob.Claim__c;
            job.Deductible__c = newMasterJob.Deductible__c;
            job.Policy__c = newMasterJob.Policy__c;
            job.Property_ID__c = newMasterJob.Property__c;
            job.Description_Of_Loss__c = newMasterJob.Description_Of_Loss__c;
        }
        Update JobList;
    }

}
    }
}