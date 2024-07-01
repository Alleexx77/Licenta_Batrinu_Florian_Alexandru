public with sharing class RequestQualificationController {
    @AuraEnabled
    public static List<String> getQualifications() {
        return new List<String>{'Building, civil and environmental', 'Electric, automation and networks', 'Facility management and services', 'Industrial plant engineering', 'Market, Home and communication', 'Design and technical Services', 'HR services and consultancy', 'GM out of Procurement', 'IT and Telecommunications'};
    }

    @AuraEnabled
    public static Map<String, String> getAccountAndContact() {
        Map<String, String> result = new Map<String, String>();
        String userId = UserInfo.getUserId();
        Contact contact = [SELECT Id, AccountId FROM Contact WHERE Id = :userId LIMIT 1];
        result.put('accountId', contact.AccountId);
        result.put('contactId', contact.Id);
        return result;
    }

    @AuraEnabled
    public static Qualification__c createQualification(String qualification, String accountId, String contactId) {
        Qualification__c newQualification = new Qualification__c();
        newQualification.Account__c = accountId;
        newQualification.Contact__c = contactId;
        newQualification.Merchandise_Group__c = qualification;
        newQualification.Status__c = 'Pending';
        insert newQualification;
        return newQualification;
    }
}
