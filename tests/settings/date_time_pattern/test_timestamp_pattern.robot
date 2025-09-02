*** Settings ***
Library    RemoteSwingLibrary
Resource   ../../../files/keywords.resource
Resource    keys.resource 
Test Setup       Setup before every tests
Test Teardown    Teardown

*** Test Cases ***
test_1
    Init table    TIMESTAMP    15.01.2025 15:35:43.180
    Set Pattern    Timestamp Pattern Format    y-M-d H-m-s-S
    ${value}=    Test
    Should Be Equal As Strings    ${value}    2025-1-15 15-35-43-1

test_2
    Init table    TIMESTAMP    05.01.0005 05:04:03.008
    Set Pattern    Timestamp Pattern Format    H/m/s/S y.d.M
    ${value}=    Test
    Should Be Equal As Strings    ${value}    5/4/3/0 5.5.1

test_3
    Init table    TIMESTAMP    05.01.0005 05:04:03.008
    Set Pattern    Timestamp Pattern Format    MMM/yyyy HH.mm.ss.SSS
    ${value}=    Test
    Should Be Equal As Strings    ${value}    Jan/0005 05.04.03.008

test_4
    Init table    TIMESTAMP    05.01.0005 05:04:03.008
    Set Pattern    Timestamp Pattern Format    dd.MM.yy G HH:mm a
    ${value}=    Test
    Should Be Equal As Strings    ${value}    05.01.05 AD 05:04 AM

test_5
    Init table    TIMESTAMP    05.02.2025 15:43
    Set Pattern    Timestamp Pattern Format    E EEEE KK:mm a
    ${value}=    Test
    Should Be Equal As Strings    ${value}    Wed Wednesday 03:43 PM

test_6
    Init table    TIMESTAMP    05.01.0005 05:04:03.008
    Set Pattern    Timestamp Pattern Format    'Timestamp =' dd.MM.yy G HH:mm a
    ${value}=    Test
    Should Be Equal As Strings    ${value}    Timestamp = 05.01.05 AD 05:04 AM

test_7
    Init table    TIMESTAMP    05.01.0005 05:04:03.008
    Set Pattern    Timestamp Pattern Format    dd.MMM.yy G HH:mm a
    ${value}=    Check Query Editor
    Should Be Equal As Strings    ${value}    05.Jan.05 AD 05:04 AM

test_8
    Init table    TIMESTAMP    05.01.0005 05:04:03.008
    Set Pattern    Timestamp Pattern Format    'Timestamp =' dd.MM.yy G HH:mm a
    ${value}=    Check Query Editor
    Should Be Equal As Strings    ${value}    Timestamp = 05.01.05 AD 05:04 AM