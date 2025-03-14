@isTest
public with sharing class OpportunityTriggerTest {

    @TestSetup
    static void setupTestData() {
        
        Account acc1 = new Account(Name = 'Test Account 1');
        insert acc1;

        Opportunity opp1 = new Opportunity(Name = 'Opportunity 1', AccountId = acc1.Id, Amount = 1000, CloseDate = Date.today(), StageName = 'Prospecting');
        Opportunity opp2 = new Opportunity(Name = 'Opportunity 2', AccountId = acc1.Id, Amount = 2000, CloseDate = Date.today(), StageName = 'Prospecting');
        
        insert new List<Opportunity>{ opp1, opp2 };
    }

    @isTest
    static void testCountOpportunityAmountForAccount_AfterInsert() {

        Account acc = [SELECT Id, Total_Opportunities_Amount__c FROM Account LIMIT 1];

        
        Opportunity opp = new Opportunity(Name = 'Opportunity 3', AccountId = acc.Id, Amount = 3000, CloseDate = Date.today(), StageName = 'Prospecting');
        

        Test.startTest();
        insert opp;
        Test.stopTest();


        acc = [SELECT Total_Opportunities_Amount__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(6000, acc.Total_Opportunities_Amount__c, 'The sum of the possibilities after the update should be 6000');
    }

    @isTest
    static void testCountOpportunityAmountForAccount_AfterUpdate() {
        Account acc = [SELECT Id, Total_Opportunities_Amount__c FROM Account LIMIT 1];
        Opportunity opp = [SELECT Id, Amount FROM Opportunity WHERE AccountId = :acc.Id LIMIT 1];

        Test.startTest();
        opp.Amount = 5000;
        update opp;
        Test.stopTest();

        acc = [SELECT Total_Opportunities_Amount__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(7000, acc.Total_Opportunities_Amount__c, 'The sum of the possibilities after the update should be 7000');
    }

    @isTest
    static void testCountOpportunityAmountForAccount_AfterDelete() {
        Account acc = [SELECT Id, Total_Opportunities_Amount__c FROM Account LIMIT 1];
        List<Opportunity> opps = [SELECT Id FROM Opportunity WHERE AccountId = :acc.Id];

        Test.startTest();
        delete opps[0]; 
        Test.stopTest();

        acc = [SELECT Total_Opportunities_Amount__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(2000, acc.Total_Opportunities_Amount__c, 'The sum of the possibilities after the update should be 2000');
    }

    @isTest
    static void testCountOpportunityAmountForAccount_AfterUndelete() {
        Account acc = [SELECT Id, Total_Opportunities_Amount__c FROM Account LIMIT 1];
        List<Opportunity> opps = [SELECT Id FROM Opportunity WHERE AccountId = :acc.Id ALL ROWS];

        Test.startTest();
        delete opps[0];
        undelete opps[0];
        Test.stopTest();

        acc = [SELECT Total_Opportunities_Amount__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(3000, acc.Total_Opportunities_Amount__c, 'The sum of the possibilities after the update should be 3000');
    }
}
