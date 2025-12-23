*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../files/keywords.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_delete
    Init
    Run Keyword In Separate Thread    Select From Tree Node Popup Menu   0    New Connection|Domains (16)|TEST_DOMAIN    Delete domain
    Select Dialog    Commiting changes
    ${res}=    Get Text Field Value    0
    Should Be Equal As Strings    ${res}    DROP DOMAIN TEST_DOMAIN    strip_spaces=${True}    collapse_spaces=${True}
    Push Button    commitButton
    Select Main Window
    Tree Node Should Exist    0     New Connection|Domains (15)
    Tree Node Should Not Exist    0    New Connection|Domains (16)|TEST_DOMAIN
    Tree Node Should Not Exist    0    New Connection|Domains (15)|TEST_DOMAIN



*** Keywords ***
Init
    [Arguments]    ${name}=TEST_DOMAIN
    Lock Employee
    Execute Immediate    CREATE DOMAIN TEST_DOMAIN AS BIGINT
    Open connection
   