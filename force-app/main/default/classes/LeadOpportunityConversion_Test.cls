@isTest
private class LeadOpportunityConversion_Test {
static testmethod void GoogleCallout() 
{
    Id u2 = UserInfo.getUserId();

    system.runAs(new User(Id=Userinfo.getUserId()))
    {
        Map <String, Schema.RecordTypeInfo> jobRecordTypeMap = Schema.SObjectType.ATI_job__c.RecordTypeInfosByName;
        Id notApprovedId = Schema.SObjectType.ATI_job__c.RecordTypeInfosByName.get('New Job (Not Approved)').RecordTypeId;
        Id approvedId = Schema.SObjectType.ATI_job__c.RecordTypeInfosByName.get('Job (Approved)').RecordTypeId;
        Integer NumToInsert = 3;
        
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

            //Test.setMock(HttpCalloutMock.class, fakeContactsResp);
        ObjectInserts ObjectData = TestDataUtil.createObjects(NumToInsert, false);
        List<ATI_Job__c> jobs = ObjectData.jobList;
        insert jobs;
        TestDataUtil.CreateObjectAccountRoles(NumToInsert, jobs, ObjectData.accountList, ObjectData.contactList);
        ATI_Job__c job = jobs[0];
        Account [] acct= ObjectData.accountList;
        Contact [] cont = ObjectData.contactList;
        Master_Job__c [] masterjob = ObjectData.masterjobList;
        Office__c [] offices = ObjectData.OfficeList;
        User [] users = ObjectData.UserList;
        Property__c [] property = ObjectData.PropertyList;
        
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, fakeContactsResp);
        Lead l = new Lead(FirstName = 'Tester', LastName = 'TestL', Company = 'AccountNameTest', Location_of_Interest__c = 'HQ', Street= '15632 Youngwood Dr', City = 'Whittier', State = 'CA', PostalCode = '90605',
        Lead_Notes__c = 'Test Notes');
        insert l;
        String LeadData = '{"AccountRoleLineItems":[{"LeadId":"' + l.Id + '"}]}';
        Id oppId = LeadOppConversion.ConvertLeadToOpp(l.Id, LeadData);
        Opportunity o = new Opportunity(Id = oppId, Division__c = 'Asbestos', StageName = 'Closed Won');
        update o;
        Test.stopTest();
        
        
    }
}
}