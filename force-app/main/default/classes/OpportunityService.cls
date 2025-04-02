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

    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getStagesWithTotalAmount(Id accountId){
        Map<String, Object> stagesData = new Map<String, Object>();
    
        List<AggregateResult> results = [
            SELECT StageName, SUM(Amount) totalAmount 
            FROM Opportunity 
            WHERE AccountId = :accountId 
            GROUP BY StageName
        ];
        
        Map<String, Decimal> stagesWithTotalAmount = new Map<String, Decimal>();
        for(AggregateResult result : results){
            stagesWithTotalAmount.put((String) result.get('StageName'), (Decimal) result.get('totalAmount'));
        }
    
        Map<String, List<Opportunity>> stageOpportunities = new Map<String, List<Opportunity>>();
        List<Opportunity> opportunities = [
            SELECT Id, Name, StageName, Amount 
            FROM Opportunity 
            WHERE AccountId = :accountId
        ];
        
        for (Opportunity opp : opportunities) {
            if (!stageOpportunities.containsKey(opp.StageName)) {
                stageOpportunities.put(opp.StageName, new List<Opportunity>());
            }
            stageOpportunities.get(opp.StageName).add(opp);
        }
    
        stagesData.put('amounts', stagesWithTotalAmount);
        stagesData.put('opportunities', stageOpportunities);
        stagesData.put('listOpp', opportunities);
    
        return stagesData;
    }
}