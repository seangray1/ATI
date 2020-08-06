public without sharing class ApproveSelectedItemsQueueable implements Queueable, Database.AllowsCallouts{
    public class ItemListToApproveReject
    {
        public List<ItemToApprove> ItemsToApproveReject {get;set;}
    }       
    public class ItemToApprove{
        public string processId {get;set;}
        public string processinstanceId {get;set;}
        // public string createdByName {get;set;}
        // public string MasterJob {get;set;}
        // public string MasterJobId {get;set;}
        // public string Account {get;set;}
        // public string AccountId {get;set;}
        // public string Contact {get;set;}
        // public string ContactId {get;set;}
        // public string ReferredBy {get;set;}
        // public string ReferredById {get;set;}
        // public string ObjectName {get;set;}
        public string id {get;set;}
        
           }
    
           public final ItemListToApproveReject itemsToApproveString;
           public string Decision; 
           public string Comments; 
    public ApproveSelectedItemsQueueable(String ItemsToApproveReject, String CommentsRecieved, String DecisionRecieved)
    {
        ItemListToApproveReject itemstoapproverejectlist = (ItemListToApproveReject)JSON.deserialize(ItemsToApproveReject, ItemListToApproveReject.class);
        itemsToApproveString = itemstoapproverejectlist;
        Comments = CommentsRecieved;
        Decision = DecisionRecieved;
    }

    public void execute(QueueableContext context) 
    {
        Set<Id> pInstanceWorkitems = new Set<Id>();
        List<Approval.ProcessWorkitemRequest> allReq = new List<Approval.ProcessWorkitemRequest>();
        List<string> iList = new List<string>();
        for(ItemToApprove i : itemsToApproveString.ItemsToApproveReject)
        {
            system.debug('i is ' + i);
            iList.add(i.id);
            pInstanceWorkitems.add(i.processId);
        }
        
        for (Id pInstanceWorkitemsId:pInstanceWorkitems)
        {
            system.debug(pInstanceWorkitemsId);
            Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
            req2.setComments(Comments);
            req2.setAction(Decision); //to approve use 'Approve'
            req2.setWorkitemId(pInstanceWorkitemsId);
            system.debug('req 2 ' + req2);
            allReq.add(req2);
        }
        Approval.ProcessResult[] result2 =  Approval.process(allReq);
        
    }
                   
    
}