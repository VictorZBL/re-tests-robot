# See RS-200882

*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../files/keywords.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests


*** Test Cases ***
test_execute
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    ${srv_ver}=    Set Variable    ${info}[2]
    Skip If    ${{not($ver == '5' and $srv_ver == 'RedDatabase')}}
    Lock Employee
    Open connection
    Sleep    2s
    Clear Text Field    0
    Select From Main Menu    Edit|Open file
    Select Dialog    Open
    ${script_path}=    Catenate    SEPARATOR=    ${EXECDIR}    /files/test_script_JSON_200882.sql
    Type Into Text Field    0    ${script_path}
    Push Button    Open
    Select Main Window
    Run Keyword In Separate Thread    Push Button    execute-script-command
    Sleep    5s
    ${value}=     Get Table Cell Value    0    0    0
    Should Be Equal As Strings    ${value}    83a40513-ecd3-1f52-b2eb-3c8bb9de94e5-7