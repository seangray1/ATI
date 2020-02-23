/**
 * @File Name          : CloneATIJob.cls
 * @Description        : 
 * @Author             : sean.gray@atirestoration.com
 * @Group              : 
 * @Last Modified By   : sean.gray@atirestoration.com
 * @Last Modified On   : 2/17/2020, 11:25:15 AM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    1/9/2020   sean.gray@atirestoration.com     Initial Version
**/
public class CloneATIJob {
   
   @AuraEnabled
    public static string CloneJobRecord(String recordId, Boolean related){
        ATI_Job__c job = [SELECT Id, name, Job_Name__c,Job_Number__c, Account__c, Contact__c, Customer__c, Lead_Source__c,
                         Description__c, Job_Class__c, Project_Site_Contact_Name__c,Contact_Information__c, Project_Manager__c, 
                         Branch_Manager__c, Project_Site_Contact_Account__c, Office2__c, Stage__c, Taken_By__c, Project_type__c,
                         Referred_by__c, CloseDate__c,Probability__c, County__c, City_of_LA__c, Project_Site_Address_2__c, 
                         Project_site_address__c, Project_site_city__c, Project_site_state__c, Project_site_zipcode__c, Year_Structure_built__c,
                         Date_of_loss__c, Project_Site_Contact_Email__c, no_Email_Available__c, Policy__c, Deductible__c, Claim__c, 
                         Cont_P_O_Client_Job__c, PO__c, Send_prelim__c FROM ATI_Job__c WHERE Id = :recordId];
        string recId;
        if(related){
            recId = recordId;
        }
        else{
            recId = '';
        }
        Id unapprovedRecordTypeId = Schema.SObjectType.ATI_Job__c.getRecordTypeInfosByName().get('New Job (Not Approved)').getRecordTypeId();
        ATI_Job__c newJob = new ATI_Job__c (Name = job.name, recordTypeId = unapprovedRecordTypeId, Job_Name__c = job.Job_Name__c, Job_Number__c= job.Job_Number__c, Account__c = job.Account__c, Contact__c = job.Contact__c,
        Customer__c = job.Customer__c, Lead_Source__c =job.Lead_Source__c, Description__c = job.Description__c, Job_Class__c = job.Job_Class__c, Project_Site_Contact_Name__c = job.Project_Site_Contact_Name__c,  
        Branch_Manager__c = job.Branch_Manager__c, Project_Site_Contact_Account__c = job.Project_Site_Contact_Account__c, Office2__c = job.Office2__c, Stage__c = 'Qualification', Taken_By__c = job.Taken_By__c, Project_type__c = job.Project_type__c,
        Referred_by__c = job.Referred_by__c, CloseDate__c = job.CloseDate__c, County__c = job.County__c, City_of_LA__c = job.City_of_LA__c, Project_Site_Address_2__c = job.Project_Site_Address_2__c, 
        Project_site_address__c = job.Project_site_address__c, Project_site_city__c = job.Project_site_city__c, Project_site_state__c = job.Project_site_state__c, Project_site_zipcode__c = job.Project_site_zipcode__c, Year_Structure_built__c = job.Year_Structure_built__c,
        Date_of_loss__c = job.Date_of_loss__c, no_Email_Available__c = job.no_Email_Available__c, Policy__c = job.Policy__c, Deductible__c = job.Deductible__c, Claim__c = job.Claim__c, 
        Cont_P_O_Client_Job__c = job.Cont_P_O_Client_Job__c, PO__c = job.PO__c, Send_prelim__c = job.Send_prelim__c, Parent_Job__c = recId );
       try {
        insert newJob;
        return newJob.id;
           
       } catch (Exception e) {
           return string.valueOf(e);
       } 
        
        
    } 
}