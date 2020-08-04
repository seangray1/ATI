public without sharing class DynamicApprovalController {
//     @AuraEnabled
// public static String ApproveSelectedItems(String ItemsToApproveReject, String Comments, String Decision)
// {
//     try 
//     {
//         system.debug('Items before ' + ItemsToApproveReject);
//         Set<Id> pInstanceWorkitems = new Set<Id>();
//         //JSONWrapper projectWrap = (JSONWrapper)JSON.deserialize(ProjectJSON, JSONWrapper.class);
//         ItemListToApproveReject itemstoapproverejectlist = (ItemListToApproveReject)JSON.deserialize(ItemsToApproveReject, ItemListToApproveReject.class);
//         system.debug('Items to Approve/reject ' + itemstoapproverejectlist);
//         List<string> iList = new List<string>();
//         for(ItemToApprove i : itemstoapproverejectlist.ItemsToApproveReject)
//         {
//             system.debug('i is ' + i);
//             iList.add(i.id);
//             pInstanceWorkitems.add(i.processId);
//         }
//         List<Approval.ProcessWorkitemRequest> allReq = new List<Approval.ProcessWorkitemRequest>(); 
//         for (Id pInstanceWorkitemsId:pInstanceWorkitems)
//         {
//             system.debug(pInstanceWorkitemsId);
//             Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
//             req2.setComments(Comments);
//             req2.setAction(Decision); //to approve use 'Approve'
//             req2.setWorkitemId(pInstanceWorkitemsId);
//             system.debug('req 2 ' + req2);
//             allReq.add(req2);
//         }
//         //Approval.ProcessResult[] result2 =  Approval.process(allReq);
//         return '200';
//     } catch (Exception e) 
//     {
//         return e.getMessage();
//     }
// }
    public class ViewItems {
        @auraenabled
        public string label {get;set;}
        @auraenabled
        public string apiName {get;set;}
    }
    @AuraEnabled
    public static List<ViewItems> GetViewTypes(String objectName)
    {
        List<ViewItems> ViewItems = new List<ViewItems>();
        List<Approval_Configuration__mdt> approvalRecord = [Select Object_Name__c, label FROM Approval_Configuration__mdt];
        system.debug('Approval Record is ' + approvalRecord);
        for(Approval_Configuration__mdt md: approvalRecord)
        {
            ViewItems view = new ViewItems();
            view.label = Schema.getGlobalDescribe().get(md.Object_Name__c).getDescribe().getLabel();
            view.apiName = md.Object_Name__c;
            system.debug('View is ' + view);
            ViewItems.add(view);
        }
         
        return ViewItems;
    }
    @AuraEnabled
    public static List<string> GetColumns(String objectName)
    {
        system.debug('working');
        Approval_Configuration__mdt approvalRecord = [Select Object_Name__c, label, Column_1__c, Column_2__c, Column_3__c,Column_4__c,Column_5__c FROM Approval_Configuration__mdt Where Object_Name__C =: objectName];
        
        List<String> columnList = new List<String>{approvalRecord.Column_1__c, approvalRecord.Column_2__c, approvalRecord.Column_3__c, approvalRecord.Column_4__c, approvalRecord.Column_5__c};
        List<String> columnListEdited = new List<String>();
        for(String s : columnList)
        {
            s = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().get(s).getDescribe().getLabel();
            columnListEdited.add(s);
        }

        system.debug('List of column list ' + columnList);
        return columnListEdited;
    }

    // @AuraEnabled
    // public static List<ItemToApprove> GetAccountData(String objectName){
    //     objectName = 'Master_Job__c';
    //     Set<Id> userSet = new Set<Id>();
    //     Set<Id> ProcessInstanceId = new Set<Id>();
    //     Map<Id, ProcessInstance> processInstanceMap = new Map<Id, ProcessInstance>();
    //     Map<Id, ProcessInstanceWorkitem> processJobMap = new Map<Id, ProcessInstanceWorkitem>();
    //     Map<Id, ProcessInstance> processMJobMap = new Map<Id, ProcessInstance>();
    //     Map<Id, ProcessInstanceWorkitem> processuserMap = new Map<Id, ProcessInstanceWorkitem>();
    //     Map<Id, String> processuserMap1 = new Map<Id, string>();
        
    //     Set<Id> mjobids = new Set<Id>();
        
    //     List<Id> mjoblist1 = new List<id>();
    //     List<ProcessInstanceWorkitem> piwi = [Select Id, ProcessInstanceId, CreatedById, ActorId FROM ProcessInstanceWorkitem Where ActorId =: userInfo.getUserId()];
    // //   if(objectName == 'Master Job')
    // //   {   
    //     for(ProcessInstanceWorkitem p : piwi)
    //     {
    //         processJobMap.put(p.ProcessInstanceId, p);
    //         userset.add(p.CreatedById);
    //         processUserMap.put(p.CreatedById, p);
    //         ProcessInstanceId.add(p.ProcessInstanceId);
    //     }
    //     List<user> usersList = [Select Id, Name FROM User Where Id=:userSet];
    //     for(user u : usersList)
    //     {
    //         processUserMap1.put(u.Id, u.Name);
    //     }
    //     List<ProcessInstance> processInstanceList = [Select Id, targetObjectId FROM ProcessInstance Where Id =: ProcessInstanceId];
    //     for(ProcessInstance p : processInstanceList)
    //     {
    //         if(p.targetobjectId.getSObjectType().getDescribe().getName() == objectName)
    //         {
    //             processInstanceMap.put(p.Id, p);
    //             processMJobMap.put(p.targetObjectId, p);
                
    //             mjobids.add(p.targetObjectId);
    //             mjoblist1.add(p.targetObjectId);
    //         }
    //     }
    //     Map<Id, SObject> mjobMap = new Map<Id,SObject>();
    //     system.debug('mjob ids ' + mjobids);
       

    //     Approval_Configuration__mdt approvalRecord = [Select Object_Name__c, label, Column_1__c, Column_2__c, Column_3__c,Column_4__c,Column_5__c FROM Approval_Configuration__mdt Where Object_Name__C =: objectName];
    //     system.debug('approvalrecord is ' + approvalRecord);
    //     // There is a way to retrieve the fields on the custom metadata
    //     // QUery + + 
    //     // String query = '[Select ' + a.FIeld1 +',
    //     // MetadataRecord a = query;
    //     // String objectName = 'Account';
    //     // String fieldName = 'Name';

    //     SObjectType r = ((SObject)(Type.forName('Schema.'+objectName).newInstance())).getSObjectType();
    //     system.debug('R ' + r);
    //     DescribeSObjectResult d = r.getDescribe();
    //     String Column1Type = String.valueOf(d.fields.getMap().get(approvalRecord.Column_1__c).getDescribe().getType());
    //     String Column2Type = String.valueOf(d.fields.getMap().get(approvalRecord.Column_2__c).getDescribe().getType());
    //     String Column3Type = String.valueOf(d.fields.getMap().get(approvalRecord.Column_3__c).getDescribe().getType());
    //     String Column4Type = String.valueOf(d.fields.getMap().get(approvalRecord.Column_4__c).getDescribe().getType());
    //     String Column5Type = String.valueOf(d.fields.getMap().get(approvalRecord.Column_5__c).getDescribe().getType());
    //     string Column1ReferenceCustomField, Column2ReferenceCustomField, Column3ReferenceCustomField, Column4ReferenceCustomField,Column5ReferenceCustomField;
    //     string Column1ReferenceStandardField, Column2ReferenceStandardField, Column3ReferenceStandardField, Column4ReferenceStandardField,Column5ReferenceStandardField;
        
       

    //     string query = 'SELECT ';
    //     if(approvalRecord.Column_1__c != null)
    //     {
    //         query = query  + approvalRecord.Column_1__c;
    //         if(Column1Type == 'Reference' )
    //         {
    //           if( approvalRecord.Column_1__c.contains('__c'))
    //           {
    //              Column1ReferenceCustomField = approvalRecord.Column_1__c.replaceAll('__c', '__r.Name');
    //             query = query + ', ' + Column1ReferenceCustomField;
    //           }
    //           else {
    //              Column1ReferenceStandardField = approvalRecord.Column_1__c + '.Name';
    //             query = query + ', ' + Column1ReferenceStandardField;
    //           }
                
    //         }
    //     }
    //     if(approvalRecord.Column_2__c != null)
    //     {
    //         query = query + ', ' + approvalRecord.Column_2__c;
    //         if(Column2Type == 'Reference' )
    //         {
    //           if( approvalRecord.Column_2__c.contains('__c'))
    //           {
    //              Column2ReferenceCustomField = approvalRecord.Column_2__c.replaceAll('__c', '__r.Name');
    //             query = query + ', ' + Column2ReferenceCustomField;
    //           }
    //           else {
    //              Column2ReferenceStandardField = approvalRecord.Column_2__c + '.Name';
    //             query = query + ', ' + Column2ReferenceStandardField;
    //           }
                
    //         }
    //     }
    //     if(approvalRecord.Column_3__c != null)
    //     {
    //         query = query + ', ' + approvalRecord.Column_3__c;
    //         if(Column3Type == 'Reference' )
    //         {
    //           if( approvalRecord.Column_3__c.contains('__c'))
    //           {
    //              Column3ReferenceCustomField = approvalRecord.Column_3__c.replaceAll('__c', '__r.Name');
    //             query = query + ', ' + Column3ReferenceCustomField;
    //           }
    //           else {
    //              Column3ReferenceStandardField = approvalRecord.Column_3__c + '.Name';
    //             query = query + ', ' + Column3ReferenceStandardField;
    //           }
                
    //         }
    //     }
    //     if(approvalRecord.Column_4__c != null)
    //     {
    //         query = query + ', ' + approvalRecord.Column_4__c;
    //         if(Column4Type == 'Reference' )
    //         {
    //           if( approvalRecord.Column_4__c.contains('__c'))
    //           {
    //              Column4ReferenceCustomField = approvalRecord.Column_4__c.replaceAll('__c', '__r.Name');
    //             query = query + ', ' + Column4ReferenceCustomField;
    //           }
    //           else {
    //              Column4ReferenceStandardField = approvalRecord.Column_4__c + '.Name';
    //             query = query + ', ' + Column4ReferenceStandardField;
    //           }
                
    //         }
    //     }
    //     if(approvalRecord.Column_5__c != null)
    //     {
    //         query = query + ', ' + approvalRecord.Column_5__c;
    //         if(Column5Type == 'Reference' )
    //         {
    //           if( approvalRecord.Column_5__c.contains('__c'))
    //           {
    //              Column5ReferenceCustomField = approvalRecord.Column_5__c.replaceAll('__c', '__r.Name');
    //             query = query + ', ' + Column5ReferenceCustomField;
    //           }
    //           else {
    //              Column5ReferenceStandardField = approvalRecord.Column_5__c + '.Name';
    //             query = query + ', ' + Column5ReferenceStandardField;
    //           }
                
    //         }
    //     }
    //     query = query + ' FROM ' + objectName + ' WHERE Id =: mjoblist1';
        
    //      system.debug(query);
    //     List<SObject> mjoblist = Database.query(query);

    //     for(SObject job : mjoblist)
    //     {
    //         system.debug('job is ' + job);
    //         mjobMap.put(job.Id, job);
    //     }
        
    //     List<ItemToapprove> ItemsToApproveClass = new List<ItemToapprove>();
    //     for( Integer i = 0; i < mjoblist.size(); i++) 
    //     {
    //         ItemToApprove its = new ItemToApprove();
    //         its.RecordId = String.valueOf(mjoblist[i].get('Id'));
    //         system.debug('AppColumn 1 is ' + approvalRecord.Column_1__c);
    //         its.Column1 = String.valueOf(mjoblist[i].get(approvalRecord.Column_1__c));
            
    //         if(Column1Type == 'Reference')
    //         {
    //             if(Column1ReferenceCustomField <> null)
    //             {
    //                 system.debug('Column1ReferenceField ' + Column1ReferenceCustomField);
    //                 // Id recId = Id.valueOf(its.Column1);
                   
    //                 // String name = recId.getSobjectType().getDescribe().getName();
                    
    //                 String objectN = Column1ReferenceCustomField.replaceAll('.Name', '');
    //                 its.Column1Name = String.valueOf(mjoblist[i].getSObject(objectN).get('Name'));
    //             }
    //             else
    //             {
    //                 its.Column1Name = String.valueOf(mjoblist[i].get(Column1ReferenceStandardField));
    //             }
    //         }
            
    //         system.debug('AppColumn 2 is ' + approvalRecord.Column_2__c);
    //         its.Column2 = String.valueOf(mjoblist[i].get(approvalRecord.Column_2__c));     
    //         if(Column2Type == 'Reference')
    //         {
    //             if(Column2ReferenceCustomField <> null)
    //             {
    //                 its.Column2Name = String.valueOf(mjoblist[i].get(Column2ReferenceCustomField));
    //             }
    //             else
    //             {
    //                 its.Column2Name = String.valueOf(mjoblist[i].get(Column2ReferenceStandardField));
    //             }
    //         }    
    //         system.debug('AppColumn 3 is ' + approvalRecord.Column_3__c);
    //         its.Column3 = String.valueOf(mjoblist[i].get(approvalRecord.Column_3__c));
    //         if(Column3Type == 'Reference')
    //         {
    //             if(Column3ReferenceCustomField <> null)
    //             {
    //                 its.Column3Name = String.valueOf(mjoblist[i].get(Column3ReferenceCustomField));
    //             }
    //             else
    //             {
    //                 its.Column3Name = String.valueOf(mjoblist[i].get(Column3ReferenceStandardField));
    //             }
    //         }
    //         system.debug('AppColumn 4 is ' + approvalRecord.Column_4__c);
    //         its.Column4 = String.valueOf(mjoblist[i].get(approvalRecord.Column_4__c));       
    //         if(Column4Type == 'Reference')
    //         {
    //             if(Column4ReferenceCustomField <> null)
    //             {
    //                 its.Column4Name = String.valueOf(mjoblist[i].get(Column4ReferenceCustomField));
    //             }
    //             else
    //             {
    //                 its.Column4Name = String.valueOf(mjoblist[i].get(Column4ReferenceStandardField));
    //             }
    //         }     
    //         system.debug('AppColumn 5 is ' + approvalRecord.Column_5__c);
    //         its.Column5 = String.valueOf(mjoblist[i].get(approvalRecord.Column_5__c));
    //         if(Column5Type == 'Reference')
    //         {
    //             if(Column5ReferenceCustomField <> null)
    //             {
    //                 its.Column5Name = String.valueOf(mjoblist[i].get(Column5ReferenceCustomField));
    //             }
    //             else
    //             {
    //                 its.Column5Name = String.valueOf(mjoblist[i].get(Column5ReferenceStandardField));
    //             }
    //         }
           

           
    //         system.debug('ItemToApprove  is  $$$$$$$' + its);
    //         ItemsToApproveClass.add(its);
    //     }
        
    //     return ItemsToApproveClass;
    // }
    @AuraEnabled
public static String ApproveSelectedItems(String ItemsToApproveReject, String Comments, String Decision, string processId)
{
    try 
    {
        system.debug('Items before ' + ItemsToApproveReject);
        
        Set<Id> pInstanceWorkitems = new Set<Id>();
        List<Approval.ProcessWorkitemRequest> allReq = new List<Approval.ProcessWorkitemRequest>();
        //JSONWrapper projectWrap = (JSONWrapper)JSON.deserialize(ProjectJSON, JSONWrapper.class);
        Integer count = 0;
        if(string.isEmpty(processId))
        {
            ItemListToApproveReject itemstoapproverejectlist = (ItemListToApproveReject)JSON.deserialize(ItemsToApproveReject, ItemListToApproveReject.class);
            system.debug('Items to Approve reject ' + itemstoapproverejectlist);
            Id qId = System.enqueueJob(new ApproveSelectedItemsQueueable(ItemsToApproveReject, Comments, Decision));
            return '200';
        }
        else
        {
                Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
                req2.setComments(Comments);
                req2.setAction(Decision); //to approve use 'Approve'
                req2.setWorkitemId(processId);
                system.debug('req 2 ' + req2);
                allReq.add(req2);
        Approval.ProcessResult[] result2 =  Approval.process(allReq);
        return '200';
    }
    } catch (Exception e) 
    {
        return e.getMessage();
    }
    
}
    @AuraEnabled
    public static List<ItemToApprove> GetAccountData(String objectName){
        system.debug('object name is ' + objectName);
        Set<Id> userSet = new Set<Id>();
        Set<Id> ProcessInstanceId = new Set<Id>();
        Map<Id, ProcessInstance> processInstanceMap = new Map<Id, ProcessInstance>();
        Map<Id, ProcessInstance> processcContactInstanceMap = new Map<Id, ProcessInstance>();
        Map<Id, ProcessInstanceWorkitem> processJobMap = new Map<Id, ProcessInstanceWorkitem>();
        Map<Id, ProcessInstance> processMJobMap = new Map<Id, ProcessInstance>();
        Map<Id, ProcessInstance> processContactMap = new Map<Id, ProcessInstance>();
        Map<Id, ProcessInstanceWorkitem> processuserMap = new Map<Id, ProcessInstanceWorkitem>();
        Map<Id, ATI_Job__c> mjobMap = new Map<Id,ATI_Job__c>();
        Map<Id, Contact> contactMap = new Map<Id,Contact>();
        Map<Id, String> processuserMap1 = new Map<Id, string>();
        List<ATI_Job__c> mjoblist = new List<ATI_Job__c>();
        List<Contact> contactlist = new List<Contact>();
        
        Set<Id> contactIds = new Set<Id>();
        Set<Id> mjobids = new Set<Id>();
        List<ProcessInstanceWorkitem> piwi = [Select Id, ProcessInstanceId, CreatedById, ActorId FROM ProcessInstanceWorkitem Where ActorId =: userInfo.getUserId()];
        system.debug('Approvals include ' + piwi);
    //   if(objectName == 'Master Job')
    //   {   
        for(ProcessInstanceWorkitem p : piwi)
        {
            processJobMap.put(p.ProcessInstanceId, p);
            userset.add(p.CreatedById);
            processUserMap.put(p.CreatedById, p);
            ProcessInstanceId.add(p.ProcessInstanceId);
        }
        List<user> usersList = [Select Id, Name FROM User Where Id=:userSet];
        for(user u : usersList)
        {
            processUserMap1.put(u.Id, u.Name);
        }
        List<ProcessInstance> processInstanceList = [Select Id, targetObjectId, CreatedById,(SELECT Id, StepStatus, Comments FROM Steps) FROM ProcessInstance Where Id =: ProcessInstanceId];
        system.debug('Approvals include ' + processInstanceList);
        for(ProcessInstance p : processInstanceList)
        {
            if(objectName == 'Contact')
            {
            if(p.targetobjectId.getSObjectType().getDescribe().getName() == 'Contact')
            {
                processcContactInstanceMap.put(p.Id, p);
                processContactMap.put(p.targetObjectId, p);
                
                contactIds.add(p.targetObjectId);
            }
        }
        if(objectName == 'Master Job')
            {
            if(p.targetobjectId.getSObjectType().getDescribe().getName() == 'Master_Job__c')
            {
                processInstanceMap.put(p.Id, p);
                processMJobMap.put(p.targetObjectId, p);
                
                mjobids.add(p.targetObjectId);
            }
        }
        }

        
        system.debug('mjob ids ' + mjobids);
        if(objectName == 'Master Job')
        {
             mjoblist = [Select Id, Name, Contact__c, Contact__r.Name, Account__c, Account__r.Name, Referred_By__c, Referred_By__r.Name, Master_Job__c, 
            Master_Job__r.Name FROM ATI_Job__c Where Master_Job__c =: mjobids];
            
            for(ATI_Job__c job : mjoblist)
            {
                system.debug('job is ' + job);
                mjobMap.put(job.Master_Job__c, job);
            }
        }
        if(objectName == 'Contact')
        {
            system.debug('Contact Ids are  '+ contactIds);
            contactMap.putAll([Select Id, Name FROM Contact Where Id =:contactIds]);
            system.debug('Contact map contains  '+ contactMap);
            // for(Contact c : contactlist)
            // {
            //     system.debug('Contact is ' + c);
            //     .put(Id, job);
            // }
        }
        List<ItemToapprove> ItemsToApproveClass = new List<ItemToapprove>();
        // system.debug('Items To Approve Class ' + ItemsToApproveClass);
        // ItemToApprove ia = new ItemToApprove();
        // ia.processId = 'Test';
        // ItemsToApproveClass.items.add(ia);
        // system.debug('Items To Approve Class ' + ItemsToApproveClass.items);
        //system.debug('Items To Approve Class ' + ItemsToApproveClass);
        if(objectName == 'Master Job')
        {
            for(ProcessInstance p : processInstanceMap.values())
            {
                ItemToApprove i = new ItemToApprove();
                i.processId = processJobMap.get(p.Id).Id;
                i.processinstanceId = p.Id;
                i.comments = p.Steps[0].comments;
                i.createdByName = processuserMap1.get(processJobMap.get(p.Id).createdById);
                system.debug('i is ' + i );
                if(p.TargetObjectId != null && mjobMap.containsKey(p.targetObjectId))
                {
                i.MasterJob = mjobMap.get(p.targetObjectId).Master_Job__r.Name;
                i.MasterJobId = mjobMap.get(p.targetObjectId).Master_Job__c;
                i.Account = mjobMap.get(p.targetObjectId).Account__r.Name;
                i.AccountId = mjobMap.get(p.targetObjectId).Account__c;
                i.Contact = mjobMap.get(p.targetObjectId).Contact__r.Name;
                i.ContactId = mjobMap.get(p.targetObjectId).Contact__c;
                i.ReferredBy = mjobMap.get(p.targetObjectId).Referred_By__r.Name;
                i.ReferredById = mjobMap.get(p.targetObjectId).Referred_By__c;
                }
                system.debug('i is ' + i );

                ItemsToApproveClass.add(i);
            }
        }
        if(objectName == 'Contact')
        {
            for(ProcessInstance p : processcContactInstanceMap.values())
            {
                ItemToApprove i = new ItemToApprove();
                i.processId = processJobMap.get(p.Id).Id;
                system.debug('Process Id is ' + i.processId + ' jobmap' + processJobMap.get(p.Id));
                i.processinstanceId = p.Id;
                i.comments = p.Steps[0].comments;
                i.createdByName = processuserMap1.get(processcContactInstanceMap.get(p.Id).createdById);
                system.debug('i is ' + i );
                
                i.Contact = contactMap.get(p.targetObjectId).Name;
                i.ContactId = p.TargetObjectId;
                system.debug('i is ' + i );

                ItemsToApproveClass.add(i);
            }
        }
        system.debug('ItemsToApproveClass is ' + ItemsToApproveClass);
        system.debug('Jobs Class is ' + mjoblist);
        
        return ItemsToApproveClass;
    }
    // if(objectName == 'All')
    //   {   
    //     for(ProcessInstanceWorkitem p : piwi)
    //     {
    //         processJobMap.put(p.ProcessInstanceId, p);
    //         userset.add(p.CreatedById);
    //         processUserMap.put(p.CreatedById, p);
    //         ProcessInstanceId.add(p.ProcessInstanceId);
    //     }
    //     List<user> usersList = [Select Id, Name FROM User Where Id=:userSet];
    //     for(user u : usersList)
    //     {
    //         processUserMap1.put(u.Id, u.Name);
    //     }
    //     List<ProcessInstance> processInstanceList = [Select Id, targetObjectId FROM ProcessInstance Where Id =: ProcessInstanceId];
    //     for(ProcessInstance p : processInstanceList)
    //     {
    //         // if(p.targetobjectId.getSObjectType().getDescribe().getName() == 'Master_Job__c')
    //         // {
    //             processInstanceMap.put(p.Id, p);
    //             processMJobMap.put(p.targetObjectId, p);
                
    //             // mjobids.add(p.targetObjectId);
    //         // }
    //     }
    //     // Map<Id, ATI_Job__c> mjobMap = new Map<Id,ATI_Job__c>();
    //     // system.debug('mjob ids ' + mjobids);
    //     // List<ATI_Job__c> mjoblist = [Select Id, Name, Contact__c, Contact__r.Name, Account__c, Account__r.Name, Referred_By__c, Referred_By__r.Name, Master_Job__c, Master_Job__r.Name FROM ATI_Job__c Where Master_Job__c =: mjobids];
    //     // for(ATI_Job__c job : mjoblist)
    //     // {
    //     //     system.debug('job is ' + job);
    //     //     mjobMap.put(job.Master_Job__c, job);
    //     // }
    //     List<ItemToapprove> ItemsToApproveClass = new List<ItemToapprove>();
    //     // system.debug('Items To Approve Class ' + ItemsToApproveClass);
    //     // ItemToApprove ia = new ItemToApprove();
    //     // ia.processId = 'Test';
    //     // ItemsToApproveClass.items.add(ia);
    //     // system.debug('Items To Approve Class ' + ItemsToApproveClass.items);
    //     //system.debug('Items To Approve Class ' + ItemsToApproveClass);
        
    //     for(ProcessInstance p : processInstanceMap.values())
    //     {
    //         ItemToApprove i = new ItemToApprove();
    //         i.processId = processJobMap.get(p.Id).Id;
    //         i.processinstanceId = p.Id;
    //         i.createdByName = processuserMap1.get(processJobMap.get(p.Id).createdById);
    //         i.ObjectName =  p.TargetObjectId;
          
    //         system.debug('i is ' + i );
    //         // i.MasterJob = mjobMap.get(p.targetObjectId).Master_Job__r.Name;
    //         // i.MasterJobId = mjobMap.get(p.targetObjectId).Master_Job__c;
    //         // i.Account = mjobMap.get(p.targetObjectId).Account__r.Name;
    //         // i.AccountId = mjobMap.get(p.targetObjectId).Account__c;
    //         // i.Contact = mjobMap.get(p.targetObjectId).Contact__r.Name;
    //         // i.ContactId = mjobMap.get(p.targetObjectId).Contact__c;
    //         // i.ReferredBy = mjobMap.get(p.targetObjectId).Referred_By__r.Name;
    //         // i.ReferredById = mjobMap.get(p.targetObjectId).Referred_By__c;
    //         system.debug('i is ' + i );

    //         ItemsToApproveClass.add(i);
    //     }
        
    //     return ItemsToApproveClass;
    // }
    // List<ItemToApprove> ita = new list<ItemToApprove>();
    // return ita;


    
    
//    @AuraEnabled
//     public class JSONWrapper{
//         public List<ItemToApprove> items;
//     }
    public class ItemListToApproveReject
    {
    @AuraEnabled
    public List<ItemToApprove> ItemsToApproveReject {get;set;}
    }
    public class ItemToApprove{
        @AuraEnabled
        public string processId {get;set;}
        @AuraEnabled
        public string processinstanceId {get;set;}
        @AuraEnabled
        public string createdByName {get;set;}
        @AuraEnabled
        public string MasterJob {get;set;}
        @AuraEnabled
        public string MasterJobId {get;set;}
        @AuraEnabled
        public string Account {get;set;}
        @AuraEnabled
        public string AccountId {get;set;}
        @AuraEnabled
        public string Contact {get;set;}
        @AuraEnabled
        public string ContactId {get;set;}
        @AuraEnabled
        public string ReferredBy {get;set;}
        @AuraEnabled
        public string ReferredById {get;set;}
        @AuraEnabled
        public string Comments {get;set;}
        @AuraEnabled
        public string ObjectName {get;set;}
        @AuraEnabled
        public string id {get;set;}
    }
    // if(objectName == 'All')
    //   {   
    //     for(ProcessInstanceWorkitem p : piwi)
    //     {
    //         processJobMap.put(p.ProcessInstanceId, p);
    //         userset.add(p.CreatedById);
    //         processUserMap.put(p.CreatedById, p);
    //         ProcessInstanceId.add(p.ProcessInstanceId);
    //     }
    //     List<user> usersList = [Select Id, Name FROM User Where Id=:userSet];
    //     for(user u : usersList)
    //     {
    //         processUserMap1.put(u.Id, u.Name);
    //     }
    //     List<ProcessInstance> processInstanceList = [Select Id, targetObjectId FROM ProcessInstance Where Id =: ProcessInstanceId];
    //     for(ProcessInstance p : processInstanceList)
    //     {
    //         // if(p.targetobjectId.getSObjectType().getDescribe().getName() == 'Master_Job__c')
    //         // {
    //             processInstanceMap.put(p.Id, p);
    //             processMJobMap.put(p.targetObjectId, p);
                
    //             // mjobids.add(p.targetObjectId);
    //         // }
    //     }
    //     // Map<Id, ATI_Job__c> mjobMap = new Map<Id,ATI_Job__c>();
    //     // system.debug('mjob ids ' + mjobids);
    //     // List<ATI_Job__c> mjoblist = [Select Id, Name, Contact__c, Contact__r.Name, Account__c, Account__r.Name, Referred_By__c, Referred_By__r.Name, Master_Job__c, Master_Job__r.Name FROM ATI_Job__c Where Master_Job__c =: mjobids];
    //     // for(ATI_Job__c job : mjoblist)
    //     // {
    //     //     system.debug('job is ' + job);
    //     //     mjobMap.put(job.Master_Job__c, job);
    //     // }
    //     List<ItemToapprove> ItemsToApproveClass = new List<ItemToapprove>();
    //     // system.debug('Items To Approve Class ' + ItemsToApproveClass);
    //     // ItemToApprove ia = new ItemToApprove();
    //     // ia.processId = 'Test';
    //     // ItemsToApproveClass.items.add(ia);
    //     // system.debug('Items To Approve Class ' + ItemsToApproveClass.items);
    //     //system.debug('Items To Approve Class ' + ItemsToApproveClass);
        
    //     for(ProcessInstance p : processInstanceMap.values())
    //     {
    //         ItemToApprove i = new ItemToApprove();
    //         i.processId = processJobMap.get(p.Id).Id;
    //         i.processinstanceId = p.Id;
    //         i.createdByName = processuserMap1.get(processJobMap.get(p.Id).createdById);
    //         i.ObjectName =  p.TargetObjectId;
          
    //         system.debug('i is ' + i );
    //         // i.MasterJob = mjobMap.get(p.targetObjectId).Master_Job__r.Name;
    //         // i.MasterJobId = mjobMap.get(p.targetObjectId).Master_Job__c;
    //         // i.Account = mjobMap.get(p.targetObjectId).Account__r.Name;
    //         // i.AccountId = mjobMap.get(p.targetObjectId).Account__c;
    //         // i.Contact = mjobMap.get(p.targetObjectId).Contact__r.Name;
    //         // i.ContactId = mjobMap.get(p.targetObjectId).Contact__c;
    //         // i.ReferredBy = mjobMap.get(p.targetObjectId).Referred_By__r.Name;
    //         // i.ReferredById = mjobMap.get(p.targetObjectId).Referred_By__c;
    //         system.debug('i is ' + i );

    //         ItemsToApproveClass.add(i);
    //     }
        
    //     return ItemsToApproveClass;
    // }
    // List<ItemToApprove> ita = new list<ItemToApprove>();
    // return ita;


    
    
//    @AuraEnabled
//     public class JSONWrapper{
//         public List<ItemToApprove> items;
//     }
    // public class ItemListToApproveReject
    // {
    // @AuraEnabled
    // public List<ItemToApprove> ItemsToApproveReject {get;set;}
    // }
    // public class ItemToApprove{
    //     @AuraEnabled
    //     public string processId {get;set;}
    //     @AuraEnabled
    //     public string processinstanceId {get;set;}
    //     @AuraEnabled
    //     public string createdByName {get;set;}
    //     @AuraEnabled
    //     public SObject Record {get;set;}
    //     @AuraEnabled
    //     public string RecordId {get;set;}
    //     @AuraEnabled
    //     public string ObjectName {get;set;}
    //     @AuraEnabled
    //     public string Column1 {get;set;}
    //     @AuraEnabled
    //     public string Column2 {get;set;}
    //     @AuraEnabled
    //     public string Column3 {get;set;}
    //     @AuraEnabled
    //     public string Column4 {get;set;}
    //     @AuraEnabled
    //     public string Column5 {get;set;}
    //     @AuraEnabled
    //     public string Column1Name {get;set;}
    //     @AuraEnabled
    //     public string Column2Name {get;set;}
    //     @AuraEnabled
    //     public string Column3Name {get;set;}
    //     @AuraEnabled
    //     public string Column4Name {get;set;}
    //     @AuraEnabled
    //     public string Column5Name {get;set;}
      
    //     @AuraEnabled
    //     public string id {get;set;}
    // }
}