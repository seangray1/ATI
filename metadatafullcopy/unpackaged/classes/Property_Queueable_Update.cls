public without sharing class Property_Queueable_Update implements Queueable{
        public final List<ATI_Job__c> jobsToUpdate;
        public final Map<Id,Property__c> propMap;
        public final String TypeQueue;

        public Property_Queueable_Update(List<ATI_Job__c> jobsRecieived, Map<Id,Property__c> propMapRecieved, String Type)
        {
            jobsToUpdate = jobsRecieived;
            propMap = propMapRecieved;
            TypeQueue = Type;
        }

        public void execute(QueueableContext context) 
        {
            system.debug('Jobs to update is ' + jobsToUpdate);
            for(ATI_Job__c job : jobsToUpdate)
            {
                Property__c prop = PropMap.get(job.Property_ID__c);
                if(TypeQueue == 'MarketChange')
                {
                    job.Market_Class__c = prop.Market_Class__c;
                    job.Market_Segment__c = prop.Market_Segment__c;
                    job.Market_Segment_Sub_Class__c = prop.Market_Segment_Sub_Class__c; 
                }
                if(TypeQueue == 'AddressChange')
                {
                    job.Project_Site_Address__c = prop.Address_line_1__c;
                    job.Project_Site_City__c = prop.City__c;
                    job.Project_Site_State__c = prop.State__c;
                    job.Project_Site_Zipcode__c = prop.Zip__c;
                }
                
                
            }
            update jobsToUpdate;
        }

}