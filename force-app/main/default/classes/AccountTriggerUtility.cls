public without sharing class AccountTriggerUtility {
    // helper method to be called on After Insert of accounts.
    public static void afterAccountInsert( List<Account> accounts ){
        createBillingAddressRecords( null, accounts );
    }
    
    public static void afterAccountUpdate( Map<Id, Account> oldAccountsMap, List<Account> newAccounts ){    
        createBillingAddressRecords( oldAccountsMap, newAccounts );
    }
    
    private static void createBillingAddressRecords( Map<Id, Account> oldAccountsMap, List<Account> accounts ){
        List<Billing_Address__c> billingAddresses = new List<Billing_Address__c>();
        for( Account acc : accounts ){
            Account oldAcc = oldAccountsMap == null ? null : oldAccountsMap.get( acc.Id );
            if((oldAcc == null && ( acc.BillingCity != null || acc.BillingState != null ||
                    acc.BillingCountry != null || acc.BillingCountry != null || acc.BillingPostalCode != null))|| 
                (oldAcc != null && oldAcc.Create_Billing_Address__c != acc.Create_Billing_Address__c && acc.Create_Billing_Address__c)) {
                Billing_Address__c ba = new Billing_Address__c();
                ba.Account__c = acc.Id;
                system.debug(acc.billingStreet);
                ba.Billing_City__c = acc.BillingCity;
                ba.Billing_State__c = acc.BillingState;
                ba.Billing_Street__c = acc.BillingStreet;
                ba.Billing_Country__c = acc.BillingCountry;
                    system.debug( acc.BillingPostalCode);
                ba.Billing_Zipcode__c = acc.BillingPostalCode;
                billingAddresses.add( ba );
            }
        }
        if( !billingAddresses.isEmpty() ){
            insert billingAddresses;
        }
    }

    public static void UpdateRelatedCases(string recordId, string Notes, string CourtesyCallOutcome)
    {
        List<Case> cases = [Select Id, Status, Courtesy_Call_Outcome__c FROM Case WHere AccountId =: recordId];
        List<CaseMilestone> caseMilestones = [Select Id,  completionDate FROM CaseMilestone Where CaseId =:cases];
        if(!cases.isEmpty())
        {
            for(Case c : cases)
            {
                String comments = '\n' + 'Courtesy Call' + '\n' + '\n' + 'Outcome: ' + CourtesyCallOutcome + '\n' + 
                'Agent/User: ' + UserInfo.getUserName() + '\n' + 'Notes: ' + Notes;
                c.Courtesy_Call_Outcome__c = CourtesyCallOutcome;
                ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
                ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
                ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
                ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
                messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
                ConnectApi.MentionSegmentInput mentionSegmentInput1 = new ConnectApi.MentionSegmentInput();
                ConnectApi.MentionSegmentInput mentionSegmentInput2 = new ConnectApi.MentionSegmentInput();
                ConnectApi.MentionSegmentInput mentionSegmentInput3 = new ConnectApi.MentionSegmentInput();
               
                //    mentionSegmentInput2.id = office[0].project_coordinator__c;
                //    messageBodyInput.messageSegments.add(mentionSegmentInput2);
                
                textSegmentInput.text = comments;
                messageBodyInput.messageSegments.add(textSegmentInput);
                feedItemInput.body = messageBodyInput;
                feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
                feedItemInput.subjectId = recordId;
                if(Test.isRunningTest())
                {
                   system.debug('Test is running ');
                }
                else
                {
                ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput);
                
                //related case criteria, they must have status = invoiced
                //Update Milestone status? trigger completion of courtesy call followup in each related case, add note TASK to each case and account
                }
            }
            update cases;
        }
        if(!caseMilestones.isEmpty())
        {
            for(CaseMilestone cm : caseMilestones)
            {
                cm.completionDate = System.today();
            }
            update caseMilestones;
        }
    }
}