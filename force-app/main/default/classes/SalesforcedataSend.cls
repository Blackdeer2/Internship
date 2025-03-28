public with sharing class SalesforcedataSend {

    @future(callout=true)
    public static void createRecordTargetOrg() {

        List<String> fieldNames = MetadataControler.getSyncFields();

        List<Account> accList = Database.query(MetadataControler.generateQuery(fieldNames));

        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:SalesforceNamedCred/services/apexrest/Account/');
        req.setHeader('content-type','application/json; charset=UTF-8');
        req.setHeader('Accept', 'application/json');
        req.setBody(setRequestBody(accList, fieldNames));
        req.setMethod('POST');

        Http http = new Http();
        HttpResponse response = http.send(req);
        boolean isSuccess = response.getStatusCode() == 200;
        System.debug('response code: ' + response.getStatusCode());
        System.debug('response body : ' + response.getBody());

        List<Map<String, Object>> accountMapsID = parseResponseBody(response);

        updateAccounts(accList, accountMapsID);

    }

    public static String setRequestBody(List<Account> accList, List<String> fieldNames){
        System.debug('start setRequestBody');
        List<Map<String, Object>> accountMaps= new List<Map<String, Object>>();

        for (Account acc : accList) {
            Map<String, Object> accountMap = new Map<String, Object>();
            //accountMap.put('Id', acc.Id);
            accountMap.put('External_Id__c', acc.Id);
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

        System.debug('start parseResponseBody()');

        String responseBody = response.getBody().toString(); 
            
        List<Map<String, Object>> accountMapsID = new List<Map<String, Object>>();

        List<Map<String, String>> items = (List<Map<String, String>>) JSON.deserialize(responseBody, List<Map<String, String>>.class);

        for(Object obj: items){
            Map<String, Object> itemMap = (Map<String, Object>) obj;
            accountMapsID.add(itemMap);
        }
        System.debug('Deserialized JSON: ' + accountMapsID);
        System.debug('finish parseResponseBody()');

        return accountMapsID;
    }

    public static void updateAccounts(List<Account> accList, List<Map<String, Object>> accountMapsID){

        List<Account> accountsToUpdate = new List<Account>();
        Map<Id, Account> accountMap = new Map<Id, Account>();

    
        for (Account acc : accList) {
            accountMap.put(acc.Id, acc);
        }


        for (Map<String, Object> mapId : accountMapsID) {
            if (mapId.containsKey('External_Id__c')) {
                String externalId = (String) mapId.get('External_Id__c');  
                Id jsonAccountId = (Id) mapId.get('Id');  

                for(Account acc: accList){
                    if (acc.Id == externalId) {
                        
                        acc.External_Id__c = jsonAccountId; 
                        accountsToUpdate.add(acc);  
                    }
                }
            }
        }
        
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
            System.debug('Updated accounts: ' + accountsToUpdate);
        }
    }


    @future(callout=true)
    public static void syncUpdatedAccounts(Set<Id> accountIds) {

        List<String> fieldNames = MetadataControler.getSyncFields();

        List<Account> accounts = Database.query(MetadataControler.generateQuery(fieldNames));

        System.debug('Accounts to send: ' + accounts);

        List<Map<String, Object>> accountData = new List<Map<String, Object>>();

        for (Account acc : accounts) {
            Map<String, Object> accMap = new Map<String, Object>();
            
            for (String field : fieldNames) {
                accMap.put(field, acc.get(field));
            }
            accMap.put('External_Id__c', acc.Id);
        
            accountData.add(accMap);
        }
        
        String jsonBody = JSON.serialize(accountData);
        System.debug('JSON Body: ' + jsonBody);

        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:SalesforceNamedCred/services/apexrest/Account/');
        req.setHeader('content-type','application/json; charset=UTF-8');
        req.setHeader('Accept', 'application/json');
        req.setBody(jsonBody);
        req.setMethod('PUT');

        System.debug('jsonBody: ' + jsonBody);

        Http http = new Http();
        HttpResponse response = http.send(req);
        boolean isSuccess = response.getStatusCode() == 200;
        System.debug('response code: ' + response.getStatusCode());
        System.debug('response body : ' + response.getBody());
    }
}