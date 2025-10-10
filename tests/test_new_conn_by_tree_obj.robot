*** Settings ***
Library    RemoteSwingLibrary
Library    Process
Library    Collections
Resource    ../files/keywords.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests
Suite Setup    Skip

*** Test Cases ***
test_1
    Create New Conn
    Select From Tree Node Popup Menu    0    New Connection 1    Connect
    Tree Node Should Not Be Leaf        0    New Connection 1

test_2
    Create New Conn
    Click On Tree Node              0    New Connection 1    2
    Tree Node Should Not Be Leaf    0    New Connection 1

*** Keywords ***
Create New Conn
    Push Button    new-connection-command
    Sleep    1s
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    IF    ${{$ver == '2.6'}}
        Select From Combo Box    serverCombo    Red Database (Firebird) 2.X
        Select From Combo Box    authCombo    Basic
    END
    Type Into Text Field    fileField    employee.fdb
    Type Into Text Field    userField    sysdba
    Type Into Text Field    passwordField    masterkey
    Check Check Box    Store Password
    Push Button    saveButton