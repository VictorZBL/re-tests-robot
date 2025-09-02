*** Settings ***
Library    RemoteSwingLibrary
Resource   ../../../files/keywords.resource
Resource    keys.resource 
Test Setup       Setup
Test Teardown    Teardown

*** Test Cases ***
test_1
    Init table    TIMESTAMP WITH TIME ZONE   15.01.2025 15:35:43.180 +3:00
    Set Pattern    Timestamp with timezone Pattern Format    y-M-d H-m-s-S x
    ${value}=    Test
    Should Be Equal As Strings    ${value}    2025-1-15 15-35-43-1 +03

test_2
    Init table    TIMESTAMP WITH TIME ZONE    05.01.0005 05:04:03.008 +3:00
    Set Pattern    Timestamp with timezone Pattern Format    H/m/s/S y.d.M X
    ${value}=    Test
    Should Be Equal As Strings    ${value}    5/4/3/0 5.5.1 +03

test_3
    Init table    TIMESTAMP WITH TIME ZONE    05.01.0005 05:04:03.008 +3:00
    Set Pattern    Timestamp with timezone Pattern Format    MMM/yyyy HH.mm.ss.SSS XXX
    ${value}=    Test
    Should Be Equal As Strings    ${value}    Jan/0005 05.04.03.008 +03:00

test_4
    Init table    TIMESTAMP WITH TIME ZONE    05.01.0005 05:04:03.008 +3:00
    Set Pattern    Timestamp with timezone Pattern Format    dd.MM.yy G HH:mm a XX
    ${value}=    Test
    Should Be Equal As Strings    ${value}    05.01.05 AD 05:04 AM +0300

test_5
    Init table    TIMESTAMP WITH TIME ZONE    05.02.2025 15:43 +3:00
    Set Pattern    Timestamp with timezone Pattern Format    E EEEE KK:mm X a
    ${value}=    Test
    Should Be Equal As Strings    ${value}    Wed Wednesday 03:43 +03 PM

test_6
    Init table    TIMESTAMP WITH TIME ZONE    05.02.2025 15:43:03.008 +3:00
    Set Pattern    Timestamp with timezone Pattern Format   MMM/yyyy HH.mm.ss.SSS O
    ${value}=    Test
    Should Be Equal As Strings    ${value}    Feb/2025 15.43.03.008 GMT+3

test_7
    Init table    TIMESTAMP WITH TIME ZONE    05.01.0005 05:04:03.008 +3:00
    Set Pattern    Timestamp with timezone Pattern Format    'Timestamp with TZ =' dd.MM.yy G HH:mm a XX
    ${value}=    Test
    Should Be Equal As Strings    ${value}    Timestamp with TZ = 05.01.05 AD 05:04 AM +0300

test_8
    Init table    TIMESTAMP WITH TIME ZONE    05.01.0005 05:04:03.008 +3:00
    Set Pattern    Timestamp with timezone Pattern Format    dd.MMM.yy G HH:mm a XX
    ${value}=    Check Query Editor
    Should Be Equal As Strings    ${value}    05.Jan.05 AD 05:04 AM +0300

test_9
    Init table    TIMESTAMP WITH TIME ZONE    05.01.0005 05:04:03.008 +3:00
    Set Pattern    Timestamp with timezone Pattern Format    'Timestamp with TZ =' dd.MM.yy G HH:mm a XX
    ${value}=    Check Query Editor
    Should Be Equal As Strings    ${value}    Timestamp with TZ = 05.01.05 AD 05:04 AM +0300