/**
 * @File Name          : BigTimeCalloutMockRequest.cls
 * @Description        : 
 * @Author             : sean.gray@atirestoration.com
 * @Group              : 
 * @Last Modified By   : Sean Gray
 * @Last Modified On   : 11/10/2019, 3:50:59 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    11/8/2019   sean.gray@atirestoration.com     Initial Version
**/
@isTest(SeeAllData=true)
private class Queueable_Test_Methods {
    @isTest static void testUpdateFotoInQueueable(){
        
        ATI_Job__c j = [Select Id, Name, division__c, bigtimeSId__c,Project_Site_Record_Id__c, Project_Site_Call_Result_Message__c, 
                                         Last_Successful_FotoIn_Update__c, Last_FotoIn_Update__c, Project_Site_Name__c, 
                                         Project_Site_Name_Fotoin__c, Project_Site_Address__c,year__c ,
                                         Project_Site_City__c, Project_Site_State__c, Project_Site_Zipcode__c  FROM Ati_Job__c WHERE name= '000-00-00002 | Test Job 1' Limit 1];
        
            Map<String,String> fotoinheaders = new Map<String,String>();
            fotoinheaders.put('Content-Type', 'application/json');
            Map<String,String> googleheaders = new Map<String,String>();
            googleheaders.put('Content-Type', 'application/json');
            String outPutJson = '{"location": { "lat": 37.09024, "lng": -95.712891}}';
            String outputJsonAddress = '{"results" : [{"access_points" : [],"address_components" : [{"long_name" : "15632","short_name" : "15632","types" : [ "street_number" ]},{"long_name" : "Youngwood Drive","short_name" : "Youngwood Dr","types" : [ "route" ]},{"long_name" : "East Whitter","short_name" : "East Whitter","types" : [ "neighborhood", "political" ]},{"long_name" : "Whittier","short_name" : "Whittier","types" : [ "locality", "political" ]},{"long_name" : "Los Angeles County","short_name" : "Los Angeles County","types" : [ "administrative_area_level_2", "political" ]},{"long_name" : "California","short_name" : "CA","types" : [ "administrative_area_level_1", "political" ]},{"long_name" : "United States","short_name" : "US","types" : [ "country", "political" ]},{"long_name" : "90603","short_name" : "90603","types" : [ "postal_code" ]},{"long_name" : "1235","short_name" : "1235","types" : [ "postal_code_suffix" ]}],"formatted_address" : "15632 Youngwood Dr, Whittier, CA 90603, USA","geometry" : {"bounds" : {"northeast" : {"lat" : 33.9551556,"lng" : -117.9936276},"southwest" : {"lat" : 33.9549415,"lng" : -117.9938733}},"location" : {"lat" : 33.9550515,"lng" : -117.9937451},"location_type" : "ROOFTOP","viewport" : {"northeast" : {"lat" : 33.9563975302915,"lng" : -117.9924014697085},"southwest" : {"lat" : 33.9536995697085,"lng" : -117.9950994302915}}},"place_id" : "ChIJ--yIXe3UwoARtn_JzLhd-i0","types" : [ "premise" ]}],"status" : "OK"}';
            SingleRequestMock fakeAccountResp = new SingleRequestMock(200,
                                                         '200',
                                                         outPutJson,
                                                         fotoinheaders);
 
            SingleRequestMock fakeContactsResp = new SingleRequestMock(200,
                                                  'Complete',
                                                  outputJsonAddress,
                                                   googleheaders);
            Test.setMock(HttpCalloutMock.class, new MockHttpGoogleMapsResponse(200, 'success', outputJsonAddress, null));
            //Test.setMock(HttpCalloutMock.class, fakeContactsResp);
            List<ATI_Job__c> jobfotoinlist = new List<ATI_Job__c>();
            jobfotoinlist.add(j);
            Id fotonInQueue = System.enqueueJob(new FotoIn_Queueable_Integration(jobfotoinlist, 'Edit', new Map<Id,ATI_Job__c>()));
            jobfotoinlist.clear();
            // jobfotoinlist.add(jobs[1]);
            // Id fotonInQueue1 = System.enqueueJob(new FotoIn_Queueable_Integration(jobfotoinlist, 'Create'));
    }
    @isTest static void testCreateFotoInQueueable(){
        
        ATI_Job__c j = [Select Id, Name, division__c, bigtimeSId__c,Project_Site_Record_Id__c, Project_Site_Call_Result_Message__c, 
                                         Last_Successful_FotoIn_Update__c, Last_FotoIn_Update__c, Project_Site_Name__c, 
                                         Project_Site_Name_Fotoin__c, Project_Site_Address__c,year__c ,
                                         Project_Site_City__c, Project_Site_State__c, Project_Site_Zipcode__c  FROM Ati_Job__c WHERE name= '000-00-00002 | Test Job 1' Limit 1];
        
            Map<String,String> fotoinheaders = new Map<String,String>();
            fotoinheaders.put('Content-Type', 'application/json');
            Map<String,String> googleheaders = new Map<String,String>();
            googleheaders.put('Content-Type', 'application/json');
            String outPutJson = '{"location": { "lat": 37.09024, "lng": -95.712891}}';
            String outputJsonAddress = '{"results" : [{"access_points" : [],"address_components" : [{"long_name" : "15632","short_name" : "15632","types" : [ "street_number" ]},{"long_name" : "Youngwood Drive","short_name" : "Youngwood Dr","types" : [ "route" ]},{"long_name" : "East Whitter","short_name" : "East Whitter","types" : [ "neighborhood", "political" ]},{"long_name" : "Whittier","short_name" : "Whittier","types" : [ "locality", "political" ]},{"long_name" : "Los Angeles County","short_name" : "Los Angeles County","types" : [ "administrative_area_level_2", "political" ]},{"long_name" : "California","short_name" : "CA","types" : [ "administrative_area_level_1", "political" ]},{"long_name" : "United States","short_name" : "US","types" : [ "country", "political" ]},{"long_name" : "90603","short_name" : "90603","types" : [ "postal_code" ]},{"long_name" : "1235","short_name" : "1235","types" : [ "postal_code_suffix" ]}],"formatted_address" : "15632 Youngwood Dr, Whittier, CA 90603, USA","geometry" : {"bounds" : {"northeast" : {"lat" : 33.9551556,"lng" : -117.9936276},"southwest" : {"lat" : 33.9549415,"lng" : -117.9938733}},"location" : {"lat" : 33.9550515,"lng" : -117.9937451},"location_type" : "ROOFTOP","viewport" : {"northeast" : {"lat" : 33.9563975302915,"lng" : -117.9924014697085},"southwest" : {"lat" : 33.9536995697085,"lng" : -117.9950994302915}}},"place_id" : "ChIJ--yIXe3UwoARtn_JzLhd-i0","types" : [ "premise" ]}],"status" : "OK"}';
            SingleRequestMock fakeAccountResp = new SingleRequestMock(200,
                                                         '200',
                                                         outPutJson,
                                                         fotoinheaders);
 
            SingleRequestMock fakeContactsResp = new SingleRequestMock(200,
                                                  'Complete',
                                                  outputJsonAddress,
                                                   googleheaders);
            Test.setMock(HttpCalloutMock.class, new MockHttpGoogleMapsResponse(200, 'success', outputJsonAddress, null));
            //Test.setMock(HttpCalloutMock.class, fakeContactsResp);
            List<ATI_Job__c> jobfotoinlist = new List<ATI_Job__c>();
            jobfotoinlist.add(j);
            Id fotonInQueue = System.enqueueJob(new FotoIn_Queueable_Integration(jobfotoinlist, 'Create', new Map<Id,ATI_Job__c>()));
            jobfotoinlist.clear();
            // jobfotoinlist.add(jobs[1]);
            // Id fotonInQueue1 = System.enqueueJob(new FotoIn_Queueable_Integration(jobfotoinlist, 'Create'));
    }
    @isTest static void test_addTask() 
    {
        ATI_Job__c j = [Select Id, Name, division__c, bigtimeSId__c,Project_Site_Record_Id__c, Project_Site_Call_Result_Message__c, 
                                         Last_Successful_FotoIn_Update__c, Last_FotoIn_Update__c, Project_Site_Name__c, 
                                         Project_Site_Name_Fotoin__c, Project_Site_Address__c,year__c ,
                                         Project_Site_City__c, Project_Site_State__c, Project_Site_Zipcode__c  FROM Ati_Job__c WHERE name= '000-00-00002 | Test Job 1' Limit 1];
        
                                         string response = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'+
                                         '<soapenv:Body>'+
                                         '<ns1:addTaskForManagerResponse soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" xmlns:ns1="http://nads.econz.co.nz/timecard1/" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">'+
                                         '<addTaskForManagerResponse xsi:type="ns1:AddNewTaskResult" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ns1="http://nads.econz.co.nz/timecard1/">'+
                                         '<accessDeniedFailure xsi:type="ns2:AccessDeniedFailure" xsi:nil="true" xmlns:ns2="http://auth.soap.econz.co.nz" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" />'+
                                         '<validationFailure xsi:type="ns3:ValidationFailure" xsi:nil="true" xmlns:ns3="http://soap.econz.co.nz" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" />'+
                                         '</addTaskForManagerResponse>'+
                                         '</ns1:addTaskForManagerResponse>'+
                                         '</soapenv:Body>'+
                                         '</soapenv:Envelope>';
            Test.setMock(HttpCalloutMock.class, new MockHttpGoogleMapsResponse(200, 'success', response, null));


            J.ECONZ_Task_Created__c = false;
            J.Project_Manager_new__c  = UserInfo.getuserId();
            j.Amount__c=5500;
            
            List<ATI_Job__c> jobs = new List<ATI_Job__c>();
            jobs.add(j);
            Map<Id,Datetime> startdatemap = new Map<Id,Datetime>();
            Map<Id,String> oldmapname = new Map<Id,String>();
            Map<Id,String> typemap = new Map<Id,String>();
            Map<Id,ATI_Job__c> oldMap = new Map<Id,ATI_Job__c>();
            oldMap.put(j.Id, j);
            startdatemap.put(j.Id, Date.Today());
            // oldmapname.put(job.Id, null);
            typemap.put(j.Id, 'addTask');
            jobs.add(j);      
            //Test.setMock(HttpCalloutMock.class, fake_AddTask());
            // List<ATI_Job__c> jobs, Map<Id,String> typemap, Map<Id,String> oldmapname, Map<Id,Datetime> startdatemap, Map<Id,ATI_Job__c> oldMap, Map<Id,ATI_Job__c> JobsCarriedOverMapTemp
            Id econzQueue = System.enqueueJob(new Econz_Queueable_Integration(jobs, typemap, oldmapname, startdatemap, oldmap, new Map<Id,ATI_Job__c>()));
            //List<ATI_Job__c> jobs, Map<Id,String> typemap, Map<Id,String> oldmapname, Map<Id,Datetime> startdatemap
            //Econz_Integration_Callouts.ECONZ_Future_Call(Job.Id,'addTask','',Date.today());
            Econz_Queueable_Integration.TestPass(jobs);
    }
    
