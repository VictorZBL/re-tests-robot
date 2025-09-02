*** Settings ***
Library    RemoteSwingLibrary
Resource   ../../../files/keywords.resource
Resource    keys.resource 
Test Setup       Setup before every tests
Test Teardown    Teardown

*** Test Cases ***
test_1
    Init table    DATE    15.01.2025
    Set Pattern    Date Pattern Format    y-M-d
    ${value}=    Test
    Should Be Equal As Strings    ${value}    2025-1-15
    
test_2
    Init table    DATE    05.01.0005
    Set Pattern    Date Pattern Format    y.d.M
    ${value}=    Test
    Should Be Equal As Strings    ${value}    5.5.1

test_3
    Init table    DATE    05.01.0005
    Set Pattern    Date Pattern Format   MMM/yyyy
    ${value}=    Test
    Should Be Equal As Strings    ${value}    Jan/0005

test_4
    Init table    DATE    05.01.2025
    Set Pattern    Date Pattern Format   ddMMMMyy
    ${value}=    Test
    Should Be Equal As Strings    ${value}    05January25

test_5
    Init table    DATE    05.01.2025
    Set Pattern    Date Pattern Format   ddLLLLyy
    ${value}=    Test
    Should Be Equal As Strings    ${value}    05January25

test_6
    Init table    DATE    05.02.0005
    Set Pattern    Date Pattern Format   dd.MM.yy D G
    ${value}=    Test
    Should Be Equal As Strings    ${value}    05.02.05 36 AD

test_7
    Init table    DATE    05.02.2025
    Set Pattern    Date Pattern Format   w W u
    ${value}=    Test
    Should Be Equal As Strings    ${value}    6 2 2025

test_8
    Init table    DATE    12.02.2025
    Set Pattern    Date Pattern Format   F E EEEE
    ${value}=    Test
    Should Be Equal As Strings    ${value}    2 Wed Wednesday

test_9
    Init table    DATE    05.02.2025
    Set Pattern    Date Pattern Format   e c
    ${value}=    Test
    Should Be Equal As Strings    ${value}    4 4

test_10
    Init table    DATE    05.07.2025
    Set Pattern    Date Pattern Format   q Q
    ${value}=    Test
    Should Be Equal As Strings    ${value}    3 3

test_11
    Init table    DATE    05.01.2025
    Set Pattern    Date Pattern Format   'Date =' dd.MMMM.yy G
    ${value}=    Test
    Should Be Equal As Strings    ${value}    Date = 05.January.25 AD

test_12
    Init table    DATE    05.01.2025
    Set Pattern    Date Pattern Format   dd.MMMM.yy G
    ${value}=    Check Query Editor
    Should Be Equal As Strings    ${value}    05.January.25 AD

test_13
    Init table    DATE    05.01.2025
    Set Pattern    Date Pattern Format   'Date =' dd.MMMM.yy G
    ${value}=    Check Query Editor
    Should Be Equal As Strings    ${value}    Date = 05.January.25 AD