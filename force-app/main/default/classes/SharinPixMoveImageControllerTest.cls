public class SharinPixMoveImageControllerTest {
	
    @AuraEnabled(cacheable=true)
    public static List<sharinpix__SharinPixImage__c> getSharinPixImageList(String selectedUserId, String startDate, String endDate) {
        List<sharinpix__SharinPixImage__c> imagesList = new List<sharinpix__SharinPixImage__c>();
        
        if(String.isBlank(selectedUserId) && String.isBlank(startDate) && String.isBlank(endDate))
            return imagesList;
        System.debug('$$$$$ selectedUserId-' + selectedUserId);
        
        Datetime searchStartDate;
        Datetime searchEndDate;
        //String fileNameSearchText = GDI_Constants.STRING_EMPTY;
        if(!String.isBlank(startDate)){
            Date dateStart = Date.ValueOf(startDate); 
            searchStartDate = datetime.newInstance(dateStart.year(), dateStart.month(),dateStart.day());
            System.debug('$$$$$ Start Date-' + searchStartDate);
            System.debug('$$$$$ local time-' + searchStartDate.format());
        }
        if(!String.isBlank(endDate)){
            Date dateEnd = Date.ValueOf(endDate); 
            searchEndDate = datetime.newInstance(dateEnd.year(), dateEnd.month(),dateEnd.day());
            searchEndDate = searchEndDate.addDays(1);
            System.debug('$$$$$ End Date-' + searchEndDate);
            System.debug('$$$$$ local time-' + searchEndDate.format());
        }
        
        String queryString = 'SELECT Id,Name,sharinpix__ImageThumbnail__c,sharinpix__ImagePublicId__c,sharinpix__ImageURLFull__c,sharinpix__FileName__c,sharinpix__Format__c ,sharinpix__DateUploaded__c  FROM sharinpix__SharinPixImage__c ' + 
            				 'WHERE ';
        if(!String.isBlank(selectedUserId))
            queryString += 'sharinpix__User__c =:selectedUserId AND ';
        /*if(!String.isBlank(fileNameSearchText))
            queryString += 'sharinpix__FileName__c LIKE : fileNameSearchText AND ';*/
        if(null != searchStartDate)
            queryString += 'sharinpix__DateUploaded__c >=:searchStartDate AND ';
        if(null != searchEndDate)
            queryString += 'sharinpix__DateUploaded__c <:searchEndDate';
        
        queryString = queryString.removeEnd('AND ');
        queryString += ' ORDER BY sharinpix__DateUploaded__c DESC';
        System.debug('$$$$$ queryString-' + queryString);
        
        List<sObject> recordList= Database.query(queryString);
        System.debug('$$$$$ recordList-' + recordList.size());
        System.debug(recordList);
        
        imagesList = (List<sharinpix__SharinPixImage__c>)recordList;
        
        return imagesList;
    }
    
    @AuraEnabled
    public static void moveSharinPixImagesToSelJob(String selectedSharinPixImagePublicIds, String targetJobId) {
        
        if(null == selectedSharinPixImagePublicIds && String.isBlank(selectedSharinPixImagePublicIds) && String.isBlank(targetJobId))
            return;
        System.debug('$$$$$ Target Job-' + targetJobId);
        System.debug('$$$$$ selectedSharinPixImagePublicIds -' + selectedSharinPixImagePublicIds);
        
        List<String> selImagePublicIdList = (List<String>)JSON.deserialize(selectedSharinPixImagePublicIds, List<String>.class);
        System.debug('$$$$$ selImagePublicIdList-' + selImagePublicIdList);
        
        List<Object> updatedObjInSharinPixList = new List<Object>();
        if(Test.isRunningTest()){
            for(String publicId : selImagePublicIdList)
           		updatedObjInSharinPixList.add(publicId);
        }
        else
            updatedObjInSharinPixList = sharinpix.Image.moveImages(selImagePublicIdList,targetJobId);
        System.debug('$$$$$ updatedObjList-' + updatedObjInSharinPixList);
        
        List<String> updatePublicImageIdList = new List<String>();
        for(Object updatedObject : updatedObjInSharinPixList){
            String publicImageId = (String)updatedObject;
            updatePublicImageIdList.add(publicImageId);
        }
        
        try{
            List<sharinpix__SharinPixImage__c> sharinPixImageList = [SELECT Id,Job__c FROM sharinpix__SharinPixImage__c WHERE sharinpix__ImagePublicId__c IN : updatePublicImageIdList LIMIT 10000];
            System.debug('$$$$$ sharinPixImageList-' + sharinPixImageList);
            //List<sharinpix__SharinPixImage__c> toBeUpdatedImageList = new List<sharinpix__SharinPixImage__c>();
            for(sharinpix__SharinPixImage__c sharinPixImage: sharinPixImageList){
                sharinPixImage.Job__c = targetJobId;
            }
            update sharinPixImageList;
        }catch(Exception e){
            System.debug('System Exception occurred : ' + e.getTypeName());
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
        }
        
    }
    
}