*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../../files/keywords.resource
Resource    ../keys.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_event_disconnect
    Init
    Uncheck Check Box    activeCheck
    Select From Combo Box    actionCombo    DISCONNECT
    Check    CREATE OR ALTER TRIGGER NEW_TRIGGER INACTIVE ON DISCONNECT POSITION 0 AS BEGIN /* Trigger impl */ END

test_event_transaction_start
    Init    NEW TRIGGER
    Select From Combo Box    actionCombo    TRANSACTION START
    Check    CREATE OR ALTER TRIGGER "NEW TRIGGER" ACTIVE ON TRANSACTION START POSITION 0 AS BEGIN /* Trigger impl */ END    NEW TRIGGER

test_event_transaction_commit
    Init    "NEW TRIGGER"
    Clear Text Field    1
    Type Into Text Field    1    10
    Select From Combo Box    actionCombo    TRANSACTION COMMIT
    Check    CREATE OR ALTER TRIGGER """NEW TRIGGER""" ACTIVE ON TRANSACTION COMMIT POSITION 10 AS BEGIN /* Trigger impl */ END    "NEW TRIGGER"

test_event_transaction_rollback
    Init
    Select From Combo Box    actionCombo    TRANSACTION ROLLBACK
    Check    CREATE OR ALTER TRIGGER NEW_TRIGGER ACTIVE ON TRANSACTION ROLLBACK POSITION 0 AS BEGIN /* Trigger impl */ END

test_use_external_module
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    Skip If    ${{$ver == '2.6'}}
    Init
    Check Check Box    useExternalCheck
    Type Into Text Field    externalField    external_point
    Type Into Text Field    engineField    external_engine
    Check    CREATE OR ALTER TRIGGER NEW_TRIGGER ACTIVE ON CONNECT POSITION 0 EXTERNAL NAME 'external_point' ENGINE external_engine

test_sql_security_definer
    Check Skip
    Init
    Select From Combo Box    userContextComboBox    DEFINER
    Check    CREATE OR ALTER TRIGGER NEW_TRIGGER ACTIVE ON CONNECT POSITION 0 SQL SECURITY DEFINER AS BEGIN /* Trigger impl */ END

test_sql_security_invoker
    Check Skip
    Init
    Select From Combo Box    userContextComboBox    INVOKER
    Check    CREATE OR ALTER TRIGGER NEW_TRIGGER ACTIVE ON CONNECT POSITION 0 SQL SECURITY INVOKER AS BEGIN /* Trigger impl */ END

*** Keywords ***
Init
    [Arguments]    ${name}=NEW_TRIGGER
    Lock Employee
    Open connection
    Select From Tree Node Popup Menu   0    New Connection|DB Triggers    Create DB trigger
    Select Dialog    Create DB trigger
    Clear Text Field    nameField
    Type Into Text Field    nameField    ${name}

Check
    [Arguments]    ${text}    ${name}=NEW_TRIGGER
    Push Button    submitButton
    Select Dialog    Commiting changes
    Sleep    1s
    ${res}=    Get Text Field Value    0
    Should Be Equal As Strings    ${res}    ${text}    strip_spaces=${True}    collapse_spaces=${True}

    Push Button    commitButton
    Sleep    0.1s
    ${old}=    Set Jemmy Timeout    DialogWaiter.WaitDialogTimeout    0
    Run Keyword And Expect Error    org.netbeans.jemmy.TimeoutExpiredException: Dialog with name or title 'Create DB trigger'    Select Dialog    Create DB trigger

    Select Main Window
    Tree Node Should Exist    0     New Connection|DB Triggers (1)|${name}