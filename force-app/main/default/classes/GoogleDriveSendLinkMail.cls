public class GoogleDriveSendLinkMail {
    
    @AuraEnabled
    public static void sendEmail(String toAddresses, String Subject, String htmlBody){
        System.debug('Inside sendEmail');
        
        try{
            List<String> recipientsList = new List<string>();
            if(toAddresses != null){
                recipientsList = toAddresses.split(';');
            }
            // Now create a new single email message object
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            // Use Organization Wide Address  
            for(OrgWideEmailAddress owa : [select id, Address, DisplayName from OrgWideEmailAddress]) {
            if(owa.Address.contains('donotreply')) mail.setOrgWideEmailAddressId(owa.id); } 
            
            if(recipientsList != null && Subject != null && htmlBody != null){
                
                String newHtmlBody = htmlBody.replace('\n','<BR>');
                System.debug('htmlBody-------->'+htmlBody);
                System.debug('newHtmlBody-------->'+newHtmlBody);
                mail.setToAddresses(recipientsList);
                mail.setSubject(Subject);
                mail.setHtmlBody('<html><body>'+newHtmlBody+'<BR><img src = "'+System.Label.ATI_Logo_URL+'"/></body></html>');
                
                // Send the email you have created.
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
            }
            
            
        }Catch(Exception e){
            System.debug('System Exception occurred : ' + e.getTypeName());
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());
        }
    }
    
}