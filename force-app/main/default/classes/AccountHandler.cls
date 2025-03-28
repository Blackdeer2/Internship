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

            Set<Id> accountIds = new Map<Id, Account>(this.triggerMapNew).keySet();
            SalesforcedataSend.createRecordTargetOrg(accountIds);
            
        } catch (DmlException e) {
            System.debug('DML Exception in afterInsert of AccountHandler: ' + e.getMessage());
        } catch (Exception e) {
            System.debug('Exception in afterInsert of AccountHandler: ' + e.getMessage());
        }
    }

    public override void afterUpdate() {
        try {
            Set<Id> accountIds = new Set<Id>();
            System.debug('Call getSyncFields');
            List<String> fieldsToCheck = MetadataControler.getSyncFields();
            for(Account acc: this.triggerNew){
                Account oldAcc = this.triggerMapOld.get(acc.Id);

                for(String fieldName: fieldsToCheck){
                    if(acc.get(fieldName) != oldAcc.get(fieldName)){
                        accountIds.add(acc.Id);
                    }
                }

            }
            SalesforcedataSend.createRecordTargetOrg(accountIds);

        } catch (DmlException e) {
            System.debug('DML Exception in afterUpdate of AccountHandler: ' + e.getMessage());
        } catch (Exception e) {
            System.debug('Exception in afterUpdate of AccountHandler: ' + e.getMessage());
        }
    }
}