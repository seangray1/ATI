public without sharing class AllSobjects implements Metadata.DeployCallback{
    
    public String selectedObject {get; set;}
    public List<FieldWrapper> listField{get;set;}

   

    // find all sObjects available in the organization
    public void handleResult(Metadata.DeployResult result, Metadata.DeployCallbackContext context) {
        if(result.status == Metadata.DeployStatus.SUCCEEDED)
        {
            //success
        }else{
            //not success
        }
        
    }
    @AuraEnabled
    public static List<string> getListObjectName() 
    {
        Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        List<string> objNames = new List<string>();
        List<String> entities = new List<String>(schemaMap.keySet());
        entities.sort();
        integer count = 0;
        String substr = '__';
        for(String name : entities)
        {
            // system.debug('Name is ' + name);
           count = name.CountMatches(substr);
           if(count > 1 || name.contains('__mdt'))
           {
                // system.debug('$$$$$$bad' + name);
           }
           else{
               objNames.add(name);
           }
        }
            // objNames.add(new SelectOption(name,name));
            
        return objNames;
    }
    @AuraEnabled
    public static List<string> getFieldNames(List<String> objectName)
    {
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(objectName[0]).getDescribe().fields.getMap();
        List<string> objNames = new List<string>();
        List<String> entities = new List<String>(fieldMap.keySet());
        entities.sort();
        integer count = 0;
        // String substr = '__';
        for(String name : entities)
        {
            objNames.add(name);
        }
        return objNames;
    }
    @AuraEnabled
    public static String SaveApprovalView(List<String> objectName, List<String> Columns)
    {
        try {
        
        // system.debug('Object name is ' + objectName + ' Columns is ' + Columns);
        Approval_Configuration__mdt approvalConfigToInsert = new Approval_Configuration__mdt(Object_Name__c = objectName[0]);
        Metadata.CustomMetadata customMetadata = new Metadata.CustomMetadata();
        string ObjectNameSpliced = objectName[0].replaceAll('__c', ' ');
        string ObjectNameSpliced1 = ObjectNameSpliced.replaceAll('_', ' ');
        customMetadata.fullName = 'Approval_Configuration.' + ObjectNameSpliced1;
        customMetadata.label = ObjectNameSpliced1;
        Metadata.CustomMetadataValue customFieldObjectName = new Metadata.CustomMetadataValue();
        customFieldObjectName.field = 'Object_Name__c';
        customFieldObjectName.value = objectName[0];
        customMetadata.values.add(customFieldObjectName);
        for( Integer i = 0; i < Columns.size(); i++) 
        {
            if(i == 0)
            {
                Metadata.CustomMetadataValue customField = new Metadata.CustomMetadataValue();
                customField.field = 'Column_1__c';
                customField.value = Columns[i];
                customMetadata.values.add(customField);
            }
            if(i == 1)
            {
                Metadata.CustomMetadataValue customField = new Metadata.CustomMetadataValue();
                customField.field = 'Column_2__c';
                customField.value = Columns[i];
                customMetadata.values.add(customField);
               
            }
            if(i == 2)
            {
                Metadata.CustomMetadataValue customField = new Metadata.CustomMetadataValue();
                customField.field = 'Column_3__c';
                customField.value = Columns[i];
                customMetadata.values.add(customField);
                
            }
            if(i == 3)
            {
                Metadata.CustomMetadataValue customField = new Metadata.CustomMetadataValue();
                customField.field = 'Column_4__c';
                customField.value = Columns[i];
                customMetadata.values.add(customField);
               
            }
            if(i == 4)
            {
                Metadata.CustomMetadataValue customField = new Metadata.CustomMetadataValue();
                customField.field = 'Column_5__c';
                customField.value = Columns[i];
                customMetadata.values.add(customField);
               
            }
        }
        Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
        mdContainer.addMetadata(customMetadata);
        AllSobjects callback = new AllSobjects();
        Id jobId = Metadata.Operations.enqueueDeployment(mdContainer, callback);
        // insert approvalConfigToInsert;
        // system.debug('jobId is ' + jobId);
        
        // Metadata.DeployContainer metaDeploy1 = new Metadata.DeployContainer();
        // metaDeploy1.addMetadata(approvalConfigToInsert);
        // Id AsynchResult1 = Metadata.Operations.enqueueDeployment(metadeploy1, null);

        return 'Success';
            
        } catch (Exception e) {
                return e.getMessage();
        }
        }
           
            
        
    
    public class FieldWrapper

    {

        public String fieldName {get; set;}

        public String fieldAPIName {get; set;}

    }

}