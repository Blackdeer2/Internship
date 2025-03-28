public with sharing class MetadataControler {
    private static List<String> syncFields = new List<String>();

    public static List<String> getSyncFields(){
        List<Field_Sync_Setting__mdt> syncSettings = [
            SELECT Field_API_Name__c FROM Field_Sync_Setting__mdt WHERE Is_Active__c = TRUE];
        
        for(Field_Sync_Setting__mdt setting : syncSettings){
            syncFields.add(setting.Field_API_Name__c);
        }
        System.debug('syncFields:' + syncFields);

        return syncFields;
    }
}