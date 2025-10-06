*** Settings ***
Library    RemoteSwingLibrary
Library    OperatingSystem
Library    platform
Resource    ../../files/keywords.resource
Test Setup       Setup
Test Teardown    Teardown after every tests
 

*** Test Cases ***    
test_backup
    Select From Tree Node Popup Menu    0    New Connection (Copy)    Create database backup
    ${bk_path}=    Catenate    SEPARATOR=    ${TEMPDIR}    /employee_backup.fbk
    Remove File    ${bk_path}
    Select Tab    Backup
    Clear Text Field     backupFileField
    Type Into Text Field    backupFileField    ${bk_path}

    Push Button    backupButton
    Sleep    2s
    Select Dialog    Message
    Label Text Should Be    0    Backup completed successfully!
    Push Button    OK

test_execute_query
    Select From Main Menu    Tools|Query Editor
    Select Main Window
    Clear Text Field    0
    Type Into Text Field    0    select cast(:test as integer) from rdb$database
    Push Button    execute-script-command
    Select Dialog    Input parameters
    Type Into Text Field    0    1234
    Push Button     OK
    Select Main Window
    Clear Text Field    0

test_export_metadata
    Select From Tree Node Popup Menu    0    New Connection (Copy)    Extract Metadata
    Push Button    extractButton
    Sleep    5s
    Close Dialog    Message
    
test_database_statistics
    Select From Main Menu    Tools|Database Statistic
    Push Button    getStatButton
    ${text}=    Get Text Field Value    0
    Should Not Be Empty    ${text}
    
test_trace_manager 
    Select From Main Menu    Tools|Trace Manager
    Sleep    5s
    Push Button    startStopSessionButton
    Sleep    10s
    Select Tab    Session Manager
    Push Button    startStopSessionButton
    Select Main Window

test_user_manager
    Select From Main Menu    Tools|User Manager
    Sleep    1s
    ${values}=    Get Table Cell Value    usersTable    0    User name
    Should Be Equal As Strings      ${values}    SYSDBA

test_grant_manager
    Select From Main Menu    Tools|Grant Manager
    Sleep    1s
    @{privileges_for_list}=    Get List Values    0
    @{expected_privileges_for_list}=    Create List    SYSDBA
    Should Be Equal As Strings    ${privileges_for_list}    ${expected_privileges_for_list}
    
test_profiler
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    Skip if   ${{$ver != '5'}}
    Select From Main Menu    Tools|Profiler
    Push Button    startButton
    Sleep    2s
    Push Button    finishButton
    Close Dialog    Warning
    
test_table_validator
    Select From Main Menu    Tools|Table Validator
    ${count}=    Get List Item Count    0
    Should Be Equal As Integers    ${count}    10

test_import_data
    Execute Immediate    CREATE TABLE TEST_TABLE (COUNTRY VARCHAR(1024), CURRENCY VARCHAR(1024))
    Select From Main Menu    Tools|Import Data
    Check Check Box    importFromConnectionCheck
    Select From Combo Box    sourceTableCombo    COUNTRY
    Select From Combo Box    targetTableCombo    TEST_TABLE
    Push Button    correlateButton
    Push Button    startImportButton
    Close Dialog    Message  

test_data_generator
    Execute Immediate    CREATE TABLE TEST_TABLE (COUNTRY VARCHAR(1024), CURRENCY VARCHAR(1024))
    Select From Main Menu    Tools|Data Generator
    Select From Combo Box    tablesCombo    TEST_TABLE
    Click On Table Cell    0    0    0
    Click On Table Cell    0    1    0
    Push Button    startButton
    Sleep    0.5s
    Close Dialog    Message

test_remove_conn
    Select From Tree Node Popup Menu    0    New Connection (Copy)   Disconnect
    Run Keyword In Separate Thread    Select From Tree Node Popup Menu    0    New Connection (Copy)   Delete connection
    Select Dialog    Delete connection
    Push Button    Yes
    Select Main Window

*** Keywords ***
Setup
    ${system}    platform.System
    Skip If    '${system}' == 'Linux'
    Lock Employee
    Setup before every tests
    Select From Tree Node Popup Menu    0    New Connection    Duplicate connection
    Select From Tree Node Popup Menu    0    New Connection (Copy)    Connection properties
    Check Check Box    useSshCheck
    Clear Text Field    sshHostField
    Type Into Text Field    sshHostField    localhost
    
    Clear Text Field    sshPortField
    Type Into Text Field    sshPortField    22
    
    ${ssh_info}=    Get User For Ssh
    ${user}=     Set Variable    ${ssh_info}[0]
    ${password}=    Set Variable    ${ssh_info}[1]

    Clear Text Field    sshUserField
    Type Into Text Field    sshUserField    ${user}
    
    Clear Text Field    10
    Type Into Text Field    10    ${password}

    Select From Combo Box    charsetsCombo    UTF8

    Push Button    testButton
    Select Dialog    Message
    Label Text Should Be    0    The connection test was successful!
    Push Button    OK
    Select Main Window
    Push Button    connectButton