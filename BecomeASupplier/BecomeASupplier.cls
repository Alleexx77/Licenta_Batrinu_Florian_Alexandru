public with sharing class SupplierController {
    @AuraEnabled
    public static void createSupplier(Map<String, String> supplierData) {
        Supplier__c newSupplier = new Supplier__c();
        newSupplier.Name = supplierData.get('organizationName');
        newSupplier.Street__c = supplierData.get('street');
        newSupplier.City__c = supplierData.get('city');
        newSupplier.State_Province__c = supplierData.get('stateProvince');
        newSupplier.Country__c = supplierData.get('country');
        newSupplier.Zip_Postal_Code__c = supplierData.get('zipCode');
        newSupplier.VAT_Reg_No__c = supplierData.get('vatRegNo');
        newSupplier.Office_Email__c = supplierData.get('officeEmail');
        newSupplier.Org_Phone__c = supplierData.get('orgPhone');
        newSupplier.First_Name__c = supplierData.get('firstName');
        newSupplier.Last_Name__c = supplierData.get('lastName');
        newSupplier.User_Email__c = supplierData.get('userEmail');
        newSupplier.User_Phone__c = supplierData.get('userPhone');

        insert newSupplier;
    }
}
