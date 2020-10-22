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
        this.mulesoftResponse = mulesoftResponse;
        this.operationDetails = operationDetails;
        this.requestBody = requestBody;
    }
}