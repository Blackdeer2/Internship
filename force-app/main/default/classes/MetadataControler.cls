public with sharing class MetadataControler {

    private static List<String> syncFields;

    public static List<String> getSyncFields(){

        System.debug('Start of getSyncFields: ' + syncFields);

        if (syncFields == null) {

            syncFields = new List<String>();
            List<Field_Sync_Setting__mdt> syncSettings = [
                SELECT Field_API_Name__c FROM Field_Sync_Setting__mdt WHERE Is_Active__c = TRUE];
            
            for(Field_Sync_Setting__mdt setting : syncSettings){
                syncFields.add(setting.Field_API_Name__c);
            }
            System.debug('Metadate downloadet from SOQL: ' + syncFields);

        } else {
            System.debug('Metadate downloadet from kesh: ' + syncFields);
        }

        return syncFields;
    }
}