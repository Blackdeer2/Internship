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

    public override void afterInsert() {
        try {
            ContactService.conectlastContactToAccount(triggerNew);
        } catch (DmlException e) {
            System.debug('DML Exception in afterInsert of ContactHandler: ' + e.getMessage());
        } catch (Exception e) {
            System.debug('Exception in afterInsert of ContactHandler: ' + e.getMessage());
        }
    }
}