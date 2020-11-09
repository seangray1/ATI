/*******************************************************************************************
* @author           Suman
* @version          1.0 
* @date             10-AUG-2020
* @Status           In-Progress
* @Class Name       GoogleDriveSubFolderFileDetail
* @description      	
*********************************************************************************************
Version     Date      Team          Comments
*********************************************************************************************
* 1      	Aug 2020    Suman        Initial Creation(JIRA AR-653)
*********************************************************************************************/
public with sharing class GoogleDriveSubFolderFileDetail {
    @AuraEnabled public String googleDriveId;
    @AuraEnabled public String name;
    @AuraEnabled public String extension;
    @AuraEnabled public String iconLink;
    @AuraEnabled public String filePath;
    @AuraEnabled public String ownerName;
    @AuraEnabled public String parentGDId;
    @AuraEnabled public String lastModifiedBy;
    @AuraEnabled public String viewLink;
    @AuraEnabled public String downloadLink;
    @AuraEnabled public String modifiedDate;// Format- Oct 16,2020
    @AuraEnabled public String size;
    @AuraEnabled public String mimeType;
    @AuraEnabled public Boolean isFolder;
    @AuraEnabled public String createdBySFUserName;
    @AuraEnabled public String createdBySFUserEmail;
    
    //Added for existing recs where Google drive fields are empty
    @AuraEnabled public String parentFolderGDId;
    @AuraEnabled public String parentFolderGDLink;
    @TestVisible 
    static Google_Drive_Integration_Configurations__mdt googleDriveConfigDetails { 
        get {
              if (null == googleDriveConfigDetails &&
                Schema.sObjectType.Google_Drive_Integration_Configurations__mdt.fields.Mulesoft_API_Email_Address__c.isAccessible() && 
                Schema.sObjectType.Google_Drive_Integration_Configurations__mdt.fields.Mulesoft_API_Name__c.isAccessible()) 
                googleDriveConfigDetails = [SELECT Mulesoft_API_Email_Address__c ,Mulesoft_API_Name__c FROM Google_Drive_Integration_Configurations__mdt LIMIT 1];
                
            return googleDriveConfigDetails;
        } set; 
    }
    
    public GoogleDriveSubFolderFileDetail(String googleDriveId, Boolean isFolder, String filePath, String name, String extension, String iconLink, String ownerName, String lastModifiedBy,String viewLink, String downloadLink, String modifiedDate, String size, String mimeType, String parentGDId, String description, String parentId, String googleDriveLink){
        this.googleDriveId = googleDriveId;
        this.name = name;
        this.extension = extension; 
        this.iconLink = iconLink;
        this.filePath = filePath;
        this.ownerName = ownerName;
        this.createdBySFUserName = description.substringBefore(GDI_Constants.STRING_SQUAREBRACKETSTART);
        this.createdBySFUserEmail = description.substringAfter(GDI_Constants.STRING_SQUAREBRACKETSTART).removeEnd(GDI_Constants.STRING_SQUAREBRACKETEND);
    	
        if(String.isBlank(googleDriveConfigDetails.Mulesoft_API_Email_Address__c) || String.isBlank(googleDriveConfigDetails.Mulesoft_API_Name__c) )
            this.lastModifiedBy = lastModifiedBy;
        else if(lastModifiedBy.equalsIgnoreCase(googleDriveConfigDetails.Mulesoft_API_Email_Address__c.trim())){
            if(String.isBlank(createdBySFUserName))
                this.lastModifiedBy = googleDriveConfigDetails.Mulesoft_API_Name__c;
            else
            	this.lastModifiedBy = createdBySFUserName;
        }
        else
            this.lastModifiedBy = lastModifiedBy;
        
        this.viewLink = viewLink;
        this.downloadLink = downloadLink;
        this.modifiedDate = modifiedDate;
        this.size = size;
        this.mimeType = mimeType;
        this.isFolder = isFolder;
        this.parentGDId = parentGDId;
        
        //Added for existing recs where Google drive fields are empty
        this.parentFolderGDId =parentId;
        this.parentFolderGDLink =googleDriveLink;
    }
}