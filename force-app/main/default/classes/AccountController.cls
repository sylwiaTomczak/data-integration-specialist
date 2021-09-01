public with sharing class AccountController {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts() {
    
        throw new AuraHandledException('Forced error');
    }
    
}