*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../../files/keywords.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_1
    Open connection
    Click On Tree Node   0    New Connection|Procedures (10)|SHOW_LANGS    2
    Select Tab As Context    Privileges
    Select Tab As Context    User->Objects
    Select Main Window
    Select Tab As Context    Privileges
    Select Tab As Context    Object->Users
