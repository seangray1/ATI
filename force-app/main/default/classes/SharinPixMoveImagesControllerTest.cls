@isTest(seeAllData = true)
public class SharinPixMoveImagesControllerTest {

    static testmethod void testMethod1(){
        User u = [Select id from User limit 1];
        Id userId = u.id;
        String startDate = string.valueOf(system.today()-7);
        String endDate = string.valueOf(system.today()+7);
        
        List<sharinpix__SharinPixImage__c> imagesListInDB = [SELECT Id FROM sharinpix__SharinPixImage__c WHERE sharinpix__User__c =:userId AND sharinpix__DateUploaded__c >=:Date.valueOf(startDate) AND sharinpix__DateUploaded__c <=:Date.valueOf(endDate)];
        List<sharinpix__SharinPixImage__c> imagesList = SharinPixMoveImagesController.getSharinPixImageList(userId, startDate,EndDate);
        System.assertEquals(imagesListInDB.size(), imagesList.size());
        
        List<sharinpix__SharinPixImage__c> imagesList1 = SharinPixMoveImagesController.getSharinPixImageList(null, null,null);
        System.assertEquals(0, imagesList1.size());
    }
    
    static testmethod void testMethod2(){
        List<sharinpix__SharinPixImage__c> sharinpixImageList = [SELECT Id,Job__c,sharinpix__ImagePublicId__c FROM sharinpix__SharinPixImage__c limit 2];
        String selectedSharinPixImagePublicIds = '["' + sharinpixImageList.get(0).sharinpix__ImagePublicId__c + '","' + sharinpixImageList.get(1).sharinpix__ImagePublicId__c +  '"]';
        System.debug('$$$$$$$$$$$' + selectedSharinPixImagePublicIds);
        ATI_Job__c job = [Select Id, Name from ATI_Job__c LIMIT 1];
        
        Test.startTest();
        SharinPixMoveImagesController.moveSharinPixImagesToSelJob(selectedSharinPixImagePublicIds, job.Id);
        Test.stopTest();
        
        List<sharinpix__SharinPixImage__c> sharinpixImageListAfterMove = [SELECT Id,Job__c FROM sharinpix__SharinPixImage__c  WHERE ID =:sharinpixImageList.get(0).Id OR ID =:sharinpixImageList.get(1).Id];
        System.assertEquals(job.Id, sharinpixImageListAfterMove.get(0).Job__c);
    }
    
    static testmethod void testMethod3(){
        Test.startTest();
        SharinPixMoveImagesController.moveSharinPixImagesToSelJob(null, null);
        Test.stopTest();
        
    }
}