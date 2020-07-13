public without sharing class LargeLossUtility {
    
    @AuraEnabled
    public static string LargeLossApprovalSubmission(string recordId, string comments) 
    {
        try 
        {
            Large_Loss_Review__c l = [SELECT Id, Job__c
                            FROM Large_Loss_Review__c 
                            WHERE Id =: recordId];
            
            Large_Loss_Review__c largeloss = CreateLargeLossRecord(l.Job__c);
            largeloss.Id = recordId;
            update largeloss;
            approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest(); 
            req1.setComments(comments);
            req1.setObjectId(recordId);
            req1.setSubmitterId(UserInfo.getUserId());
            req1.setProcessDefinitionNameOrId('Large_Loss_Review');
            req1.setSkipEntryCriteria(true);
            // Submit the approval request for the account
            Approval.ProcessResult result = Approval.process(req1);
            //Approval.UnlockResult unlockedResults = Approval.unlock(recordId, false);
            return 'success';
        } 
        catch (Exception e) 
        {
            return e.getMessage();
        }
        
    }

    @AuraEnabled
    public static string ValidateRecord(String recordId)
    {
        //validate if user has access and return TRUE or FALSE
    try {
            
        
        ATI_Job__c job = [SELECT Id, Large_Loss_Flag__c, Stage__c
                        FROM ATI_Job__c
                        WHERE Id =:recordId];
        List<Large_Loss_Review__c> LLRelatedList = [SELECT Id 
                                                FROM Large_Loss_Review__c 
                                                WHERE Job__c =:recordId];
        
        if(!LLRelatedList.isEmpty())
        {
            return 'A Large Loss Review record already exists for this Loss.';
        }
        else if(!Job.Large_Loss_Flag__c)
        {
            //job.Large_Loss_Flag__c.addError('This Loss must be marked as "Large Loss"');
            return 'This Loss must be marked as "Large Loss"';
        }
        else if(Job.Stage__c == 'Lost' || Job.Stage__c == 'Billing Complete' || Job.Stage__c == 'Work Complete')
        {
            //job.addError('The Stage cannot be "Lost", "Billing Complete", or "Work Complete"');
            return 'The Stage cannot be "Lost", "Billing Complete", or "Work Complete"';
        }
        else
        {
            Large_Loss_Review__c largeloss = CreateLargeLossRecord(recordId);
            largeloss.NLLS_Number__c = 1;
            insert largeloss;
            return largeloss.Id;
        }
    } catch (Exception e) 
    {
        return e.getMessage();
    }
      
    }
    @AuraEnabled 
    public static string RefreshLargeLoss(Id recordId)
    {
        try 
        {
            Large_Loss_Review__c l = [SELECT Id, Job__c
                            FROM Large_Loss_Review__c 
                            WHERE Id =: recordId];
            
            Large_Loss_Review__c largeloss = CreateLargeLossRecord(l.Job__c);
            largeloss.Id = recordId;
            update largeloss;
            return 'success';
        }
        catch(Exception e)
        {
            return e.getMessage();
        }
    }
    public static void AutoCreateNewLargeLoss(Map<Id,Large_Loss_Review__c> oldMap, List<Large_Loss_Review__c> largeLossList)
    {
        List<ATI_Job__c> jobsToUpdate = new List<ATI_Job__c>();
        Map<Id,Large_Loss_Review__c> largeLossRecordsToLock = new Map<Id,Large_Loss_Review__c>();
        List<Large_Loss_Review__c> recordsToInsert = new List<Large_Loss_Review__c>();
        for(Large_Loss_Review__c largeloss : largeLossList)
        {
            Large_Loss_Review__c oldLargeLoss = oldmap.get(largeloss.Id);
            if((largeloss.Status__c == 'Approved' || largeloss.Status__c == 'Rejected') && largeloss.Status__c != oldLargeLoss.Status__c)
            {
                //add to large loss records to create and lock
                largeLossRecordsToLock.put(largeloss.Id, largeloss);
            }
        }
        if(!largeLossRecordsToLock.isEmpty())
        {
            for(Large_Loss_Review__c largeloss : largeLossRecordsToLock.values())
            {
                Large_Loss_Review__c l = CreateLargeLossRecord(largeloss.Job__c);
                l.NLLS_Number__c = oldMap.get(largeloss.Id).NLLS_Number__c + 1;
                recordsToInsert.add(l);
                ATI_Job__c job = new ATI_Job__c(Id = largeloss.job__c, Large_Loss_Status__c = 'Approved');
                jobsToUpdate.add(job);
            }
            insert recordsToInsert;
            update jobstoUpdate;
            Approval.lock(largelossRecordsToLock.values());
            //submit new records for approval
            // List<Approval.ProcessSubmitRequest> allReq = new List<Approval.ProcessSubmitRequest>(); 
            // for(Large_Loss_Review__c largeloss : recordsToInsert)
            // {
            //     Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            //     req1.setComments('Submitting request for approval.');
            //     req1.setProcessDefinitionNameOrId('Large_Loss_Review');
            //     req1.setObjectId(largeloss.Id);
            //     req1.setskipentrycriteria(true);
            //     req1.submitterId = UserInfo.getUserId();
            //     allreq.add(req1);
            // }
            // Approval.ProcessResult[] result = Approval.process(allreq); 
        }
    }
    public static void LargeLossNameFormat(List<Large_Loss_Review__c> largelossList)
    {
            // Validate preconditions
            if (largelossList == null || largelossList.isEmpty()) {
                System.debug(Logginglevel.INFO, 'BudgetNameFormat.setBudgetNumbers: Argument contains no Budget to process');
                return;
            }
            
            // Ignore all Budget that don't have jobs and sort Budget by job
            // number
            Map<Id, List<Large_Loss_Review__c>> BudgetJobBuckets = new Map<Id, List<Large_Loss_Review__c>>();
            for (Large_Loss_Review__c i : largelossList) {
                if (i.Job__c!= null) {
                    if (! budgetJobBuckets.containsKey(i.Job__c)) {
                        budgetJobBuckets.put(i.Job__c, new List<Large_Loss_Review__c>{i});
                    } else {
                        budgetJobBuckets.get(i.Job__c).add(i);
                    }
                }
            }
            
            // No buckets = no Budget = no work
            if (budgetJobBuckets.isEmpty()) {
                System.debug(Logginglevel.INFO, 'BudgetNameFormat.setbudgetNumbers: No valid Budget to process');
                return;
            }
            
            // Define a mapping between Job ID and job number
            Map<Id, String> jobNumbers = new Map<Id, String>();
            
            // Determine the current incremental value for each job
            AggregateResult[] maxResults = [SELECT Job__c,  Job__r.Job_Number__c jn, 
                                                   MAX(Large_Loss_Number_Incremental__c)m
                                            FROM Large_Loss_Review__c
                                            WHERE Job__c IN :budgetJobBuckets.keySet()
                                            GROUP BY Job__c,  Job__r.Job_Number__c];
            
            // Generate a mapping from job ID to nexts incremental
            Map<Id, Integer> budgetIncrementals = new Map<Id, Integer>();
            for (AggregateResult ar : maxResults) {
                
                // Retrieve the current incremental value
                Decimal incRaw = (Decimal) ar.get('m');
                Integer inc = (Integer) ((incRaw == null) ? 0 : incRaw.round());
                
                // Get the job information
                Id jobId = (Id) ar.get('Job__c');
                budgetIncrementals.put(jobId, inc);
                
                String jobNumber = (String) ar.get('jn');
                jobNumbers.put(jobId, jobNumber);
                
            }
            
            // Go through each of the Budget that may not have numbers yet
            Set<Id> jobIdsForFirstBudget = new Set<Id>();
            for (Id jobId : budgetJobBuckets.keySet()) {
                if (! jobNumbers.keySet().contains(jobId)) {
                    jobIdsForFirstBudget.add(jobId);
                }
            }
            
            // Get information for the first Budget per job
            if (! jobIdsForFirstBudget.isEmpty()) {
                
                // Get job numbers for all of the first Budget per job
                List<ATI_Job__c> jobs = [SELECT Id, Job_Number__c FROM ATI_Job__c WHERE Id IN :jobIdsForFirstBudget];
                
                // Retain the information for the first budget per job
                for (ATI_Job__c j : jobs) {
                    budgetIncrementals.put(j.Id, 0);
                    jobNumbers.put(j.Id, j.Job_Number__c);
                }
                
            }
            
            // Go through each of the input jobs
            for (Id jobId : budgetJobBuckets.keySet()) {
                
                // Normalize job data from the aggregate result
                Integer bud = budgetIncrementals.get(jobId);
                String jobNumber = jobNumbers.get(jobId);
                
                System.debug('BudgetNameFormat.setbudgetNumbers: Handling Job '+jobNumber+' ['+jobId+']. Current incremental: '+bud);
                
                // Go through each of the Budget related to this job
                for (Large_Loss_Review__c i : budgetJobBuckets.get(jobId)) {
                    
                    // Check if the budget needs an incremental value
                    if (i.Large_Loss_Number_Incremental__c == null) {
                        bud += 1;
                        i.Large_Loss_Number_Incremental__c = bud;
                    }
                    
                    // Get the integer value of the budget incremental (while this
                    // may sometimes be redundant, it is safer to do it every time)
                    Integer budInc = (Integer) i.Large_Loss_Number_Incremental__c.round();
                    
                    System.debug('BudgetNameFormat.setbudgetNumbers: Handling budget ['+i.Id+'] for job ['+jobId+']. Current incremental: '+budInc);
                    
                    // If a job number was not available, add an error
                    if (jobNumber == null) {
                        i.addError('Both "Job Number" fields must be populated on the associated Job before this record can be saved.'+
                                   '  Please fix the Job then re-save this budget.');
                    }
                    
                    // Set the budget name based on the job number (no hyphens)
                    // and the budget incremental
                    String budgetNumber = jobNumber.replace('-','');
                    budgetNumber = 'LLR-' + budgetNumber + '-' + ADCUtil_Base.forceStringLength((''+budInc), 2, '0', false);
                    
                    System.debug('BudgetNameFormat.setbudgetNumbers: budget number for budget ['+i.Id+'] calculated: '+budgetNumber);
                    
                    // Set the budget name to the new budget number
                    i.Name = budgetNumber;
                    
                }       
            }
    }
    
    public static Large_Loss_Review__c CreateLargeLossRecord(Id recordId)
    {
        //query for all of the record
        // missing contract start date and completion date
        ATI_Job__c job = [SELECT Project_Manager__c, ContractId__c, Project_manager_new__c, Regional_Director__c, Branch_Manager__c, Amount__c,
        Estimated_Completion_Date_Per_PD__c,Estimated_Completion_Date__c,Job_Start_Date__c,Job_to_Date_Payments_AR_RS__c,Percent_Complete__c
                        FROM ATI_Job__c
                        WHERE Id =: recordId];
        Contract contr = [SELECT Id, StartDate, EndDate
                        FROM Contract
                        WHERE Id =: job.ContractId__c]; 
        Financial__c financial = [SELECT Id, Job_to_date_work_billed__c, Job_to_Date_Costs__c, Job_To_Date_GP_Percent__c, Gross_Profit__c
                                FROM Financial__c
                                WHERE ATI_Job__c =: recordId LIMIT 1];
        Budget__c bud = [SELECT Id, Budget_Status__c, Rejected_Reason__c, Total_Budget_Goal__c, Allocation_Percentage__c
                        FROM Budget__c
                        WHERE ATI_Job__c =: recordId
                        ORDER BY createdDate DESC LIMIT 1];
        // List<Forecast__c> forecasts = [SELECT Id, SUM(Revenue_Amount__c), CreatedDate
        //                                 FROM Forecast__c
        //                                 Where ATI_Job__c =:recordId];
        Date startOfMonth = Date.today().toStartOfMonth();
        
        Date startOfNextMonth = startOfMonth.addMonths(1);
        system.debug('start of month ' + startOfMonth + ' Start of next month ' + startOfNextMonth);                                
        List<AggregateResult> forecastFullAmount=[SELECT SUM(Revenue_Amount__c) 
                                  FROM Forecast__c 
                                  WHERE ATI_Job__c =:recordId];
        List<AggregateResult> forecastFutureAmount=[SELECT SUM(Revenue_Amount__c) 
                                  FROM Forecast__c 
                                  WHERE ATI_Job__c =:recordId AND Invoice_Date__c >= :startOfNextMonth
                                  ];
        List<AggregateResult> forecastCurrentMonthAmount=[SELECT SUM(Revenue_Amount__c) 
                                  FROM Forecast__c 
                                  WHERE ATI_Job__c =:recordId  AND Invoice_Date__c >= :startOfMonth
                                  AND Invoice_Date__c < :startOfNextMonth];
        system.debug(forecastFullAmount + '  ' + forecastFutureAmount + '  ' + forecastCurrentMonthAmount);
        Large_Loss_Review__c largeloss = new Large_Loss_Review__c(Job__c = recordId, Amount__c = job.Amount__c,
        Contract_Start_Date__c = contr.StartDate, Contract_End_Date__c = contr.EndDate, Job_To_Date_Payments__c = job.Job_to_Date_Payments_AR_RS__c,
        Percent_Complete__c = job.Percent_Complete__c, Job_Start_Date__c = job.Job_Start_Date__c, Estimated_Completion_Date_Per_Contract__c = job.Estimated_Completion_Date__c,
        Estimated_Completion_Date_Per_PM__c = job.Estimated_Completion_Date_Per_PD__c, Job_To_Date_Work_Billed__c = financial.Job_to_date_work_billed__c,
        Job_to_Date_Costs__c = financial.Job_to_Date_Costs__c, Job_To_Date_GP_Percent__c = financial.Job_To_Date_GP_Percent__c, 
        Estimated_GP_Percent__c = financial.Gross_Profit__c, Budget_Status__c = bud.Budget_Status__c, Rejected_Reason__c = bud.Rejected_Reason__c,
        Total_Budget_Goal__c = bud.Total_Budget_Goal__c, Allocation_Percent__c = bud.Allocation_Percentage__c, 
        Total_Billing_Forecast__c = (Double)forecastFullAmount[0].get('expr0'), Forecast_for_Current_Month__c = (Double)forecastCurrentMonthAmount[0].get('expr0'), 
        Future_Forecast__c = (Double)forecastFutureAmount[0].get('expr0'), Regional_Manager__c = job.Branch_Manager__c, Regional_Director__c = job.Regional_Director__c,
        Project_Director__c = job.Project_Manager__c, Project_Manager__c = job.Project_Manager_new__c);
        //insert and return
        return largeloss;
    }

}