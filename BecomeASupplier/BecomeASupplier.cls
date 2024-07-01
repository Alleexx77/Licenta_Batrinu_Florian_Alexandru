public with sharing class CreateSupplierCalloutService implements Queueable {
    private static final String SALESFORCE_ENDPOINT = 'https://salesforce/services/apexrest/createLead';
    
    @future(callout=true)
    public static void createLead(String companyName, String street, String city, String state, String postalCode, String country, String phoneNumber) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        // Set endpoint and method
        request.setEndpoint(SALESFORCE_ENDPOINT);
        request.setMethod('POST');
        
        // Create JSON request body
        String jsonBody = '{' +
            '"Company": "' + companyName + '",' +
            '"Street": "' + street + '",' +
            '"City": "' + city + '",' +
            '"State": "' + state + '",' +
            '"PostalCode": "' + postalCode + '",' +
            '"Country": "' + country + '",' +
            '"Phone": "' + formatPhoneNumber(phoneNumber) + '"' +
        '}';
        
        request.setBody(jsonBody);
        
        // Set headers
        request.setHeader('Content-Type', 'application/json');
        
        try {
            HttpResponse response = http.send(request);
            
            if (response.getStatusCode() == 201) {
                System.debug('Lead creation successful: ' + response.getBody());
            } else {
                System.debug('Failed to create lead. Status code: ' + response.getStatusCode());
            }
        } catch (Exception e) {
            System.debug('Exception occurred while creating lead: ' + e.getMessage());
        }
    }
    
    // Validation phone number
    private static String formatPhoneNumber(String phoneNumber) {
        if (!phoneNumber.startsWith('+') || phoneNumber.length() < 5) {
            throw new IllegalArgumentException('Flow error');
        }
        return phoneNumber;
    }
}
