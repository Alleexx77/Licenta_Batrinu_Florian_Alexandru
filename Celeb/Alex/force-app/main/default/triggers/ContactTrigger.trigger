trigger ContactTrigger on Contact (after update) {
    // Get the updated contacts
    List<Contact> updatedContacts = Trigger.new;

    // Enqueue a ContactUpdater job for each updated contact
    for (Contact updatedContact : updatedContacts) {
        System.enqueueJob(new ContactUpdater(new List<Contact>{updatedContact}));
    }
}
