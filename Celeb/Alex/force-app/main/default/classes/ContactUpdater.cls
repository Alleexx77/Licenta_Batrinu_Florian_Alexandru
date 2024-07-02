/*************************************************************************************************************
Name:  ContactUpdater
==============================================================================================================
Purpose: Apex class to integrate with the Cellebrite API.
==============================================================================================================
History                                                            
-------                                                            
VERSION  AUTHOR                                             DATE           DETAIL          Description
1.0      Scutariu Lucian                                  15/01/2024      Created         Initial version
**************************************************************************************************************/
public with sharing class ContactUpdater implements Queueable {
    private List<Contact> contacts;

    public ContactUpdater(List<Contact> contacts) {
        this.contacts = contacts;
    }

    public void execute(QueueableContext context) {
        for (Contact contact : contacts) {
            makeCellebriteApiRequest(contact);
        }
    }

    private static void makeCellebriteApiRequest(Contact contact) {
        // Your logic to make API request for a single contact goes here
        String firstName = contact.FirstName;
        String lastName = contact.LastName;

        // Construct the JSON request body
        String requestBody = '{"FirstName":"' + firstName + '","LastName":"' + lastName + '"}';

        // Make the HTTP request to the Cellebrite API
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://clb-candidates-data-5d5991b93b50.herokuapp.com/getContacts');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setBody(requestBody);

        HttpResponse response = new Http().send(request);

        // Process the API response
        if (response.getStatusCode() == 200) {
            handleSuccessfulResponse(contact, response.getBody());
        } else {
            handleErrorResponse(response.getStatusCode(), response.getBody(), contact);
        }
    }

    private static void handleSuccessfulResponse(Contact contact, String responseBody) {
        Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

        if (jsonResponse.containsKey('candidate')) {
            Map<String, Object> candidateInfo = (Map<String, Object>) jsonResponse.get('candidate');
            updateContact(contact, candidateInfo);
        } else {
            handleCandidateNotFound(contact);
        }
    }

    private static void handleCandidateNotFound(Contact contact) {
        // Handle the case where the candidate is not found in the API response
        System.debug('Candidate not found for ' + contact.FirstName + ' ' + contact.LastName);

        // Set all fields to null or handle it based on your business logic
        contact.FirstName = null;
        contact.LastName = null;
        contact.Email = null;
        contact.MobilePhone = null;
        contact.Birthdate = null;
        contact.Description = null;

        // Perform DML operation to update the contact
        try {
            update contact;
            System.debug('Contact updated with null values: ' + contact.Id);
        } catch (DmlException e) {
            // Handle DML exceptions
            for (Integer i = 0; i < e.getNumDml(); i++) {
                System.debug('Error updating contact fields: ' + e.getDmlMessage(i));
            }
            throw e;
        } catch (Exception e) {
            // Handle other exceptions
            System.debug('Error updating contact: ' + e.getMessage());
            throw e;
        }
    }

    private static void handleErrorResponse(Integer statusCode, String responseBody, Contact contact) {
        // Handle API request failure
        System.debug('API Request failed with status code: ' + statusCode);
        System.debug('Error Response: ' + responseBody);

        // Retry the request if it's a temporary failure (e.g., status code 5xx)
        if (statusCode >= 500 && statusCode < 600) {
            System.debug('Retrying the request...');
            makeCellebriteApiRequest(contact);
        } else {
            System.debug('Error logged for further analysis.');
        }
    }

    private static void updateContact(Contact contact, Map<String, Object> candidateInfo) {
        // Update contact fields based on the API response
        contact.FirstName = (String) candidateInfo.get('FirstName');
        contact.LastName = (String) candidateInfo.get('LastName');
        contact.Email = (String) candidateInfo.get('Email');
        contact.MobilePhone = (String) candidateInfo.get('Mobile');
        contact.Birthdate = (Date) candidateInfo.get('Birthdate');
        contact.Description = (String) candidateInfo.get('Description');

        // Perform DML operation to update the contact
        try {
            update contact;
            System.debug('Contact updated: ' + contact.Id);
        } catch (DmlException e) {
            // Handle DML exceptions
            for (Integer i = 0; i < e.getNumDml(); i++) {
                System.debug('Error updating contact fields: ' + e.getDmlMessage(i));
            }
            throw e;
        } catch (Exception e) {
            // Handle other exceptions
            System.debug('Error updating contact: ' + e.getMessage());
            throw e;
        }
    }
}


