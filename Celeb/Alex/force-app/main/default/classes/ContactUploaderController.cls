/*************************************************************************************************************
Name:  ContactUploaderController
==============================================================================================================
Purpose: Apex class to handle the bulk creation of contacts from a CSV file.
==============================================================================================================
History                                                            
-------                                                            
VERSION  AUTHOR                                             DATE           DETAIL          Description
1.0      Scutariu Lucian                                  13/01/2024      Created         Initial version
**************************************************************************************************************/
public with sharing class ContactUploaderController {

    public class AccountOption {
        @AuraEnabled
        public String label { get; set; }
        @AuraEnabled
        public String value { get; set; }

        public AccountOption(String label, String value) {
            this.label = label;
            this.value = value;
        }
    }

    /**
     * Retrieves a list of Account options for use in the Lightning Web Component.
     * 
     * @return List of SelectOption representing available Account options.
     */
    @AuraEnabled(cacheable=true)
    public static List<AccountOption> getAccountOptions() {
        List<AccountOption> options = new List<AccountOption>();

        // Query to retrieve accounts that are like "Onboarding Manager"
        List<Account> accounts = [SELECT Id, Name FROM Account WHERE Name LIKE 'Onboarding Manager%' ORDER BY Name ASC];

        for (Account acc : accounts) {
            options.add(new AccountOption(acc.Name, acc.Id));
        }
        return options;
    }

    /**
     * Processes the CSV content and creates contacts under the specified Account.
     * 
     * @param accountId The Id of the target Account for contact creation.
     * @param csvContent The content of the CSV file to be processed.
     * @throws AuraHandledException if an error occurs during processing.
     */
    @AuraEnabled
    public static void processCsvAndCreateContacts(Id accountId, String csvContent) {
        try {
            // Parse the CSV content
            List<Map<String, String>> csvData = CsvReader.parse(csvContent);

            // Retrieve existing contacts under the specified Account
            List<Contact> existingContacts = [SELECT Id, FirstName, LastName FROM Contact WHERE AccountId = :accountId];

            // Create a map to store existing contacts by first and last name for quick lookup
            Map<String, Contact> existingContactsMap = new Map<String, Contact>();
            for (Contact existingContact : existingContacts) {
                String key = existingContact.FirstName + existingContact.LastName;
                existingContactsMap.put(key, existingContact);
            }

            // List to store new contacts
            List<Contact> newContacts = new List<Contact>();

            // List to store unique combinations of first and last names for existing contacts
            List<String> existingNameCombinations = new List<String>(existingContactsMap.keySet());

            // Iterate through the CSV data and create contacts
            for (Map<String, String> row : csvData) {
                String firstName = row.get('FirstName');
                String lastName = row.get('LastName');

                // Check if the contact with the same first and last name already exists under the specified Account
                String key = firstName + lastName;
                if (!existingNameCombinations.contains(key)) {
                    Contact newContact = new Contact(
                        FirstName = firstName,
                        LastName = lastName,
                        AccountId = accountId
                    );
                    newContacts.add(newContact);
                    existingNameCombinations.add(key); // Add to list to avoid duplicates
                }
            }

            // Insert new contacts with error handling
            Database.SaveResult[] contactInsertResults = Database.insert(newContacts, false);

        } catch (Exception e) {
            throw new AuraHandledException('Error processing CSV and creating contacts: ' + e.getMessage());
        }
    }

}
