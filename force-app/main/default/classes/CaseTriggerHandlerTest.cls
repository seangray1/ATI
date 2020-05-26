@isTest
public class CaseTriggerHandlerTest {

    //Test method for Contact email scenario
    static testMethod void testCaseExt() {
		//Create Account Record
        Account acc = new Account(Name ='TestAccount');
        insert acc;
        System.debug(acc);
        
        //Create Contact Record
        Contact con = new Contact(AccountId = acc.Id, LastName = 'TestCon', Contact_Type__c ='Additional Contact', email = 'Test@ati.com');
        insert con;

        //Create the Case Record
		String DescriptionText = 'Organization ICO Sales \n Crisis Plan Crisis Response Playbook \n Event Name Report an Incident \n Reported By Test@ati.com \n Device Time 3/17/2020 4:1:34 PM';
        Case cas = new Case(Status ='New', Priority = 'Medium', Origin = 'Email', Description = DescriptionText ); 
        insert cas;
        
        
    }
    
    //Test method for Account website scenario
    static testMethod void testCaseExt2() {
		//Create Account Record
        Account acc = new Account(Name ='TestAccount', Website = 'ati.com');
        insert acc;
        System.debug(acc);
        
        //Create Contact Record
        Contact con = new Contact(AccountId = acc.Id, LastName = 'TestCon', Contact_Type__c ='Additional Contact');
        insert con;

        //Create the Case Record
		String DescriptionText = 'Organization ICO Sales \n Crisis Plan Crisis Response Playbook \n Event Name Report an Incident \n Reported By Test@ati.com \n Device Time 3/17/2020 4:1:34 PM';
        Case cas = new Case(Status ='New', Priority = 'Medium', Origin = 'Email', Description = DescriptionText ); 
        insert cas;
        system.debug('EmailAccount'+ cas.AccountId);
    }
    
    //Test method for Account/Organization name
    static testMethod void testCaseExt3() {
		//Create Account Record
        Account acc = new Account(Name ='ICO Sales');
        insert acc;
        System.debug(acc);
        
        //Create Contact Record
        Contact con = new Contact(AccountId = acc.Id, LastName = 'TestCon', Contact_Type__c ='Additional Contact');
        insert con;

        //Create the Case Record
		String DescriptionText = 'Organization ICO Sales \n Crisis Plan Crisis Response Playbook \n Event Name Report an Incident \n Reported By Test@ati.com \n Device Time 3/17/2020 4:1:34 PM';
        Case cas = new Case(Status ='New', Priority = 'Medium', Origin = 'Email', Description = DescriptionText ); 
        insert cas;
        system.debug('EmailAccount'+ cas.AccountId);
    }
    
    //Test method for all the negatives 
    static testMethod void testCaseExt4() {
		
        //Create the Case Record
		String DescriptionText = 'Organization ICO Sales \n Crisis Plan Crisis Response Playbook \n Event Name Report an Incident \n Reported By Test@ati.com \n Device Time 3/17/2020 4:1:34 PM';
        Case cas = new Case(Status ='New', Priority = 'Medium', Origin = 'Email', Description = DescriptionText ); 
        insert cas;
        system.debug('EmailAccount'+ cas.AccountId);
    }
}