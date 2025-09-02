*** Settings ***
Library    RemoteSwingLibrary
Library    OperatingSystem
Library    firebird.driver
Library    fdb
Library    platform
Resource   ../../files/keywords.resource 
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_extract
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
    
    Push Button    extract-metadata-command
    Select From Combo Box    dbTargetComboBox    New Connection 1
    Push Button    extractButton
    Sleep    5s
    Select Dialog    Message
    Run Keyword And Continue On Failure    Label Text Should Be    1    Objects to create - 0
    Close Dialog    Message
    Select Main Window
    

