public class SharinPixResyncController {

    public class MulesoftAPIException extends Exception {}
    
    @AuraEnabled
    public static String executeJob(String JobId){
    	String message = SharinPix_Constants.STRING_EMPTY;
        String body = SharinPix_Constants.STRING_EMPTY;
        System.debug('JobID-----'+ JobId);
        ATI_Job__c Job = [select Id, Google_Drive_Folder_Ref__c from ATI_Job__c where Id =: JobId];
        List<sharinpix__SharinPixImage__c> allSharinPixImages = new List<sharinpix__SharinPixImage__c>([select id from sharinpix__SharinPixImage__c where Job__c =: JobId]);
        List<SharinPix_Deleted_Images__c> allSharinPixDelImages = new List<SharinPix_Deleted_Images__c>([select Old_SharinPix_record_ID__c from SharinPix_Deleted_Images__c where Job__c =: JobId]);
        
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('Job', Job.id);
        gen.writeStringField('ParentGDID', Job.Google_Drive_Folder_Ref__c);        
        gen.writeFieldName('CurrentImages');
    	gen.writeStartArray();
            for(sharinpix__SharinPixImage__c asi :allSharinPixImages){
                gen.writeStartObject();
                gen.writeStringField('Id', asi.Id);
                gen.writeEndObject();
            }
    	gen.writeEndArray();        
        gen.writeFieldName('DeletedImages');
    	gen.writeStartArray();
            for(SharinPix_Deleted_Images__c asdi :allSharinPixDelImages){
                gen.writeStartObject();
                gen.writeStringField('Id', asdi.Old_SharinPix_record_ID__c);
                gen.writeEndObject();
            }
    	gen.writeEndArray();
        
        gen.writeEndObject();
        body = gen.getAsString(); 
        
        System.debug('body---------->'+body);
        
        
        HttpResponse res1;
        res1 = ResyncAPI(body);
        
        
        String str=res1.getbody();
        Integer Status = res1.getStatusCode();
        System.debug('******* Result ResyncAPI API function - ' + str);
        if(Status == 200 || Status == 201){
        	message = 'Success';
        }
        else{
            message = 'Error';
        }
        
        return message;
        
        
    }

    @TestVisible
    private static HttpResponse ResyncAPI(String Body) {
        if(String.isBlank(Body))
            throw new MulesoftAPIException(SharinPix_Constants.APIERROR_BODYISEMPTY); 
        
        Http http = new Http();
        HttpRequest req1 = new HttpRequest();
        
        req1.setEndpoint(SharinPix_Constants.ENDPOINTURL + SharinPix_Constants.API_RESYNC);
        req1.setmethod(SharinPix_Constants.HTTPREQMETHOD_POST);
        req1.setHeader('Content-Type', SharinPix_Constants.CONTENTTYPE_JSON); 
        req1.setTimeout(20000);
        req1.setbody(body);
        
        HttpResponse res1;
        res1 = http.send(req1);
        
        return res1;
    }
}