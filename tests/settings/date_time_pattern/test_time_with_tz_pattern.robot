*** Settings ***
Library    RemoteSwingLibrary
Resource   ../../../files/keywords.resource
Resource    keys.resource 
Test Setup       Setup
Test Teardown    Teardown

*** Test Cases ***
test_1
    Init table    TIME WITH TIME ZONE    15:35 +3:00 
    Set Pattern    Time with timezone Pattern Format    H:m x
    ${value}=    Test
    Should Be Equal As Strings    ${value}    15:35 +03

test_2
    Init table    TIME WITH TIME ZONE    15:35 +3:00 
    Set Pattern    Time with timezone Pattern Format    H:m X
    ${value}=    Test
    Should Be Equal As Strings    ${value}    15:35 +03

test_3
    Init table    TIME WITH TIME ZONE    15:35 +3:00 
    Set Pattern    Time with timezone Pattern Format    H:m XXX
    ${value}=    Test
    Should Be Equal As Strings    ${value}    15:35 +03:00

test_4
    Init table    TIME WITH TIME ZONE    15:35 +3:00 
    Set Pattern    Time with timezone Pattern Format    H:m O
    ${value}=    Test
    Should Be Equal As Strings    ${value}    15:35 GMT+3

test_5
    Init table    TIME WITH TIME ZONE    15:35 +3:00 
    Set Pattern    Time with timezone Pattern Format    'Time with TZ =' H:m XXX
    ${value}=    Test
    Should Be Equal As Strings    ${value}    Time with TZ = 15:35 +03:00

test_6
    Init table    TIME WITH TIME ZONE    15:35 +3:00 
    Set Pattern    Time with timezone Pattern Format    H:m XXX
    ${value}=    Check Query Editor
    Should Be Equal As Strings    ${value}    15:35 +03:00

test_7
    Init table    TIME WITH TIME ZONE    15:35 +3:00 
    Set Pattern    Time with timezone Pattern Format    'Time with TZ =' H:m x
    ${value}=    Check Query Editor
    Should Be Equal As Strings    ${value}    Time with TZ = 15:35 +03