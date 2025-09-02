*** Settings ***
Library    RemoteSwingLibrary
Library    os
Library    platform
Library    Collections
Resource    ../../files/keywords.resource
Resource    keys.resource
Test Setup       Setup
Test Teardown    Teardown
*** Test Cases ***
test_re
    Init
    Select From Tree Node Popup Menu    0    New Connection    Duplicate connection
    Type Into Text Field    roleField    TEST_ROLE
    Clear Text Field    userField
    Type Into Text Field    userField    TEST_USER
    Clear Text Field    passwordField
    Type Into Text Field    passwordField    123
    Push Button    saveButton
    Push Button    connectButton
    Open connection
    Check    127.0.0.1


test_isql
    Skip
    Init
    Run Isql
    Open connection
    Check    ::1
    Stop Server

*** Keywords ***
Init
    Execute Immediate    CREATE ROLE TEST_ROLE;
    Execute Immediate    CREATE USER TEST_USER PASSWORD '123';
    Execute Immediate    GRANT TEST_ROLE TO TEST_USER;

Teardown
    Teardown after every tests
    Execute Immediate    REVOKE TEST_ROLE FROM TEST_USER;
    Execute Immediate    DROP USER TEST_USER;
    Execute Immediate    DROP ROLE TEST_ROLE;

Check
    [Arguments]    ${ip}
    ${name}=    os.Getlogin
    ${host}=    platform.Node
    Select From Main Menu    Tools|Profiler
    Select From Combo Box    connectionCombo    New Connection
    Push Button    attachmentButton
    Sleep    2s
    Select Dialog    Select Attachment
    @{values}=    Get Table Values    attachmentsTable
    
    VAR    ${count}    ${{len($values)}}
    Should Be Equal As Integers    ${count}    2    msg=В списке недостоточно коннектов

    Sort List    ${values}

    Should Not Be Equal As Integers    ${{$values[0][1].find('${ip}')}}    -1
    Should Be Equal As Strings    ${values}[0][2:]    ['TEST_USER', 'TEST_ROLE', '${host}', '${name}']    ignore_case=${True}

    Should Not Be Equal As Integers    ${{$values[1][1].find('127.0.0.1')}}    -1
    Should Be Equal As Strings    ${values}[1][2:]    ['SYSDBA', 'NONE', '${host}', '${name}']
