public without sharing class AddressValidationQueueable implements Queueable, Database.AllowsCallouts{
    public List<Account> AccountListUpdate;
    public List<Contact> ContactListUpdate;
    public List<Lead> LeadListUpdate;

    public AddressValidationQueueable(List<Account> AccountList, List<Contact> ContactList, List<Lead> LeadList)
    {
        AccountListUpdate = AccountList;
        ContactListUpdate = ContactList;
        LeadListUpdate = LeadList;
    }

    public void execute(QueueableContext context) 
    {
        Boolean AccountsToUpdate = false;
        Boolean ContactsToUpdate = false;
        Boolean LeadsToUpdate = false;
        if(!AccountListUpdate.isEmpty())
        {
            list<Account> jobList = AccountListUpdate.deepClone(true, false, false);
            AccountsToUpdate = true;
            for(Account a : jobList)
            {
                NewJobController.PropertyAddresses addresses = NewJobController.GoogleCallout(a.BillingStreet, a.BillingCity, a.BillingPostalCode, a.BillingState);
                a.BillingCountry = addresses.Country;
                a.BillingStreet = addresses.Street;
                a.BillingCity = addresses.City;
                a.BillingPostalCode = addresses.Zipcode;
                a.BillingState = addresses.State;
            }
            update jobList;
        }
        if(!ContactListUpdate.isEmpty())
        {
            list<Contact> jobList = ContactListUpdate.deepClone(true, false, false);
            ContactsToUpdate = true;
            for(Contact a : jobList)
            {
                NewJobController.PropertyAddresses addresses = NewJobController.GoogleCallout(a.MailingStreet, a.MailingCity, a.MailingPostalCode, a.MailingState);
                a.MailingCountry = addresses.Country;
                a.MailingStreet = addresses.Street;
                a.MailingCity = addresses.City;
                a.MailingPostalCode = addresses.Zipcode;
                a.MailingState = addresses.State;
            }
            update jobList;
        }
        if(!LeadListUpdate.isEmpty())
        {
            list<Lead> jobList = LeadListUpdate.deepClone(true, false, false);
            LeadsToUpdate = true;
            for(Lead a : jobList)
            {
                NewJobController.PropertyAddresses addresses = NewJobController.GoogleCallout(a.Street, a.City, a.PostalCode, a.State);
                a.Country = addresses.Country;
                a.Street = addresses.Street;
                a.City = addresses.City;
                a.PostalCode = addresses.Zipcode;
                a.State = addresses.State;
            }
            update jobList;
        }
    }

}