*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../files/keywords.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_1
    Init    NEW_EXP    test_text
    Check    CREATE OR ALTER EXCEPTION NEW_EXP 'test_text'    NEW_EXP

test_2
    Init    NEW EXP    test text
    Check    CREATE OR ALTER EXCEPTION "NEW EXP" 'test text'    NEW EXP

test_3
    Init    NE_W E_XP    ${EMPTY}
    Check    CREATE OR ALTER EXCEPTION "NE_W E_XP" ''    NE_W E_XP

test_4
    Init    ${EMPTY}    test text
    Select Dialog    Commiting changes
    Sleep    1s
    ${value}=    Get Table Cell Value    0    0    Status
    Should Be Equal As Strings    ${value}    Error
    Push Button    rollbackButton
    Select Dialog    Create exception
    Push Button    cancelButton
    Select Dialog    Confirmation
    Push Button    Yes
    Select Main Window
    Tree Node Should Exist    0     New Connection|Exceptions (5)
    Tree Node Should Not Exist    0     New Connection|Exceptions (6)


*** Keywords ***
Init
    [Arguments]    ${name}    ${text}
    Lock Employee
    Open connection
    Select From Tree Node Popup Menu   0    New Connection|Exceptions (5)    Create exception
    Select Dialog    Create exception
    Clear Text Field    nameField
    Type Into Text Field    nameField    ${name}

    Clear Text Field    1
    Type Into Text Field    1    ${text}

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
    Run Keyword And Expect Error    org.netbeans.jemmy.TimeoutExpiredException: Dialog with name or title 'Create exception'    Select Dialog    Create exception

    Select Main Window
    Tree Node Should Exist    0     New Connection|Exceptions (6)|${name}