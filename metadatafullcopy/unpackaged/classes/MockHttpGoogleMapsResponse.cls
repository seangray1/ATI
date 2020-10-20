@isTest
public class MockHttpGoogleMapsResponse implements HttpCalloutMock {
    protected Integer code;
	protected String status;
	protected String body;
	protected Map<String, String> responseHeaders;

	public MockHttpGoogleMapsResponse() {

	}
    public MockHttpGoogleMapsResponse(Integer code, String status, String body, Map<String, String> responseHeaders) {
	    this.code = code;
	    this.status = status;
	    this.body = body;
	    this.responseHeaders = responseHeaders;
	}
    public HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(body);
        res.setStatusCode(code);
        system.debug('Response is ' + res.getBody());
        return res;
    }
}