    @isTest static void test_updateTaskManager() {
        ATI_Job__c j = [Select Id, Name, division__c, bigtimeSId__c,Project_Site_Record_Id__c, Project_Site_Call_Result_Message__c, 
                                         Last_Successful_FotoIn_Update__c, Last_FotoIn_Update__c, Project_Site_Name__c, 
                                         Project_Site_Name_Fotoin__c, Project_Site_Address__c,year__c ,
                                         Project_Site_City__c, Project_Site_State__c, Project_Site_Zipcode__c  FROM Ati_Job__c WHERE name= '000-00-00002 | Test Job 1' Limit 1];
        
                                         string response = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'+
                                         '<soapenv:Body>'+
                                         '<ns1:addTaskForManagerResponse soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" xmlns:ns1="http://nads.econz.co.nz/timecard1/" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">'+
                                         '<addTaskForManagerResponse xsi:type="ns1:AddNewTaskResult" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ns1="http://nads.econz.co.nz/timecard1/">'+
                                         '<accessDeniedFailure xsi:type="ns2:AccessDeniedFailure" xsi:nil="true" xmlns:ns2="http://auth.soap.econz.co.nz" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" />'+
                                         '<validationFailure xsi:type="ns3:ValidationFailure" xsi:nil="true" xmlns:ns3="http://soap.econz.co.nz" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" />'+
                                         '</addTaskForManagerResponse>'+
                                         '</ns1:addTaskForManagerResponse>'+
                                         '</soapenv:Body>'+
                                         '</soapenv:Envelope>';
            Test.setMock(HttpCalloutMock.class, new MockHttpGoogleMapsResponse(200, 'success', response, null));


            J.ECONZ_Task_Created__c = false;
            J.Project_Manager_new__c  = UserInfo.getuserId();
            j.Amount__c=5500;
            
            List<ATI_Job__c> jobs = new List<ATI_Job__c>();
            jobs.add(j);
            Map<Id,Datetime> startdatemap = new Map<Id,Datetime>();
            Map<Id,String> oldmapname = new Map<Id,String>();
            Map<Id,String> typemap = new Map<Id,String>();
            Map<Id,ATI_Job__c> oldMap = new Map<Id,ATI_Job__c>();
            oldMap.put(j.Id, j);
            startdatemap.put(j.Id, Date.Today());
            // oldmapname.put(job.Id, null);
            typemap.put(j.Id, 'updateTaskManager');
            jobs.add(j);      
            //Test.setMock(HttpCalloutMock.class, fake_AddTask());
            Id econzQueue = System.enqueueJob(new Econz_Queueable_Integration(jobs, typemap, oldmapname, startdatemap, oldmap, new Map<Id,ATI_Job__c>()));
            //List<ATI_Job__c> jobs, Map<Id,String> typemap, Map<Id,String> oldmapname, Map<Id,Datetime> startdatemap
            //Econz_Integration_Callouts.ECONZ_Future_Call(Job.Id,'addTask','',Date.today());
        }
    
