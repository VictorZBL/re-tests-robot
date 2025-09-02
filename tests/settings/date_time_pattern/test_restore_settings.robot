*** Settings ***
Library    RemoteSwingLibrary
Resource   ../../../files/keywords.resource
Resource    keys.resource 
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_1
    Select From Main Menu    System|Preferences
    Select Dialog    Preferences
    Click On Tree Node    0    Result Set Table
    Sleep    2s
    ${row}=    Find Table Row    0    Date Pattern Format

    Clear Table Cell    0    ${row}    2
    Type Into Table Cell    0    ${row}    2    MM.yy
    Push Button    applyButton
    Close Dialog    Message
    Close Dialog    Preferences
    Select Main Window
    Select From Main Menu    System|Preferences
    Select Dialog    Preferences
    Click On Tree Node    0    Result Set Table
    Sleep    2s
    ${value}=    Get Table Cell Value    0    ${row}    2
    Should Be Equal As Strings   ${value}    MM.yy

    Push Button    restoreButton
    ${value}=    Get Table Cell Value    0    ${row}    2
    Should Be Equal As Strings   ${value}    dd.MM.yyyy