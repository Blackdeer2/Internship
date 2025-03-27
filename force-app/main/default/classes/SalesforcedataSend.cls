public with sharing class SalesforcedataSend {

    @future(callout=true)
public static void createRecordTargetOrg() {

    List<Account> accList = [SELECT Id, Name, External_Id__c FROM Account];

    List<Map<String, Object>> accountMaps= new List<Map<String, Object>>();

    for (Account acc : accList) {
        Map<String, Object> accountMap = new Map<String, Object>();
        //accountMap.put('Id', acc.Id);
        accountMap.put('Name', acc.Name);
        accountMap.put('External_Id__c', acc.Id);
        accountMaps.add(accountMap);
    }

    String jsonBody = JSON.serialize(accountMaps);

    HttpRequest req = new HttpRequest();
    req.setEndpoint('callout:SalesforceNamedCred/services/apexrest/Account/');
    req.setHeader('content-type','application/json; charset=UTF-8');
    req.setHeader('Accept', 'application/json');
    req.setBody(jsonBody);
    req.setMethod('POST');

    System.debug('jsonBody: ' + jsonBody);

    Http http = new Http();
    HttpResponse response = http.send(req);
    boolean isSuccess = response.getStatusCode() == 200;
    System.debug('response code: ' + response.getStatusCode());
    System.debug('response body : ' + response.getBody());

    if (response.getStatusCode() == 200) {

        String responseBody = response.getBody().toString(); 

        if (responseBody.startsWith('"') && responseBody.endsWith('"')) {
            responseBody = responseBody.substring(1, responseBody.length() - 1);
        }

        responseBody = responseBody.replace('\\', '');

        System.debug('Cleaned response body: ' + responseBody);
        
        List<Object> items = (List<Object>) JSON.deserializeUntyped(responseBody);
        
        List<Map<String, Object>> accountMapsID = new List<Map<String, Object>>();

        for(Object obj: items){
            Map<String, Object> itemMap = (Map<String, Object>) obj;
            accountMapsID.add(itemMap);
        }
        System.debug('Deserialized JSON: ' + accountMapsID);

        //до цього рядочка все працює чотко

        List<Account> accountsToUpdate = new List<Account>();
        Map<Id, Account> accountMap = new Map<Id, Account>();

       
        for (Account acc : accList) {
            accountMap.put(acc.Id, acc);
        }
        System.debug(accountMap);


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


}
}


//------------------Код з іншої організації------------------

// @RestResource(urlMapping='/Account/*')
// global class RestApiUsingConnectClass {
    
//  @HttpPost
//     global static String receiveAccount() {
//         try {
//              String body = RestContext.request.requestBody.toString();
            
//              List<Account> accList = (List<Account>) JSON.deserialize(body, List<Account>.class);
            
//             upsert accList External_Id__c;
//             System.debug('Upsert successful');
//             System.debug('before convert json');
//             List<Map<String, Id>> accountMapsID= new List<Map<String, Id>>();
        
//             for (Account acc : accList) {
//                 Map<String, Id> accountMap = new Map<String, Id>();
//                 accountMap.put('Id', acc.Id);
//                 accountMap.put('External_Id__c', acc.External_Id__c);

//                 accountMapsID.add(accountMap);
//             }
           
//             String IdWithExternal = JSON.serialize(accountMapsID);
//             System.debug('JSON Id and External Id: ' + IdWithExternal);

//             return IdWithExternal;

            
//         } catch (Exception e) {
//             return 'Error: ' + e.getMessage();
//         }
//     }
// }