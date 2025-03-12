public with sharing class ContactService {


    public static void conectlastContactToAccount(List<Contact> newContacts){
        if(newContacts == null || newContacts.isEmpty()){
            return;
        }
        Map<Id, Contact> latestContact = new Map<Id, Contact>();

        for(Contact c : newContacts){
            if(c.AccountId != null){
                latestContact.put(c.AccountId, c);
            }
        }

        List<Account> accountsToUpdate = new List<Account>();
        for(Id accId: latestContact.keySet()){
            Account acc = new Account(Id = accId, Last_Contact__c = latestContact.get(accId).Id);
            accountsToUpdate.add(acc);
        }

        if(!accountsToUpdate.isEmpty()){
            update accountsToUpdate;
        }
    }
}