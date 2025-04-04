public with sharing class SalesforcedataSend {

    private static String endPoint = 'callout:SalesforceNamedCred/services/apexrest/Account/';
    private static String externalIdField = 'External_Id__c';
    private static String clientNamec = 'Client_Namec__c';
    private static String id = 'Id';
    private static final Map<String, String> strHeader = new Map<String, String>{
        'content-type' => 'application/json; charset=UTF-8',
        'Accept' => 'application/json'
    };

    @future(callout=true)
    public static void createRecordTargetOrg(Set<Id> accountIds) {

        if (accountIds.isEmpty()){
            return;
        }

        List<String> fieldNames = MetadataControler.getSyncFields();

        List<Account> accList = Database.query(generateQuery(fieldNames));

        HttpRequest req = new HttpRequest();
        req.setEndpoint(endPoint);
        for (String key : strHeader.keySet()) {
            req.setHeader(key, strHeader.get(key));
        }
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
            accountMap.put(externalIdField, acc.Id);
            accountMap.put(clientNamec, acc.Custom_Namec__c);
            
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
            if (mapId.containsKey(externalIdField) && mapId.containsKey(id)) {
                Id externalId = (Id) mapId.get(externalIdField);
                if (accountMap.containsKey(externalId)) {
                    Account acc = accountMap.get(externalId);
                    acc.External_Id__c = (Id) mapId.get(id);
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

        String queryTemplate = 'SELECT {0} FROM Account WHERE Id IN :accountIds';
        String formattedQuery  = String.format(queryTemplate, new List<String>{String.join(fieldNames, ', ')});

        System.debug('MetadataControler.generateQuery:' + formattedQuery);

        return formattedQuery;
    }
}