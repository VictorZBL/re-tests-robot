*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../files/keywords.resource
Test Setup       Setup
Test Teardown    Teardown after every tests

*** Test Cases ***
test_search
    Type Into Text Field    textField    Tools
    @{names1}=    Get Tree Node Child Names    navigationTree
    @{names2}=    Get Tree Node Child Names    navigationTree    Tool Bar
    Should Be Equal As Strings    ${names1}    ['Editor', 'Tool Bar']
    Should Be Equal As Strings    ${names2}    ['Database Tools', 'Application Tools', 'System Tools', 'Query Editor Tools']

test_inside_search
    Type Into Text Field    textField    All
    @{names1}=    Get Tree Node Child Names    navigationTree
    @{names2}=    Get Tree Node Child Names    navigationTree    Tool Bar
    Should Be Equal As Strings    ${names1}    ['Shortcuts', 'Connection', 'Editor', 'Tool Bar']
    Should Be Equal As Strings    ${names2}    ['Database Tools', 'Query Editor Tools']

    Click On Tree Node    navigationTree    Shortcuts
    ${row}=    Find Table Row     shortcutsTable    Rollback all changes    Command
    Should Not Be Equal As Integers    ${row}    -1

    Click On Tree Node    navigationTree    Connection
    ${row}=    Find Table Row     0    Sort alphabetically    1
    Should Not Be Equal As Integers    ${row}    -1

    Click On Tree Node    navigationTree    Editor
    ${row}=    Find Table Row     0    Print all SQL to output panel    1
    Should Not Be Equal As Integers    ${row}    -1

    Click On Tree Node    navigationTree    Tool Bar|Database Tools
    @{values}=    Get Table Column Values    0    2
    Should Be Equal As Strings   ${values}    ['Connect All', 'Disconnect All']

    Click On Tree Node    navigationTree    Tool Bar|Query Editor Tools
    @{values}=    Get Table Column Values    0    2
    Should Be Equal As Strings   ${values}    ['Rollback all changes']


test_clear
    Type Into Text Field    textField    Tools
    Push Button    clearButton
    ${value}=    Get Text Field Value    textField
    Should Be Equal As Strings    ${value}    ${EMPTY}
    @{names}=    Get Tree Node Child Names    navigationTree
    Should Be Equal As Strings    ${names}    ['General', 'Display', 'Shortcuts', 'SQL Shortcuts', 'Connection', 'Editor', 'Result Set Table', 'Tool Bar', 'Fonts', 'Colours']

test_no_find
    Type Into Text Field    textField    aaaaaa
    @{names}=    Get Tree Node Child Names    navigationTree
    Should Be Equal As Strings   ${names}    []
    Label Text Should Be    1    No matches found

*** Keywords ***
Setup
    Setup before every tests
    Select From Main Menu    System|Preferences
    Select Dialog    Preferences
    Clear Text Field    textField
    
