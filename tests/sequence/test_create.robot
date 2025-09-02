*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../files/keywords.resource
Resource    keys.resource
Test Setup       Setup
Test Teardown    Teardown after every tests

*** Test Cases ***
test_1
    Init    NEW_SEQ    0    10
    Check    CREATE OR ALTER SEQUENCE NEW_SEQ START WITH 0 INCREMENT BY 10    NEW_SEQ

test_2
    Init    NEW SEQ    2    2
    Check    CREATE OR ALTER SEQUENCE "NEW SEQ" START WITH 2 INCREMENT BY 2   NEW SEQ

test_3
    Init    NEW_SEQ    0    0
    Error check

test_4
    Init    NEW_SEQ    ${EMPTY}    ${EMPTY}
    Error check
    
test_5
    Init    "NEW_SEQ"    ${EMPTY}    2
    Check    CREATE OR ALTER SEQUENCE """NEW_SEQ""" START WITH 0 INCREMENT BY 2   "NEW_SEQ"

test_6
    Init    ${EMPTY}    2    2
    Select Dialog    Error message
    Label Text Should Be    0    Name can not be empty
    Push Button    OK


*** Keywords ***
Init
    [Arguments]    ${name}    ${start}    ${increment}
    Lock Employee
    Open connection
    Select From Tree Node Popup Menu   0    New Connection|Sequences (2)    Create sequence
    Select Dialog    Create sequence
    Clear Text Field    nameField
    Type Into Text Field    nameField    ${name}

    Clear Text Field    1
    Type Into Text Field    1    ${start}

    Clear Text Field    2
    Type Into Text Field    2    ${increment}

    Push Button    submitButton

Check
    [Arguments]    ${text}    ${name}
    Select Dialog    Commiting changes
    Sleep    1s
    ${res}=    Get Text Field Value    0
    Should Be Equal As Strings    ${res}    ${text}

    Push Button    commitButton
    Sleep    0.1s
    ${old}=    Set Jemmy Timeout    DialogWaiter.WaitDialogTimeout	0
    Run Keyword And Expect Error    org.netbeans.jemmy.TimeoutExpiredException: Dialog with name or title 'Create sequence'    Select Dialog    Create sequence

    Select Main Window
    Tree Node Should Exist    0     New Connection|Sequences (3)|${name}

Error check
    Select Dialog    Commiting changes
    Sleep    1s
    ${value}=    Get Table Cell Value    0    0    Status
    Should Be Equal As Strings    ${value}    Error
    Push Button    rollbackButton
    Select Dialog    Create sequence
    Push Button    cancelButton
    Select Dialog    Confirmation
    Push Button    Yes
    Select Main Window
    Tree Node Should Exist    0     New Connection|Sequences (2)
    Tree Node Should Not Exist    0     New Connection|Sequences (3)