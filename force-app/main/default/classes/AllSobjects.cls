public without sharing class AllSobjects {
    
    public String selectedObject {get; set;}
    public List<FieldWrapper> listField{get;set;}

   

    // find all sObjects available in the organization
    @AuraEnabled
    public static List<string> getListObjectName() 
    {
        Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        List<string> objNames = new List<string>();
        List<String> entities = new List<String>(schemaMap.keySet());
        entities.sort();
        integer count = 0;
        String substr = '__';
        for(String name : entities)
        {
            system.debug('Name is ' + name);
           count = name.CountMatches(substr);
           if(count > 1 || name.contains('__mdt'))
           {
                system.debug('$$$$$$bad' + name);
           }
           else{
               objNames.add(name);
           }
        }
            // objNames.add(new SelectOption(name,name));
            
        return objNames;
    }
    public class FieldWrapper

    {

        public String fieldName {get; set;}

        public String fieldAPIName {get; set;}

    }

}
