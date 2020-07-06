public with sharing class FotoIn_Queueable_Integration implements Queueable, Database.AllowsCallouts {

    private Map<Id,ATI_Job__c> newMap;
    private Map<Id,ATI_Job__c> oldMap;
    public List<ATI_Job__c> jobsqueueable;
    Map<Id,String> typequeueablemap;
    Map<Id,String> oldmapNamequeue;
    Map<Id,Datetime> startdateQueue;
    String TypeOfAction;
    public static Map<Id,ATI_Job__c> globalJobMap = new Map<Id, ATI_Job__c>();
    public static Map<Id,User> globalUserMap = new Map<Id, User>();
    // public class EconzInfo{
    //     public string type {get;set;}
    //     public string oldmapname {get;set;}
    //     public dateTime startdateQueue {get;set;}
    // }
    public FotoIn_Queueable_Integration(List<ATI_Job__c> jobs, String TypeOfAction1) 
    {
        TypeOfAction = TypeOfAction1;
        jobsqueueable = jobs;
    }
    
    public void execute(QueueableContext context) {
       
        list<ATI_Job__c> jobList = jobsqueueable.deepClone(true, false, false);
        // globalJobMap = putall([SELECT Id, Name, Project_Site_Record_Id__c, Project_Site_Call_Result_Message__c, 
        //                                  Last_Successful_FotoIn_Update__c, Last_FotoIn_Update__c, Project_Site_Name__c, 
        //                                  Project_Site_Name_Fotoin__c, Project_Site_Address__c,year__c ,
        //                                  Project_Site_City__c, Project_Site_State__c, Project_Site_Zipcode__c 
        //                           FROM ATI_Job__c 
        //                           WHERE Id IN: jobList LIMIT 49999 ]);
        system.debug('job list ' + jobList.size());
        Integer count = 0;
        List<ATI_Job__c> jobList1 = new List<ATI_Job__c>();
        List<ATI_Job__c> jobList2 = new List<ATI_Job__c>();
        // List<ATI_Job__c> jobList3 = new List<ATI_Job__c>();
        // List<ATI_Job__c> jobList4 = new List<ATI_Job__c>();
        // List<ATI_Job__c> jobList5 = new List<ATI_Job__c>();
        if(jobList.size() >= 45 )
        {
            for(ATI_Job__c job : jobList)
            {

                if(count <= 45)
                {
                    jobList1.add(job);
                }
                if(count > 45)
                {
                    jobList2.add(job);
                }
                 
                count++;
            }
        }
        if(jobList1.isEmpty())
        {
            for(ATI_Job__c job : jobList)
            {
                if(TypeOfAction == 'Create')
                {
                    callFotoIn2Create(job);                
                }
                if(TypeOfAction == 'Edit')
                {
                    callFotoIn2Update(job);
            
                }
            }
        }
        else{
            for(ATI_Job__c job : jobList1)
            {
                if(TypeOfAction == 'Create')
                {
                    callFotoIn2Create(job);                
                }
                if(TypeOfAction == 'Edit')
                {
                    callFotoIn2Update(job);
            
                }
            }
        }
        update globalJobMap.values();
        if(!jobList2.isEmpty())
        {
            Id fotoin = System.enqueueJob(new FotoIn_Queueable_Integration(joblist2, TypeOfAction));
        }
        
    }
    public static void callFotoIn2Create(ATI_Job__c job){
    
        //took out Project_Site_Address_2__c from the soql query. 
            try{
                String jsonInput = JSON.serializePretty(callGoogleMapAPI(Job));
                getHttpResponse('POST', Label.FotoIn_Stage_Project_End_Point_URL, jsonInput, Job);
            }
            catch(Exception e){
                System.debug('Http call error ...' + e.getMessage());
                Job.Last_FotoIn_Update__c = Datetime.now();
                Job.Project_Site_Call_Result_Message__c = e.getMessage().left(2047);
                globalJobMap.put(job.Id, job);
                //update Job;
            }
    }
    public static void callFotoIn2Update(ATI_Job__c job) {
        
        //took out Project_Site_Address_2__c from the soql query. 
       
            try{
                JobWrap updateJobWrap = callGoogleMapAPI(Job);
                updateJobWrap.id = Job.Project_Site_Record_Id__c;
                String jsonInput = JSON.serializePretty(updateJobWrap);
                system.debug('Before PUT');
                getHttpResponse('PUT', Label.FotoIn_Stage_Project_End_Point_URL, jsonInput, Job);
                system.debug('After PUT');
                Job.Last_FotoIn_Update__c = Datetime.now();
                job.Last_Successful_FotoIn_Update__c = Datetime.now();
                Job.Project_Site_Call_Result_Message__c = 'Successfull';
                system.debug('End of PUT');
                globalJobMap.put(job.Id, job);
                
            }
            catch(Exception e){
                System.debug('Http call error ...' + e.getMessage());
                Job.Last_FotoIn_Update__c = Datetime.now();
                Job.Project_Site_Call_Result_Message__c = e.getMessage().left(2047);
                globalJobMap.put(job.Id, job);
            }
        }
    
    public static JobWrap callGoogleMapAPI(ATI_Job__c Job){
        String address = '';
        String JobId = Job.Id;
        if (Job.Project_Site_Address__c != null){
            address += Job.Project_Site_Address__c;
            
            address += ', ';
        }
        if (Job.Project_Site_City__c != null){
            address += Job.Project_Site_City__c +', ';
        }
        if (Job.Project_Site_State__c != null){
            address += Job.Project_Site_State__c +' ';
        }
        if (Job.Project_Site_Zipcode__c != null){
            address += Job.Project_Site_Zipcode__c +', ';
        }
        //address += 'USA';
        //address = EncodingUtil.urlEncode(address, 'UTF-8');
        system.debug('@@@ ADDRESS ===' +address);
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://maps.googleapis.com/maps/api/geocode/json?key=AIzaSyBuE7iBv1fugjx2Az7h-bCwJCoWOadglz8&address='+
                         EncodingUtil.urlEncode(address, 'UTF-8')+'&sensor=false');
        req.setMethod('GET');
        req.setTimeout(60000);
        JobWrap JobWrap = new JobWrap();
        // callout
        HttpResponse res = h.send(req);
        if(res.getStatusCode() == 200 || res.getStatusCode() == 201 ){
            // parse coordinates from response
            System.debug('Google response body ...' + res.getBody());
            JSONParser parser = JSON.createParser(res.getBody());
            double lat = null;
            double lon = null;
            while (parser.nextToken() != null) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'location'){
                    parser.nextToken(); // object start
                    while (parser.nextToken() != JSONToken.END_OBJECT){
                        String txt = parser.getText();
                        parser.nextToken();
                        if (txt == 'lat'){
                            lat = parser.getDoubleValue();
                        }
                        else if (txt == 'lng'){
                            lon = parser.getDoubleValue();
                        } 
                    }
                    System.debug('@@@ LAT ====' +lat);
                }
            }
            // update coordinates if we get back
            JobWrap.locations = new List<JobWrap.Location>();
            JobWrap.Location location = new JobWrap.Location();
            if (lat != null){
                location.latitude = lat;
            }
            if(lon != null){
                location.longitude = lon;
            }
            location.radius = Long.valueOf(Label.FotoIn_Project_Site_Radius);
            JobWrap.locations.add(location);
            JobWrap.archived = false;
            JobWrap.address = address;
            JobWrap.projectName = Job.Project_Site_Name_Fotoin__c;
            JobWrap.projectKey = Job.year__c;
        }
        else{
            throw new CallFotoInException(res.getBody());
        }
        return JobWrap ;
    }
    
    public static HTTPResponse getHttpResponse(String method, String endPoint, String jsonInput, ATI_Job__c updateJob) {
        HttpRequest req = new HttpRequest();
        Blob headerValue = Blob.valueOf(Label.FotoIn_User_Name + ':' + Label.FotoIn_User_Password);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);
        req.setMethod(method);
        req.setEndpoint(endPoint);
        req.setHeader('Content-Type','application/json');
        req.setBody(jsonInput);
        req.setTimeout(120000);
        Http http = new Http();
        HTTPResponse res = new HTTPResponse();
        Map<String, Object> responseMap = new Map<String, Object>();
        res = http.send(req);
        System.debug('This is the status code' + res.getStatuscode());
        if(res.getStatusCode() == 200 || res.getStatusCode() == 201){
            //todo need to save the project Id in the salesforce
            System.debug('Input: ... ' + jsonInput);
            System.debug('OutPut: ... ' + res.getBody());
            JSONParser parser = JSON.createParser(res.getBody());
            Long projectRecordId = 0;
            while (parser.nextToken() != null) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'data'){
                    parser.nextToken(); // object start
                    while (parser.nextToken() != JSONToken.END_OBJECT){
                        String txt = parser.getText();
                        parser.nextToken();
                        if (txt == 'id'){
                            projectRecordId = parser.getLongValue();
                        }
                    }
                    System.debug('@@@ projectRecordId ====' +projectRecordId);
                }
            }
            updateJob.Project_Site_Record_Id__c = String.valueOf(projectRecordId);
            updateJob.Last_Successful_FotoIn_Update__c = Datetime.now();
            updateJob.Last_FotoIn_Update__c = Datetime.now();
            updateJob.Project_Site_Call_Result_Message__c = '';
            globalJobMap.put(updateJob.Id, updateJob);
           // update ;
        }else{
            throw new CallFotoInException(res.getBody());
        }
        return res;
    }
}