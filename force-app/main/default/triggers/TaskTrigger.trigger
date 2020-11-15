/**
 * @File Name          : TaskTrigger.trigger
 * @Description        : 
 * @Author             : Sean Gray
 * @Group              : 
 * @Last Modified By   : Sean Gray
 * @Last Modified On   : 10/8/2019, 2:14:53 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    10/8/2019   Sean Gray     Initial Version
**/
//Version 1.0
//create by - Prabaharan Periasamy
//trigger called when there are updates, deletes, inserts on task object.
trigger TaskTrigger on Task (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
    
    
    if( trigger.isInsert && trigger.isAfter ){
        TaskTriggerUtility.afterTaskInsert( trigger.new, trigger.newMap );
        TaskUpdateLastActivityDate.TaskUpdateLastActivityDate(trigger.new);
    }
    
    if(trigger.isbefore && trigger.isInsert)
    {
        TaskTriggerValidation.ValidateXactTask(trigger.new);
        TaskTriggerUtility.beforeInsert(trigger.new);
    }
}