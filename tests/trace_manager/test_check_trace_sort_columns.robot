*** Settings ***
Library    RemoteSwingLibrary
Library    random
Resource    keys.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_1
    Select From Main Menu    Tools|Trace Manager
    Sleep    5s
    Push Button    visibleColumnsButton
    Select Dialog    Visible Columns
    Randoming
    Push Button    removeAllButton
    Push Button    sortAvailableButton
    @{list_column}=    Get List Values    0
    @{expected_list_column}=    Create List    CHARSET    CLIENT_ADDRESS    CLIENT_PROCESS    COUNT_FETCHES    COUNT_MARKS    COUNT_READS    COUNT_WRITES    DATABASE    DECLARE_CONTEXT_VARIABLES    ERROR_MESSAGE    EVENT_TYPE    EXECUTOR    FAILED    GRANTOR    ID_CLIENT_PROCESS    ID_CONNECTION    ID_PROCESS    ID_SERVICE    ID_SESSION    ID_STATEMENT    ID_THREAD    ID_TRANSACTION    LEVEL_ISOLATION    MODE_OF_ACCESS    MODE_OF_BLOCK    NAME_SESSION    NEXT_TRANSACTION    NUM    OLDEST_ACTIVE    OLDEST_INTERESTING    OLDEST_SNAPSHOT    OPTIONS_START_SERVICE    PARAMETERS_TEXT    PLAN_TEXT    PRIVILEGE    PRIVILEGE_ATTACHMENT    PRIVILEGE_OBJECT    PRIVILEGE_TRANSACTION    PRIVILEGE_USERNAME    PROCEDURE_NAME    PROTOCOL_CONNECTION    RECEIVED_DATA    RECORDS_FETCHED    RETURN_VALUE    ROLE    SENT_DATA    SORT_MEMORY_USAGE_CACHED    SORT_MEMORY_USAGE_ON_DISK    SORT_MEMORY_USAGE_TOTAL    STATEMENT_TEXT    TABLE_COUNTERS    TIME_EXECUTION    TRIGGER_INFO    TSTAMP    TYPE_QUERY_SERVICE    USERNAME
    Should Be Equal As Strings    ${list_column}    ${expected_list_column}
    
    Randoming
    Push Button    sortSelectedButton
    @{list_column}=    Get List Values    1
    Should Be Equal As Strings    ${list_column}    ${expected_list_column}
    
*** Keywords ***
Randoming
    Push Button    removeAllButton
    Push Button    selectAllButton
    @{list_column}=    Get List Values    1
    @{avaible_actions}    Create List    movePageUpButton    moveUpButton    moveDownButton    movePageDownButton
    VAR    ${i}    0
    FOR  ${i}  IN  5
        ${rel}=    random.Choice    ${list_column}
        ${ract}=    random.Choice    ${avaible_actions}
        Click On List Item    1    ${rel}
        Push Button    ${ract}
    END
