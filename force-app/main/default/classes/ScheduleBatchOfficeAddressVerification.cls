/**
 * @File Name          : ScheduleBatchOfficeAddressVerification.cls
 * @Description        : 
 * @Author             : sean.gray@atirestoration.com
 * @Group              : 
 * @Last Modified By   : sean.gray@atirestoration.com
 * @Last Modified On   : 2/3/2020, 8:06:53 AM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    2/3/2020   sean.gray@atirestoration.com     Initial Version
**/
global class ScheduleBatchOfficeAddressVerification implements Schedulable {
    Public set<id> ids=new set<id>();
    Public ScheduleBatchOfficeAddressVerification(){}
    Public ScheduleBatchOfficeAddressVerification (set<id> recids){
        ids=recids;
    }
    global void execute(SchedulableContext SC) {
       smartystreets.BatchAddressVerification bp = new smartystreets.BatchAddressVerification('select id from Property__c',ids);
       database.executebatch(bp,50);
    }
 }