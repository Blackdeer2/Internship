@isTest
private with sharing class AccountTriggerTest {

    @TestSetup
    static void setupTestData(){

        List<Account> accounts = new List<Account>();
        accounts.add(new Account(Name = 'Test Account 1'));
        accounts.add(new Account(Name = 'Test Account 2'));
        
        insert accounts;
    }

    @isTest
    static void testCreateTaskForAccount_Positive(){
        List<Account> accounts = [SELECT Id FROM Account];

        delete [SELECT Id FROM Task];

        Test.startTest();
        AccountService.createTaskForAccount(accounts);
        Test.stopTest();

        List<Task> tasks = [SELECT Id, Subject, WhatId, Status FROM Task];
        System.assertEquals(2, tasks.size(), 'Must create 2 tasks');
        for(Task t : tasks){
            System.assertEquals('Call', t.Subject, 'Subject must be Call');
            System.assertNotEquals(null, t.WhatId, 'WhatId must be Account Id');
            System.assertEquals('Not Started', t.Status, 'Status must be Not Started');
        }
    }

    @isTest
    static void testCreateTaskForAccount_Negative(){
        List<Account> accounts = new List<Account>();

        delete [SELECT Id FROM Task];

        Test.startTest();
        AccountService.createTaskForAccount(accounts);
        Test.stopTest();

        List<Task> tasks = [SELECT Id FROM Task];
        System.assertEquals(0, tasks.size(), 'Must not create any task');
    }


}