*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../files/keywords.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_execute_sql
    Execute    execute-script-command

test_execute_statement
    Check Tool
    Execute    execute-statement-command
    Check Tool

*** Keywords ***
Execute
    [Arguments]    ${button}
    Open connection
    Clear Text Field    0
    Type Into Text Field    0    select cast(:test as integer) from rdb$database
    Push Button    ${button}
    Select Dialog    Input parameters
    Type Into Text Field    0    1234
    Push Button     OK
    Select Main Window
    Sleep    1s
    Push Button    ${button}
    Select Dialog    Input parameters
    ${value}=    Get Text Field Value    0
    Clear Text Field    0
    Type Into Text Field    0    4321
    Push Button     OK
    Should Be Equal As Strings    ${value}    1234
    
    #cancel
    Select Main Window
    Sleep    1s
    Push Button    ${button}
    Close Dialog    Input parameters

Check Tool
    Select From Main Menu    System|Preferences
    Select Dialog    Preferences
    Click On Tree Node    0    Tool Bar|Query Editor Tools
    ${values}=    Get Table Values    0
    ${row}=    Find Table Row    0    Execute single statement    2
    Click On Table Cell    0    ${row}    0
    Push Button    applyButton
    Close Dialog    Message
    Close Dialog    Preferences
    Select Main Window