/**
 * @File Name          : BigTime_Integration_Invoices.cls
 * @Description        : 
 * @Author             : Sean Gray
 * @Group              : 
 * @Last Modified By   : Sean Gray
 * @Last Modified On   : 1/23/2020, 5:27:49 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    10/12/2019   Sean Gray     Initial Version
**/
public with sharing class BigTime_Integration_Invoices implements Queueable, Database.AllowsCallouts  {
    public class TokenWrapper{
           public List<Invoices> Invoices;
       }
       public class Invoices{
        public String SID {get;set;}
        public String ProjectSid {get;set;}
        public String StatusTxt {get;set;}
       }
       public class TokenWrapper1{
           public invoice invoice;
       }
       public class invoice{
        public List<lines> lines;
       }
       public class lines{
        public integer LineNbr{get;set;}
        public string Nm{get;set;}
        public Decimal Quantity{get;set;}
        public Decimal Rate{get;set;}
        public Decimal Amt{get;set;}
        public string SubTotalSID{get;set;}
        public string LineCategory{get;set;}
        

       }

       public List<Invoice__c> invoicesToInsert = new List<Invoice__c>();
       public Set<string> invoiceSet = new Set<string>(); 
       public void execute(QueueableContext context) {
           Map<string,BigTime__c> mapCredentials = BigTime__c.getAll();
                String token = mapCredentials.get('Bigtime').token__c;
                String firmId = mapCredentials.get('Bigtime').firmid__c;
                Http http = new Http();
                HttpRequest request = new HttpRequest();
                Date endDate = system.today() + 7;
                String startDate = string.valueOf(system.today()-7);
                String startDateEdited = startDate.replace(' 00:00:00', '');
                String endDateEdited = string.valueOf(endDate).replace(' 00:00:00', '');
                //request.setEndpoint('https://iq.bigtime.net/BigTimeData/api/v2/invoice/history?startDt='+ startDateEdited + '&endDt='+ endDateEdited);
                request.setEndpoint('https://iq.bigtime.net/BigTimeData/api/v2/invoice/history?startDt='+ startDateEdited + '&endDt='+ endDateEdited);
                request.setMethod('GET');
                request.setHeader('Content-Type', 'application/json;charset=UTF-8');
                request.setHeader('X-Auth-Token', token);
                request.setHeader('X-Auth-Realm', firmId);
                HttpResponse response = http.send(request);
              
                if (response.getStatusCode() == 200) {
              
                String body = response.getBody();
                system.debug('Getting the project '+ response.getBody());
                body = '{"Invoices":'+ body;
                body = body + '}';
                system.debug('Getting the body after edit  ' + body);
                TokenWrapper tokenwrap = (TokenWrapper)JSON.deserialize(body, TokenWrapper.class);
                system.debug('Tokenwrap : ' + tokenwrap);
                Set<string> projectIds = new Set<String>();
                
                map<String, string> invoiceMap = new map<string, string>();
                
                
                for(Invoices big : tokenwrap.Invoices){
                if(big.Statustxt == 'Sent' && !String.isBlank(big.ProjectSid )){
                invoiceMap.put(big.ProjectSid, big.Sid);
                projectIds.add(big.ProjectSid); 
                invoiceSet.add(big.SID);
                system.debug(big);
                }
                }
                system.debug('PRoject Ids ' + projectIds);
                if(!projectIds.isEmpty()){
                    system.debug('PRoject Ids ' + projectIds);
                List<ATI_Job__c> jobs = [Select Id, BigTimeSID__c FROM ATI_Job__c Where BigTimeSID__c =:projectIds];
                List<Invoice__c> inv = [Select Id, BigTimeSID__c, ATI_Job__c FROM Invoice__c Where BigTimeSID__c =: invoiceSet];
                system.debug('Inv is ' + inv);
                system.debug('Jobs is ' + jobs);
                map<Id, Invoice__c> invoiceMapJobKey = new Map<Id, Invoice__c>();
                for(Invoice__c i : inv){
                    invoiceMapJobKey.put(i.ATI_Job__c, i);
                }
                //remember to update big time invoice created....
                //jobToUpdate.BigTime_Last_Sync__c = system.now();
                //jobToUpdate.BigTime_status__c = string.valueOf(StatusCode);
                //if(Bigtimeid == null){
                //jobToUpdate.BigtimeSID__c = tokenwrap.SystemId;
                //I have the jobs, now I need to create the invoices and put the projectSID number on it. Then I need to update the invoices with line items
                
                List<ATI_Job__c> validJobs = new List<ATI_Job__c>();
                map<string, invoice__c> invoices = new map<string, invoice__c>();
                for(ATI_Job__c job : jobs){
                    system.debug('Invoice map Job key contains    ' + invoiceMapJobKey);
                    if(!invoiceMapJobKey.containsKey(job.id)){
                Invoice__c invoiceSingle = new Invoice__c(Name = 'BigTime Invoice', ATI_Job__c = job.id, BigTimeSid__c = invoiceMap.get(job.BigTimeSID__c), due_date__c = system.today());
                invoicesToInsert.add(invoiceSingle);
                validJobs.add(job);
                invoices.put(invoiceSingle.BigTimeSid__c, invoicesingle);
                system.debug('Invoice Single is ' + invoiceSingle);
                    } 
               // invoiceSet.add(i.id);
                }
                if(!invoicesToInsert.isEmpty()){
                    system.debug('Invoices to Insert are ' + invoicesToInsert);
                    GetInvoiceSpecifics(invoicesToInsert,invoices, validJobs);
                }
                
                
                // if(!invoicesToInsert.isEmpty()){
                // insert invoicesToInsert;
                // for(invoice__c i : invoicesToInsert){
                
                //}
               // }
                //GetLineItemsForInvoices(invoiceSet);

                
                
                }}
                }
                public static void GetInvoiceSpecifics(List<Invoice__c> inv, Map<string, invoice__c> invoices, List<ATI_Job__c> job){
                    system.debug('Invoices being inserted are ' + inv);
                    
                    system.debug('After inv insert ' );
                    Map<string, invoice> invs = new map<string, invoice>();
                    List<invoice_line_item__c> invItemToInsert = new List<Invoice_Line_Item__c>();
                    
Map<string,BigTime__c> mapCredentials = BigTime__c.getAll();
    String token = mapCredentials.get('Bigtime').token__c;
    String firmId = mapCredentials.get('Bigtime').firmid__c;
for(Invoice__c invoice : inv){
Http http = new Http();
HttpRequest request = new HttpRequest();
request.setEndpoint('https://iq.bigtime.net/BigTimeData/api/v2/invoice/detail/' + invoice.BigTimeSID__c);
request.setMethod('GET');
request.setHeader('Content-Type', 'application/json;charset=UTF-8');
request.setHeader('X-Auth-Token', token);
request.setHeader('X-Auth-Realm', firmId);
HttpResponse response = http.send(request);
if (response.getStatusCode() == 200) {

     String body = response.getBody();
    system.debug('Getting the project '+ response.getBody());
     TokenWrapper1 tokenwrap = (TokenWrapper1)JSON.deserialize(body, TokenWrapper1.class);
     invs.put(invoice.BigTimeSID__c, tokenwrap.invoice);
}
}
insert inv;
system.debug('After inv insert ' + inv);

for(String bigTimeSID : invs.Keyset()){
    invoice invLineItems = invs.get(bigTimeSID);
    for(lines line: invLineItems.lines){
        double hours = 0;
         if(line.rate != 0){
         hours = line.amt / line.rate; 
         }
         
         Invoice_Line_Item__c invItem = new Invoice_Line_Item__c(name = '', invoice__c = invoices.get(bigTimeSID).id, amount__c = line.amt, description__c = line.Nm + ' - ' + '\n' + 'Rate:' + line.Rate + ' - ' + '\n' + 'Hours: ' + hours);
         system.debug('Line ' +  line);
         invItemToInsert.add(invItem);
    }
}
insert invItemToInsert;
// If the request is successful, parse the JSON response.
// if (response.getStatusCode() == 200) {
//     List<invoice_line_item__c> invItemToInsert = new List<Invoice_Line_Item__c>();
//      String body = response.getBody();
//     system.debug('Getting the project '+ response.getBody());
//      TokenWrapper1 tokenwrap = (TokenWrapper1)JSON.deserialize(body, TokenWrapper1.class);
//      invoice invs = tokenwrap.invoice;
//      insert inv;
//      for(lines line: invs.lines){
//          double hours = 0;
//          if(line.rate != 0){
//          hours = line.amt / line.rate; 
//          }
//          Invoice_Line_Item__c invItem = new Invoice_Line_Item__c(name = '', invoice__c = inv.id, amount__c = line.amt, description__c = line.Nm + ' - ' + '\n' + 'Rate:' + line.Rate + ' - ' + '\n' + 'Hours: ' + hours);
//          system.debug('Line ' +  line);
//          invItemToInsert.add(invItem);
//      }

//      insert invItemToInsert;
//         system.debug('Tokenwrap : ' + tokenwrap);
    // Deserialize the JSON string into collections of primitive data types.
    //system.debug('Getting the project '+ response.getBody()); 

                }
}