public without sharing class ApproveSelectedItemsQueueable implements Queueable, Database.AllowsCallouts{
    public class ItemListToApproveReject
    {
        public List<ItemToApprove> ItemsToApproveReject {get;set;}
    }       
    public class ItemToApprove{
        public string processId {get;set;}
        public string processinstanceId {get;set;}
        // public string createdByName {get;set;}
        public string MasterJob {get;set;}
        // public string MasterJobId {get;set;}
        // public string Account {get;set;}
        // public string AccountId {get;set;}
        // public string Contact {get;set;}
        // public string ContactId {get;set;}
        // public string ReferredBy {get;set;}
        // public string ReferredById {get;set;}
        // public string ObjectName {get;set;}
        // public Id Id {get;set;}
        
           }
    
           public final ItemListToApproveReject itemsToApproveString;
           public string Decision; 
           public string Comments; 
    public ApproveSelectedItemsQueueable(String ItemsToApproveReject, String CommentsRecieved, String DecisionRecieved)
    {
        system.debug('Hitting queeable ' + ItemsToApproveReject);
        ItemListToApproveReject itemstoapproverejectlist = (ItemListToApproveReject)JSON.deserialize(ItemsToApproveReject, ItemListToApproveReject.class);
        system.debug('Hitting queeable ' + ItemsToApproveReject);
        itemsToApproveString = itemstoapproverejectlist;
        Comments = CommentsRecieved;
        Decision = DecisionRecieved;
    }

    public void execute(QueueableContext context) 
    {
        Set<Id> pInstanceWorkitems = new Set<Id>();
        Set<Id> pInstanceSet = new Set<Id>();
        List<Approval.ProcessWorkitemRequest> allReq = new List<Approval.ProcessWorkitemRequest>();
        List<Id> iList = new List<Id>();
        List<Master_Job__c> mjList = new List<Master_Job__c>();
        Id mjobout;
        if(itemsToApproveString.ItemsToApproveReject[0].MasterJob != null)
        {
            mjobout = Id.valueOf(itemsToApproveString.ItemsToApproveReject[0].MasterJob.replaceAll('/', ''));
        }
        if(mjobout != null && mjobout.getSObjectType().getDescribe().getName() == 'Master_Job__c')
        {
            for(ItemToApprove i : itemsToApproveString.ItemsToApproveReject)
            {
                system.debug('i is ' + i);
                Id mjId = Id.valueOf(i.MasterJob.replaceAll('/', ''));
                iList.add(mjId);
                pInstanceWorkitems.add(i.processId);
                pInstanceSet.add(i.processinstanceId);
            }
            Map<Id,Master_Job__c> mjMap = new Map<Id,Master_Job__c>([Select Id, Account_Executive_1__c, Account_Executive_2__c FROM Master_Job__c WHERE Id =:iList]);
            Map<Id,ProcessInstanceWorkitem> pWorkItemMasterJob = new Map<Id,ProcessInstanceWorkitem>([SELECT Id, ProcessInstanceId FROM ProcessInstanceWorkitem WHERE Id =:pInstanceWorkitems]);
            Map<Id,ProcessInstance> PI = new Map<Id,ProcessInstance>([SELECT Id, TargetObjectId FROM ProcessInstance WHERE Id =: pInstanceSet]);

            for (Id pInstanceWorkitemsId:pWorkItemMasterJob.keySet())
            {
                // for(ProcessInstance processInst : pWorkItemMasterJob.get(pInstanceWorkitemsId).ProcessInstance)
                // {
                    if(mjMap.get(PI.get(pworkItemMasterJob.get(pInstanceWorkitemsId).ProcessInstanceId).TargetObjectId).Account_Executive_2__c != null && mjMap.get(PI.get(pworkItemMasterJob.get(pInstanceWorkitemsId).ProcessInstanceId).TargetObjectId).Account_Executive_1__c != null)
                    {
                        // mjMap.get(processInst.TargetObjectId.Approval_Error__c = 'Two AEs are already assigned');
                        // mjList.add(mjMap.get(processInst.TargetObjectId.Approval_Error__c));
                        mjMap.get(PI.get(pworkItemMasterJob.get(pInstanceWorkitemsId).ProcessInstanceId).TargetObjectId).Approval_Error__c = 'Two AEs are already assigned';
                        Master_Job__c m = mjMap.get(PI.get(pworkItemMasterJob.get(pInstanceWorkitemsId).ProcessInstanceId).TargetObjectId);
                        mjList.add(m);
                    
                    }
                    else if(mjMap.get(PI.get(pworkItemMasterJob.get(pInstanceWorkitemsId).ProcessInstanceId).TargetObjectId).Account_Executive_2__c == userInfo.getUserId() && mjMap.get(PI.get(pworkItemMasterJob.get(pInstanceWorkitemsId).ProcessInstanceId).TargetObjectId).Account_Executive_1__c == userInfo.getUserId())
                    {
                        mjMap.get(PI.get(pworkItemMasterJob.get(pInstanceWorkitemsId).ProcessInstanceId).TargetObjectId).Approval_Error__c = 'AE is already assigned to this job';
                        Master_Job__c m = mjMap.get(PI.get(pworkItemMasterJob.get(pInstanceWorkitemsId).ProcessInstanceId).TargetObjectId);
                        mjList.add(m);
                    }
                    else{
                        system.debug(pInstanceWorkitemsId);
                        Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
                        req2.setComments(Comments);
                        req2.setAction(Decision); //to approve use 'Approve'
                        req2.setWorkitemId(pInstanceWorkitemsId);
                        system.debug('req 2 ' + req2);
                        allReq.add(req2);
                        Approval.ProcessResult result2 =  Approval.process(req2);
                  //  }
                
            }
            // Approval.ProcessResult[] result2 =  Approval.process(allReq);
        
        }
    }
    else
    {
        for(ItemToApprove i : itemsToApproveString.ItemsToApproveReject)
            {
                system.debug('i is ' + i);
                // iList.add(i.id);
                pInstanceWorkitems.add(i.processId);
            }
            // Map<Id,Master_Job__c> mjMap = new Map<Id,Master_Job__c>([Select Id, Account_Exective_1__c, Account_Executive_2__c FROM Master_Job__c WHERE Id =:iList]);
            // Map<Id,ProcessInstanceWorkitem> pWorkItemMasterJob = new Map<Id,ProcessInstanceWorkitem>([SELECT Id, (SELECT Id, TargetObjectId FROM ProcessInstance) FROM ProcessInstanceWorkitem WHERE Id =:pInstanceWorkitems]);

            for (Id pInstanceWorkitemsId:pInstanceWorkitems)
            {
                // for(ProcessInstance processInst : pWorkItemMasterJob.get(pInstanceWorkitemsId).ProcessInstance)
                // {
                    // if(mjMap.get(processInst.TargetObjectId).Account_Executive_2__c != null && mjMap.get(processInst.TargetObjectId).Account_Executive_1__c != null)
                    // {
                    //     mjMap.get(processInst.TargetObjectId.Approval_Error__c = 'Two AEs are already assigned');
                    //     mjList.add(mjMap.get(processInst.TargetObjectId.Approval_Error__c));
                    
                    // }
                    // else{
                        system.debug(pInstanceWorkitemsId);
                        Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
                        req2.setComments(Comments);
                        req2.setAction(Decision); //to approve use 'Approve'
                        req2.setWorkitemId(pInstanceWorkitemsId);
                        system.debug('req 2 ' + req2);
                        allReq.add(req2);
                        Approval.ProcessResult result2 =  Approval.process(req2);
                    // }
                
            //}
            // Approval.ProcessResult[] result2 =  Approval.process(allReq);
        
            }
        }
        if(!mjList.isEmpty())
        {
            update mjList;
        }
    }
                   
    
}