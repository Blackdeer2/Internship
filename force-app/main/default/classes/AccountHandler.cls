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

    public override void afterInsert() {
        try {
            AccountService.createTaskForAccount(this.triggerNew);

            if(TriggerControlSync.isSyncRunning == true){
                System.debug('Sync is already running. Skipping execution.');
                return;
            }

            AccountService.sendCreatedAccountToAnotherOrg(this.triggerMapNew);
            
        } catch (DmlException e) {
            System.debug('DML Exception in afterInsert of AccountHandler: ' + e.getMessage());
        } catch (Exception e) {
            System.debug('Exception in afterInsert of AccountHandler: ' + e.getMessage());
        }
    }

    public override void afterUpdate() {
        try {

            if (TriggerControlSync.isSyncRunning == true) {
                System.debug('Sync is already running. Skipping execution.');
                return;
            }
            AccountService.sendUpdatedAccountToAnotherOrg(this.triggerNew, this.triggerMapOld);

        } catch (DmlException e) {
            System.debug('DML Exception in afterUpdate of AccountHandler: ' + e.getMessage());
        } catch (Exception e) {
            System.debug('Exception in afterUpdate of AccountHandler: ' + e.getMessage());
        }
    }
}