public with sharing class SankeyChartController {
    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getOpportunityFlow() {
        List<Map<String, Object>> data = new List<Map<String, Object>>();

        AggregateResult[] results = [
            SELECT StageName, Owner.Name, IsClosed, IsWon, SUM(Amount) totalAmount
            FROM Opportunity
            WHERE Amount != NULL
            GROUP BY StageName, Owner.Name, IsClosed, IsWon
        ];

        for (AggregateResult result : results) {
            String closeStatus = (Boolean) result.get('IsWon') ? 'Won' : ((Boolean) result.get('IsClosed') ? 'Lost' : 'Open');

            data.add(new Map<String, Object>{
                'source' => result.get('StageName'),
                'target' => result.get('Owner.Name'),
                'value' => result.get('totalAmount')
            });

            data.add(new Map<String, Object>{
                'source' => result.get('Owner.Name'),
                'target' => closeStatus,
                'value' => result.get('totalAmount')
            });
        }
        return data;
    }
}
