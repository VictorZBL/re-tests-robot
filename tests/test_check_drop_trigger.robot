*** Settings ***
Library    RemoteSwingLibrary
Library    Process
Library    Collections
Resource    ../files/keywords.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_drop_trigger_for_ddl
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    Skip If    ${{$ver == '2.6'}}
    VAR    ${script}   CREATE OR ALTER TRIGGER NEW_TRIGGER
    ...    ACTIVE BEFORE ANY DDL STATEMENT POSITION 0
    ...    AS
    ...    BEGIN
    ...    END
    Drop Trigger    ${script}    DDL Triggers (1)|NEW_TRIGGER    DDL

test_drop_trigger_for_db
    VAR    ${script}   CREATE OR ALTER TRIGGER NEW_TRIGGER
    ...    ACTIVE ON CONNECT POSITION 0
    ...    AS
    ...    BEGIN
    ...    END
    Drop Trigger    ${script}    DB Triggers (1)|NEW_TRIGGER    DB

*** Keywords ***
Drop Trigger
    [Arguments]    ${script}    ${path}    ${type}
    Execute Immediate    ${script}
    Open connection
    Run Keyword In Separate Thread    Select From Tree Node Popup Menu    0    New Connection|${path}    Delete ${type} trigger
    Select Dialog    dialog0
    ${row}=    Find Table Row    0    Success    Status
    Push Button    commitButton
    Should Not Be Equal As Integers    ${row}    -1
    VAR    ${error}    DatabaseError:
    Run Keyword And Expect Error    STARTS:${error}    Execute Immediate    DROP TRIGGER NEW_TRIGGER