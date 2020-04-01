public with sharing class SubmitForApprovalExtension {
    public Id objId { get; set; }
    public String doLock { get; set; }
    // public SubmitForApprovalExtension(){
    //     objId = ApexPages.currentPage().getParameters().get('id');
    //     doLock = Apexpages.currentPage().getParameters().get('lock');
    // }
    @AuraEnabled
    public static String submitForApproval(Id recordId){
        
        try{
            Set<Id> GroupMemberSet = new Set<Id>();
        ATI_Job__c job = [Select Id, recordTypeId FROM ATI_Job__c Where Id =: recordId];
        Group groupId = [Select Id FROM GROUP Where Type='Queue' AND DeveloperName = 'Hybrid_PD'];
        List<GroupMember> groupMembers = [Select Id, userOrGroupId, GroupId FROM GroupMember Where GroupId =: groupId.Id];
        for(GroupMember groupMember1 : groupMembers){
            GroupMemberSet.add(groupMember1.userorgroupId);
        }
        Id recordTypeId = Schema.SObjectType.ATI_Job__c.getRecordTypeInfosByName().get('Job (Approved)').getRecordTypeId();
            list<Profile> profs = [Select Name FROM Profile Where Name in ('Marketing Representative','System Administrator')];
            Id userPr = UserInfo.getProfileId();
            Id user1 = UserInfo.getUserId();
            if(job.recordTypeId == recordTypeId && (userPr == profs[0].Id || userPr == profs[1].id  || groupMemberset.contains(user1))){
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setComments('Submitting request for approval.');
            // req1.setSubmitterId(user1);
            // Submit the record to specific process and skip the criteria evaluation
            req1.setProcessDefinitionNameOrId('Credit_Request_Approval_Process');
            req1.setObjectId(recordId);
            req1.setskipentrycriteria(true);
            // Submit the approval request for the account
            Approval.ProcessResult result = Approval.process(req1);
            
            UnlockRecord(recordId); 
            // if( doLock == '0' ){
            //     Approval.Unlock(objId);
            // }
            return 'Success';
            }else{
                return 'User does not have Access or Job is not Approved';
            }
        }catch(Exception e){
            return e.getMessage();
        }
    }
    @future
    public static void UnlockRecord(Id recordId){
        Approval.Unlock(recordId);
    }
    //     }catch( DmlException ex ){
    //         for( Integer i=0; i<ex.getNumDml(); i++ ){                
    //             Apexpages.addMessage( new ApexPages.message( Apexpages.Severity.ERROR, ex.getDmlMessage(i) ) );
    //         }
    //         return null;
    //     }catch( Exception ex ){
    //         Apexpages.addMessage( new ApexPages.message( Apexpages.Severity.ERROR, ex.getMessage() ) );
    //         return null;
    //     }
    //     return new PageReference( '/' + objId );
    // }
    
    @AuraEnabled
    public static sObject getsObject(ID ObjectId){
        
        String sObjName = ObjectId.getSObjectType().getDescribe().getName();
        
        if(sObjName == 'ATI_Job__c'){
            ATI_Job__c job = (ATI_Job__c)Database.query('SELECT Id FROM ATI_Job__c where Id =: ObjectId LIMIT 1');
            return job;
        }
        else if(sObjName == 'Contact'){
                Contact con = (Contact)Database.query('Select Id from Contact where Id =: ObjectId limit 1');
                return con; 
        }
        else
            return null;



    }
}