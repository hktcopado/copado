/*------------------------------------------------------------  
Author:        David Norris
Company:       Salesforce.com
Description:   An utility class for common application logging functions
Test Class:    ApplicationLogHelper_Test
History        Ian Huang     18-Aug-2020     Updates for HKT Ruby project
------------------------------------------------------------*/

public inherited sharing class ApplicationLogHelper {

    //get enable debug value from from App_Setting custom setting
    public static final Boolean DEBUG = App_Setting__c.getInstance().Enable_Debug__c;

    //Log debug message
    public static void logDebug(String origin,
                                String source,
                                String sourceFunction,
                                String referenceId,
                                String referenceInfo,
                                String logMessage) {
        logMessage('Debug', origin, source, sourceFunction, referenceId, referenceInfo, logMessage);
    }

    //Log info message
    public static void logInfo(String origin,
                               String source,
                               String sourceFunction,
                               String referenceId,
                               String referenceInfo,
                               String logMessage) {
        logMessage('Info', origin, source, sourceFunction, referenceId, referenceInfo, logMessage);
    }
    
    //Log warning message
    public static void logWarning(String origin,
                                  String source,
                                  String sourceFunction,
                                  String referenceId,
                                  String referenceInfo,
                                  String logMessage) {
        logMessage('Warning', origin, source, sourceFunction, referenceId, referenceInfo, logMessage);
    }
    
    //Log error message
    public static void logError(String origin,
                                String source,
                                String sourceFunction,
                                String referenceId,
                                String referenceInfo,
                                String logMessage) {
        logMessage('Error', origin, source, sourceFunction, referenceId, referenceInfo, logMessage);
    }
    
    //Log DML error
    public static void logDMLError(String origin,
                                   String source,
                                   String sourceFunction,
                                   Database.Error dbError) {
        
        ApplicationLogMessage appLogMessage = new ApplicationLogMessage();
        appLogMessage.logType        = 'Error';
        appLogMessage.origin         = origin;                                       
        appLogMessage.source         = source;
        appLogMessage.sourceFunction = sourceFunction;
        appLogMessage.referenceId    = 'Exception-' + dbError.fields;
        appLogMessage.referenceInfo  = String.valueOf(dbError.getStatusCode());
        appLogMessage.logMessage     = dbError.getStatusCode() + ': ' + dbError.getMessage();
        appLogMessage.timestamp      = System.now();    
        logMessage(appLogMessage);
    }
    
    //Description:   Method used for exception logging.
    //Inputs:        sourceClass - Originating trigger or utility class
    //               sourceFunction - Method in class above that caused the message
    //               ex - the standard exception object for errors
    public static void logException(String origin,
                                    String source,
                                    String sourceFunction,
                                    Exception ex) {
        ApplicationLogMessage appLogMessage = new ApplicationLogMessage();
        appLogMessage.origin         = origin;
        appLogMessage.logType        = 'Error';
        appLogMessage.source         = source;
        appLogMessage.sourceFunction = sourceFunction;
        appLogMessage.referenceId    = 'Exception: ' + ex.getLineNumber();
        appLogMessage.referenceInfo  = ex.getTypeName();
        appLogMessage.logMessage     = '';
        appLogMessage.ex             = ex;
        logMessage(appLogMessage);
    }
    
    //Log integration message
    public static void logCallout(String    origin,
                                  String    source,
                                  String    sourceFunction,
                                  String    referenceId,
                                  String    referenceInfo,
                                  String    endPoint,
                                  String    statusCode,
                                  String    requestBody,
                                  String    responseBody,
                                  long      timeTaken) {

        ApplicationLogMessage msg = new ApplicationLogMessage();

        msg.logType             = 'Callout';
        msg.origin              = origin;
        msg.source              = source;
        msg.sourceFunction      = sourceFunction;
        msg.referenceId         = referenceId;
        msg.referenceInfo       = referenceInfo;
        msg.CalloutEndPoint     = endPoint;
        msg.CalloutStatusCode   = statusCode;
        msg.CalloutRequestBody  = requestBody;
        msg.CalloutResponseBody = responseBody;
        msg.Timer               = timeTaken;
        msg.timestamp           = System.now();
               
        logMessage(msg);
    }
   
    //Overloaded Method to log a single record to the application log table
    public static void logMessage(ApplicationLogMessage appLog) {
        logMessage(new List<ApplicationLogMessage>{appLog});
    }
    
    //Overloaded Log message method
    private static void logMessage(String logType,
                                   String origin,
                                   String source,
                                   String sourceFunction,
                                   String referenceId,
                                   String referenceInfo,
                                   String logMessage) {

        ApplicationLogMessage msg = new ApplicationLogMessage();

        msg.logType        = logType;
        msg.origin         = origin;
        msg.source         = source;
        msg.sourceFunction = sourceFunction;
        msg.referenceId    = referenceId;
        msg.referenceInfo  = referenceInfo;
        msg.logMessage     = logMessage;
        msg.timestamp      = System.now();                

        logMessage(msg);
    }
    
    //Overloaded Method to log multiple records to the application log table
    //publish platform event to save app log 
    public static void logMessage(List<ApplicationLogMessage> appLogs) {
        List<Application_Log_Event__e> logEvents = new List<Application_Log_Event__e>();
        for (ApplicationLogMessage appLog :appLogs) {
            Application_Log_Event__e logEvent = new Application_Log_Event__e();

            logEvent.Log_Type__c              = String.valueOf(appLog.LogType);
            logEvent.Reference_Id__c          = appLog.ReferenceId;
            logEvent.Reference_Information__c = appLog.ReferenceInfo;
            logEvent.Source__c                = appLog.Source;
            logEvent.Source_Function__c       = appLog.SourceFunction;
            logEvent.Message__c               = appLog.LogMessage;
            logEvent.Timer__c                 = appLog.Timer;
            logEvent.Timestamp__c             = appLog.Timestamp;
            logEvent.Callout_End_Point__c     = appLog.CalloutEndPoint;
            logEvent.Callout_Status_Code__c   = appLog.CalloutStatusCode;
            logEvent.Callout_Request_Body__c  = appLog.CalloutRequestBody;
            logEvent.Callout_Response_Body__c = appLog.CalloutResponseBody;

            if (appLog.ex != null) {
                logEvent.Stack_Trace__c    = appLog.ex.getStackTraceString();
                logEvent.Message__c        = String.isNotBlank(logEvent.Message__c) ? '\r\n' : ''; 
                logEvent.Message__c       += applog.ex.getMessage() + '\r\n' + applog.ex.getTypeName();
                //display message in system debug log
                debugLog(appLog.ex);
            }
            
            logEvents.add(logEvent);
        }

        //fire platform event to save Application log record
        EventBus.publish(logEvents);
    }

    public static void debugLog(Exception ex) {
        debugLog(ex.getMessage());
        debugLog(ex.getStackTraceString());
        debugLog(ex.getTypeName());
        debugLog(String.valueOf(ex.getLineNumber()));
    }    
    
    public static void debugLog(String message) {
        if(DEBUG) {
            System.Debug(message);
        }
    }
}