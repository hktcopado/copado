@isTest
private class ApplicationLogHelper_Test {
	
    public class TestException extends Exception {}
    
    @isTest static void testLogDebug() {
        ApplicationLogHelper.logDebug('orgin', 'sourceClass', 'sourceFunction', 'referenceId', 'referenceInfo', 'logMessage');
        List<Application_Log__c> appLogs = [SELECT Id, Type__c FROM Application_Log__c];
        
        System.assertEquals(0, appLogs.size());
        //System.assertEquals('Debug', appLogs[0].Type__c);
    }
    
    @isTest static void testLogInfo() {
        ApplicationLogHelper.logInfo('orgin', 'sourceClass', 'sourceFunction', 'referenceId', 'referenceInfo', 'logMessage');
        List<Application_Log__c> appLogs = [SELECT Id, Type__c FROM Application_Log__c];
        
        System.assertEquals(0, appLogs.size());
        //System.assertEquals('Info', appLogs[0].Type__c);
    }
    
    @isTest static void testLogWarning() {
        ApplicationLogHelper.logWarning('orgin', 'sourceClass', 'sourceFunction', 'referenceId', 'referenceInfo', 'logMessage');
        List<Application_Log__c> appLogs = [SELECT Id, Type__c FROM Application_Log__c];
        
        System.assertEquals(0, appLogs.size());
        //System.assertEquals('Warning', appLogs[0].Type__c);
    }
    
    @isTest static void testLogError() {
        ApplicationLogHelper.logError('orgin', 'sourceClass', 'sourceFunction', 'referenceId', 'referenceInfo', 'logMessage');
        List<Application_Log__c> appLogs = [SELECT Id, Type__c FROM Application_Log__c];
        
        System.assertEquals(0, appLogs.size());
        //System.assertEquals('Error', appLogs[0].Type__c);
    }
    
    @isTest static void testLogException() {
        ApplicationLogHelper.LogException('orgin', 'sourceClass', 'sourceFunction', new TestException());
    }
        
    @isTest static void testLogDMLError() {
        Account[] accounts = new List<Account>{new Account(), new Account()};
        Database.SaveResult[] sr = Database.insert(accounts, false);
        
        ApplicationLogHelper.logDMLError('orgin', 'sourceClass', 'sourceFunction', sr[0].getErrors()[0]);
    }    
    
    @isTest static void testLogCallout() {
        ApplicationLogHelper.logCallout('orgin', 'sourceClass', 'sourceFunction', 'referenceId', 'referenceInfo', 'https://api.testendpoint.io', 'logMessage', 'Request', 'Response', 1000);
        List<Application_Log__c> appLogs = [SELECT Id, Type__c FROM Application_Log__c];
        
        System.assertEquals(0, appLogs.size());
        //System.assertEquals('Callout', appLogs[0].Type__c);
    }
    
}