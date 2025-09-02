*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../files/keywords.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_1
    Check Tool
    Push Button    editor-command
    Clear Text Field    0
    Type Into Text Field    0    releasehub on
    Push Button    execute-statement-command
    Clear Text Field    0
    Type Into Text Field    0    releasehub off
    Push Button    execute-statement-command
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