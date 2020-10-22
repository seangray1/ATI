Public Class CaseTriggerHandler{
    
    
    Public static Void PopulateCrisisInformationOnCase(List<Case>  cases){
        
        
        String reportedBy;
        String organization;
        String domain;
        Integer WebEmailCount = 0;
        
        List<Contact> cons = new List<Contact>();
        List<Account> accs = new List<Account>();
        List<Account> orgAccs = new List<Account>();
        for(Case cs: cases){
            
            If(String.isNotBlank(cs.SuppliedEmail)){
                WebEmailCount++;
            }
            
            If(String.isNotBlank(cs.Description)){
                reportedBy = cs.Description.substringAfter('Reported By');
                reportedBy = reportedBy.substringBefore('\n').trim();
                organization = cs.Description.substringAfter('Organization');
                organization = organization.substringBefore('\n').trim();
                domain =  '\'%' + String.escapeSingleQuotes(reportedBy.substringAfter('@')) + '\'';
                
            }
            
        }
        
        
        System.debug('WebEmailCount---------->'+WebEmailCount);
        
        If(WebEmailCount > 0){
            If(String.isNotBlank(domain))
            {
                accs = Database.query('Select Id,Name From Account WHERE Website LIKE' + domain);
            }
            If(String.isNotBlank(organization))
            {
                orgAccs = [Select id,name from Account where name =:organization limit 1];
            }
            If(String.isNotBlank(reportedBy))
            {
                cons = [Select id,email from contact where email =: reportedBy limit 1];
            }
            List< Test_Account__mdt > testAccs = [select id,Account_Id__c from Test_Account__mdt];
            
            System.debug(orgAccs);
              System.debug(accs);
             System.debug(cons);
            for(Case cs:cases){
                
                if(cons.size() > 0){
                    cs.ContactId = cons[0].Id;
                }
                else{
                    if(accs.size() > 0){
                        cs.AccountId = accs[0].id;
                    }
                    else if(orgAccs.size() > 0){
                        
                        cs.AccountId = orgAccs[0].id;
                    }
                    else{
                        
                        cs.AccountId = testAccs[0].Account_Id__c;
                        
                    }
                    
                }
                
            }
        }
    }
    
    
}