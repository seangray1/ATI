public class SharinPixImageTriggerHandler {

    public static void createBackupRecords( List<sharinpix__SharinPixImage__c> deletedRecordList){
        List<SharinPix_Deleted_Images__c> sharinPixDeletedImagesList = new List<SharinPix_Deleted_Images__c>();
        
        for(sharinpix__SharinPixImage__c DeletedImage : deletedRecordList){
            SharinPix_Deleted_Images__c singleImageData = new SharinPix_Deleted_Images__c();
            singleImageData.Old_SharinPix_record_ID__c = DeletedImage.id;
            singleImageData.Job__c = DeletedImage.Job__c;
            singleImageData.Album_ID__c = DeletedImage.sharinpix__AlbumID__c;
            singleImageData.Converted_Image_URL__c = DeletedImage.Converted_Image_URL__c;
            singleImageData.Date_Uploaded__c = DeletedImage.sharinpix__DateUploaded__c;
            singleImageData.Job__c = DeletedImage.Job__c;
            singleImageData.File_Name__c = DeletedImage.sharinpix__FileName__c;
            singleImageData.Google_Drive_ID_Edited__c = DeletedImage.Google_Drive_ID_Edited__c;
            singleImageData.Google_Drive_ID_Original__c = DeletedImage.Google_Drive_ID_Original__c;
            singleImageData.Image_URL_Full__c = DeletedImage.sharinpix__ImageURLFull__c;
            singleImageData.Image_URL_Original__c = DeletedImage.sharinpix__ImageURLOriginal__c;
            singleImageData.Tags__c = DeletedImage.sharinpix__Tags__c;
            singleImageData.User__c = DeletedImage.sharinpix__User__c;
            sharinPixDeletedImagesList.add(singleImageData);
        }
        
        if(sharinPixDeletedImagesList.size() > 0){
            insert sharinPixDeletedImagesList;
        }
        
        
    }
}