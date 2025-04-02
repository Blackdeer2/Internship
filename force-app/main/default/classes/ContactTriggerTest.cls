@isTest
private with sharing class ContactTriggerTest {


    @TestSetup
    static void setupTestData() {
        
        Account acc1 = new Account(Name = 'Test Account 1');
        insert acc1;

        Account acc2 = new Account(Name = 'Test Account 2');
        insert acc2;
    }

    @isTest
    static void testConectLastContactToAccount_Positive() {
        List<Account> accounts = [SELECT Id FROM Account];
        Account acc1 = accounts[0];
        Account acc2 = accounts[1];

        Contact con1 = new Contact(LastName = 'Contact 1', AccountId = acc1.Id);
        Contact con2 = new Contact(LastName = 'Contact 2', AccountId = acc2.Id);
        insert new List<Contact>{ con1, con2 };

        Test.startTest();
        ContactService.conectlastContactToAccount(new List<Contact>{ con1, con2 });
        Test.stopTest();

        Account updatedAcc1 = [SELECT Last_Contact__c FROM Account WHERE Id = :acc1.Id];
        Account updatedAcc2 = [SELECT Last_Contact__c FROM Account WHERE Id = :acc2.Id];

        System.assertEquals(con1.Id, updatedAcc1.Last_Contact__c, 'Last_Contact__c must contain ID of the last contact');
        System.assertEquals(con2.Id, updatedAcc2.Last_Contact__c, 'Last_Contact__c must contain ID of the last contact');
    }

    @isTest
    static void testConectLastContactToAccount_Negative() {

        List<Account> accounts = [SELECT Id, Last_Contact__c FROM Account];

        Test.startTest();
        ContactService.conectlastContactToAccount(new List<Contact>()); 
        Test.stopTest();

  
        for (Account acc : accounts) {
            Account updatedAcc = [SELECT Last_Contact__c FROM Account WHERE Id = :acc.Id];
            System.assertEquals(null, updatedAcc.Last_Contact__c, 'Last_Contact__c must stay NULL');
        }
    }

}