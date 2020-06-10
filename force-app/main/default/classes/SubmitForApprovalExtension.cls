public without sharing class SubmitForApprovalExtension {
    public Id objId { get; set; }
    public String doLock { get; set; }
    // public SubmitForApprovalExtension(){
    //     objId = ApexPages.currentPage().getParameters().get('id');
    //     doLock = Apexpages.currentPage().getParameters().get('lock');
    // }
@AuraEnabled
public static String submitForApproval(Id recordId)
{
try 
{
            
         
    Id userPr = UserInfo.getProfileId();
    Id user1 = UserInfo.getUserId();
    String sObjName = recordId.getSObjectType().getDescribe().getName();
    if(sObjName == 'ATI_Job__c')
    {
        ATI_Job__c job1 = [Select Id, Master_Job__c FROM ATI_Job__c Where Id =: recordId];
        
        List<Profile> profs = [Select Id, Name FROM Profile Where Name in ('Marketing Representative','System Administrator', 'Project Director')];
        Map<Id,Profile> profiles = new Map<Id,Profile>();
        profiles.putall(profs);
        if(profiles.containsKey(userPr))
        {
            Master_Job__c mjob = [Select Id, Name FROM Master_Job__c Where Id =: job1.Master_Job__c];
            List<ATI_Job__c> job = [Select Id, Name, Account__c, Account__r.Name, Referred_By__c, Referred_By__r.Name, Contact__c, Contact__r.Name FROM ATI_Job__c Where Master_job__c =: mjob.Id Limit 5];
            list<Task> t = [Select Id, CreatedDate, whoId, subject, ownerId, description FROM Task Where whoId =:job[0].Contact__c AND Type = 'Marketing Note' ORDER BY createdDate DESC Limit 1];
            Set<Id> uIds = new Set<Id>{UserInfo.getUserId()};
            if(!t.isEmpty())
            {
                uIds.add(t[0].ownerId);
            }
            Map<id,User> u = new Map<Id, User>([Select Id, ManagerId, Name FROM User Where id =: uIds]);
            Id managerId = u.get(userinfo.getUserId()).ManagerId;
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setComments('Submitting request for approval.');
            req1.setProcessDefinitionNameOrId('Credit_Request_Approval_Process');
            req1.setObjectId(mjob.Id);
            req1.setskipentrycriteria(true);          
            Approval.ProcessResult result = Approval.process(req1); 
                    
            Approval.Unlock(mjob.Id);
            String JobNames;
            for(integer i = 0; i<job.size(); i++)
            {
                if(i == 0)
                {
                    JobNames = job[i].Name;
                }
                else 
                    {
                        JobNames = JobNames + '; ' + job[i].Name;
                    }
                       
            }
            //String fullRecordURLJOB = URL.getSalesforceBaseUrl().toExternalForm() + '/' + result.Id;
            //string comments = '\n' + 'Project Note: ' + job.name +'\n' + '\n' + '\n' + 'Percent of Job Complete: ' + percent + '%' + '\n' +'\n' + 'Work/Trades started/completed since last week: ' + workCompleted + '\n' +'\n' + 'Work to be started this week: '+ workStarted + '\n' + '\n' +'Estimated completion date Per PM: '+ completionDate + '\n' + '\n' +'Has Insured/Member completed all selections? Y/N:' + insured + '\n' +'\n' + 'Potential Supplement?Y/N: '+ supplement + '\n' +'\n' + 'Repair Update Comments: ' + repairComments;
            List<Id> newWorkItemIds = result.getNewWorkitemIds();
        
            string approvallink = URL.getSalesforceBaseUrl().toExternalForm() + '/' + newWorkItemIds[0];
            string accountLink = URL.getSalesforceBaseUrl().toExternalForm() + '/' + job[0].Account__c;
            string contactlink = URL.getSalesforceBaseUrl().toExternalForm() + '/' + job[0].Contact__c;
            string referredBylink = URL.getSalesforceBaseUrl().toExternalForm() + '/' + job[0].Referred_By__c;
            String comments = '&nbsp;' + u.get(UserInfo.getUserId()).Name + ' is requesting Credit for Master Job: ' + mjob.Name + '&nbsp;' + 'Job(s): ' + JobNames + '&nbsp;' + 
            '\n' + 'Account : ' + '<a href="' + accountLink + '">' + job[0].Account__r.Name  + '&nbsp;' + '</a>' + 'Contact:' +  '<a href="' + contactlink + '">' + job[0].Contact__r.Name  + '</a>';
            if(job[0].Referred_By__c != null)
            {
                comments = comments + '&nbsp;' + 'Referred By : ' + '<a href="' + referredByLink + '">' + job[0].Referred_By__r.Name  + '</a>';
            }
            if(!t.isempty())
            {
                comments = comments + '&nbsp;' + '&nbsp;' +'Marketing Notes: ' + '&nbsp;' + 'Created By : ' + u.get(t[0].ownerId).Name + '&nbsp;' +
                'Created Date: ' + t[0].createdDate + '&nbsp;'+ 'Notes: ' + t[0].Description;
            }  
            comments = comments + '&nbsp;' + '&nbsp;' +  +  '<a href="' + approvallink + '">' + 'Link to Approval'  + '</a>';
            //Now submit email
            //if statement if t is null..
            FeedItem post = new FeedItem();
            post.ParentId = mjob.Id;
            post.isRichText = true;
            post.body = comments;
            if(Test.isRunningTest()){

            }else{
                insert post;
            }
            
          
            return 'Success';
        }else
        {
        return 'User does not have Access to Request Credit';
        }
    }
    if(sObjName == 'Master_Job__c')
    {
        // ATI_Job__c job1 = [Select Id, Master_Job__c FROM ATI_Job__c Where Master_Job__c =: recordId LIMIT 1];
        List<Profile> profs = [Select Id, Name FROM Profile Where Name in ('Marketing Representative','System Administrator', 'Project Director')];
        Map<Id,Profile> profiles = new Map<Id,Profile>();
        profiles.putall(profs);
        if(profiles.containsKey(userPr))
        {
            Master_Job__c mjob = [Select Id, Name FROM Master_Job__c Where Id =: recordId];
    List<ATI_Job__c> job = [Select Id, Name, Account__c, Account__r.Name, Referred_By__c, Referred_By__r.Name, Contact__c, Contact__r.Name FROM ATI_Job__c Where Master_job__c =: recordId Limit 5];
    list<Task> t = [Select Id, CreatedDate, whoId, subject, ownerId, description FROM Task Where whoId =:job[0].Contact__c AND Type = 'Marketing Note' ORDER BY createdDate DESC Limit 1];
    Set<Id> uIds = new Set<Id>{UserInfo.getUserId()};
    if(!t.isEmpty())
    {
        uIds.add(t[0].ownerId);
    }
    Map<id,User> u = new Map<Id, User>([Select Id, ManagerId, Name FROM User Where id =: uIds]);
    Id managerId = u.get(userinfo.getUserId()).ManagerId;
    Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
    req1.setComments('Submitting request for approval.');
    req1.setProcessDefinitionNameOrId('Credit_Request_Approval_Process');
    req1.setObjectId(recordId);
    req1.setskipentrycriteria(true);          
    Approval.ProcessResult result = Approval.process(req1); 
            
    Approval.Unlock(recordId);
    String JobNames;
    for(integer i = 0; i<job.size(); i++)
    {
        if(i == 0)
        {
            JobNames = job[i].Name;
        }
        else 
            {
                JobNames = JobNames + '; ' + job[i].Name;
            }
               
    }
    //String fullRecordURLJOB = URL.getSalesforceBaseUrl().toExternalForm() + '/' + result.Id;
    //string comments = '\n' + 'Project Note: ' + job.name +'\n' + '\n' + '\n' + 'Percent of Job Complete: ' + percent + '%' + '\n' +'\n' + 'Work/Trades started/completed since last week: ' + workCompleted + '\n' +'\n' + 'Work to be started this week: '+ workStarted + '\n' + '\n' +'Estimated completion date Per PM: '+ completionDate + '\n' + '\n' +'Has Insured/Member completed all selections? Y/N:' + insured + '\n' +'\n' + 'Potential Supplement?Y/N: '+ supplement + '\n' +'\n' + 'Repair Update Comments: ' + repairComments;
    List<Id> newWorkItemIds = result.getNewWorkitemIds();

    string approvallink = URL.getSalesforceBaseUrl().toExternalForm() + '/' + newWorkItemIds[0];
    string accountLink = URL.getSalesforceBaseUrl().toExternalForm() + '/' + job[0].Account__c;
    string contactlink = URL.getSalesforceBaseUrl().toExternalForm() + '/' + job[0].Contact__c;
    string referredBylink = URL.getSalesforceBaseUrl().toExternalForm() + '/' + job[0].Referred_By__c;
    // String comments = '<p>' + '&nbsp;' + u.get(UserInfo.getUserId()).Name + ' is requesting Credit for Master Job: ' + mjob.Name + '&nbsp;' + 'Job(s): ' + JobNames + '&nbsp;' + 
    //     '\n' + 'Account : ' + '<a href="' + accountLink + '">' + job[0].Account__r.Name  + '&nbsp;' + '</a>' + 'Contact:' +  '<a href="' + contactlink + '">' + job[0].Contact__r.Name  + '</a>' ;
    // if(job[0].Referred_By__c != null)
    // {
    //     comments = comments + '&nbsp;' + 'Referred By : ' + '<a href="' + referredByLink + '">' + job[0].Referred_By__r.Name  + '</a>';
    // }
    // if(!t.isempty())
    // {
    //     comments = comments + '&nbsp;' + '&nbsp;' +'Marketing Notes: ' + '&nbsp;' + 'Created By : ' + u.get(t[0].ownerId).Name + '&nbsp;' +
    //     'Created Date: ' + t[0].createdDate + '&nbsp;'+ 'Notes: ' + t[0].Description;
    // }  
    // comments = comments + '&nbsp;' + '&nbsp;' +  +  '<a href="' + approvallink + '">' + 'Link to Approval'  + '</a>' + '</p>';
    //Now submit email
    //if statement if t is null..
    string codesnippet = '<html>\n\t<body>\n\t\tHello, world!\n\t</body>\n<a href="' + accountLink + '">accountslink</a></html>';
    String communityId = null;
    String targetUserOrGroupOrRecordId  = '0050g0000066uffAAA';

    ConnectApi.FeedItemInput input = new ConnectApi.FeedItemInput();
    input.subjectId = targetUserOrGroupOrRecordId;
    input.feedElementType = ConnectApi.FeedElementType.FeedItem;
    
    ConnectApi.MessageBodyInput messageInput = new ConnectApi.MessageBodyInput();
    ConnectApi.TextSegmentInput textSegment;
    ConnectApi.MarkupBeginSegmentInput markupBeginSegment;
    ConnectApi.MarkupEndSegmentInput markupEndSegment;
    
    messageInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
    
    markupBeginSegment = new ConnectApi.MarkupBeginSegmentInput();
    markupBeginSegment.markupType = ConnectApi.MarkupType.Code;
    messageInput.messageSegments.add(markupBeginSegment);
    
    textSegment = new ConnectApi.TextSegmentInput();
    textSegment.text = codeSnippet;
    messageInput.messageSegments.add(textSegment);
    
    markupEndSegment = new ConnectApi.MarkupEndSegmentInput();
    markupEndSegment.markupType = ConnectApi.MarkupType.Code;
    messageInput.messageSegments.add(markupEndSegment);
    
    input.body = messageInput;
    
    ConnectApi.ChatterFeeds.postFeedElement(null, input);
            return 'Success';
        }else
        {
        return 'User does not have Access to Request Credit';
        }
    }
    if(sObjName == 'Contact')
    {
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setSubmitterId(user1);
        // Submit the record to specific process and skip the criteria evaluation
        req1.setProcessDefinitionNameOrId('Contact_Ownership_Request_Approval');
        req1.setObjectId(recordId);
        req1.setskipentrycriteria(true);
        // Submit the approval request for the account
        Approval.ProcessResult result = Approval.process(req1);
        
        Approval.Unlock(recordId);
        return 'Success';
    }
    return 'Success';
}
catch (Exception e) 
{
    return e.getMessage();        
} 
}
// @future
// public static void submitEmailAndApproval(string mjobId, string jobId)
// {
//     Master_Job__c mjob = [Select Id, Name FROM Master_Job__c Where Id =: mjobId];
//     List<ATI_Job__c> job = [Select Id, Name, Account__c, Account__r.Name, Referred_By__c, Referred_By__r.Name, Contact__c, Contact__r.Name FROM ATI_Job__c Where Master_job__c =: mjobId Limit 5];
//     list<Task> t = [Select Id, CreatedDate, whoId, subject, ownerId, description FROM Task Where whoId =:job[0].Contact__c ORDER BY createdDate DESC Limit 1];
//     Set<Id> uIds = new Set<Id>{UserInfo.getUserId()};
//     if(!t.isEmpty())
//     {
//         uIds.add(t[0].ownerId);
//     }
//     Map<id,User> u = new Map<Id, User>([Select Id, ManagerId, Name FROM User Where id =: uIds]);
//     Id managerId = u.get(userinfo.getUserId()).ManagerId;
//     Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
//     req1.setComments('Submitting request for approval.');
//     req1.setProcessDefinitionNameOrId('Credit_Request_Approval_Process');
//     req1.setObjectId(mjobId);
//     req1.setskipentrycriteria(true);          
//     Approval.ProcessResult result = Approval.process(req1); 
            
//     Approval.Unlock(mjobId);
//     String JobNames;
//     for(integer i = 0; i<job.size(); i++)
//     {
//         if(i == 0)
//         {
//             JobNames = job[i].Name;
//         }
//         else 
//             {
//                 JobNames = JobNames + '; ' + job[i].Name;
//             }
               
//     }
//     //String fullRecordURLJOB = URL.getSalesforceBaseUrl().toExternalForm() + '/' + result.Id;
//     //string comments = '\n' + 'Project Note: ' + job.name +'\n' + '\n' + '\n' + 'Percent of Job Complete: ' + percent + '%' + '\n' +'\n' + 'Work/Trades started/completed since last week: ' + workCompleted + '\n' +'\n' + 'Work to be started this week: '+ workStarted + '\n' + '\n' +'Estimated completion date Per PM: '+ completionDate + '\n' + '\n' +'Has Insured/Member completed all selections? Y/N:' + insured + '\n' +'\n' + 'Potential Supplement?Y/N: '+ supplement + '\n' +'\n' + 'Repair Update Comments: ' + repairComments;
//     List<Id> newWorkItemIds = result.getNewWorkitemIds();

//     string approvallink = URL.getSalesforceBaseUrl().toExternalForm() + '/' + newWorkItemIds[0];
//     string accountLink = URL.getSalesforceBaseUrl().toExternalForm() + '/' + job[0].Account__c;
//     string contactlink = URL.getSalesforceBaseUrl().toExternalForm() + '/' + job[0].Contact__c;
//     string referredBylink = URL.getSalesforceBaseUrl().toExternalForm() + '/' + job[0].Referred_By__c;
//     String comments = '\n' + u.get(UserInfo.getUserId()).Name + ' is requesting Credit for Master Job: ' + mjob.Name + '\n' + 'Job(s): ' + JobNames + '\n' + 
//     '\n' + 'Account : ' + job[0].Account__r.Name + '          ' + accountLink + '\n' + 'Contact: ' + job[0].Contact__r.Name + '          ' + contactLink;
//     if(job[0].Referred_By__c != null)
//     {
//         comments = comments + '\n' + 'Referred By : ' + job[0].Referred_By__r.Name + '          ' + referredByLink;
//     }
//     if(!t.isempty())
//     {
//         comments = comments + '\n' + '\n' +'Marketing Notes: ' + '\n' + 'Created By : ' + u.get(t[0].ownerId).Name + '\n' +
//         'Created Date: ' + t[0].createdDate + '\n'+ 'Notes: ' + t[0].Description;
//     }  
//     comments = comments + '\n' + '\n' + 'Link to Approval: ' + approvallink;
//     //Now submit email
//     //if statement if t is null..
//     FeedItem post = new FeedItem();
//     post.ParentId = mjobId;
//     ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
//     ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
//     ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
//     ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
//     messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
//     mentionSegmentInput.id = managerId;
//     messageBodyInput.messageSegments.add(mentionSegmentInput);  
//     textSegmentInput.text = comments;
//     messageBodyInput.messageSegments.add(textSegmentInput);
//     feedItemInput.body = messageBodyInput;
//     feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
//     feedItemInput.subjectId = mjobId;
//     if(Test.isRunningTest()){}
//     else{
//     ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput);
    
//     }


     // where type is marketing note and the latest, show the description, date, who wrote it etc.
    
//}
    // @AuraEnabled
    // public static sObject getsObject(ID ObjectId){
        
    //     String sObjName = ObjectId.getSObjectType().getDescribe().getName();
        
    //     if(sObjName == 'ATI_Job__c'){
    //         ATI_Job__c job = (ATI_Job__c)Database.query('SELECT Id FROM ATI_Job__c where Id =: ObjectId LIMIT 1');
    //         return job;
    //     }
    //     else if(sObjName == 'Contact'){
    //             Contact con = (Contact)Database.query('Select Id from Contact where Id =: ObjectId limit 1');
    //             return con; 
    //     }
    //     else if(sObjName == 'Master_Job__c'){
    //         Contact con = (Contact)Database.query('Select Id from Contact where Id =: ObjectId limit 1');
    //         return con; 
    // }
    //     else
    //         return null;



    // }
    //  try{
            //Set<Id> GroupMemberSet = new Set<Id>();
        //ATI_Job__c job = [Select Id, recordTypeId FROM ATI_Job__c Where Id =: recordId];
        // Group groupId = [Select Id FROM GROUP Where Type='Queue' AND DeveloperName = 'Hybrid_PD'];
        // List<GroupMember> groupMembers = [Select Id, userOrGroupId, GroupId FROM GroupMember Where GroupId =: groupId.Id];
        // for(GroupMember groupMember1 : groupMembers){
        //     GroupMemberSet.add(groupMember1.userorgroupId);
        // }
       // Id recordTypeId = Schema.SObjectType.ATI_Job__c.getRecordTypeInfosByName().get('Job (Approved)').getRecordTypeId();
       
            
}