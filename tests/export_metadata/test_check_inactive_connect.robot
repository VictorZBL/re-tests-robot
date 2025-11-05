*** Settings ***
Library    RemoteSwingLibrary
Resource   ../../files/keywords.resource 
Test Setup       Init
Test Teardown    Teardown after every tests


*** Test Cases ***
test_extract
    Push Button    extract-metadata-command
    Select From Combo Box    dbTargetComboBox    New Connection 1
    Push Button    extractButton
    Select Dialog    Warning
    Label Text Should Be    0    Unable to compare.
    Label Text Should Be    1    Connection is inactive.

test_compare
    Push Button    comparerDB-command
    Push Button    selectAllAttributesButton
    Select From Combo Box    dbTargetComboBox    New Connection 1
    Push Button    compareButton
    Select Dialog    Warning
    Label Text Should Be    0    Unable to compare.
    Label Text Should Be    1    At least one of the connections is inactive.

*** Keywords ***
Init
    Setup before every tests
    Push Button    new-connection-command
    Clear Text Field    portField
    Type Into Text Field    fileField    employee.fdb
    Type Into Text Field    userField    sysdba
    Type Into Text Field    passwordField    masterkey
    Push Button    saveButton