*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../files/keywords.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_1
    Check Skip
    Lock Employee
    Open connection
    Clear Text Field    0
    Type Into Text Field    0    SELECT * FROM COUNTRY;
    Push Button    execute-in-profiler-command
    Sleep    3s
    Push Button    discardButton

test_2
    Check Skip
    Lock Employee
    Open connection
    Clear Text Field    0
    Type Into Text Field    0    SELECT * FROM 123;
    Push Button    execute-in-profiler-command
    Sleep    3s
    Close Dialog    Warning

test_3
    Check Skip
    Lock Employee
    Open connection
    Clear Text Field    0
    Type Into Text Field    0    SELECT * FROM 123;
    Push Button    execute-in-profiler-command
    Sleep    0.5s
    Push Button    stop-execution-command

*** Keywords ***
Check Skip
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    Skip If    ${{$ver != '5.0'}}