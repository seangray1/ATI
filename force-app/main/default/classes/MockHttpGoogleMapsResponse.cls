@isTest
global class MockHttpGoogleMapsResponse implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{{"results" : [{"access_points" : [],"address_components" : [{"long_name" : "15632","short_name" : "15632","types" : [ "street_number" ]},{"long_name" : "Youngwood Drive","short_name" : "Youngwood Dr","types" : [ "route" ]},{"long_name" : "East Whitter","short_name" : "East Whitter","types" : [ "neighborhood", "political" ]},{"long_name" : "Whittier","short_name" : "Whittier","types" : [ "locality", "political" ]},{"long_name" : "Los Angeles County","short_name" : "Los Angeles County","types" : [ "administrative_area_level_2", "political" ]},{"long_name" : "California","short_name" : "CA","types" : [ "administrative_area_level_1", "political" ]},{"long_name" : "United States","short_name" : "US","types" : [ "country", "political" ]},{"long_name" : "90603","short_name" : "90603","types" : [ "postal_code" ]},{"long_name" : "1235","short_name" : "1235","types" : [ "postal_code_suffix" ]}],"formatted_address" : "15632 Youngwood Dr, Whittier, CA 90603, USA","geometry" : {"bounds" : {"northeast" : {"lat" : 33.9551556,"lng" : -117.9936276},"southwest" : {"lat" : 33.9549415,"lng" : -117.9938733}},"location" : {"lat" : 33.9550515,"lng" : -117.9937451},"location_type" : "ROOFTOP","viewport" : {"northeast" : {"lat" : 33.9563975302915,"lng" : -117.9924014697085},"southwest" : {"lat" : 33.9536995697085,"lng" : -117.9950994302915}}},"place_id" : "ChIJ--yIXe3UwoARtn_JzLhd-i0","types" : [ "premise" ]}],"status" : "OK"}');
        res.setStatusCode(200);
        return res;
    }
}

