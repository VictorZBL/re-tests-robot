*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../../files/keywords.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_1
    Open connection
    Click On Tree Node   0    New Connection|Procedures (10)|DELETE_EMPLOYEE   2
    Uncheck Check Box    showHelpersCheck
    Run Keyword And Expect Error    Can't select tab: Variables because it doesn't contain any container.    Select Tab As Context    Variables
    Check Check Box    showHelpersCheck

test_2
    Open connection
    Click On Tree Node   0    New Connection|Procedures (10)|DELETE_EMPLOYEE   2
    Push Button    2
    Run Keyword And Expect Error    Can't select tab: Variables because it doesn't contain any container.    Select Tab As Context    Variables
    Push Button    2

test_3
    Open connection
    Click On Tree Node   0    New Connection|Procedures (10)|DELETE_EMPLOYEE   2
    Push Button    3
    Sleep    2s
    Push Button    2
    Sleep    2s