*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../files/keywords.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests


*** Test Cases ***
test_execute_sql_script
    Init
    Push Button    execute-script-command

test_execute_statement
    Check Tool
    Init
    Push Button    execute-statement-command
    Check Tool

test_execute_in_profiler
    Init
    Push Button    execute-in-profiler-command

*** Keywords ***
Init
    Push Button    editor-command
    Clear Text Field    0
    Type Into Text Field    0    SELECT * FROM COUNTRY;

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