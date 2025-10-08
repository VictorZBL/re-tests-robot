*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../../files/keywords.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_1
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    Skip If    ${{$ver != '5'}}
    Lock Employee
    ${create_procudere_script}=     Build Procedure
    Open connection
    Click On Tree Node   0    New Connection|Procedures (11)|DECLARE_KEYWORDS   2
    ${ddl}=    Get Text Field Value    1
    Should Be Equal As Strings    ${ddl}    ${create_procudere_script}    strip_spaces=${True}    collapse_spaces=${True}