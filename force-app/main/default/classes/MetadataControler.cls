public with sharing class MetadataControler {

    public static List<String> getSyncFields(){

        List<String> syncFields = new List<String>();
        List<Field_Sync_Setting__mdt> syncSettings = [
            SELECT Field_API_Name__c FROM Field_Sync_Setting__mdt WHERE Is_Active__c = TRUE];
        
        for(Field_Sync_Setting__mdt setting : syncSettings){
            syncFields.add(setting.Field_API_Name__c);
        }
        System.debug('getSyncFields.syncFields():' + syncFields);

        return syncFields;
    }

    public static String generateQuery(List<String> fieldNames){

        String query = 'SELECT ' + String.join(fieldNames, ', ') + ' FROM Account';
        System.debug('MetadataControler.generateQuery:' + query);

        return query;
    }
}