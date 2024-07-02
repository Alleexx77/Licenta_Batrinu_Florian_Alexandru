public with sharing class ContactUpdaterBatchProcessor {
    public static void processContacts(List<Contact> contacts) {
        List<List<Contact>> contactBatches = splitContactsIntoBatches(contacts, 10);

        for (List<Contact> contactBatch : contactBatches) {
            enqueueContactUpdaterQueueable(contactBatch);
        }
    }

    private static void enqueueContactUpdaterQueueable(List<Contact> contactBatch) {
        // Enqueue a Queueable job for processing the batch
        System.enqueueJob(new ContactUpdater(contactBatch));
    }

    private static List<List<Contact>> splitContactsIntoBatches(List<Contact> contacts, Integer batchSize) {
        List<List<Contact>> contactBatches = new List<List<Contact>>();
        for (Integer i = 0; i < contacts.size(); i += batchSize) {
            contactBatches.add(contacts.subList(i, Math.min(i + batchSize, contacts.size())));
        }
        return contactBatches;
    }
}
