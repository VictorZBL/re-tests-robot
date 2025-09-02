*** Settings ***
Library    RemoteSwingLibrary
Resource    ../files/keywords.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests
 

*** Test Cases ***
test_1
    Select From Tree Node Popup Menu    0    New Connection    Duplicate connection
    Open connection
    Select From Menu    Tools|User Manager
    Select From Combo Box    databasesCombo    New Connection (Copy)
    Tree Node Should Not Be Leaf        0    New Connection (Copy)