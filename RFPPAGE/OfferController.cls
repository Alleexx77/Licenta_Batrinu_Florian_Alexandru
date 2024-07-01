public with sharing class OfferController {
    @AuraEnabled(cacheable=true)
    public static List<Offer__c> getOffers(Set<String> merchandiseGroups) {
        if (merchandiseGroups == null || merchandiseGroups.isEmpty()) {
            return new List<Offer__c>();
        }
        return [
            SELECT Id, Name, Type__c, MerchandiseGroup__c, Status__c
            FROM Offer__c
            WHERE MerchandiseGroup__c IN :merchandiseGroups
        ];
    }
}
