/**
 * Trigger on Order. Will be triggered only on update and delete. No logic is contained in this class, it is all handled through the OrderTriggerHandler
 */
trigger OrderTrigger on Order (before update,before delete) {
    if(Trigger.isBefore && Trigger.isUpdate) {
        OrderTriggerHandler.beforeUpdate(Trigger.OldMap,Trigger.NewMap);
    }
    if(Trigger.isBefore && Trigger.isDelete){
        OrderTriggerHandler.beforeDelete(Trigger.Old);
    }

}