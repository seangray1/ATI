public without sharing class MasterJobTriggerHandler {
    public static final string Job_CREDIT_REQ_STATUS = 'Approved';
    public static final string PROFILE_MARKETING_REP = 'Marketing Representative';
    public static final string Job_TEAM_ROLE_ACC_EXEC1 = 'Account Executive 1';
    public static final string Job_TEAM_ROLE_ACC_EXEC2 = 'Account Executive 2';
    public static final string TASK_TYPE_LUNCH_LEARN = 'Lunch and Learn';
    public static final string Job_RTYPE_JOB_APPROVED_DEV_NAME = 'Job_Approved';

    public static void MasterJobNameFormat(List<Master_Job__c> MasterJobs) 
    {
        Set<Id> mjobids = new Set<Id>();
        for(Master_Job__c MasterJob : MasterJobs){
            if(MasterJob.Property__c != null){
                if(MasterJob.Date_Of_Loss__c == null){
                MasterJob.Name = MasterJob.Job_Address_Line_1__c + ' ' + MasterJob.Project_Site_City__c + ' ' + MasterJob.Project_Site_State__c ; 
                }else{
                MasterJob.Name = MasterJob.Job_Address_Line_1__c + ' ' + MasterJob.Project_Site_City__c + ' ' + MasterJob.Project_Site_State__c +' | ' + MasterJob.Date_Of_Loss__c;
                MasterJob.Name = MasterJob.Name.replace('00:00:00', '');   
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
    public static void MasterJobNameUpdate(List<Master_Job__c> newMasterJobs, map<Id,Master_Job__c> oldMasterJobs, map<Id, Master_Job__c> newMasterJobsMap){
        Set<String> creditReqEmails = new Set<String>();
        for(Master_Job__c MasterJob : newMasterJobs)
        {
            
            Master_Job__c oldJob = oldMasterJobs.get(MasterJob.Id);
            // if(MasterJob.Send_Prelim__c != oldJob.Send_Prelim__c)
            // {
            //     MasterJob.Send_Prelim_Last_Modified_Date_Time1__c = system.now();
            //     MasterJob.Send_Prelim_Last_Modified_Date_Time__c = UserInfo.getUserName();
            //     if(MasterJob.Send_prelim__c == 'Yes')
            //     {
            //         MasterJob.PN_Request_Date__c = system.today();
            //     }
            // }
            if( MasterJob.Credit_Request_Status__c != oldJob.Credit_Request_Status__c && 
                MasterJob.Credit_Request_Status__c == Job_CREDIT_REQ_STATUS )
            {
                if( MasterJob.Credit_Request_Submitter_Email__c != null )
                {
                    creditReqEmails.add( MasterJob.Credit_Request_Submitter_Email__c );        
                }
            }
            
            if(MasterJob.Property__c != oldMasterJobs.get(MasterJob.Id).Property__c){
                if(MasterJob.Date_Of_Loss__c == null){
                    MasterJob.Name = MasterJob.Job_Address_Line_1__c + ' ' + MasterJob.Project_Site_City__c + ' ' + MasterJob.Project_Site_State__c; 
                }
                if(MasterJob.Date_Of_Loss__c != null){
                    MasterJob.Name = MasterJob.Job_Address_Line_1__c + ' ' + MasterJob.Project_Site_City__c + ' ' + MasterJob.Project_Site_State__c + ' | ' + MasterJob.Date_Of_Loss__c;
                    MasterJob.Name = MasterJob.Name.replace('00:00:00', ''); 
                }

            }
            if(MasterJob.Property__c == oldMasterJobs.get(MasterJob.Id).Property__c)
            {
                if(MasterJob.Date_Of_Loss__c != oldMasterJobs.get(MasterJob.Id).Date_Of_Loss__c && MasterJob.Date_Of_Loss__c != null)
                {
                    MasterJob.Name = MasterJob.Job_Address_Line_1__c + ' ' + MasterJob.Project_Site_City__c + ' ' + MasterJob.Project_Site_State__c + ' | ' + MasterJob.Date_Of_Loss__c;
                    MasterJob.Name = MasterJob.Name.replace('00:00:00', '');
                    if(MasterJob.name.length() > 79)
                    {
                        MasterJob.name = MasterJob.name.substring(0, 79);
                    }
                }
            
            }
        }
        if( !creditReqEmails.isEmpty() )
        {
            Map<String, Id> userEmailToId = new Map<String, Id>();
            for( User u : [ SELECT Id, Email FROM User WHERE Email IN : creditReqEmails] )
            {
                userEmailToId.put( u.email, u.id );
            }
            for( Master_Job__c job : newMasterJobsMap.values() )
            {
                Master_Job__c oldJob = oldMasterJobs.get( job.Id );
                if( job.Credit_Request_Status__c != oldJob.Credit_Request_Status__c && 
                job.Credit_Request_Status__c == Job_CREDIT_REQ_STATUS && job.Credit_Request_Submitter_Email__c != null )
                {
                    Id currentUserId = userEmailToId.get( job.Credit_Request_Submitter_Email__c );    
        //If there is already an AE 1 associated with that job that the requester is requesting credit for, 
        //instead of wiping all AE's out we would add the requester as AE 2 and set both AE 1 and AE 2 to a 50% split. 
                    if( job.Account_Executive_1__c != null && job.Account_Executive_2__c == null && 
                        job.Account_Executive_1__c != currentUserId )
                    {
                        job.Account_Executive_2__c = currentUserId; 
                    }
                    else if( job.Account_Executive_2__c != null && job.Account_Executive_1__c == null && 
                    job.Account_Executive_2__c != currentUserId )
                    {
                        job.Account_Executive_1__c = currentUserId; 
                    }
                    else if( job.Account_Executive_1__c == null && job.Account_Executive_2__c == null )
                    {
                        //If there is not an AE 1, then the Requester is added as the AE 1 with a 100% split (as is happening now)
                        job.Account_Executive_1__c = currentUserId;
                    }
                    else if( job.Account_Executive_1__c != null && job.Account_Executive_2__c != null &&
                            job.Account_Executive_1__c != currentUserId )
                    {
                                //If there is already an AE 1 and an AE 2 on a job and someone requests credit, 
                                //then it gives them an error(already an AE1 And AE 2 assigned, please contact the Marketing Manager etc.)
                                job.addError( 'You may not request credit for a job with 2 AE\'s assigned. Please contact Marketing Manager'+
                                                ' for assistance' );
                    }
                }
            }            
        }
    }
public static void UpdateJobDetails(List<Master_Job__c> newMasterJobs, map<Id,Master_Job__c> oldMasterJobs, map<Id,Master_Job__c> newMasterJobsMap){
    Set<Id> MasterJobIdSet = new Set<Id>();
    
    List<ATI_Job__c> JobList = new List<ATI_Job__c>();

    for(Master_Job__c MasterJob : newMasterJobs)
    {
        system.debug('Master Job' + MasterJob);
        //lead source 
        Master_Job__c oldJob = oldMasterJobs.get(MasterJob.Id);
        //For AE Assignment after Request Credit is Approved
        

        if(MasterJob.AfterHoursUpdate__c == oldjob.AfterHoursUpdate__c)
        {
            system.debug('Old Master Job ' + oldJob);
            system.debug('New Lead source ' + MasterJob.Lead_Source__c + '   Old Lead Source is ' + oldJob.Lead_Source__c);
            if(MasterJob.Date_of_loss__c != oldJob.Date_of_loss__c || MasterJob.Claim__c != oldJob.Claim__c || 
            MasterJob.Policy__c != oldJob.Policy__c || MasterJob.Deductible__c != oldJob.Deductible__c ||
            MasterJob.Date_of_loss__c != oldJob.Date_of_loss__c || MasterJob.Lead_Source__c != oldJob.Lead_Source__c ||
            MasterJob.Property__c != oldJob.Property__c || MasterJob.PO__c != oldJob.PO__c
            || MasterJob.Account_Executive_1__c != oldJob.Account_Executive_1__c || MasterJob.Account_Executive_2__c != oldJob.Account_Executive_2__c
            || MasterJob.Office2__c != oldJob.Office2__c || MasterJob.Office2__c != oldJob.Office2__c ||
            MasterJob.Lead_Source__c != oldJob.Lead_Source__c || MasterJob.Major_Event__c != oldJob.Major_Event__c ||
            MasterJob.National_Project_Manager__c != oldJob.National_Project_Manager__c ||  MasterJob.Cont_P_O_Client_Job__c != oldJob.Cont_P_O_Client_Job__c
            || (MasterJob.Force_Master_Job_Sync__c == true && MasterJob.Force_Master_Job_Sync__c != oldJob.Force_Master_Job_Sync__c))
            {
                system.debug('Passed');
                MasterJobIdSet.add(MasterJob.Id);
            }
        }
    }
    
    // || MasterJob.Send_Prelim__c != oldJob.Send_Prelim__c ||
    // MasterJob.PN_Request_Date__c != oldJob.PN_Request_Date__c || MasterJob.PN_Amount__c != oldJob.PN_Amount__c || MasterJob.ML_amount__c != oldJob.ML_amount__c ||
    // MasterJob.PN_Recording_Number__c != oldJob.PN_Recording_Number__c || MasterJob.ML_Recording_Number__c != oldJob.ML_Recording_Number__c || 
    // MasterJob.ML_Request_Date__c != oldJob.ML_Request_Date__c || MasterJob.ML_Release_Recording_Date__c != oldJob.ML_Release_Recording_Date__c ||
  
// remember to do if statements to check if blank
// query for jobs that need to be updated
    if(!MasterJobIdSet.isEmpty())
    {
        JobList = [Select Id, Date_Of_Loss__c, Claim__c, Deductible__c, Policy__c, Master_Job__c, Property_ID__c, Description__c, Account_Executive_1__c, Account_Executive_2__c FROM ATI_Job__c Where Master_Job__c =: MasterJobIdSet];
        if(!JobList.isEmpty())
        {
            for(ATI_Job__c job : JobList)
            {
                system.debug('Test is it hits ');
                Master_job__c newMasterJob = newMasterJobsMap.get(job.Master_job__c);
                job.Date_Of_Loss__c = newMasterJob.Date_of_Loss__c;
                job.Claim__c = newMasterJob.Claim__c;
                job.Deductible__c = newMasterJob.Deductible__c;
                job.Policy__c = newMasterJob.Policy__c;
                job.Property_ID__c = newMasterJob.Property__c;
                job.PO__c = newMasterJob.PO__c;
                job.Account_Executive_1__c = newMasterJob.Account_Executive_1__c;
                job.Account_Executive_2__c = newMasterJob.Account_Executive_2__c;
                job.Office2__c = newMasterJob.Office2__c;
                
                // job.Send_Prelim__c = newMasterJob.Send_Prelim__c;
                // job.Send_Prelim_Last_Modified_Date_Time__c = newMasterJob.Send_Prelim_Last_Modified_Date_Time1__c;
                // job.Send_Prelim_Last_Modified_By__c = newMasterJob.Send_Prelim_Last_Modified_Date_Time__c;
                // job.PN_Request_Date__c = newMasterJob.PN_Request_Date__c;
                // job.PN_Amount__c = newMasterJob.PN_Amount__c;
                // job.PN_Recording_Number__c = newMasterJob.PN_Recording_Number__c;
                // job.PN_Recording_Date__c = newMasterJob.PN_Recording_Date__c;
                // job.ML_amount__c = newMasterJob.ML_amount__c;
                // job.ML_Recording_Number__c = newMasterJob.ML_Recording_Number__c;
                // job.ML_Recording_Date__c = newMasterJob.ML_Recording_Date__c;
                // job.ML_Release_Recording_Date__c = newMasterJob.ML_Release_Recording_Date__c;
                // job.ML_Request_Date__c = newMasterJob.ML_Request_Date__c;
                job.Cont_P_O_Client_Job__c = newMasterJob.Cont_P_O_Client_Job__c;
                job.Lead_Source__c = newMasterJob.Lead_Source__c;
                job.Office2__c = newMasterJob.Office2__c;
                //job.Office2__c = newMasterJob.Regional_Manager__c;
                job.Major_Event__c = newMasterJob.Major_Event__c;
                job.National_Project_Manager__c = newMasterJob.National_Project_Manager__c;
               
                
            }
            update JobList;
        }
    }

}
}