public with sharing class AccountHandler extends TriggerHandler {

    private List<Account> triggerNew;
    private List<Account> triggerOld;
    private Map<Id, Account> triggerMapNew;
    private Map<Id, Account> triggerMapOld;

    public AccountHandler() {
        this.triggerNew = (List<Account>) Trigger.new;
        this.triggerOld = (List<Account>) Trigger.old;
        this.triggerMapNew = (Map<Id, Account>) Trigger.newMap;
        this.triggerMapOld = (Map<Id, Account>) Trigger.oldMap;
    }

    public override void beforeInsert() {
        // try {
            
        // } catch (Exception e) {
        //     System.debug('Exception in beforeInsert of AccountHandler: ' + e.getMessage());
        // }
    }

    public override void afterInsert() {
        try {
            AccountService.createTaskForAccount(this.triggerNew);
        } catch (DmlException e) {
            System.debug('DML Exception in afterInsert of AccountHandler: ' + e.getMessage());
        } catch (Exception e) {
            System.debug('Exception in afterInsert of AccountHandler: ' + e.getMessage());
        }
    }

    public override void beforeUpdate() {
        // try {
            
        // } catch (DmlException e) {
        //     System.debug('DML Exception in beforeUpdate of AccountHandler: ' + e.getMessage());
        // } catch (Exception e) {
        //     System.debug('Exception in beforeUpdate of AccountHandler: ' + e.getMessage());
        // }
    }

    @SuppressWarnings('PMD.ApexCRUDViolation')
    public override void afterUpdate() {
        // try {

        // } catch (Exception e) {
        //     System.debug('Exception in afterUpdate of AccountHandler: ' + e.getMessage());
        // }
    }

    @SuppressWarnings('PMD.ApexCRUDViolation')
    public override void beforeDelete() {
        // try {
        //     // Add your logic here if needed
        // } catch (Exception e) {
        //     System.debug('Exception in beforeDelete of AccountHandler: ' + e.getMessage());
        // }
    }

    @SuppressWarnings('PMD.ApexCRUDViolation')
    public override void afterDelete() {
        // try {
        //     // Add your logic here if needed
        // } catch (Exception e) {
        //     System.debug('Exception in afterDelete of AccountHandler: ' + e.getMessage());
        // }
    }

    @SuppressWarnings('PMD.ApexCRUDViolation')
    public override void afterUndelete() {
        // try {
        //     // Add your logic here if needed
        // } catch (Exception e) {
        //     System.debug('Exception in afterUndelete of AccountHandler: ' + e.getMessage());
        // }
    }
}