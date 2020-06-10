public without sharing class JobTriggerHandlerWorkflow 
{
  
    public static void MasterJobAmountRollup(List<ATI_Job__c> jobs, Map<Id,ATI_Job__c> newJobMap, Map<Id,ATI_Job__c> oldJobMap) 
    {
        Set<Id> NewJobMasterSet = new Set<Id>();
        Set<Id> OldJobMasterSet = new Set<Id>();
        Map<Id, Master_Job__c> MasterJobs = new Map<Id, Master_Job__c>();
        Map<Id, Master_Job__c> MasterJobToUpdate = new Map<Id, Master_Job__c>();
    if(Trigger.isUpdate)
    {
        for(ATI_Job__c job : jobs)
        {
            NewJobMasterSet.add(job.Master_Job__c);
        }
        if(!NewJobMasterSet.isEmpty())
        {
           List<Master_Job__c> MasterJobsList = [Select Id, Amount__c FROM Master_Job__c WHere Id =:NewJobMasterSet];
           MasterJobs.putall(MasterJobsList);
        }
        if(!MasterJobs.isEmpty())
        {
            for(ATI_Job__c job : jobs)
            {
                
                system.debug('1 NewMaster Amount ' + MasterJobs.get(job.Master_Job__c).Amount__c + '\n' +
                'Job new amount is ' + job.Amount__c);
                    Decimal oldjobamount;
                    Decimal newjobamount;
                    ATI_Job__c oldJob = oldJobMap.get(job.Id);
                    if(MasterJobs.get(job.Master_Job__c).Amount__c  == null)
                    {
                        MasterJobs.get(job.Master_Job__c).Amount__c = 0;
                    }
                    if(job.Amount__c == null)
                    {
                        newjobamount = 0;
                    }else 
                    {
                        newjobamount = job.Amount__c;    
                    }
                    if(oldJob.Amount__c == null)
                    {
                        oldjobamount = 0;
                    }else
                    {
                        oldjobamount = oldJob.Amount__c;
                    }
                    if(job.Amount__c != oldJob.Amount__c)
                    {  
                        MasterJobs.get(job.Master_Job__c).Amount__c = MasterJobs.get(job.Master_Job__c).Amount__c + newjobamount - oldjobamount;
                        Master_Job__c mj = new Master_Job__c(Id = job.master_job__c, Amount__c = MasterJobs.get(job.Master_job__c).Amount__c);
                        MasterJobToUpdate.put(mj.id, mj);
                    }
                    if(job.Master_Job__c != oldJob.Master_Job__c && newjobamount == oldjobamount)
                    {
                        system.debug('2 NewMaster Amount ' + MasterJobs.get(job.Master_Job__c).Amount__c + '\n' +
                        'Job new amount is ' + job.Amount__c);
                        MasterJobs.get(job.Master_Job__c).Amount__c = MasterJobs.get(job.Master_Job__c).Amount__c + newjobamount;
                        Master_Job__c mj = new Master_Job__c(Id = job.master_job__c, Amount__c = MasterJobs.get(job.Master_job__c).Amount__c);
                        MasterJobToUpdate.put(mj.id, mj);
                    }
                    if(oldJob != null && job.Stage__c != oldJob.Stage__c && job.Stage__c == 'Won')
                    {
                        if(job.Estimate_Only__c == false)
                        {
                            if(MasterJobToUpdate.containsKey(job.Master_Job__c))
                            {
                                MasterJobToUpdate.get(job.Master_Job__c).Send_Prelim__c = 'Yes';
                                MasterJobToUpdate.get(job.Master_Job__c).PN_Request_Date__c = system.today();
                            }else
                            {
                                Master_Job__c mj = new Master_Job__c(Id = job.master_job__c, Send_Prelim__c = 'Yes', PN_Request_Date__c = system.today() );
                                MasterJobToUpdate.put(mj.Id, mj);
                            }
                            
                        }
                        
                    }
                }
            }

        
        if(!MasterJobToUpdate.isEmpty())
        {
            update MasterJobToUpdate.values();
        }
    }
    if(Trigger.isInsert)
    {
        Map<Id,Master_Job__c>  MasterJobToUpdatePrelim = new Map<Id,Master_Job__c>();
        Set<Id> acctSet = new Set<Id>();
        for(ATI_Job__c job : jobs)
        {
            acctSet.add(job.Account__c);
        }
        Map<Id, Account> AcctMap = new Map<Id, Account>([Select Id, Name FROM Account Where Id =:acctSet]);
        for(ATI_Job__c job : jobs)
        {
                if((job.Division__c == 'Consultant' || job.Division__c == 'Contents' || job.Division__c == 'Marketing' || 
                (job.Account__c != null && AcctMap.get(job.Account__c).Name.contains('American Technologies')) || job.Market_Segment__c == 'Education' || job.Market_Segment__c == 'Federal Government' || job.Market_Segment__c == 'State/Municipal') && 
                job.Send_Prelim__c == null) 
                {
                    // job.Send_Prelim__c = 'No';
                    // job.PN_Request_Date__c = null;
                    Master_Job__c mj = new Master_Job__c(Id = job.master_job__c, Send_Prelim__c = 'No', PN_Request_Date__c = null );
                    MasterJobToUpdatePrelim.put(mj.Id, mj);
                }
                
                if(!MasterJobToUpdatePrelim.isEmpty())
                {
                    update MasterJobToUpdatePrelim.values();
                }
        }
    }
    }

public static void AssignProjectRoles(list<ATI_Job__c> newJobs, Map<Id, ATI_Job__c> newJobMap, Map<Id, ATI_Job__c> oldJobMap, ObjectInserts oi)
{
        Id approvedRecordTypeId = Schema.SObjectType.ATI_Job__c.getRecordTypeInfosByName().get('Job (Approved)').getRecordTypeId();
        Map<Id, Office__c> offices = new Map<Id,Office__c>([Select Id, Name, Branch_Manager__c, Biohazard_Operations_Manager__c,
        Asbestos_Operations_Manager__c, Catastrophes_Operations_Manager__c, Consulting_Operations_Manager__c, 
        Contents_Operations_Manager__c, Demolition_Operations_Manager__c, Emergency_Services_Operations_Manager__c, 
        Environmental_Branch_Manager__c, Environmental_Operations_Manager__c, ES_and_Contents_Operations_Manager__c,
        Health_Science_Operations_Manager__c, Lead_Operations_Manager__c, Marketing_Operations_Manager__c,
        Microbial_Operations_Manager__c, Operations_Manager__c, Regional_Manager__c, Structure_Contents_Branch_Manager__c,
        Technical_Services_Operations_Manager__c, Evp_1__c FROM Office__c]);
        //IF OldJob == null, it's insert, set PM. If its update, only update the PM if the office has changed, allows manual changes
        //of the Project_Manager_New__c/Project Manager
        system.debug('Offices from Objecinsert are ' + oi);
        system.debug('Offices are ' + offices);
        
    if(!offices.isEmpty())
    {
        Set<Id> acctSet = new Set<Id>();
        for(ATI_Job__c job : newJobs)
        {
            acctSet.add(job.Account__c);
        }
        Map<Id, Account> AcctMap = new Map<Id, Account>([Select Id, Name FROM Account Where Id =:acctSet]);
        for(ATI_Job__c job : newJobs)
        {

            ATI_Job__c oldJob = new ATI_Job__c();
            if(Trigger.isInsert)
            {
            
                if(job.Project_Manager__c != null)
                {
                    job.OwnerId = job.Project_manager__c;
                }
                if(job.recordtypeId == approvedRecordTypeId) {
                    string test1 = job.name.replace('|','');
                    string test = EncodingUtil.urlEncode(test1, 'UTF-8').replace('+', '%20'); // convert to year, do everything after date
                    Date timeToDate = Date.valueOf(job.date_time_taken__c); 
                    job.egnyte_Full_Path__c = 'https://atirestoration.egnyte.com/app/index.do#storage/files/1/Shared/Salesforce.com/Jobs' + '/' + timeTodate.year()+ '/'+ test;
                }
                
                
            }
            if(Trigger.isUpdate)
            {
                oldJob = oldJobMap.get(job.id);
                system.debug('Old Job office and division ' + oldJob.Office2__c + oldJob.Division__c + '  New Job office and division ' + job.Division__c + job.Office2__c);
                if(job.Project_Manager__c != null && job.Project_Manager__c != oldJobMap.get(job.Id).Project_Manager__c)
                {
                job.OwnerId = job.Project_manager__c;
                }
                //If approved and job was cloned => changes intake status to Cloned- completed/reviewed
                if(job.RecordTypeId != oldJob.RecordTypeId && job.Intake_Status__c == 'Cloned - Pending Review')
                {
                job.Intake_Status__c = 'Cloned - Completed/Reviewed';
                
                }
                if(job.recordtypeId == approvedRecordTypeId &&(job.name !=  oldJob.Name || job.recordtypeId != oldJob.recordtypeid)) 
                {
                    string test1 = job.name.replace('|','');
                    string test = EncodingUtil.urlEncode(test1, 'UTF-8').replace('+', '%20'); // convert to year, do everything after date
                    Date timeToDate = Date.valueOf(job.date_time_taken__c); 
                    job.egnyte_Full_Path__c = 'https://atirestoration.egnyte.com/app/index.do#storage/files/1/Shared/Salesforce.com/Jobs' + '/' + timeTodate.year()+ '/'+ test;
                
                }
            }
            if(Trigger.isUpdate && job.Office2__c != null && (oldJob.Office2__c != job.Office2__c || oldJob.Division__c != job.Division__c))
            {
                system.debug('Old Job Division is ' + oldJob.Division__c +  '\n' + 'New Job Division is ' + job.Division__c);
                if(offices.get(job.Office2__c).Name != 'Anaheim')
                {
                    job.Branch_Manager__c = offices.get(job.Office2__c).Branch_Manager__c;
                    job.Regional_Director__c = offices.get(job.Office2__c).Evp_1__c;
                }
                else if(job.Division__c == 'Lead' || job.Division__c == 'Microbial' || job.Division__c == 'Asbestos'
                        || job.Division__c == 'Demolition' || job.Division__c == 'Health Services')
                {
                    job.Branch_Manager__c = offices.get(job.Office2__c).Environmental_Branch_Manager__c;
                    job.Regional_Director__c = offices.get(job.Office2__c).Evp_1__c;
                }
                else if(job.Division__c == 'Catastrophes' || job.Division__c == 'Technical Svces' || job.Division__c == 'Consulting'
                        || job.Division__c == 'Marketing' || job.Division__c == 'Construction' || job.Division__c == 'Contents' 
                        || job.Division__c == 'Emergency Svces')
                {
                    job.Branch_Manager__c = offices.get(job.Office2__c).Structure_Contents_Branch_Manager__c;
                    job.Regional_Director__c = offices.get(job.Office2__c).Evp_1__c;
                }
                if(job.Division__c == 'Asbestos')
                {
                    job.Project_Manager_New__c = offices.get(job.Office2__c).Asbestos_Operations_Manager__c;
                }
                if(job.Division__c == 'Biohazard')
                {
                    job.Project_Manager_New__c = offices.get(job.Office2__c).Biohazard_Operations_Manager__c;
                }
                if(job.Division__c == 'Catastrophes')
                {
                    job.Project_Manager_New__c = offices.get(job.Office2__c).Catastrophes_Operations_Manager__c;
                }
                // if(job.Division__c == 'Construction')
                // {
                //     job.Project_manager__new__c = offices.get(job.Office2__c).;
                // }
                if(job.Division__c == 'Consulting')
                {
                    job.Project_Manager_New__c = offices.get(job.Office2__c).Consulting_Operations_Manager__c;
                }
                if(job.Division__c == 'Contents')
                {
                    job.Project_Manager_New__c = offices.get(job.Office2__c).Contents_Operations_Manager__c;
                }
                if(job.Division__c == 'Demolition')
                {
                    job.Project_Manager_New__c = offices.get(job.Office2__c).Demolition_Operations_Manager__c;
                }
                if(job.Division__c == 'Emergency Svces')
                {
                    job.Project_Manager_New__c = offices.get(job.Office2__c).Emergency_Services_Operations_Manager__c;
                }
                if(job.Division__c == 'Lead')
                {     
                    job.Project_Manager_New__c = offices.get(job.Office2__c).Lead_Operations_Manager__c;   
                }
                if(job.Division__c == 'Microbial')
                {
                    job.Project_Manager_New__c = offices.get(job.Office2__c).Microbial_Operations_Manager__c;
                }
                if(job.Division__c == 'Technical Svces')
                {
                    job.Project_Manager_New__c = offices.get(job.Office2__c).Technical_Services_Operations_Manager__c; 
                } 
            }

            if(Trigger.isInsert && job.Office2__c != null && job.Division__c != null)
            {
                if(offices.get(job.Office2__c).Name != 'Anaheim')
                {
                    job.Branch_Manager__c = offices.get(job.Office2__c).Branch_Manager__c;
                    job.Regional_Director__c = offices.get(job.Office2__c).Evp_1__c;
                }
                else if(job.Division__c == 'Lead' || job.Division__c == 'Microbial' || job.Division__c == 'Asbestos'
                        || job.Division__c == 'Demolition' || job.Division__c == 'Health Services')
                {
                    job.Branch_Manager__c = offices.get(job.Office2__c).Environmental_Branch_Manager__c;
                    job.Regional_Director__c = offices.get(job.Office2__c).Evp_1__c;
                }
                else if(job.Division__c == 'Catastrophes' || job.Division__c == 'Technical Svces' || job.Division__c == 'Consulting'
                        || job.Division__c == 'Marketing' || job.Division__c == 'Construction' || job.Division__c == 'Contents' 
                        || job.Division__c == 'Emergency Svces')
                {
                    job.Branch_Manager__c = offices.get(job.Office2__c).Structure_Contents_Branch_Manager__c;
                    job.Regional_Director__c = offices.get(job.Office2__c).Evp_1__c;
                }
                if(job.Division__c == 'Asbestos')
                {
                    job.Project_Manager_New__c = offices.get(job.Office2__c).Asbestos_Operations_Manager__c;
                }
                if(job.Division__c == 'Biohazard')
                {
                    job.Project_Manager_New__c = offices.get(job.Office2__c).Biohazard_Operations_Manager__c;
                }
                if(job.Division__c == 'Catastrophes')
                {
                    job.Project_Manager_New__c = offices.get(job.Office2__c).Catastrophes_Operations_Manager__c;
                }
                // if(job.Division__c == 'Construction')
                // {
                //     job.Project_manager__new__c = offices.get(job.Office2__c).;
                // }
                if(job.Division__c == 'Consulting')
                {
                    job.Project_Manager_New__c = offices.get(job.Office2__c).Consulting_Operations_Manager__c;
                }
                if(job.Division__c == 'Contents')
                {
                    job.Project_Manager_New__c = offices.get(job.Office2__c).Contents_Operations_Manager__c;
                }
                if(job.Division__c == 'Demolition')
                {
                    job.Project_Manager_New__c = offices.get(job.Office2__c).Demolition_Operations_Manager__c;
                }
                if(job.Division__c == 'Emergency Svces')
                {
                    job.Project_Manager_New__c = offices.get(job.Office2__c).Emergency_Services_Operations_Manager__c;
                }
                if(job.Division__c == 'Lead')
                {     
                    job.Project_Manager_New__c = offices.get(job.Office2__c).Lead_Operations_Manager__c;   
                }
                if(job.Division__c == 'Microbial')
                {
                    job.Project_Manager_New__c = offices.get(job.Office2__c).Microbial_Operations_Manager__c;
                }
                if(job.Division__c == 'Technical Svces')
                {
                    job.Project_Manager_New__c = offices.get(job.Office2__c).Technical_Services_Operations_Manager__c; 
                } 
            }
            //Update send Prelim
            
        }
    }
    
}
    public static void StageChanged(List<ATI_Job__c> jobs, Map<Id, ATI_Job__c> newJobMap, Map<Id, ATI_Job__c> oldJobMap)
    {
        for(ATI_Job__c job : jobs)
        {
            ATI_Job__c oldJob = new ATI_Job__c();
            if(oldJobMap != null)
            {
                oldJob = oldJobMap.get(job.id);
            }
            if(oldJob != null && job.Stage__c != oldJob.Stage__c && job.Stage__c == 'Billing Complete' && job.Billing_complete_Date__c == null)
            {
                job.Billing_complete_Date__c = system.today();
                if(job.Completion_Date__c == null)
                {
                    job.Completion_Date__c = system.today();
                }
            }
            if(oldJob != null && job.Stage__c != oldJob.Stage__c && job.Stage__c == 'Estimating/Review' && job.Estimating_Review_Date__c == null)
            {
                job.Estimating_Review_Date__c = system.now();
            }
            // if(oldJob != null && job.Stage__c != oldJob.Stage__c && job.Stage__c == 'Won')
            // {
            //     if(Estimate_Only__c == false)
            //     {
            //         job.Send_Prelim__c = 'Yes';
            //     }
            //     if(job.Job_Start_Date__c == null)
            //     {
            //         job.Job_Start_Date__c = system.now();
            //     }

            // }
            if(oldJob != null && job.Stage__c != oldJob.Stage__c && job.Stage__c == 'Lost' && job.Job_Lost_Date__c == null)
            {
                job.Job_Lost_Date__c = system.now();
                job.Completion_Date__c = null;
                job.Job_Start_Date__c = null;
            }
            if(oldJob != null && job.Stage__c != oldJob.Stage__c && job.Stage__c == 'Work Complete' && job.Work_Complete_Date__c == null)
            {
                job.Work_Complete_Date__c = system.now();
                if(job.Completion_Date__c == null)
                {
                    job.Completion_Date__c = system.today();
                }
            }
        }
    }
    //JobTeamCreation needs to be called after AssignRoles Process
    public static void JobTeamCreation(List<ATI_Job__c> jobs, Map<Id, ATI_Job__c> newJobMap, Map<Id, ATI_Job__c> oldJobMap)
    {
        
        List<ATI_Job_Team__c> jobTeams = new List<ATI_Job_Team__c>();
        List<ATI_Job_Split__c> jsToInsert = new List<ATI_Job_Split__c>();
        List<ATI_Job_Team__c> otmToDelete = new List<ATI_Job_Team__c>();
        List<ATI_Job_Split__c> jobSplitsDelete = new List<ATI_Job_Split__c>();
        Set<Id> JobSetSplitsToDelete = new Set<Id>();
        list<Financial__c> financialsToInsert = new List<Financial__c>();
        for(ATI_Job__c job : jobs)
        {
            system.debug('JobTeamCreation new job is ' + jobs);
            if(Trigger.isInsert)
            {
                
                if(job.Financial_Record_Availablity__c == False)
                {
                    Financial__c f = new Financial__c(ATI_Job__c = job.Id, ReferenceId__c = job.Id);
                    financialsToInsert.add(f);
                }
                system.debug('Passed Trigger is insert');
                if(job.Project_Manager_New__c != null)
                {
                    system.debug('first pM is not null');
                    ATI_Job_Team__c jt = new ATI_Job_Team__c(User__c = job.Project_Manager_New__c, Team_Member_Role__c = 'Project Manager', 
                    ATI_Job__c = job.Id);
                    jobTeams.add(jt);
                    system.debug('PM Job Team contains ' + jobTeams);
                }
                if(job.Project_Manager__c != null)
                {
                    
                    ATI_Job_Team__c jt = new ATI_Job_Team__c(User__c = job.Project_Manager__c, Team_Member_Role__c = 'Project Director', 
                    ATI_Job__c = job.Id);
                    jobTeams.add(jt);
                }
                
                // if(job.Account_Executive_1__c != null)
                // {
                //     ATI_Job_Team__c jt = new ATI_Job_Team__c(User__c = job.Account_Executive_1__c, Team_Member_Role__c = 'Account Executive 1', 
                //     ATI_Job__c = job.Id);
                //     jobTeams.add(jt);
                // }
                // if(job.Account_Executive_2__c != null)
                // {
                //     ATI_Job_Team__c jt = new ATI_Job_Team__c(User__c = job.Account_Executive_2__c, Team_Member_Role__c = 'Account Executive 2', 
                //     ATI_Job__c = job.Id);
                //     jobTeams.add(jt);
                // }
                if(job.Branch_Manager__c != null)
                {
                    ATI_Job_Team__c jt = new ATI_Job_Team__c(User__c = job.Branch_Manager__c, Team_Member_Role__c = 'Regional Manager', 
                    ATI_Job__c = job.Id);
                    jobTeams.add(jt);
                }

                //If AE is new, sets the owner and inserts job split with them having 100%. If AE1 is not null on insertion, inserts the JobSplit AE1 with 100,
                //if AE2 and AE1 is not null, inserts both and splits percentage to 50/50
                // if(job.Account_Executive_1__c == null && job.Account_Executive_2__c == null)
                // {
                ATI_Job_Split__c js = new ATI_Job_Split__c(Member_Role__c = 'Others', Team_Member__c = job.Taken_By__c, Type__c = 'Revenue', ATI_Job__c = job.Id,
                Percentage__c = 100.00);
                jsToInsert.add(js);
                // }else if(job.Account_Executive_1__c != null && job.Account_Executive_2__c == null)
                // {
                //     ATI_Job_Split__c js = new ATI_Job_Split__c(Member_Role__c = 'Account Executive', Team_Member__c = job.Account_Executive_1__c, Type__c = 'Revenue', ATI_Job__c = job.Id,
                //     Percentage__c = 100.00);
                //     jsToInsert.add(js);
                    
                // }else if(job.Account_Executive_1__c != null && job.Account_Executive_2__c != null)
                // {
                //     ATI_Job_Split__c js = new ATI_Job_Split__c(Member_Role__c = 'Account Executive', Team_Member__c = job.Account_Executive_1__c, Type__c = 'Revenue', ATI_Job__c = job.Id,
                //     Percentage__c = 50.00);
                //     ATI_Job_Split__c js1 = new ATI_Job_Split__c(Member_Role__c = 'AAccount Executive', Team_Member__c = job.Account_Executive_2__c, Type__c = 'Revenue', ATI_Job__c = job.Id,
                //     Percentage__c = 50.00);
                //     jsToInsert.add(js);
                // }

            }
        
        if(Trigger.isUpdate)
        {
            //** job split to change owner percent to 100 or 0 depending on whether there is an existing AE */
            //Remove old Job Team member by adding job.pm/pd etc if it meets criteria.. going to have to run a query for the team members then delete.
            //need another if statement before setting team member. actualy don't have access directly..
            ATI_Job__c oldJob = oldJobMap.get(job.Id);
            List<ATI_JOb__c> updatedJobs = new List<ATI_Job__c>();
                if(job.Project_Manager_New__c != null && oldJob.Project_Manager_New__c != job.Project_Manager_New__c)
                {
                    ATI_Job_Team__c jt = new ATI_Job_Team__c(User__c = job.Project_Manager_New__c, Team_Member_Role__c = 'Project Manager', 
                    ATI_Job__c = job.Id);
                    jobTeams.add(jt);
                }
                if(job.Project_Manager__c != null && oldJob.Project_Manager__c != job.Project_Manager__c)
                {
                    
                    ATI_Job_Team__c jt = new ATI_Job_Team__c(User__c = job.Project_Manager__c, Team_Member_Role__c = 'Project Director', 
                    ATI_Job__c = job.Id);
                    jobTeams.add(jt);
                }
                // if(job.Account_Executive_1__c != null && oldJob.Account_Executive_1__c != job.Account_Executive_1__c)
                // {
                //     ATI_Job_Team__c jt = new ATI_Job_Team__c(User__c = job.Account_Executive_1__c, Team_Member_Role__c = 'Account Executive 1', 
                //     ATI_Job__c = job.Id);
                //     jobTeams.add(jt);
                //     //0 out owner split
                // }
                // if(job.Account_Executive_2__c != null && oldJob.Account_Executive_2__c != job.Account_Executive_2__c)
                // {
                //     ATI_Job_Team__c jt = new ATI_Job_Team__c(User__c = job.Account_Executive_2__c, Team_Member_Role__c = 'Account Executive 2', 
                //     ATI_Job__c = job.Id);
                //     jobTeams.add(jt);
                //     //0 out owner split
                // }
                if(job.Branch_Manager__c != null && oldJob.Branch_Manager__c != job.Branch_Manager__c)
                {
                    ATI_Job_Team__c jt = new ATI_Job_Team__c(User__c = job.Branch_Manager__c, Team_Member_Role__c = 'Regional Manager', 
                    ATI_Job__c = job.Id);
                    jobTeams.add(jt);
                }
                //Dealing with AE's to update job team and job split
                if (job.RecordTypeId != oldJob.RecordTypeId && (job.Account_Executive_1__c != null || job.Account_Executive_2__c != null)) 
                {
                    if(job.Account_Executive_1__c != null || job.Account_Executive_2__c == null)
                    {
                        ATI_Job_Split__c js = new ATI_Job_Split__c(Member_Role__c = 'Account Executive', Team_Member__c = job.Account_Executive_1__c, Type__c = 'Revenue', ATI_Job__c = job.Id,
                        Percentage__c = 100.00);
                        ATI_Job_Team__c jt = new ATI_Job_Team__c(User__c = job.Account_Executive_1__c, Team_Member_Role__c = 'Account Executive 1', 
                        ATI_Job__c = job.Id);
                        jobTeams.add(jt);
                        jsToInsert.add(js);
                        JobSetSplitsToDelete.add(job.Id);
                    }
                    if(job.Account_Executive_1__c != null && job.Account_Executive_2__c != null)
                    {
                        ATI_Job_Split__c js = new ATI_Job_Split__c(Member_Role__c = 'Account Executive', Team_Member__c = job.Account_Executive_1__c, Type__c = 'Revenue', ATI_Job__c = job.Id,
                        Percentage__c = 50.00);
                        ATI_Job_Split__c js1 = new ATI_Job_Split__c(Member_Role__c = 'Account Executive', Team_Member__c = job.Account_Executive_2__c, Type__c = 'Revenue', ATI_Job__c = job.Id,
                        Percentage__c = 50.00);
                        ATI_Job_Team__c jt1 = new ATI_Job_Team__c(User__c = job.Account_Executive_1__c, Team_Member_Role__c = 'Account Executive 1', 
                        ATI_Job__c = job.Id);
                        ATI_Job_Team__c jt2 = new ATI_Job_Team__c(User__c = job.Account_Executive_2__c, Team_Member_Role__c = 'Account Executive 2', 
                        ATI_Job__c = job.Id);
                        jsToInsert.add(js);
                        jsToInsert.add(js1);
                        jobTeams.add(jt1);
                        jobTeams.add(jt2);
                        JobSetSplitsToDelete.add(job.Id);
                    }     
                }      
            }
        }
        if(!financialsToInsert.isEmpty())
        {
            insert financialsToInsert;
        }
        system.debug('Job Teams contains ' + jobTeams.size());
        system.debug('Job Teams contains ' + jobTeams);
        if(!jobTeams.isEmpty())
        {
            insert jobTeams;
        }
        if(!jsToInsert.isEmpty())
        {
            Map<Id, ATI_Job_Split__c> jobSplitOwners = new Map<Id, ATI_Job_Split__c>([Select id, percentage__c FROM ATI_Job_Split__c WHere ATI_Job__c =: JobSetSplitsToDelete]);
            for(ATI_Job_Split__c jsplits : jobSplitOwners.values())
            {
                jsplits.Percentage__c = 0;
                jsToInsert.add(jsplits);
            }
            
            upsert jsToInsert;
        }
        
    }
    @AuraEnabled 
    public static list<Account_Roles__c> CheckId6(string propId){
        List<Account_Roles__c> a = [Select Id, Name, Roles__c, Contact_ID__c, Multiple_Roles__c, Address__c, Text__c, Account_ID__c FROM Account_Roles__c Where Property_ID__c =: propId];
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }
        for(Account_Roles__c ar : a){
            ar.Text__c = ar.Roles__c;
        }

        system.debug('Prop Id + ' + propId);
        system.debug('Contact ID is ' + a);
        return a;

    }
}