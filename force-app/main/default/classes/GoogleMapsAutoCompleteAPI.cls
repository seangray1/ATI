public class GoogleMapsAutoCompleteAPI {

    // Google Maps API Place Autocomplete
    // Documentation: https://developers.google.com/places/web-service/autocomplete

    // public PlaceAutocompleteResponse getAutoComplete(String input, String types, String components) {
    //     string url = 'https://maps.googleapis.com/maps/api/place/autocomplete/xml?input=Youngwood&types=establaddress&key=AIzaSyB5flG6nv_7071Z217sNxzzoExZUKbll3M';
    //     // String url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input='
    //     //     + EncodingUtil.urlEncode(input, 'UTF-8')
    //     //     + '&components=' + components // country:uk'
    //     //     + '&types=' + types
    //     //     + '&key=' + getAPIKey();
    //     //     system.debug('url is ' + url);
            
    //     return PlaceAutocompleteResponse.parse(makeAPICall(url));
    // }

    // private string makeAPICall(string url) {

    //     Http http = new Http();
    //     HttpRequest httpRequest = new HttpRequest();
    //     HttpResponse httpResponse = new HttpResponse();
    //     httpRequest.setMethod('GET');
    //     httpRequest.setEndpoint(url);
    //     httpRequest.setTimeout(120000);
    //     httpResponse = http.send(httpRequest); 

    //     if (httpResponse.getStatusCode() == 200){
    //         system.debug('REsponse is ' + httpResponse.getBody());
    //         return httpResponse.getBody();    
    //     } else {
    //         System.debug(httpResponse.getStatusCode());
    //         System.debug(httpResponse.getBody());
    //         throw new AuraHandledException(httpResponse.getBody());
    //     } 
    // }
    @AuraEnabled
	public static string getSuggestions(String input) {
	    String url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?'
	            + 'input=' + EncodingUtil.urlEncode(input, 'UTF-8')
	            + '&types=address' + getKey();
        String response = getResponse(url);
        system.debug('response is ' + response);
	    return response;
	}
@AuraEnabled
	public static string getPlaceDetails(String placeId) {
     	String url = 'https://maps.googleapis.com/maps/api/place/details/json?'
	            + 'placeid=' + EncodingUtil.urlEncode(placeId, 'UTF-8')
	            + getKey(); 
	    String response = getResponse(url);
	    return response;
	}

    private string getAPIKey() {
        return 'AIzaSyByZA3geMAonPMwa-JBAXlxjEEbPUkr3iQ'; // add api key or get from custom settings
    }
    
	public static string getResponse(string strURL){
		Http h = new Http();
		HttpRequest req = new HttpRequest();
		HttpResponse res = new HttpResponse();
		req.setMethod('GET');
		req.setEndpoint(strURL);
		req.setTimeout(120000);
		res = h.send(req); 
		String responseBody = res.getBody(); 
		return responseBody;
	}
 
	public static string getKey(){
		string key = 'xxxxxxxxxxxxx';
		string output = '&key=' + key;	 
		return output;
    }
    
    // @AuraEnabled
    // public static PlaceAutocompleteResponse Test (String input){
        
    // String types = 'address';
    // String components = 'country:US';

    // GoogleMapsAutoCompleteAPI api = new GoogleMapsAutoCompleteAPI();
    // return api.getAutoComplete(input, types, components);
   
    // }
    // @AuraEnabled
    // public static PlaceAutocompleteResponse Test (String input){
        
    // String types = 'address';
    // String components = 'country:US';

    // GoogleMapsAutoCompleteAPI api = new GoogleMapsAutoCompleteAPI();
    // return api.getAutoComplete(input, types, components);
}