    @isTest static void test_renameTask() 
    {
        ATI_Job__c j = [Select Id, Name, division__c, bigtimeSId__c,Project_Site_Record_Id__c, Project_Site_Call_Result_Message__c, 
                                         Last_Successful_FotoIn_Update__c, Last_FotoIn_Update__c, Project_Site_Name__c, 
                                         Project_Site_Name_Fotoin__c, Project_Site_Address__c,year__c ,
                                         Project_Site_City__c, Project_Site_State__c, Project_Site_Zipcode__c  FROM Ati_Job__c WHERE name= '000-00-00002 | Test Job 1' Limit 1];
        
                                         string response = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'+
                '   <soapenv:Body>'+
                '      <ns1:getUserDetailByLoginIDResponse soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" xmlns:ns1="http://nads.econz.co.nz/timecard1/">'+
                '         <getUserDetailByLoginIDResponse xsi:type="ns1:GetUserDetailResult">'+
                '            <userDetails xsi:type="ns1:UserBean">'+
                '               <primaryKey xsi:type="xsd:string">12345</primaryKey>'+
                '               <updateIndex xsi:type="xsd:int">13</updateIndex>'+
                '               <deleted xsi:type="xsd:boolean">false</deleted>'+
                '               <loginID xsi:type="xsd:string">test@testATI.com</loginID>'+
                '               <name xsi:type="xsd:string">Test User OM</name>'+
                '               <teams soapenc:arrayType="xsd:string[0]" xsi:type="soapenc:Array" xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/"/>'+
                '               <timezone xsi:type="xsd:string">US/Pacific</timezone>'+
                '               <userTypePK xsi:type="xsd:string">9</userTypePK>'+
                '               <description xsi:type="xsd:string"/>'+
                '               <emailAddress xsi:type="xsd:string"/>'+
                '               <phoneNumber xsi:type="xsd:string"/>'+
                '               <faxNumber xsi:type="xsd:string"/>'+
                '               <pagerNumber xsi:type="xsd:string"/>'+
                '               <mobileNumber xsi:type="xsd:string"/>'+
                '               <securityQuestion xsi:type="xsd:string">__INVALID</securityQuestion>'+
                '               <securityAnswer xsi:type="xsd:string"/>'+
                '               <synchronisation soapenc:arrayType="ns2:SynchronisationBean[0]" xsi:type="soapenc:Array" xmlns:ns2="http://soap2.nads.econz.co.nz" xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/"/>'+
                '            </userDetails>'+
                '            <accessDeniedFailure xsi:type="ns3:AccessDeniedFailure" xsi:nil="true" xmlns:ns3="http://auth.soap.econz.co.nz"/>'+
                '         </getUserDetailByLoginIDResponse>'+
                '      </ns1:getUserDetailByLoginIDResponse>'+
                '   </soapenv:Body>'+
                '</soapenv:Envelope>';
            Test.setMock(HttpCalloutMock.class, new MockHttpGoogleMapsResponse(200, 'success', response, null));
            

            J.ECONZ_Task_Created__c = false;
            J.Project_Manager_new__c  = UserInfo.getuserId();
            j.Amount__c=5500;
            
            List<ATI_Job__c> jobs = new List<ATI_Job__c>();
            jobs.add(j);
            Map<Id,Datetime> startdatemap = new Map<Id,Datetime>();
            Map<Id,String> oldmapname = new Map<Id,String>();
            Map<Id,String> typemap = new Map<Id,String>();
            Map<Id,ATI_Job__c> oldMap = new Map<Id,ATI_Job__c>();
            oldMap.put(j.Id, j);
            startdatemap.put(j.Id, Date.Today());
            // oldmapname.put(job.Id, null);
            typemap.put(j.Id, 'updateTaskManager');
            jobs.add(j);      
            //Test.setMock(HttpCalloutMock.class, fake_AddTask());
            Id econzQueue = System.enqueueJob(new Econz_Queueable_Integration(jobs, typemap, oldmapname, startdatemap, oldmap, new Map<Id,ATI_Job__c>()));
            //List<ATI_Job__c> jobs, Map<Id,String> typemap, Map<Id,String> oldmapname, Map<Id,Datetime> startdatemap
            //Econz_Integration_Callouts.ECONZ_Future_Call(Job.Id,'addTask','',Date.today());
    }
    
