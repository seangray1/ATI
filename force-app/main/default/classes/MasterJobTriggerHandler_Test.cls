@isTest
public with sharing class MasterJobTriggerHandler_Test {
    static testMethod void MasterJobInsertUpdate() {
        Property__c p = new Property__c(Name = 'Test', Alternate_Name__c = 'Test Job', Address_Line_1__c = '15632 La Palma', City__c = 'Anaheim', State__c='CA');
        insert p;
        system.debug('Property is ' + p);
        Master_Job__c mj = new Master_Job__c(Name = 'Test', property__c = p.Id, Stage__c = 'Pre-work');
        insert mj;
        Master_Job__c mj1 = new Master_Job__c(Name = 'Test', Address_Line_1__c = '123', State__c = 'CA', City__c = 'Whit', Stage__c = 'Pre-work');
        insert mj1;
        system.debug('Master Job is ' + mj);
        p.Alternate_Name__c = 'Test Job 1';
        update p;
        mj.Date_of_Loss__c = system.today() + 1;
        update mj;
        mj1.Property__c = p.Id;
        update mj1;
        mj1.Date_Of_Loss__c = system.today();
        update mj1;
    }
}