public with sharing class AddressValidationCheck {
    public static void AddressValidationCheck(List<SObject> objects, Map<Id,SObject> oldMap) 
    {
        String sobjectype = objects[0].Id.getSobjectType().getDescribe().getName();
        List<Account> AccountList = new List<Account>();
        List<Contact> ContactList = new List<Contact>();
        List<Lead> LeadList = new List<Lead>();
        for(SObject s : objects)
        {
            if(sobjectype == 'Account')
            {
                system.debug(s);
                Account convertedAccount = (Account)s;
                Account oldMapAccount = (Account)oldMap.get(convertedAccount.Id);
                system.debug(convertedAccount.BillingStreet + ' ' + oldMapAccount.BillingAddress);
                if(convertedAccount.Address_Validated__c == false && (convertedAccount.BillingStreet != oldMapAccount.BillingStreet || convertedAccount.BillingState != oldMapAccount.BillingState
                || convertedAccount.BillingCity != oldMapAccount.BillingCity || convertedAccount.BillingPostalCode != oldMapAccount.BillingPostalCode))
                {
                    system.debug('Account needs Google Validation');
                    AccountList.add(convertedAccount);
                }
            }
            if(sobjectype == 'Contact')
            {
                system.debug(s);
                Contact convertedContact = (Contact)s;
                Contact oldMapContact = (Contact)oldMap.get(convertedContact.Id);
                if(convertedContact.Address_Validated__c == false && (convertedContact.MailingStreet != oldMapContact.MailingStreet ||
                convertedContact.MailingState != oldMapContact.MailingState || convertedContact.MailingCity != oldMapContact.MailingCity ||
                convertedContact.MailingPostalCode != oldMapContact.MailingPostalCode))
                {
                    system.debug('Contact needs Google Validation');
                    ContactList.add(convertedContact);
                }
            }
            if(sobjectype == 'Lead')
            {
                system.debug(s);
                Lead convertedLead = (Lead)s;
                Lead oldMapLead = (Lead)oldMap.get(convertedLead.Id);
                if(convertedLead.Address_Validated__c == false && (convertedLead.Street != oldMapLead.Street || 
                convertedLead.State != oldMapLead.State || convertedLead.PostalCode != oldMapLead.PostalCode || 
                convertedLead.City != oldMapLead.City))
                {
                    system.debug('Lead needs Google Validation');
                    LeadList.add(convertedLead);
                }
            }
        }
        if(!LeadList.isEmpty() || !ContactList.isEmpty() || !AccountList.isEmpty())
        {
            Id addresscheckQueueable = System.enqueueJob(new AddressValidationQueueable(AccountList, ContactList, LeadList));
        }
    }
}