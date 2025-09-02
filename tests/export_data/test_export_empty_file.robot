*** Settings ***
Library    RemoteSwingLibrary
Library    OperatingSystem
Resource    ../../files/keywords.resource
Resource    key.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_1
    Open connection
    Clear Text Field    0
    Insert Into Text Field    0    SELECT * FROM PROJECT
    Push Button    execute-script-command
    Sleep    1s  
    Select From Table Cell Popup Menu    0    0    0   Export|Table
    Select Dialog    Export Data
    Select From Combo Box    typeCombo    CSV
    Select From Combo Box    columnDelimiterCombo    ;
    Clear Text Field    filePathField
    Uncheck All Checkboxes
    Push Button    exportButton 
    Select Dialog    Warning
    Label Text Should Be    0    You must specify a file to export to.
    Push Button    OK
