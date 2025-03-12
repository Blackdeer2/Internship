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
    

}