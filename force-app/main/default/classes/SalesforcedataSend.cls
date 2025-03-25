public with sharing class SalesforcedataSend {

    @future(callout=true)
    public static void createRecordTargetOrg(){

        List<Account> accounts  = [SELECT Id, Name FROM Account];

        if (accounts.isEmpty()) {
            System.debug('No records found');
            return;
        }

        String jsonBody = JSON.serialize(accounts);

        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:SalesforceNamedCred/services/apexrest/Account/');
        req.setHeader('content-type','application/json; charset=UTF-8');
        req.setHeader('Accept', 'application/json');
        req.setBody(jsonBody);
        req.setMethod('POST');
        Http http = new Http();
        HttpResponse response = http.send(req);
        System.debug('response code:'+response.getStatusCode());
        System.debug('response body : '+response.getBody());

        if (response.getStatusCode() != 200) {
            System.debug('Error syncing accounts: ' + response.getBody());
        } else {
            System.debug('Accounts synced successfully!');
        }
    }

}