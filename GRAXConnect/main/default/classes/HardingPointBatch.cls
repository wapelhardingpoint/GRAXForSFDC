global class HardingPointBatch implements
    Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {
    // instance member to retain state across transactions
    global Integer recordsProcessed = 0;
    global Integer recordLimit = 200;
    global String Query = '';
    global String CurrentObjectName = '';

    string BuildQuery(string ObjectName){
        SObjectType t = Schema.getGlobalDescribe().get(ObjectName);
        SObject o = t.newSobject();
        string BuildQuery = '';
        Map<String, Schema.SObjectField> m = t.getDescribe().fields.getMap();
        for (String fieldName : m.keySet()) {
            if (BuildQuery!=''){
                BuildQuery+=',';
            }
          BuildQuery += fieldName;
        }
        if (BuildQuery!=''){
            // Query = 'Select ' + BuildQuery + ' From ' + ObjectName + ' LIMIT ' + recordLimit;
            Query = 'Select ' + BuildQuery + ' From ' + ObjectName;
        }
        return Query;
   }

    global HardingPointBatch(String ObjectName){
        if (ObjectName!=''){
            Query = BuildQuery(ObjectName);
        }
        CurrentObjectName = ObjectName;
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug('Starting Batch Query: ' + Query);
        return Database.getQueryLocator(Query);
    }

    global void execute(Database.BatchableContext bc, List<SObject> scope){
        List<Object> triggerNew = new List<Object>();
        List<Object> triggerOld = new List<Object>();

        String url = 'https://prod.hardingpoint.com/v9.3/api';

        for (SObject currentObject : scope) {
            System.debug('Processing: ' + currentObject.Id);
            triggerNew.add(currentObject);
            recordsProcessed++;
        }
        HardingPointAPI.calloutnow(url,HardingPointAPI.jsonContent(triggerNew,triggerOld));
    }

    global void finish(Database.BatchableContext bc){
        System.debug(recordsProcessed + ' Records Synchronized. Harding Point Graph Synchronized for ' + CurrentObjectName);
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors,
            JobItemsProcessed,
            TotalJobItems
            FROM AsyncApexJob
            WHERE Id = :bc.getJobId()];

        // CreatedBy.Email
        // call some utility to send email
        // EmailUtils.sendMessage(a, recordsProcessed);
    }

    public static void ProcessHistory(String ObjectName){
        HardingPointBatch newbatch = new HardingPointBatch(ObjectName);
        Database.executeBatch(newbatch, 10);
    }
}