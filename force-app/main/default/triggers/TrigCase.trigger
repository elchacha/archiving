trigger TrigCase on Case (after delete) {
    
    CaseTriggerHandler.deleteArchived(Trigger.Old);

}