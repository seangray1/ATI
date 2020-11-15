public class GoogleDriveIntegrationAPILogData {
    public String uiMessage;
    public String recordId;
	public String googleDriveRef;
    public Integer mulesoftResponseCode;
    public String mulesoftResponse;
    public String operationDetails;
    public String requestBody;
    
    public GoogleDriveIntegrationAPILogData(String uiMessage, String recordId, String googleDriveRef, Integer mulesoftResponseCode, String mulesoftResponse, String operationDetails, String requestBody) {
        this.uiMessage = uiMessage;
        this.recordId = recordId;
        this.googleDriveRef = googleDriveRef;
        this.mulesoftResponseCode = mulesoftResponseCode;
        if(mulesoftResponse.length() > 32700)
            this.mulesoftResponse = mulesoftResponse.substring(0, 32700);
        else
            this.mulesoftResponse = mulesoftResponse;
        this.operationDetails = operationDetails;
        this.requestBody = requestBody;
    }
}