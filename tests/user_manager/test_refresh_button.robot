*** Settings ***
Library    RemoteSwingLibrary
Library    Process
Library    Collections
Resource   ../../files/keywords.resource 
Test Setup       Setup before every tests
Test Teardown    Teardown

*** Test Cases ***
test_1
    Open connection
    Select From Menu        Tools|User Manager
    Sleep    2s
    Execute Immediate    CREATE USER TEST_REFRESH_USER PASSWORD 'pass'
    ${rowCount}=    Get Table Row Count    usersTable
    Should Be Equal As Integers    1    ${rowCount}
    Push Button    refreshButton
    Sleep    2s
    ${rowCount}=    Get Table Row Count    usersTable
    Should Be Equal As Integers    2    ${rowCount}

*** Keywords ***
Teardown
    Teardown after every tests
    Run Keyword And Ignore Error    Execute Immediate    DROP USER TEST_REFRESH_USER