*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../files/keywords.resource
Resource    keys.resource
Test Setup       Setup
Test Teardown    Teardown after every tests

*** Test Cases ***
test_1
    Init    NEW_PACK    BEGIN\n\nEND    BEGIN\n\nEND
    Check    CREATE OR ALTER PACKAGE NEW_PACK AS BEGIN END    RECREATE PACKAGE BODY NEW_PACK AS BEGIN END    NEW_PACK

test_2
    Init    NEW PACK    BEGIN\n\nEND    BEGIN\n\nEND
    Check    CREATE OR ALTER PACKAGE "NEW PACK" AS BEGIN END    RECREATE PACKAGE BODY "NEW PACK" AS BEGIN END    NEW PACK

test_3
    Init    "NEW PACK"    BEGIN\n\nEND    BEGIN\n\nEND
    Check    CREATE OR ALTER PACKAGE """NEW PACK""" AS BEGIN END    RECREATE PACKAGE BODY """NEW PACK""" AS BEGIN END    "NEW PACK"

test_4
    Init    NEW_PACK    BEGIN\n\nEND    ${EMPTY}
    Check    CREATE OR ALTER PACKAGE NEW_PACK AS BEGIN END    ${None}    NEW_PACK

test_5
    Init    ${EMPTY}    BEGIN\n\nEND    BEGIN\n\nEND
    Check error

test_6
    Init    NEW_PACK    ${EMPTY}    BEGIN\n\nEND
    Check error


*** Keywords ***
Init
    [Arguments]    ${name}    ${header}    ${body}
    Lock Employee
    Open connection
    Select From Tree Node Popup Menu   0    New Connection|Packages (0)    Create package
    Select Dialog    Create package
    Clear Text Field    nameField
    Type Into Text Field    nameField    ${name}
    
    Select Tab As Context   Header
    Clear Text Field    0
    Type Into Text Field    0    ${header}
    
    Select Dialog    Create package
    Select Tab As Context   Body    
    Clear Text Field    0
    Type Into Text Field    0    ${body}

    Select Dialog    Create package
    Push Button    submitButton

Check
    [Arguments]    ${create_header}    ${create_body}    ${name}
    Select Dialog    Commiting changes
    Sleep    1s
    
    ${row_header}=     Find Table Row    0    CREATE OR ALTER PACKAGE
    ${value}=    Get Table Cell Value    0    ${row_header}    Status
    Should Be Equal As Strings    ${value}    Success
    Click On Table Cell    0    ${row_header}    Name operation
    ${res}=    Get Text Field Value    0
    Should Be Equal As Strings    ${res}    ${create_header}    strip_spaces=${True}    collapse_spaces=${True}
    Log Variables
    ${row_body}=     Find Table Row    0    OPERATION
    
    IF    $create_body != None
        ${value}=    Get Table Cell Value    0    ${row_body}    Status
        Should Be Equal As Strings    ${value}    Success
        Click On Table Cell    0    ${row_body}    Name operation 
        ${res}=    Get Text Field Value    0
        Should Be Equal As Strings    ${res}    ${create_body}    strip_spaces=${True}    collapse_spaces=${True}
    ELSE
        Should Be Equal As Integers    ${row_body}    -1
    END

    Push Button    commitButton
    Sleep    0.1s
    ${old}=    Set Jemmy Timeout    DialogWaiter.WaitDialogTimeout	0
    Run Keyword And Expect Error    org.netbeans.jemmy.TimeoutExpiredException: Dialog with name or title 'Create package'    Select Dialog    Create package

    Select Main Window
    Tree Node Should Exist    0     New Connection|Packages (1)|${name}


Check error
    Select Dialog    Commiting changes
    Sleep    1s
    ${value}=    Get Table Cell Value    0    0    Status
    Should Be Equal As Strings    ${value}    Error
    Push Button    rollbackButton
    Select Dialog    Create package
    Push Button    cancelButton
    Select Dialog    Confirmation
    Push Button    Yes
    Sleep    0.1s
    Select Main Window
    Tree Node Should Exist    0     New Connection|Packages (0)
    Set Jemmy Timeouts    0
    Tree Node Should Not Exist    0     New Connection|Packages (1)