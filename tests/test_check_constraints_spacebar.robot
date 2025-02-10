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
    Execute Immediate    CREATE TABLE NEW_TABLE_1(\"TEST COMMENT\" int)
    Open connection
    Click On Tree Node    0    New Connection|Tables (11)|NEW_TABLE_1    2   
    Select Tab As Context    Constraints
    Push Button    addConstraintButton
    Select Dialog    Create constraint
    Select From Combo Box    typesCombo    UNIQUE
    Click On List Item    0    TEST COMMENT    2
    Push Button    submitButton
    Select Dialog    dialog1
    Push Button    commitButton
    Select Window    regexp=^RDB.*
    Select Tab As Context    Constraints 
    ${row}=    Find Table Row    0    UNIQUE    Type
    Should Not Be Equal As Integers    ${row}    -1  