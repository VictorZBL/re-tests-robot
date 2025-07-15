*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../files/keywords.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_grant_privileges
    Lock Employee
    Execute Immediate    CREATE ROLE NEW_ROLE
    Open connection 
    Click On Tree Node    0    New Connection|Roles (1)|NEW_ROLE    2 
    Select From Tree Node Popup Menu    0    New Connection|Roles (1)|NEW_ROLE   Edit role
    Select Tab As Context    Privileges
    Click On Table Cell     0    0    Select 
    Push Button    Grant all privileges to selected column
    Select Main Window 
    Push Button    Apply

test_add_comment
    Lock Employee
    Execute Immediate    CREATE ROLE NEW_ROLE
    Open connection 
    Click On Tree Node    0    New Connection|Roles (1)|NEW_ROLE    2 
    Select From Tree Node Popup Menu    0    New Connection|Roles (1)|NEW_ROLE   Edit role
    Select Tab As Context    Comment
    Clear Text Field    0
    Type Into Text Field    0    test_comment 
    Select Main Window 
    Push Button    Apply
    Select Dialog    Commiting changes
    Push Button    commitButton