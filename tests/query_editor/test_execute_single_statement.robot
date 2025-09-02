*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../files/keywords.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests


*** Test Cases ***
test_1
    Lock Employee
    Check Tool
    Open connection
    Sleep    2s
    Clear Text Field    0
    Type Into Text Field    0    SELECT * FROM COUNTRY;
    Push Button    execute-statement-command
    Sleep    2s
    Clear Text Field    0
    Check Tool

test_cancel
    Lock Employee
    Check Tool
    Open connection
    Sleep    2s
    Clear Text Field    0
    Type Into Text Field    0    EXECUTE BLOCK AS BEGIN WHILE (1 = 1) DO BEGIN END end
    Push Button    execute-statement-command
    Sleep    2s
    Push Button    stop-execution-command
    Clear Text Field    0
    Check Tool

*** Keywords ***
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