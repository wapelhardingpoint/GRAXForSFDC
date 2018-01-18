public class HardingPointAPI {
    // -------------------------------------------------
    // https://www.hardingpoint.com/
    // Support Contact - Support At HardingPoint.com
    // -------------------------------------------------
    public static String jsonContent(List<Object> triggerNew, List<Object> triggerOld) {

        String newObjects = '[]';
        if (triggerNew != null) {
            newObjects = JSON.serialize(triggerNew);
        }
        String oldObjects = '[]';
        if (triggerOld != null) {
            oldObjects = JSON.serialize(triggerOld);
        }
        String userId = JSON.serialize(UserInfo.getUserId());
        HardingPoint__c hpd = HardingPoint__c.getOrgDefaults();

        // This is the URL for Neo4j
        // System.debug('graphdburl:' + hpd.graphdburl__c);
        String graphdburl = hpd.graphdburl__c;

        String content = '{"new": ' + newObjects + ', "old": ' + oldObjects + ', "orgId": "'+ UserInfo.getOrganizationId() +  '", "userId": ' + userId + ', "graphdburl": "' + graphdburl + '"}';
        // String content = '{"new": ' + newObjects + ', "orgId": "'+ UserInfo.getOrganizationId() +  '", "userId": ' + userId + ', "graphdburl": "' + graphdburl + '"}';

        return content;
    }

    public static void calloutnow(String url, String content) {
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        HardingPoint__c hpd = HardingPoint__c.getOrgDefaults();
        // ------------------------------
        //  Use for Org Wide Override
        // ------------------------------
        //if (hpd.APIURL__c!=''){
        //    req.setEndpoint(hpd.APIURL__c);
        //}else{
            req.setEndpoint(url);
        //}
        // ------------------------------
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        // Does not work!
        if ( hpd.LicenseToken__c != null ){
            req.setHeader('licensetoken',hpd.LicenseToken__c);
        }
        if ( hpd.ApiToken__c != null ){
            req.setHeader('authorizationToken', hpd.ApiToken__c);
        }
        if ( hpd.GatewayToken__c != null){
            req.setHeader('x-api-key', hpd.GatewayToken__c);
        }
        req.setHeader('sfdcorgid', UserInfo.getOrganizationId() );
        req.setBody(content);
        h.send(req);
    }

    @future(callout=true)
    public static void callout(String url, String content) {
        HardingPointAPI.calloutnow(url,content);
    }

    public static SObject mock(String sobjectName) {
        SObjectType t = Schema.getGlobalDescribe().get(sobjectName);

        SObject o = t.newSobject();

        Map<String, Schema.SObjectField> m = t.getDescribe().fields.getMap();

        for (String fieldName : m.keySet()) {
        DescribeFieldResult f = m.get(fieldName).getDescribe();
        if (!f.isNillable() && f.isCreateable() && !f.isDefaultedOnCreate()) {
        if (f.getType() == DisplayType.Boolean) {
            o.put(f.getName(), false);
            }
            else if (f.getType() == DisplayType.Currency) {
                o.put(f.getName(), 0);
            }
            else if (f.getType() == DisplayType.Date) {
                o.put(f.getName(), Date.today());
            }
            else if (f.getType() == DisplayType.DateTime) {
                o.put(f.getName(), System.now());
            }
            else if (f.getType() == DisplayType.Double) {
                o.put(f.getName(), 0.0);
            }
            else if (f.getType() == DisplayType.Email) {
                o.put(f.getName(), 'foo@foo.com');
            }
            else if (f.getType() == DisplayType.Integer) {
                o.put(f.getName(), 0);
            }
            else if (f.getType() == DisplayType.Percent) {
                o.put(f.getName(), 0);
            }
            else if (f.getType() == DisplayType.Phone) {
                o.put(f.getName(), '555-555-1212');
            }
            else if (f.getType() == DisplayType.String) {
                o.put(f.getName(), 'TEST');
            }
            else if (f.getType() == DisplayType.TextArea) {
                o.put(f.getName(), 'TEST');
            }
            else if (f.getType() == DisplayType.Time) {
                o.put(f.getName(), System.now().time());
            }
            else if (f.getType() == DisplayType.URL) {
                o.put(f.getName(), 'http://foo.com');
            }
            else if (f.getType() == DisplayType.PickList) {
                o.put(f.getName(), f.getPicklistValues()[0].getValue());
            }
        }
    }
    return o;
    }
}