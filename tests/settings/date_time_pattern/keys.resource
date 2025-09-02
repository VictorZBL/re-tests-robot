*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../../files/keywords.resource

*** Keywords ***
Set Pattern
    [Arguments]    ${pattern_name}    ${pattern}
    Backup User Properties
    Select From Main Menu    System|Preferences
    Select Dialog    Preferences
    Click On Tree Node    0    Result Set Table
    Sleep    2s
    ${row}=    Find Table Row    0    ${pattern_name}

    Clear Table Cell    0    ${row}    2
    Type Into Table Cell    0    ${row}    2    ${pattern}
    Click On Tree Node    0    Result Set Table
    Push Button    applyButton
    Close Dialog    Message
    Close Dialog    Preferences
    Select Main Window
    Focus To Component    0

Init table
    [Arguments]     ${type}    ${value}
    Lock Employee
    Execute Immediate    CREATE TABLE TEST_TABLE (TEST ${type})
    Execute Immediate    INSERT INTO TEST_TABLE VALUES ('${value}')

Test
    Open connection
    Click On Tree Node    0    New Connection|Tables (11)|TEST_TABLE    clickCount=2
    Sleep    1s
    Select Tab As Context    Data
    Sleep    2s
    ${value}=    Get Table Cell Value    0    0    TEST
    RETURN    ${value}

Check Query Editor
    Open connection
    Sleep    2s
    Clear Text Field    0
    Type Into Text Field    0    Select * from TEST_TABLE
    Push Button    execute-script-command
    Sleep    2s
    ${value}=    Get Table Cell Value    0    0    TEST
    RETURN    ${value}

Setup
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    Skip If    ${{$ver != '5.0'}}
    Setup before every tests

Teardown
    Teardown after every tests
    Restore User Properties
