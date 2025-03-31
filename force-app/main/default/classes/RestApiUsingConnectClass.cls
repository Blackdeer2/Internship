@RestResource(urlMapping='/Account/*')
global class RestApiUsingConnectClass {
    
 	@HttpPost
    global static List<Map<String, String>> receiveAccount() {
        try {
             String body = RestContext.request.requestBody.toString();
            
             List<Account> accList = (List<Account>) JSON.deserialize(body, List<Account>.class);
            
            upsert accList External_Id__c;
            System.debug('Upsert successful');
            System.debug('before convert json');
            List<Map<String, String>> accountMapsID= new List<Map<String, Id>>();
        
            for (Account acc : accList) {
                Map<String, Id> accountMap = new Map<String, Id>();
                accountMap.put('Id', acc.Id);
                accountMap.put('External_Id__c', acc.External_Id__c);

                accountMapsID.add(accountMap);
            }

            return accountMapsID;

            
        } catch (Exception e) {
            return null;
        }
    }   
}