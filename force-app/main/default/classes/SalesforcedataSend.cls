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

    System.debug('response code: ' + response.getStatusCode());
    System.debug('response body : ' + response.getBody());
}

}

//-------------Код на іншій організації-------------

// @RestResource(urlMapping='/Account/*')
// global class RestApiUsingConnectClass {
    
//  @HttpPost
//     global static String receiveAccount() {
//         try {
//              String body = RestContext.request.requestBody.toString();
            
            
//             //Account acc = (Account) JSON.deserialize(body, Account.class);
            
//              List<Account> accList = (List<Account>) JSON.deserialize(body, List<Account>.class);
            
//             upsert accList External_Id__c;
            
//               return 'Success: Account created or updated with External_Id__c = ';

            
//         } catch (Exception e) {
//             return 'Error: ' + e.getMessage();
//         }
//     }
// }