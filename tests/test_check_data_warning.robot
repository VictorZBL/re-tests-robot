*** Settings ***
Library    RemoteSwingLibrary
Library    Process
Library    Collections
Resource    ../files/keywords.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_1
    Lock Employee
    Execute Immediate    CREATE TABLE NEW_TABLE_1(TEST_COL int)
    Open connection
    Click On Tree Node    0    New Connection|Tables (11)|NEW_TABLE_1    2   
    Select Tab As Context    Data
    Sleep    2s
    Push Button    0
    Sleep    1s
    Push Button    2
    Sleep    1s
    Click On Table Cell    0    0    TEST_COL
    Push Button    1
    Select Main Window
    Run Keyword In Separate Thread     Select Tab    Constraints    ${EMPTY}
    List Dialogs
    Select Dialog    Confirmation
    Push Button    Yes