*** Settings ***
Library    RemoteSwingLibrary
Library    Process
Library    Collections
Resource    ../files/keywords.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_1
    Select From Tree Node Popup Menu    0    New Connection    Duplicate connection
    Click On Tree Node    0    New Connection    1
    Select From Table Cell Popup Menu    0    0    0    Connections properties    
    Button Should Exist    Connect