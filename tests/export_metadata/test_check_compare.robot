*** Settings ***
Library    RemoteSwingLibrary
Library    firebird.driver
Resource   ../../files/keywords.resource 
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_same_compare
    Push Button    comparerDB-command
    Push Button    compareButton
    Select Dialog    Warning
    Run Keyword And Continue On Failure    Label Text Should Be    0    Unable to compare.
    Run Keyword And Continue On Failure    Label Text Should Be    1    The same connections selected.

test_check_warning
    Push Button    new-connection-command
    Push Button    comparerDB-command
    Select From Combo Box    dbMasterComboBox    New Connection 1
    Push Button    selectAllPropertiesButton
    Push Button    selectAllPropertiesButton
    Push Button    compareButton
    Select Dialog    Warning
    Run Keyword And Continue On Failure    Label Text Should Be    0    Unable to compare.
    Run Keyword And Continue On Failure    Label Text Should Be    1    No properties for comparing selected.


test_switch_database
    ${test_base_path}=     Catenate    SEPARATOR=    ${TEMPDIR}    /test.fdb
    @{files}=    Create List    ${test_base_path}
    Delete Files    ${files}
    firebird.driver.Create Database    database=${test_base_path}    user=SYSDBA    password=masterkey
    Create Connect    ${test_base_path}
    Select Window    regexp=^RDB.*
    Push Button    comparerDB-command
    Select From Combo Box    dbMasterComboBox    New Connection 1
    Push Button    selectAllAttributesButton
    Check Compare DB    Objects to create - 59    Objects to drop - 0
    Select Window    regexp=^RDB.*
    Push Button    switchTargetSourceButton
    Check Compare DB    Objects to create - 0    Objects to drop - 59

*** Keywords ***
Create Connect
    [Arguments]    ${test_base_path}
    Select Window    regexp=^RDB.*
    Push Button    new-connection-command
    Sleep    1s
    Type Into Text Field    3    ${test_base_path}
    Type Into Text Field    5    sysdba
    Type Into Text Field    6    masterkey
    Check Check Box    Store Password

Check Compare DB
    [Arguments]    ${label_create}    ${label_drop}    
    Push Button    compareButton
    Sleep    2s
    Select Dialog    Message
    Run Keyword And Continue On Failure    Label Text Should Be    1    ${label_create}
    Run Keyword And Continue On Failure    Label Text Should Be    2    ${label_drop}
    Run Keyword And Continue On Failure    Label Text Should Be    3    Objects to alter - 0
    Sleep    2s
    Close Dialog    Message