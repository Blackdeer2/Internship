public with sharing class OpportunityService {
        public static void countOpportunityAmountForAccount(List<Opportunity> opportunities) {
            if (opportunities == null || opportunities.isEmpty()) {
                return;
            }

            Set<Id> accountIds = new Set<Id>();
            for (Opportunity opp : opportunities) {
                if (opp.AccountId != null) {
                    accountIds.add(opp.AccountId);
                }
            }

            if (accountIds.isEmpty()) {
                return;
            }

            Map<Id, Decimal> accountAmountMap = new Map<Id, Decimal>();

            List<AggregateResult> results = [SELECT AccountId, SUM(Amount) sumAmount 
                                    FROM Opportunity 
                                    GROUP BY AccountId];

            for (AggregateResult ar : results) {
                accountAmountMap.put((Id)ar.get('AccountId'), (Decimal)ar.get('sumAmount'));
            }                  
            List<Account> accountsToUpdate = [SELECT Id, Total_Opportunities_Amount__c FROM Account WHERE Id IN :accountAmountMap.keySet()]; //повертає id and total amount
                                                            // проходимося по списку і призначаємо значення
                                                            //і вже тоді update

            for(Account acc : accountsToUpdate ){
                if(accountAmountMap.containsKey(acc.Id)){
                    acc.Total_Opportunities_Amount__c = accountAmountMap.get(acc.Id);
            }

            if (!accountsToUpdate.isEmpty()) {
                update accountsToUpdate;
            }
        }
    }
}
