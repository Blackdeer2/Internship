public with sharing class SalesforcedataSend {

    @future(callout=true)
public static void createRecordTargetOrg() {

    Account acc = [SELECT Id, Name, External_Id__c FROM Account LIMIT 1];

    // Створення Map з потрібними полями
    Map<String, Object> accountMap = new Map<String, Object>();
    //accountMap.put('Id', acc.Id);
    accountMap.put('Name', acc.Name);
    accountMap.put('External_Id__c', acc.Id);

    // Серіалізація Map без атрибутів
    String jsonBody = JSON.serialize(accountMap);

    // Створення HTTP запиту
    HttpRequest req = new HttpRequest();
    req.setEndpoint('callout:SalesforceNamedCred/services/apexrest/Account/');
    req.setHeader('content-type','application/json; charset=UTF-8');
    req.setHeader('Accept', 'application/json');
    req.setBody(jsonBody);
    req.setMethod('POST');

    // Логування
    System.debug('jsonBody: ' + jsonBody);

    Http http = new Http();
    HttpResponse response = http.send(req);

    // Логування відповіді
    System.debug('response code: ' + response.getStatusCode());
    System.debug('response body : ' + response.getBody());
}

}

