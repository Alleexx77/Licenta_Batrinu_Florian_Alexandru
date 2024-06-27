public with sharing class AuthenticationController {
    @AuraEnabled
    public static Boolean isAuthenticated() {
        return UserInfo.getUserType() != 'Guest';
    }
}
