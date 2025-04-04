public with sharing class AccountService {

    public static void createTaskForAccount(List<Account> accounts){

        if(accounts == null || accounts.isEmpty()){
            return;
        }

        List<Task> tasks = new List<Task>();
        for(Account acc : accounts){
            Task t = new Task();
            t.Subject = 'Call';
            t.WhatId = acc.Id;
            t.Priority = 'Normal';
            t.Status = 'Not Started';
            t.Description = 'Created by Apex Trigger';
            tasks.add(t);

        }

        if (!tasks.isEmpty()) {
            insert tasks;
        }
    }

    public static void sendUpdatedAccountToAnotherOrg(List<Account> accounts, Map<Id, Account> accountMapsOld){

        Set<Id> accountIds = new Set<Id>();
        System.debug('Call getSyncFields');
        List<String> fieldsToCheck = MetadataControler.getSyncFields();
        if(fieldsToCheck == null){
            System.debug('afterUpdate fieldsToCheck == null');
            return;
        }
        for(Account acc: accounts){
            Account oldAcc = accountMapsOld.get(acc.Id);

            for(String fieldName: fieldsToCheck){
                if(acc.get(fieldName) != oldAcc.get(fieldName)){
                    accountIds.add(acc.Id);
                }
            }

        }
        SalesforcedataSend.createRecordTargetOrg(accountIds);

    }


    public static void sendCreatedAccountToAnotherOrg(Map<Id, Account> accountMapsNew){

        Set<Id> accountIds = new Map<Id, Account>(accountMapsNew).keySet();
        SalesforcedataSend.createRecordTargetOrg(accountIds);

    }
    

}