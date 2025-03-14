@isTest
private with sharing class ContactValidationTest {

    @TestSetup
    static void setupTestData(){

        Account acc1 = new Account(Name = 'Test Account 1');
        insert acc1;
    }

    @isTest
    static void testValidationOfPhoneInContact_Insert(){


        Account acc1 = [SELECT Id FROM Account LIMIT 1];
        Contact con1 = new Contact(LastName = 'Contact 1', AccountId = acc1.Id, Phone = '0123456789');

        Test.startTest();
        insert con1;
        Test.stopTest();

        Contact insertedContact = [SELECT Phone FROM Contact WHERE Id = :con1.Id];
        System.assertEquals('0123456789', insertedContact.Phone);
    }

    @isTest
    static void testValidationOfPhoneInContact_Update_ValidPhone(){

        Account acc1 = [SELECT Id FROM Account LIMIT 1];

        Contact con3 = new Contact(LastName = 'Contact 2', AccountId = acc1.Id, Phone = '01234567890');
        insert con3;
        con3.Phone = '012345678123';
        
        Test.startTest();
        update con3;
        Test.stopTest();

   
        Contact updatedContact = [SELECT Phone FROM Contact WHERE Id = :con3.Id];
        System.assertEquals('012345678123', updatedContact.Phone);
    }

}