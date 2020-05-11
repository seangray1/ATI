global class BatchUpdatePropertyGoogleMaps implements Database.Batchable<sObject>, Database.AllowsCallouts {
        global String Query;
        global final String Entity;
        global final String Field;
        global final String Value;
        global class resultswrapper{
            public list<results> results {get;set;}
        }
        global class results{
            public list<address_components> address_components{get;set;}
        }
        global class address_components{
            public String long_name {get;set;}
            public String short_name {get;set;}
            public list<String> types {get;set;}
        }
     
          
       
            global Database.QueryLocator start(Database.BatchableContext BC){
             //    string pn = 'PN-'+ '%';
             //AND Job_Class__c != \'Residential\' AND (Year_Taken__c = \'2017\' OR Year_Taken__c = \'2020\' OR Year_Taken__c = \'2019\' OR Year_Taken__c = \'2020\')
                query = 'select Id, Address_Line_1__c, Address_Verified__c, Street__c, City__c, State__c, Zip__c, County__c from Property__c where Address_Verified__c = FALSE AND City__c != null AND State__c != null AND Address_Line_1__c != null' ;
         
             return Database.getQueryLocator(query);
     
            }
            global void execute(Database.BatchableContext BC, List<Property__c> scope){
                List<Property__c> propsToUpdate = new List<Property__c>();
                for(Property__c p:scope){
                    // system.debug('Id is ' + p.Id);
                    if(p.Address_Line_1__c != null && p.State__c != null && p.City__c != null && !p.Address_Line_1__c.contains('null')){
                Http h = new Http();
            HttpRequest req = new HttpRequest();
             String address = p.Address_Line_1__c + ', ' + p.State__c + ', ' + p.City__c + ' ' + p.Zip__c;
             req.setEndpoint('https://maps.googleapis.com/maps/api/geocode/json?key=AIzaSyBuE7iBv1fugjx2Az7h-bCwJCoWOadglz8&address='+
             EncodingUtil.urlEncode(address, 'UTF-8')+'&sensor=false');
             req.setMethod('GET');
             req.setTimeout(60000);
             string county;
             string street;
             string city;
             string zip;
             string state;
             string streetnumber;
             string postalcode;
           
            HttpResponse res = h.send(req);
            // system.debug('Response is ' + res.getBody());
            resultswrapper result = (resultswrapper)JSON.deserialize(res.getBody(), resultswrapper.class);
            // system.debug('results are ' + result);
            
            for(results a: result.results){
                // system.debug('a ' + a);
                for(address_components ad : a.address_components){
                   // system.debug('ad ' + ad.types[0]);
                    if(ad.types[0] == 'administrative_area_level_2'){
                        county = ad.long_name.replace('County', '');
                        // system.debug('County is  ' + county);
                    }
                    if(ad.types[0] == 'route'){
                        street = ad.short_name;
                      //  system.debug('Street is  ' + street);
                    }
                    if(ad.types[0] == 'locality'){
                        city = ad.short_name;
                       // system.debug('state is  ' + state);
                    }
                    if(ad.types[0] == 'administrative_area_level_1'){
                        state = ad.short_name;
                     //   system.debug('city is  ' + city);
                    }
                    if(ad.types[0] == 'street_number'){
                        streetnumber = ad.short_name;
                        //system.debug('street # is  ' + streetnumber);
                    }
                    if(ad.types[0] == 'postal_code'){
                        postalcode = ad.short_name;
                      //  system.debug('Postal # is  ' + postalcode);
                    }
                    

                
            }

        }
      
            // system.debug('Address Line 1 before ' + p.Address_Line_1__c);
            if(streetnumber != null) p.Address_Line_1__c = streetnumber + ' '+ street;
            if(streetnumber == null && street != null) p.Address_Line_1__c = street;
            
            // system.debug('Address Line 1 after ' + p.Address_Line_1__c);
            p.State__c = state;
            p.City__c = city;
            p.Zip__c = postalcode;
            p.County__c = county;
            p.Address_Verified__c = TRUE;
            if(street != null){
             propsToUpdate.add(p);
            }   
        }
            }
            if(!propsToUpdate.isEmpty()){
            update propsToUpdate;
            }
        }
            global void finish(Database.BatchableContext BC){
            }
         }