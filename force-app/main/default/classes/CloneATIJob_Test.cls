/**
 * @File Name          : CloneATIJob_Test.cls
 * @Description        : 
 * @Author             : sean.gray@atirestoration.com
 * @Group              : 
 * @Last Modified By   : sean.gray@atirestoration.com
 * @Last Modified On   : 2/17/2020, 11:06:55 AM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    2/17/2020   sean.gray@atirestoration.com     Initial Version
**/
@isTest(SeeAllData=true)

public with sharing class CloneATIJob_Test {
    static testMethod void CloneATIJob(){
        ATI_Job__c job = [Select Id from ATI_Job__c Limit 1];
        CloneATIJob.CloneJobRecord(job.Id, true);
        CloneATIJob.CloneJobRecord(job.Id, false);
}
}