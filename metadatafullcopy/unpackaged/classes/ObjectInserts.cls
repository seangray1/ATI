global without sharing class ObjectInserts {
    public list<ATI_Job__c> jobList {get;set;}
    public list<Contact> contactList {get;set;}
    public list<Account> accountList {get;set;}
    public list<Master_Job__c> masterjobList {get;set;}
    public list<Property__c> propertyList {get;set;}
    public list<User> userList {get;set;}
    public list<Office__c> officeList {get;set;}
    public list<Account_Roles__c> accountroleList {get;set;}
    global Map<Id, Office__c> officeMap {get;set;}
}