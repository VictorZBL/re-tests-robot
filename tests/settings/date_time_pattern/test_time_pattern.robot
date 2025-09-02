*** Settings ***
Library    RemoteSwingLibrary
Resource   ../../../files/keywords.resource
Resource    keys.resource 
Test Setup       Setup before every tests
Test Teardown    Teardown

*** Test Cases ***
test_1
    Init table    TIME    15:35:43.18
    Set Pattern    Time Pattern Format    H-m-s-S
    ${value}=    Test
    Should Be Equal As Strings    ${value}    15-35-43-1

test_2
    Init table    TIME    05:04:03.008
    Set Pattern    Time Pattern Format    H/m/s/S
    ${value}=    Test
    Should Be Equal As Strings    ${value}    5/4/3/0

test_3
    Init table    TIME    05:04:03.008
    Set Pattern    Time Pattern Format    HH.mm.ss.SSS
    ${value}=    Test
    Should Be Equal As Strings    ${value}    05.04.03.008

test_4
    Init table    TIME    05:04
    Set Pattern    Time Pattern Format    HH:mm a
    ${value}=    Test
    Should Be Equal As Strings    ${value}    05:04 AM

test_5
    Init table    TIME    15:43
    Set Pattern    Time Pattern Format    HH:mm a
    ${value}=    Test
    Should Be Equal As Strings    ${value}    15:43 PM

test_6
    Init table    TIME    00:04
    Set Pattern    Time Pattern Format    HH:mm
    ${value}=    Test
    Should Be Equal As Strings    ${value}    00:04

test_7
    Init table    TIME    00:04
    Set Pattern    Time Pattern Format    kk:mm
    ${value}=    Test
    Should Be Equal As Strings    ${value}    24:04

test_8
    Init table    TIME    05:04
    Set Pattern    Time Pattern Format    KK:mm a
    ${value}=    Test
    Should Be Equal As Strings    ${value}    05:04 AM

test_9
    Init table    TIME    15:43
    Set Pattern    Time Pattern Format    KK:mm a
    ${value}=    Test
    Should Be Equal As Strings    ${value}    03:43 PM

test_10
    Init table    TIME    00:04
    Set Pattern    Time Pattern Format    KK:mm
    ${value}=    Test
    Should Be Equal As Strings    ${value}    00:04

test_11
    Init table    TIME    00:04
    Set Pattern    Time Pattern Format    hh:mm
    ${value}=    Test
    Should Be Equal As Strings    ${value}    12:04

test_12
    Init table    TIME    15:04
    Set Pattern    Time Pattern Format    B
    ${value}=    Test
    Should Be Equal As Strings    ${value}    in the afternoon

test_13
    Init table    TIME    05:04
    Set Pattern    Time Pattern Format    B
    ${value}=    Test
    Should Be Equal As Strings    ${value}    at night

test_14
    Init table    TIME    11:00
    Set Pattern    Time Pattern Format    B
    ${value}=    Test
    Should Be Equal As Strings    ${value}    in the morning

test_15
    Init table    TIME    23:00
    Set Pattern    Time Pattern Format    B
    ${value}=    Test
    Should Be Equal As Strings    ${value}    at night

test_16
    Init table    TIME    00:04:
    Set Pattern    Time Pattern Format    A n N
    ${value}=    Test
    Should Be Equal As Strings    ${value}    240000 0 240000000000

test_17
    Init table    TIME    01:04
    Set Pattern    Time Pattern Format    mmppH
    ${value}=    Test
    Should Be Equal As Strings    ${value}    04 1

test_18
    Init table    TIME    15:04
    Set Pattern    Time Pattern Format    mmppH
    ${value}=    Test
    Should Be Equal As Strings    ${value}    0415

test_19
    Init table    TIME    05:04:03.008
    Set Pattern    Time Pattern Format    'Time =' HH mm ss SSS
    ${value}=    Test
    Should Be Equal As Strings    ${value}    Time = 05 04 03 008

test_20
    Init table    TIME    05:04:03.008
    Set Pattern    Time Pattern Format    HH:mm:ss:SSS a
    ${value}=    Check Query Editor
    Should Be Equal As Strings    ${value}    05:04:03:008 AM

test_21
    Init table    TIME    05:04:03.008
    Set Pattern    Time Pattern Format    'Time =' HH mm ss SSS
    ${value}=    Check Query Editor
    Should Be Equal As Strings    ${value}    Time = 05 04 03 008
