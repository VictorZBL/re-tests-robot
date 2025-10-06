*** Settings ***
Library    RemoteSwingLibrary
Resource   ../../../files/keywords.resource
Resource    keys.resource 
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_1
    Test    Date Pattern Format    date

test_2
    Test    Time Pattern Format    time

test_3
    Test    Timestamp Pattern Format    timestamp

test_4
    Check Skip
    Test    Time with timezone Pattern Format     zoned time

test_5
    Check Skip
    Test    Timestamp with timezone Pattern Format    zoned timestamp

*** Keywords ***
Test
    [Arguments]    ${pattern_name}    ${name}
    Select From Main Menu    System|Preferences
    Select Dialog    Preferences
    Click On Tree Node    0    Result Set Table
    Sleep    2s
    ${row}=    Find Table Row    0    ${pattern_name}

    Clear Table Cell    0    ${row}    2
    Type Into Table Cell    0    ${row}    2    aaaa

    Push Button    OK

    Select Dialog    Warning
    Label Text Should Be    0    Invalid ${name} format: aaaa
    Label Text Should Be    1    Changes will reversed
    Push Button    OK

Check Skip
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    Skip If    ${{$ver != '5'}}