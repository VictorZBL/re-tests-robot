*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../files/keywords.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests


*** Test Cases ***
test_sql_script
    Run Script    execute-script-command

test_single_statement
    Check Tool
    Run Script    execute-statement-command
    [Teardown]    Check Tool

*** Keywords ***
Select Driver
    [Arguments]    ${driver}
    Select From Tree Node Popup Menu    0    New Connection    Connection properties
    Select From Combo Box    driverCombo    ${driver}

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

Run Script
    [Arguments]    ${button}
    Select Driver    Jaybird 5 Driver
    Open connection
    Clear Text Field    0
    Type Into Text Field    0    SELECT * FROM EMPLOYEE;
    Push Button    ${button}
    Sleep    1s
    Select Driver    Jaybird 4 Driver