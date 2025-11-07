*** Settings ***
Library    RemoteSwingLibrary
Library    OperatingSystem
Resource    ../files/keywords.resource
Test Setup       Setup before every tests
Test Teardown    Teardown

*** Variables ***
${db_path}

*** Test Cases ***
test_1
    Push Button    create-database-command
    Type Into Text Field    nameField    New Database
    Set Test Variable    ${db_path}    ${TEMPDIR}${/}test_database.fdb
    Remove File    ${db_path}
    Type Into Text Field    fileField    ${db_path}
    Type Into Text Field    userField    SYSDBA
    Type Into Text Field    passwordField    masterkey
    Push Button    createButton
    Select Dialog    Database Registration
    Push Button    Yes
    Select Main Window
    Tree Node Should Exist    0    New Database
    File Should Exist    ${db_path}

*** Keywords ***
Teardown
    Remove File    ${db_path}
    Teardown after every tests