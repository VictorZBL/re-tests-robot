*** Settings ***
Library    RemoteSwingLibrary
Library    Process
Library    Collections
Resource   ../../files/keywords.resource 
Test Setup       Setup before every tests
Test Teardown    Teardown

*** Test Cases ***
test_1
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    Skip If    ${{$ver == '2.6'}}
    Execute Immediate    CREATE USER TEST_USER PASSWORD 'pass'
    Open connection
    Select From Menu        Tools|User Manager
    Sleep    1s
    ${row}=    Find Table Row    usersTable    TEST_USER    User name
    Select Table Cell    usersTable    ${row}    User name
    Push Button    editUserButton
    Select Dialog    Edit user
    Type Into Text Field    firstNameField     first
    Type Into Text Field    middleNameField    middle
    Type Into Text Field    lastNameField      last
    Select Tab    Comment
    Type Into Text Field    0    description
    Push Button      submitButton
    Select Dialog    Commiting changes
    Push Button      commitButton
    ${result}=    Execute    select cast(sec$user_name as VARCHAR(9)), sec$first_name, sec$middle_name, sec$last_name, sec$active, sec$admin, sec$description, cast(sec$plugin as VARCHAR(3)) from sec$users where sec$user_name='TEST_USER'
    Should Be Equal    ${result}    [('TEST_USER', 'first', 'middle', 'last', True, False, None, 'Srp')]

*** Keywords ***
Teardown
    Teardown after every tests
    Run Keyword And Ignore Error    Execute Immediate    DROP USER TEST_USER