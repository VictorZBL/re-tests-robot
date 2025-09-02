*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../files/keywords.resource
Resource    keys.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_1
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    Skip If    ${{$ver == '5.0'}}
    Open connection
    Select From Main Menu    Tools|Profiler
    Push Button    startButton
    Select Dialog    Warning
    Label Text Should Be    0    Unable to start profiler session
    Label Text Should Be    1    Connection does not support profiler utils.
    Push Button    OK
    