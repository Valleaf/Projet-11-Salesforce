/**
 * Trigger on Order. Will be triggered only on update and delete. No logic is contained in this class, it is all handled through the OrderTriggerHandler
 */
trigger OrderTrigger on Order (before insert,before update, after delete) {
    if(Trigger.isBefore && Trigger.isInsert) {
        OrderTriggerHandler.beforeInsert(Trigger.New);
    }
    if(Trigger.isBefore && Trigger.isUpdate) {
        OrderTriggerHandler.beforeUpdate(Trigger.OldMap,Trigger.NewMap);
    }
    if(Trigger.isAfter && Trigger.isDelete){
        OrderTriggerHandler.afterDelete(Trigger.Old);
    }

}