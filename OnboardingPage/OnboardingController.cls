public class OnboardingController {
    @AuraEnabled
    public static List<SelectOption> getActivityTypeOptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Building, civil and environmental', 'Building, civil and environmental'));
        options.add(new SelectOption('Electric, automation and networks', 'Electric, automation and networks'));
        options.add(new SelectOption('Facility management and services', 'Facility management and services'));
        options.add(new SelectOption('Industrial plant engineering', 'Industrial plant engineering'));
        options.add(new SelectOption('IT and Telecommunications', 'IT and Telecommunications'));
        options.add(new SelectOption('Market, Home and communication', 'Market, Home and communication'));
        options.add(new SelectOption('Design and technical Services', 'Design and technical Services'));
        options.add(new SelectOption('HR services and consultancy', 'HR services and consultancy'));
        return options;
    }
    
    @AuraEnabled
    public static void submit(Office__c office, List<String> selectedActivityTypes) {
        insert office;
        List<Activity_Type__c> activityTypes = new List<Activity_Type__c>();
        for (String activityType : selectedActivityTypes) {
            Activity_Type__c newActivityType = new Activity_Type__c();
            newActivityType.Office__c = office.Id;
            newActivityType.Name = activityType;
            activityTypes.add(newActivityType);
        }
        insert activityTypes;
    }
}
