@isTest
public class PropertyTriggerTest {
    
     static testmethod void propertyTriggerTest() {

         Property__c prop = new Property__c();
         prop.Name='Test Property';
         Insert prop;
         
         prop.Name='Test Property';
         update prop;
     }
}