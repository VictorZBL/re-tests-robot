*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../files/keywords.resource
Resource    keys.resource
Test Setup       Setup
Test Teardown    Teardown after every tests

*** Test Cases ***
test_start
    Test    startButton
    
test_select
    Test    attachmentButton
    
*** Keywords ***
Test
    [Arguments]    ${button}
    Select From Main Menu    Tools|Profiler
    Push Button    ${button}
    Select Dialog    Warning
    Label Text Should Be    0    Selected connection is unavailable.
    Push Button    OK
    