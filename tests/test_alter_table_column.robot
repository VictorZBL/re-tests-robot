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
    Execute Immediate    CREATE TABLE NEW_TABLE_1(PUBLIC int)
    Open connection
    Click On Tree Node    0    New Connection|Tables (11)|NEW_TABLE_1    2
    ${row}=    Find Table Row    0    PUBLIC    Name
    Run Keyword In Separate Thread     Click On Table Cell    0    ${row}    Name    2    BUTTON1_MASK
    Select Dialog    Edit table column
    Clear Text Field    nameField
    Type Into Text Field    nameField    TEST
    Push Button    submitButton
    Select Dialog    dialog1
    ${textFieldValue}=    Get Textfield Value    0
    Push Button      commitButton
    Select Window    regexp=^RDB.*
    ${row}=    Find Table Row    0    TEST    Name
    Should Not Be Equal As Integers    ${row}    -1  