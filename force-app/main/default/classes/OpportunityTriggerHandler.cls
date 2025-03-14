public with sharing class OpportunityTriggerHandler extends TriggerHandler {
    private List<Opportunity> triggerNew;
    private List<Opportunity> triggerOld;
    private Map<Id, Opportunity> triggerMapNew;
    private Map<Id, Opportunity> triggerMapOld;

    public OpportunityTriggerHandler() {
        this.triggerNew = (List<Opportunity>) Trigger.new;
        this.triggerOld = (List<Opportunity>) Trigger.old;
        this.triggerMapNew = (Map<Id, Opportunity>) Trigger.newMap;
        this.triggerMapOld = (Map<Id, Opportunity>) Trigger.oldMap;
    }

    public override void afterInsert() {
        try {
            OpportunityService.countOpportunityAmountForAccount(triggerNew);
        } catch (Exception e) {
            System.debug('Exception in afterInsert of OpportunityHandler: ' + e.getMessage());
        }
    }

    @SuppressWarnings('PMD.ApexCRUDViolation')
    public override void afterUpdate() {
        try {
            OpportunityService.countOpportunityAmountForAccount(triggerNew);
        } catch (Exception e) {
            System.debug('Exception in afterUpdate of OpportunityHandler: ' + e.getMessage());
        }
    }

    @SuppressWarnings('PMD.ApexCRUDViolation')
    public override void afterDelete() {
        try {
            OpportunityService.countOpportunityAmountForAccount(triggerOld);
        } catch (Exception e) {
            System.debug('Exception in afterDelete of OpportunityHandler: ' + e.getMessage());
        }
    }

    @SuppressWarnings('PMD.ApexCRUDViolation')
    public override void afterUndelete() {
        try {
            OpportunityService.countOpportunityAmountForAccount(triggerNew);
        } catch (Exception e) {
            System.debug('Exception in afterUndelete of OpportunityHandler: ' + e.getMessage());
        }
    }
}