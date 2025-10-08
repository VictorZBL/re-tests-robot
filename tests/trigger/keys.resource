*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../files/keywords.resource

*** Keywords ***
Check Skip
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    ${srv_ver}=    Set Variable    ${info}[2]
    Skip If    ${{$ver == '2.6' or ($ver == '3' and $srv_ver == 'Firebird')}}

Popup Active
    [Arguments]    ${script}    ${trigger_type}
    Lock Employee
    Execute Immediate    ${script}
    Open connection
    Expand Tree Node    0    New Connection|${trigger_type}
    Select From Tree Node Popup Menu   0    New Connection|${trigger_type}|NEW_TRIGGER    Active|Disable
    ${result}=    Execute    SELECT RDB$TRIGGER_INACTIVE FROM RDB$TRIGGERS WHERE RDB$TRIGGER_NAME='NEW_TRIGGER'
    Check    [(1,)]
    
    Select From Tree Node Popup Menu   0    New Connection|${trigger_type}|NEW_TRIGGER    Active|Enable
    Check    [(0,)]

Check
    [Arguments]    ${expected_result}
    ${result}=    Execute    SELECT RDB$TRIGGER_INACTIVE FROM RDB$TRIGGERS WHERE RDB$TRIGGER_NAME='NEW_TRIGGER'
    Should Be Equal As Strings    ${result}    ${expected_result}