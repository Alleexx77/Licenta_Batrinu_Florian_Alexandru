@RestResource(urlMapping='/suppliers/*')
global with sharing class SupplierRESTController {

    @HttpGet
    global static Supplier__c getSupplier() {
        RestRequest req = RestContext.request;
        String supplierId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        return [SELECT Id, Name, Street__c, City__c, State_Province__c, Country__c, Zip_Postal_Code__c, VAT_Reg_No__c, Office_Email__c, Org_Phone__c, First_Name__c, Last_Name__c, User_Email__c, User_Phone__c FROM Supplier__c WHERE Id = :supplierId LIMIT 1];
    }

    @HttpPost
    global static String createSupplier(String organizationName, String street, String city, String stateProvince, String country, String zipCode, String vatRegNo, String officeEmail, String orgPhone, String firstName, String lastName, String userEmail, String userPhone) {
        Supplier__c newSupplier = new Supplier__c();
        newSupplier.Name = organizationName;
        newSupplier.Street__c = street;
        newSupplier.City__c = city;
        newSupplier.State_Province__c = stateProvince;
        newSupplier.Country__c = country;
        newSupplier.Zip_Postal_Code__c = zipCode;
        newSupplier.VAT_Reg_No__c = vatRegNo;
        newSupplier.Office_Email__c = officeEmail;
        newSupplier.Org_Phone__c = orgPhone;
        newSupplier.First_Name__c = firstName;
        newSupplier.Last_Name__c = lastName;
        newSupplier.User_Email__c = userEmail;
        newSupplier.User_Phone__c = userPhone;

        insert newSupplier;
        return newSupplier.Id;
    }
}
