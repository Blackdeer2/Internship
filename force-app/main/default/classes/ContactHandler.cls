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

    public override void beforeInsert() {
        // try {
            
        // } catch (Exception e) {
        //     System.debug('Exception in beforeInsert of ContactHandler: ' + e.getMessage());
        // }
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

    public override void beforeUpdate() {
        // try {
            
        // } catch (DmlException e) {
        //     System.debug('DML Exception in beforeUpdate of ContactHandler: ' + e.getMessage());
        // } catch (Exception e) {
        //     System.debug('Exception in beforeUpdate of ContactHandler: ' + e.getMessage());
        // }
    }

    @SuppressWarnings('PMD.ApexCRUDViolation')
    public override void afterUpdate() {
        // try {

        // } catch (Exception e) {
        //     System.debug('Exception in afterUpdate of ContactHandler: ' + e.getMessage());
        // }
    }

    @SuppressWarnings('PMD.ApexCRUDViolation')
    public override void beforeDelete() {
        // try {
        //     // Add your logic here if needed
        // } catch (Exception e) {
        //     System.debug('Exception in beforeDelete of ContactHandler: ' + e.getMessage());
        // }
    }

    @SuppressWarnings('PMD.ApexCRUDViolation')
    public override void afterDelete() {
        // try {
        //     // Add your logic here if needed
        // } catch (Exception e) {
        //     System.debug('Exception in afterDelete of ContactHandler: ' + e.getMessage());
        // }
    }

    @SuppressWarnings('PMD.ApexCRUDViolation')
    public override void afterUndelete() {
        // try {
        //     // Add your logic here if needed
        // } catch (Exception e) {
        //     System.debug('Exception in afterUndelete of ContactHandler: ' + e.getMessage());
        // }
    }
}