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
            SalesforcedataSend.createRecordTargetOrg();
        } catch (DmlException e) {
            System.debug('DML Exception in afterInsert of AccountHandler: ' + e.getMessage());
        } catch (Exception e) {
            System.debug('Exception in afterInsert of AccountHandler: ' + e.getMessage());
        }
    }

    public override void afterUpdate() {
        try {
            Set<Id> accountIds = new Set<Id>();
            for(Account acc: this.triggerNew){
                Account oldAcc = this.triggerMapOld.get(acc.Id);
                if(acc.Name != oldAcc.Name || acc.Website != oldAcc.Website || 
                    acc.BillingStreet != oldAcc.BillingStreet || acc.BillingCity != oldAcc.BillingCity ||
                    acc.BillingState != oldAcc.BillingState || acc.BillingPostalCode != oldAcc.BillingPostalCode ||
                    acc.BillingCountry != oldAcc.BillingCountry ||
                    acc.ShippingStreet != oldAcc.ShippingStreet || acc.ShippingCity != oldAcc.ShippingCity ||
                    acc.ShippingState != oldAcc.ShippingState || acc.ShippingPostalCode != oldAcc.ShippingPostalCode ||
                    acc.ShippingCountry != oldAcc.ShippingCountry) {

                    accountIds.add(acc.Id);
                }
            }
            SalesforcedataSend.syncUpdatedAccounts(accountIds);

        } catch (DmlException e) {
            System.debug('DML Exception in afterUpdate of AccountHandler: ' + e.getMessage());
        } catch (Exception e) {
            System.debug('Exception in afterUpdate of AccountHandler: ' + e.getMessage());
        }
    }
}