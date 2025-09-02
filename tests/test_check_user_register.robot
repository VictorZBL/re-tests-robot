*** Settings ***
Library    RemoteSwingLibrary
Library    Process
Library    Collections
Resource    ../files/keywords.resource
Test Setup       Setup before every tests
Test Teardown    Teardown

*** Test Cases ***
test_1
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    Skip If    ${{$ver == '2.6'}}
    Execute Immediate    CREATE USER "DEMO" PASSWORD 'pass'
    Execute Immediate    CREATE USER "dEmO" PASSWORD 'pass'
    Open connection
    Expand Tree Node    0    New Connection
    ${res1}=    Check user    DEMO    
    Select Window    regexp=^Red.*
    ${res2}=    Check user    dEmO    
    Should Be Equal    ${res1}    CREATE USER DEMO ACTIVE USING PLUGIN Srp;\n      collapse_spaces=True
    Should Be Equal    ${res2}    CREATE USER "dEmO" ACTIVE USING PLUGIN Srp;\n      collapse_spaces=True
    
*** Keywords ***
Check user
    [Arguments]     ${type}  
    Select From Tree Node Popup Menu    0    New Connection|Users (3)|${type}    Edit user
    Select Tab    DDL to create
    ${res}=    Get Text Field Value    1
    RETURN    ${res}

Teardown
    Teardown after every tests
    Run Keyword And Ignore Error    Execute Immediate    DROP USER "DEMO"
    Run Keyword And Ignore Error    Execute Immediate    DROP USER "dEmO"