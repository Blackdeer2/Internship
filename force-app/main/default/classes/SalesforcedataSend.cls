public with sharing class SalesforcedataSend {

    @future(callout=true)
    public static void createRecordTargetOrg(Set<Id> accountIds) {

        if (accountIds.isEmpty()){
            return;
        }

        List<String> fieldNames = MetadataControler.getSyncFields();
        if(fieldNames == null){
            System.debug('SalesforcedataSend.createRecordTargetOrg fieldNames == null');
            return;
        }

        List<Account> accList = Database.query(generateQuery(fieldNames) + ' WHERE Id IN :accountIds');

        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:SalesforceNamedCred/services/apexrest/Account/');
        req.setHeader('content-type','application/json; charset=UTF-8');
        req.setHeader('Accept', 'application/json');
        req.setBody(setRequestBody(accList, fieldNames));
        req.setMethod('POST');

        Http http = new Http();
        HttpResponse response = http.send(req);
        System.debug('response code: ' + response.getStatusCode());
        System.debug('response body : ' + response.getBody());

        if(response.getStatusCode() == 200){

        List<Map<String, Object>> accountMapsID = parseResponseBody(response);

        updateAccounts(accList, accountMapsID);
        }
    }

    public static String setRequestBody(List<Account> accList, List<String> fieldNames){
        System.debug('start setRequestBody');
        List<Map<String, Object>> accountMaps= new List<Map<String, Object>>();

        for (Account acc : accList) {
            Map<String, Object> accountMap = new Map<String, Object>();
            //accountMap.put('Id', acc.Id);
            accountMap.put('External_Id__c', acc.Id);
            accountMap.put('Created_by_Another_Org__c', true);
            for(String field : fieldNames){
                accountMap.put(field, acc.get(field));
            }
            accountMaps.add(accountMap);
        }

        String jsonBody = JSON.serialize(accountMaps);
        System.debug('jsonBody: ' + jsonBody);
        System.debug('finish setRequestBody');

        return jsonBody;
    }

    public static  List<Map<String, Object>> parseResponseBody( HttpResponse response){

        String responseBody = response.getBody().toString(); 
            
        List<Map<String, Object>> accountMapsID = new List<Map<String, Object>>();

        List<Map<String, String>> items = (List<Map<String, String>>) JSON.deserialize(responseBody, List<Map<String, String>>.class);

        for(Object obj: items){
            Map<String, Object> itemMap = (Map<String, Object>) obj;
            accountMapsID.add(itemMap);
        }
        System.debug('Deserialized JSON: ' + accountMapsID);

        return accountMapsID;
    }

    public static void updateAccounts(List<Account> accList, List<Map<String, Object>> accountMapsID){

        List<Account> accountsToUpdate = new List<Account>();
        Map<Id, Account> accountMap = new Map<Id, Account>(accList);


        for (Map<String, Object> mapId : accountMapsID) {
            if (mapId.containsKey('External_Id__c') && mapId.containsKey('Id')) {
                Id externalId = (Id) mapId.get('External_Id__c');
                if (accountMap.containsKey(externalId)) {
                    Account acc = accountMap.get(externalId);
                    acc.External_Id__c = (Id) mapId.get('Id');
                    accountsToUpdate.add(acc);
                }
            }
        }
    
        
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
            System.debug('Updated accounts: ' + accountsToUpdate);
        }
    }

    public static String generateQuery(List<String> fieldNames){

        String query = 'SELECT ' + String.join(fieldNames, ', ') + ' FROM Account';
        System.debug('MetadataControler.generateQuery:' + query);

        return query;
    }
}