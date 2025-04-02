public with sharing class ContactHandler extends TriggerHandler {
    private List<Contact> triggerNew;
    private List<Contact> triggerOld;
    private Map<Id, Contact> triggerMapNew;
    private Map<Id, Contact> triggerMapOld;

    public ContactHandler() {
        this.triggerNew = (List<Contact>) Trigger.new;
        this.triggerOld = (List<Contact>) Trigger.old;
        this.triggerMapNew = (Map<Id, Contact>) Trigger.newMap;
        this.triggerMapOld = (Map<Id, Contact>) Trigger.oldMap;
    }

    // public override void beforeInsert() {
    //     try {
    //        ContactService.validationOfPhoneInContact(triggerNew); 
    //     } catch (Exception e) {
    //         System.debug('Exception in beforeInsert of ContactHandler: ' + e.getMessage());
    //     }
    // }

    public override void afterInsert() {
        try {
            ContactService.conectlastContactToAccount(triggerNew);
        } catch (Exception e) {
            System.debug('Exception in afterInsert of ContactHandler: ' + e.getMessage());
        }
    }
  
    // public override void beforeUpdate() {
    //     try {
    //         ContactService.validationOfPhoneInContact(triggerNew);
    //     } catch (Exception e) {
    //         System.debug('Exception in beforeUpdate of ContactHandler: ' + e.getMessage());
    //     }
    // }
}