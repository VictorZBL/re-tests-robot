*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../files/keywords.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_execute_sql
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    ${srv_ver}=    Set Variable    ${info}[2]
    Skip If    ${{not($ver == '5' and $srv_ver == 'RedDatabase')}}
    Lock Employee
    Open connection
    Clear Text Field    0
    Type Into Text Field    0    recreate PROCEDURE SUMM \n(A INTEGER, B INTEGER ) \nRETURNS(C INTEGER) \nAS BEGIN c = a + b; SUSPEND; END; \n\n call SUMM(?,?, c => ?);\n
    Push Button    execute-script-command
    Select Dialog    Input parameters
    Type Into Text Field    0    2
    Type Into Text Field    1    5
    Push Button     OK
    Select Main Window
    Sleep    1s
    Push Button    execute-script-command
    Select Dialog    Input parameters
    ${value1}=    Get Text Field Value    0
    ${value2}=    Get Text Field Value    1
    Clear Text Field    0
    Type Into Text Field    0    4321
    Clear Text Field    1
    Type Into Text Field    1    4321
    Push Button     OK
    Should Be Equal As Strings    ${value1}    2
    Should Be Equal As Strings    ${value2}    5