    @isTest static void test_renTask() {
        ATI_Job__c j = [Select Id, Name, division__c, bigtimeSId__c,Project_Site_Record_Id__c, Project_Site_Call_Result_Message__c, 
                                         Last_Successful_FotoIn_Update__c, Last_FotoIn_Update__c, Project_Site_Name__c, 
                                         Project_Site_Name_Fotoin__c, Project_Site_Address__c,year__c ,
                                         Project_Site_City__c, Project_Site_State__c, Project_Site_Zipcode__c  FROM Ati_Job__c WHERE name= '000-00-00002 | Test Job 1' Limit 1];
        
                                         string response = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'+
                                         '<soapenv:Body>'+
                                         '<ns1:addTaskForManagerResponse soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" xmlns:ns1="http://nads.econz.co.nz/timecard1/" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">'+
                                         '<addTaskForManagerResponse xsi:type="ns1:AddNewTaskResult" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ns1="http://nads.econz.co.nz/timecard1/">'+
                                         '<accessDeniedFailure xsi:type="ns2:AccessDeniedFailure" xsi:nil="true" xmlns:ns2="http://auth.soap.econz.co.nz" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" />'+
                                         '<validationFailure xsi:type="ns3:ValidationFailure" xsi:nil="true" xmlns:ns3="http://soap.econz.co.nz" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" />'+
                                         '</addTaskForManagerResponse>'+
                                         '</ns1:addTaskForManagerResponse>'+
                                         '</soapenv:Body>'+
                                         '</soapenv:Envelope>';
            Test.setMock(HttpCalloutMock.class, new MockHttpGoogleMapsResponse(200, 'success', response, null));


            J.ECONZ_Task_Created__c = false;
            J.Project_Manager_new__c  = UserInfo.getuserId();
            j.Amount__c=5500;
            
            List<ATI_Job__c> jobs = new List<ATI_Job__c>();
            jobs.add(j);
            Map<Id,Datetime> startdatemap = new Map<Id,Datetime>();
            Map<Id,String> oldmapname = new Map<Id,String>();
            Map<Id,String> typemap = new Map<Id,String>();
            Map<Id,ATI_Job__c> oldMap = new Map<Id,ATI_Job__c>();
            oldMap.put(j.Id, j);
            startdatemap.put(j.Id, Date.Today());
            // oldmapname.put(job.Id, null);
            typemap.put(j.Id, 'renameTask');
            jobs.add(j);      
            //Test.setMock(HttpCalloutMock.class, fake_AddTask());
            Id econzQueue = System.enqueueJob(new Econz_Queueable_Integration(jobs, typemap, oldmapname, startdatemap, oldmap, new Map<Id,ATI_Job__c>()));
            //List<ATI_Job__c> jobs, Map<Id,String> typemap, Map<Id,String> oldmapname, Map<Id,Datetime> startdatemap
            //Econz_Integration_Callouts.ECONZ_Future_Call(Job.Id,'addTask','',Date.today());
    
    }
}
    
    // public static testmethod void test_updateTaskDates() {
    //     // Create a User
    //     User testUser = createAdminUser();
    //     insert testUser;
        
    //     System.runAs(testUser){
    //         ATI_Job__c Job = createJobWithTestSetupData(testUser); 
    //         Job.Project_Manager_new__c  = testUser.id;
    //         insert Job;
    //         Test.startTest();
    //         Test.setMock(HttpCalloutMock.class, new fake_AddTask());
    //         Econz_Integration_Callouts.isECONZCalloutsProcessed = true;
    //         Job = Econz_Integration_Callouts.updateTaskDates(Job,Date.today());
    //         Test.stopTest();
    //     }
    // }
    
    // static testmethod void test_updateTaskManager() {
    //     // Create a User
    //     User testUser = createAdminUser();
    //     insert testUser;
        
    //     System.runAs(testUser){
    //         ATI_Job__c Job = createJobWithTestSetupData(testUser); 
    //         Job.ECONZ_Task_Created__c = true;
    //         Job.Project_Manager_new__c  = testUser.id;
    //         insert Job;
    //         ATI_Job__c testJob = Econz_Integration_Callouts.getJobRecord(Job.Id);
    //         Test.startTest();
    //         Test.setMock(HttpCalloutMock.class, new fake_AddTask());
    //         Econz_Integration_Callouts.isECONZCalloutsProcessed = true;
    //         Econz_Integration_Callouts.updateTaskManager(testJob);
    //         Test.stopTest();
    //     }
    // }
    
    // static testmethod void test_JobUpdate() {
    //     // Create a User
    //     User testUser = createAdminUser();
    //     insert testUser;
        
    //     System.runAs(testUser){
    //         ATI_Job__c Job = createJobWithTestSetupData(testUser); 
    //         Job.ECONZ_Task_Created__c = true;
    //         Job.Project_Manager_new__c  = testUser.id;
    //         insert Job;
    //         Job.Division__c = 'Microbial';
            
    //         try{
    //             Test.startTest();
    //             Test.setMock(HttpCalloutMock.class, new fake_AddTask());
    //             update Job;
    //             Test.stopTest();
    //         }catch(exception e){
    //             System.assert(true);
    //         }
    //     }
    // }
    
    // static testmethod void test_button() {
    //     // Create a User
    //     User testUser = createAdminUser();
    //     insert testUser;
        
    //     System.runAs(testUser){
    //         ATI_Job__c Job = createJobWithTestSetupData(testUser); 
    //         Job.Project_Manager_new__c  = testUser.id;
    //         insert Job;
    //         Test.startTest();
    //         Test.setMock(HttpCalloutMock.class, new fake_AddTask());
    //         Econz_Integration_Callouts.isECONZCalloutsProcessed = true;
    //         Econz_Integration_Callouts.invokeIntegration(Job.Id);
    //         Test.stopTest();
    //     }
    // }
    
    // static testmethod void test_renameTask() {
    //     // Create a User
    //     User testUser = createAdminUser();
    //     insert testUser;
        
    //     System.runAs(testUser){
    //         ATI_Job__c Job = createJobWithTestSetupData(testUser); 
    //         Job.ECONZ_Task_Created__c = true;
    //         Job.Project_Manager_new__c  = testUser.id;
    //         insert Job;
    //         Test.startTest();
    //         Test.setMock(HttpCalloutMock.class, new fake_AddTask());
    //         Econz_Integration_Callouts.isECONZCalloutsProcessed = true;
    //         Econz_Integration_Callouts.renameTask(Job,'Old Name');
    //         Test.stopTest();
    //     }
    // }
    
    // static testmethod void test_getUserByLoginID() {
    //     // Create a User
    //     User testUser = createAdminUser();
    //     insert testUser;
        
    //     System.runAs(testUser){
    //         ATI_Job__c Job = createJobWithTestSetupData(testUser); 
    //         Job.Project_Manager_new__c  = testUser.id;
    //         insert Job;
    //         Test.startTest();
    //         Test.setMock(HttpCalloutMock.class, new fake_getUserByLoginID());
    //         Econz_Integration_Callouts.isECONZCalloutsProcessed = true;
    //         Econz_Integration_Callouts.ECONZ_Future_Call(Job.Id,'updateTaskManager','',Date.today());
    //         Test.stopTest();
    //     }
    // }
    
    
    // static testmethod void test_Batch() {
    //     // Create a User
    //     User testUser = createAdminUser();
    //     insert testUser;
        
    //     System.runAs(testUser){
    //         ATI_Job__c Job = createJobWithTestSetupDataATIJob(testUser); 
    //         Job.ECONZ_Integration_Error__c = true;
    //         Job.Project_Manager_new__c  = testUser.id;
    //         Job.ECONZ_Task_Created__c = false;
    //         Job.Job_Start_Date__c = system.today();
    //         insert Job;
    //         List<ATI_Job__c> jobtest = [SELECT Id FROM ATI_Job__c WHERE (ECONZ_Integration_Error__c = true AND Job_Start_Date__c != NULL) OR (Job_Start_Date__c != NULL AND ECONZ_Task_Created__c = false)];
    //         //system.debug('-------TestClass----'+jobtest);
    //         Test.startTest();
    //         Test.setMock(HttpCalloutMock.class, new fake_AddTask());
    //         //Database.executeBatch(new ECONZ_Integration_RetryBatch(''));
            
    //         ECONZ_Integration_RetryBatch cb = New ECONZ_Integration_RetryBatch('');
            
    //         Database.QueryLocator ql = cb.start(null);
    //         cb.execute(null,jobtest);
    //         cb.Finish(null);
            
    //         Test.stopTest();
    //     }
    // }
    
    // static testmethod void validateScheduleClass(){
        
    //     //   Test.startTest();
    //     // Schedule the test job
    //     // Integer year = system.today().year() + 1;
    //     // String sch = '0 0 0 1 1 ? ' + year;
    //     //   User testUser = createAdminUser();
    //     // insert testUser;
    //     // System.runAs(testUser){
    //     //  ATI_Job__c Job = createJobWithTestSetupDataATIJob(testUser); 
    //     //    Job.ECONZ_Integration_Error__c = true;
    //     //                Job.Job_Start_Date__c = system.today();
        
    //     //      insert Job;
    //     //         Test.setMock(HttpCalloutMock.class, new fake_AddTask());
    //     // Database.executeBatch(new ECONZ_Integration_RetryBatch(''),1);
        
    //     //Id jobId = System.schedule('test_sch_batch', sch, new Econz_SchRetryBatch(''));
        
    //     // CronTrigger cronTrigger1 = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :jobId];
    //     //   System.assertEquals(sch, cronTrigger1.CronExpression);
    //     //  System.assertEquals(0, cronTrigger1.TimesTriggered);
    //     //  System.assertEquals(year + '-01-01 00:00:00',String.valueOf(cronTrigger1.NextFireTime));
    //     //   Test.stopTest();
    //     //    }
        
    // }
    
    // public class fake_getUserByLoginID implements HttpCalloutMock{
    //     // Implement this interface method
    //     public HTTPResponse respond(HTTPRequest req) {
    //         // Create a fake response
    //         string response = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'+
    //             '   <soapenv:Body>'+
    //             '      <ns1:getUserDetailByLoginIDResponse soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" xmlns:ns1="http://nads.econz.co.nz/timecard1/">'+
    //             '         <getUserDetailByLoginIDResponse xsi:type="ns1:GetUserDetailResult">'+
    //             '            <userDetails xsi:type="ns1:UserBean">'+
    //             '               <primaryKey xsi:type="xsd:string">12345</primaryKey>'+
    //             '               <updateIndex xsi:type="xsd:int">13</updateIndex>'+
    //             '               <deleted xsi:type="xsd:boolean">false</deleted>'+
    //             '               <loginID xsi:type="xsd:string">test@testATI.com</loginID>'+
    //             '               <name xsi:type="xsd:string">Test User OM</name>'+
    //             '               <teams soapenc:arrayType="xsd:string[0]" xsi:type="soapenc:Array" xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/"/>'+
    //             '               <timezone xsi:type="xsd:string">US/Pacific</timezone>'+
    //             '               <userTypePK xsi:type="xsd:string">9</userTypePK>'+
    //             '               <description xsi:type="xsd:string"/>'+
    //             '               <emailAddress xsi:type="xsd:string"/>'+
    //             '               <phoneNumber xsi:type="xsd:string"/>'+
    //             '               <faxNumber xsi:type="xsd:string"/>'+
    //             '               <pagerNumber xsi:type="xsd:string"/>'+
    //             '               <mobileNumber xsi:type="xsd:string"/>'+
    //             '               <securityQuestion xsi:type="xsd:string">__INVALID</securityQuestion>'+
    //             '               <securityAnswer xsi:type="xsd:string"/>'+
    //             '               <synchronisation soapenc:arrayType="ns2:SynchronisationBean[0]" xsi:type="soapenc:Array" xmlns:ns2="http://soap2.nads.econz.co.nz" xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/"/>'+
    //             '            </userDetails>'+
    //             '            <accessDeniedFailure xsi:type="ns3:AccessDeniedFailure" xsi:nil="true" xmlns:ns3="http://auth.soap.econz.co.nz"/>'+
    //             '         </getUserDetailByLoginIDResponse>'+
    //             '      </ns1:getUserDetailByLoginIDResponse>'+
    //             '   </soapenv:Body>'+
    //             '</soapenv:Envelope>';
            
    //         HttpResponse res = new HttpResponse();
    //         res.setHeader('Content-Type', 'application/json');
    //         res.setBody(response);
    //         res.setStatusCode(200);
    //         return res;
    //     }
    // }
    
    // @isTest static class fake_AddTask implements HttpCalloutMock{
    //     // Implement this interface method
    //     public HTTPResponse respond(HTTPRequest req) {
    //         // Create a fake response
    //         string response = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'+
    //             '<soapenv:Body>'+
    //             '<ns1:addTaskForManagerResponse soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" xmlns:ns1="http://nads.econz.co.nz/timecard1/" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">'+
    //             '<addTaskForManagerResponse xsi:type="ns1:AddNewTaskResult" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ns1="http://nads.econz.co.nz/timecard1/">'+
    //             '<accessDeniedFailure xsi:type="ns2:AccessDeniedFailure" xsi:nil="true" xmlns:ns2="http://auth.soap.econz.co.nz" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" />'+
    //             '<validationFailure xsi:type="ns3:ValidationFailure" xsi:nil="true" xmlns:ns3="http://soap.econz.co.nz" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" />'+
    //             '</addTaskForManagerResponse>'+
    //             '</ns1:addTaskForManagerResponse>'+
    //             '</soapenv:Body>'+
    //             '</soapenv:Envelope>';
    //         HttpResponse res = new HttpResponse();
    //         res.setHeader('Content-Type', 'application/json');
    //         res.setBody(response);
    //         res.setStatusCode(200);
    //         return res;
    //     }
    // }
    
    // private static User createAdminUser(){
    //     Profile testProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' Limit 1];
    //     User testUser = new User(
    //         Username = 'sampletest' + System.now().millisecond() + '@test.com'
    //         , ProfileId = testProfile.Id
    //         , Alias = 'test' + System.now().millisecond()
    //         , Email = 'test' + System.now().millisecond() + '@test.com'
    //         , EmailEncodingKey = 'UTF-8'
    //         , LastName = 'test' + System.now().millisecond()
    //         , CommunityNickname = 'test' + System.now().millisecond()
    //         , TimeZoneSidKey = 'America/Los_Angeles'
    //         , LocaleSidKey = 'en_US'
    //         , LanguageLocaleKey = 'en_US'
    //     );
        
    //     return testUser;
    // }
    
    // private static ATI_Job__c createJobWithTestSetupDataATIJob(User testUser){
    //     RecordType tBusiness = [Select Id from RecordType Where Name = 'Business Account' and SObjectType = 'Account'];
    //     RecordType tPersons = [Select Id from RecordType Where Name = 'Person Accounts' and SObjectType = 'Account'];    
    //     //Create Test Record for Custom Setting
    //     TriggerStatus__c tStat = new TriggerStatus__c(
    //         AccountGenerateCustomerNumber__c = true,
    //         AccountSyncToTimberline__c = true,
    //         Forecast_Sync_to_Timberline__c = true,
    //         InvoiceAutomaticInvoiceNumber__c = true,
    //         InvoiceSyncToTimberline__c= true,
    //         InvoiceLineItemAutoCreation__c= true,
    //         InvoiceLineItemAutomaticNaming__c= true,
    //         InvoiceLineItemAutomaticOrder__c= true,
    //         InvoiceTaxGroupSetUp__c= true,
    //         JobCopyPMToOwner__c= true,
    //         JobOpportunitySync__c= true,
    //         JobSetJobNumber__c= false,
    //         JobSyncToTimberline__c= true,
    //         LeadPMLeadSync__c= true,
    //         OpportunityJobSync__c= true,
    //         PMLeadCalculateJobNumber__c= true,
    //         PMLeadConversion__c= true,
    //         PMLeadLeadSync__c= true,
    //         TaskTaskSync__c= true,
    //         TaxGroupRefreshFromTimberline__c= true,
    //         TaxGroupSetName__c= true
    //     );
    //     insert tStat;
        
    //     Waiver_Settings__c wStat = new Waiver_Settings__c(
    //         Name = 'Apex Settings',
    //         Unconditional_Final_Name__c = 'Unconditional Final Waiver',
    //         Unconditional_Progress_Name__c = 'Unconditional Progress Waiver',
    //         Conditional_Final_Name__c = 'Conditional Final Waiver',
    //         Conditional_Progress_Name__c = 'Conditional Progress Waiver',
    //         Letter_60_Day_Name__c = '60 Day Letter'
    //     );
    //     insert wStat;
    //     EconzIntegration__c csTest = new EconzIntegration__c();
    //     csTest.Name = 'Test';
    //     csTest.EndPointURL__c = 'Test';
    //     csTest.UserId__c = 'Test';
    //     csTest.Password__c = 'Test';
    //     insert csTest;
        
    //     EconzIntegration__c csProd = new EconzIntegration__c();
    //     csProd.Name = 'Prod';
    //     csProd.EndPointURL__c = 'Prod';
    //     csProd.UserId__c = 'Prod';
    //     csProd.Password__c = 'Prod';
    //     insert csProd;
        
    //     Tax_Group__c taxGrp = new Tax_Group__c(
            
    //         Name = 'TestTaxGroup',
    //         Tax_Rate__c = 25,
    //         Timberline_Id__c = 'TestTaxGroup'   
    //     );
    //     insert taxGrp;
        
    //     Account acc = new Account(
    //         Name = 'TestAccount',
    //         RecordTypeId = tBusiness.Id,
    //         Status__c = 'Active',
    //         BillingCity = 'TestBCity',
    //         BillingCountry = 'USA',
    //         BillingState = 'CA',
    //         BillingStreet = 'TestBStreet',
    //         BillingPostalCode = '55555',
    //         Tax_Group__c = taxGrp.Id,
    //         ShippingCity = 'TestSCity',
    //         ShippingCountry = 'USA',
    //         ShippingState = 'CA',
    //         ShippingStreet = 'TestSStreet',
    //         Company_Type__c = 'Agent/ Brokerage',
    //         Industry = 'Apparel'
    //     );
    //     insert acc;
        
    //     Contact con = new Contact(
    //         FirstName = 'TestFN',
    //         LastName = 'TestLN',
    //         AccountId = acc.Id,
    //         Email='mrstanziabrown@yahoo.com',
    //         Phone = '1234'
    //     );    
    //     insert con;   
    //     Id appRecordTypeId = Schema.SObjectType.ATI_Job__c.getRecordTypeInfosByName().get('Job (Approved)').getRecordTypeId();
    //     Id appRecordTypeId1 = Schema.SObjectType.ATI_Job__c.getRecordTypeInfosByName().get('New Job (Not Approved)').getRecordTypeId();
    //     ATI_Job__c Job = new ATI_Job__c(
    //         //Account__c = acc.Id,
    //         Name = 'TestJob',
    //         Stage__c = 'Won',
    //         CloseDate__c = Date.Today(),
    //         Job_Name__c = 'Test Job Name',
    //         Job_Number__c = 'TT-5555555',
    //         Project_Site_Contact_Name__c = con.id,
    //         Lost_Job_Reason__c = 'Unknown',
    //         Lost_Job_Description__c = 'TestJob',
    //         Project_Site_Contact_Account__c = acc.id,
    //         Project_Manager_New__c = testUser.Id,
    //         Date_Time_Approved__c = system.today(),
    //         Completion_Date__c = system.today(),
    //         Division__c = 'Lead',
            
    //         RecordTypeId = appRecordTypeId
    //     );       
        
    //     return Job;
    // }
    
    // private static ATI_Job__c createJobWithTestSetupData(User testUser){
    //     RecordType tBusiness = [Select Id from RecordType Where Name = 'Business Account' and SObjectType = 'Account'];
    //     RecordType tPersons = [Select Id from RecordType Where Name = 'Person Accounts' and SObjectType = 'Account'];    
    //     //Create Test Record for Custom Setting
    //     TriggerStatus__c tStat = new TriggerStatus__c(
    //         AccountGenerateCustomerNumber__c = true,
    //         AccountSyncToTimberline__c = true,
    //         Forecast_Sync_to_Timberline__c = true,
    //         InvoiceAutomaticInvoiceNumber__c = true,
    //         InvoiceSyncToTimberline__c= true,
    //         InvoiceLineItemAutoCreation__c= true,
    //         InvoiceLineItemAutomaticNaming__c= true,
    //         InvoiceLineItemAutomaticOrder__c= true,
    //         InvoiceTaxGroupSetUp__c= true,
    //         JobCopyPMToOwner__c= true,
    //         JobOpportunitySync__c= true,
    //         JobSetJobNumber__c= false,
    //         JobSyncToTimberline__c= true,
    //         LeadPMLeadSync__c= true,
    //         OpportunityJobSync__c= true,
    //         PMLeadCalculateJobNumber__c= true,
    //         PMLeadConversion__c= true,
    //         PMLeadLeadSync__c= true,
    //         TaskTaskSync__c= true,
    //         TaxGroupRefreshFromTimberline__c= true,
    //         TaxGroupSetName__c= true
    //     );
    //     insert tStat;
        
    //     Waiver_Settings__c wStat = new Waiver_Settings__c(
    //         Name = 'Apex Settings',
    //         Unconditional_Final_Name__c = 'Unconditional Final Waiver',
    //         Unconditional_Progress_Name__c = 'Unconditional Progress Waiver',
    //         Conditional_Final_Name__c = 'Conditional Final Waiver',
    //         Conditional_Progress_Name__c = 'Conditional Progress Waiver',
    //         Letter_60_Day_Name__c = '60 Day Letter'
    //     );
    //     insert wStat;
    //     EconzIntegration__c csTest = new EconzIntegration__c();
    //     csTest.Name = 'Test';
    //     csTest.EndPointURL__c = 'Test';
    //     csTest.UserId__c = 'Test';
    //     csTest.Password__c = 'Test';
    //     insert csTest;
        
    //     EconzIntegration__c csProd = new EconzIntegration__c();
    //     csProd.Name = 'Prod';
    //     csProd.EndPointURL__c = 'Prod';
    //     csProd.UserId__c = 'Prod';
    //     csProd.Password__c = 'Prod';
    //     insert csProd;
        
    //     Tax_Group__c taxGrp = new Tax_Group__c(
            
    //         Name = 'TestTaxGroup',
    //         Tax_Rate__c = 25,
    //         Timberline_Id__c = 'TestTaxGroup'   
    //     );
    //     insert taxGrp;
        
    //     Account acc = new Account(
    //         Name = 'TestAccount',
    //         RecordTypeId = tBusiness.Id,
    //         Status__c = 'Active',
    //         BillingCity = 'TestBCity',
    //         BillingCountry = 'USA',
    //         BillingState = 'CA',
    //         BillingStreet = 'TestBStreet',
    //         BillingPostalCode = '55555',
    //         Tax_Group__c = taxGrp.Id,
    //         ShippingCity = 'TestSCity',
    //         ShippingCountry = 'USA',
    //         ShippingState = 'CA',
    //         ShippingStreet = 'TestSStreet',
    //         Company_Type__c = 'Agent/ Brokerage',
    //         Industry = 'Apparel'
    //     );
    //     insert acc;
        
    //     Contact con = new Contact(
    //         FirstName = 'TestFN',
    //         LastName = 'TestLN',
    //         AccountId = acc.Id,
    //         Email='mrstanziabrown@yahoo.com',
    //         Phone = '1234'
    //     );    
    //     insert con;   
    //     Id appRecordTypeId = Schema.SObjectType.ATI_Job__c.getRecordTypeInfosByName().get('Job (Approved)').getRecordTypeId();
    //     Id appRecordTypeId1 = Schema.SObjectType.ATI_Job__c.getRecordTypeInfosByName().get('New Job (Not Approved)').getRecordTypeId();
    //     ATI_Job__c Job = new ATI_Job__c(
    //         Account__c = acc.Id,
    //         Name = 'TestJob',
    //         Stage__c = 'Lost',
    //         CloseDate__c = Date.Today(),
    //         Job_Name__c = 'Test Job Name',
    //         Job_Number__c = 'TT-5555555',
    //         Project_Site_Contact_Name__c = con.id,
    //         Lost_Job_Reason__c = 'Unknown',
    //         Lost_Job_Description__c = 'TestJob',
    //         Project_Site_Contact_Account__c = acc.id,
    //         Project_Manager_New__c = testUser.Id,
    //         Date_Time_Approved__c = system.today(),
    //         Completion_Date__c = system.today(),
    //         Division__c = 'Lead',
            
    //         RecordTypeId = appRecordTypeId
    //     );       
        
    //     return Job;
    // }
    
    // public class fake_getUserByLoginID_Failure implements HttpCalloutMock{
    //     // Implement this interface method
    //     public HTTPResponse respond(HTTPRequest req) {
    //         // Create a fake response
    //         string response = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'+
    //             '   <soapenv:Body>'+
    //             '      <ns1:getUserDetailByLoginIDResponse soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" xmlns:ns1="http://nads.econz.co.nz/timecard1/">'+
    //             '         <getUserDetailByLoginIDResponse xsi:type="ns1:GetUserDetailResult">'+
    //             '            <userDetails xsi:type="ns1:UserBean">'+
    //             '               <primaryKey xsi:type="xsd:string">12345</primaryKey>'+
    //             '               <updateIndex xsi:type="xsd:int">13</updateIndex>'+
    //             '               <deleted xsi:type="xsd:boolean">false</deleted>'+
    //             '               <loginID xsi:type="xsd:string">test@testATI.com</loginID>'+
    //             '               <name xsi:type="xsd:string">Test User OM</name>'+
    //             '               <teams soapenc:arrayType="xsd:string[0]" xsi:type="soapenc:Array" xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/"/>'+
    //             '               <timezone xsi:type="xsd:string">US/Pacific</timezone>'+
    //             '               <userTypePK xsi:type="xsd:string">9</userTypePK>'+
    //             '               <description xsi:type="xsd:string"/>'+
    //             '               <emailAddress xsi:type="xsd:string"/>'+
    //             '               <phoneNumber xsi:type="xsd:string"/>'+
    //             '               <faxNumber xsi:type="xsd:string"/>'+
    //             '               <pagerNumber xsi:type="xsd:string"/>'+
    //             '               <mobileNumber xsi:type="xsd:string"/>'+
    //             '               <securityQuestion xsi:type="xsd:string">__INVALID</securityQuestion>'+
    //             '               <securityAnswer xsi:type="xsd:string"/>'+
    //             '               <synchronisation soapenc:arrayType="ns2:SynchronisationBean[0]" xsi:type="soapenc:Array" xmlns:ns2="http://soap2.nads.econz.co.nz" xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/"/>'+
    //             '            </userDetails>'+
    //             '            <accessDeniedFailure xsi:type="ns3:AccessDeniedFailure" xsi:nil="true" xmlns:ns3="http://auth.soap.econz.co.nz"/>'+
    //             '         </getUserDetailByLoginIDResponse>'+
    //             '      </ns1:getUserDetailByLoginIDResponse>'+
    //             '   </soapenv:Body>'+
    //             '</soapenv:Envelope>';
            
    //         HttpResponse res = new HttpResponse();
    //         res.setHeader('Content-Type', 'application/json');
    //         res.setBody(response);
    //         res.setStatusCode(201);
    //         return res;
    //     }
    // }
    
    // static testmethod void test_renameTask_1() {
    //     // Create a User
    //     User testUser = createAdminUser();
    //     insert testUser;
        
    //     System.runAs(testUser){
    //         ATI_Job__c Job = createJobWithTestSetupData(testUser); 
    //         Job.ECONZ_Task_Created__c = true;
    //         Job.Project_Manager_new__c  = testUser.id;
    //         insert Job;
    //         Test.startTest();
    //         Test.setMock(HttpCalloutMock.class, new fake_AddTask());
    //         Econz_Integration_Callouts.isECONZCalloutsProcessed = true;
    //         Econz_Integration_Callouts.renameTask(Job,'renameTask');
    //         Test.stopTest();
    //     }
    // }