*** Settings ***
Library    RemoteSwingLibrary
Library    firebird.driver
Library    fdb
Library    platform
Library    OperatingSystem
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
    Run Keyword And Continue On Failure    Label Text Should Be    1    At least one of the connections is inactive.


test_switch_database
    ${test_base_path}=     Catenate    SEPARATOR=    ${TEMPDIR}    /test.fdb
    Remove File   ${test_base_path}
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    IF    $ver != '2.6'
        firebird.driver.Create Database    database=${test_base_path}    user=SYSDBA    password=masterkey
    ELSE
        ${home}=     Set Variable    ${info}[0]
        ${system}    platform.System
        ${fd_lib}    Set Variable If    '${system}' == 'Linux'    lib/libfbclient.so    bin/fbclient.dll
        fdb.Load Api    ${home}${fd_lib}
        fdb.Create Database    database=${test_base_path}    user=SYSDBA    password=masterkey
    END
    Create Connect    ${test_base_path}    ${ver}
    Select Main Window
    Push Button    comparerDB-command
    Select From Combo Box    dbMasterComboBox    New Connection 1
    Push Button    selectAllAttributesButton
    Check Compare DB    Objects to create - 59    Objects to drop - 0
    Select Main Window
    Push Button    switchTargetSourceButton
    Check Compare DB    Objects to create - 0    Objects to drop - 59

*** Keywords ***
Create Connect
    [Arguments]    ${test_base_path}    ${ver}
    Select Main Window
    Push Button    new-connection-command
    Sleep    1s
    IF    ${{$ver == '2.6'}}
        Select From Combo Box    serverCombo    Red Database (Firebird) 2.X
        Select From Combo Box    authCombo    Basic
    END
    Type Into Text Field    fileField    ${test_base_path}
    Type Into Text Field    userField    sysdba
    Type Into Text Field    passwordField    masterkey
    Check Check Box    Store Password

Check Compare DB
    [Arguments]    ${label_create}    ${label_drop}    
    Push Button    compareButton
    Sleep    2s
    Select Dialog    Message
    Run Keyword And Continue On Failure    Label Text Should Be    1    ${label_create}
    Run Keyword And Continue On Failure    Label Text Should Be    2    Objects to alter - 0
    Run Keyword And Continue On Failure    Label Text Should Be    3    ${label_drop}
    Sleep    2s
    Close Dialog    Message