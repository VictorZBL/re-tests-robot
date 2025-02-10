*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../files/keywords.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_1
    ${conf_path}=    Catenate    SEPARATOR=    ${TEMPDIR}    /test_conf.conf
    ${log_path}=    Catenate    SEPARATOR=    ${TEMPDIR}    /test_log.fbtrace_text
    Open connection
    Select From Main Menu    Tools|Trace Manager
    Sleep    5s
    Push Button    newConfigButton
    Select Dialog    Build configuration file
    Select From Combo Box    0    RedDatabase 3.0
    Type Into Text Field    15    ${conf_path}
    Push Button    Save
    Select Dialog    Message
    Push Button    OK
    Close Dialog    Build configuration file

    #create connection
    Select Window    regexp=^RDB.*
    Select Tab As Context    Connection
    List Components In Context
    Select From Combo Box    databaseBox    New Connection
    Select From Combo Box    charsetCombo    UTF8
    Clear Text Field    2
    Type Into Text Field    2    ${conf_path}
    Check Check Box    logToFileBox
    Clear Text Field    fileLogField
    Type Into Text Field    fileLogField    ${log_path}
    Select Window    regexp=^RDB.*
    Push Button    Start

    #fill log file
    Select Tab As Context    Session Manager
    Push Button    Refresh list
    Select Window    regexp=^RDB.*
    Push Button    visibleColumnsButton
    Select Dialog    Visible Columns
    Push Button    removeAllButton
    Click On List Item    0    EVENT_TYPE
    Push Button    selectOneButton
    Click On List Item    0    USERNAME
    Push Button    selectOneButton
    Click On List Item    0    TYPE_QUERY_SERVICE
    Push Button    selectOneButton
    Close Dialog    Visible Columns
    Select Window    regexp=^RDB.*
    Select Tab As Context    Session Manager
    Click On List Item    0    New
    Push Button    Stop session
    Sleep    5s
    Select Window    regexp=^RDB.*
    Push Button    Stop
    Sleep    5s
    Select Tab As Context    Grid View
    Select Window    regexp=^RDB.*
    Push Button    Clear Table
    Sleep    5s
    Select Tab As Context    Grid View
    ${headers}=    Get Table Headers    0
    ${columnValues}=    Get Table Values    0
    Should Be Equal As Strings  ${headers}    ['EVENT_TYPE', 'USERNAME', 'TYPE_QUERY_SERVICE']


test_2
    ${conf_path}=    Catenate    SEPARATOR=    ${TEMPDIR}    /test_conf.conf
    ${log_path}=    Catenate    SEPARATOR=    ${TEMPDIR}    /test_log.fbtrace_text
    Open connection
    Select From Main Menu    Tools|Trace Manager
    Sleep    5s
    Push Button    openLogButton
    Sleep    1s
    Select Dialog    Open
    Type Into Text Field    0    ${log_path}
    Push Button    Open
    Select Window    regexp=^RDB.*
    Select Tab As Context    Grid View
    Select From Combo Box    1    TYPE_QUERY_SERVICE
    Type Into Text Field    0    Start
    Select From Combo Box    0    Filter
    ${columnValues}=    Get Table Values    0
    Should Not Be Equal    first=${{['', '', ''] in $columnValues}}    second=${True}
    Should Be Equal        first=${{['START_SERVICE', 'SYSDBA', 'Start Trace Session'] in $columnValues}}    second=${True}