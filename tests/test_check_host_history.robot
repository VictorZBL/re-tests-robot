*** Settings ***
Library    RemoteSwingLibrary
Library    OperatingSystem
Resource    ../files/keywords.resource
Test Teardown    Teardown after every tests

*** Test Cases ***
test_1
    ${path}=    Setup
    File Should Exist    ${path}
    ${content}=    Get File    ${path}
    Should Be Equal As Strings    ${content}    localhost
    Remove File    ${path}

test_2
    ${path}=    Setup
    Add Hosts
    ${content}=    Get File    ${path}
    Should Be Equal As Strings    ${content}    127.0.0.1\nhost\nlocalhost
    Remove File    ${path}
    
test_3
    ${path}=    Setup
    ${selected}=    Get Selected Item From Combo Box    hostCombo
    Should Be Equal As Strings    ${selected}    localhost
    Add Hosts
    @{value}=    Get Combobox Values    hostCombo
    Should Be Equal As Strings    ${value}    ['127.0.0.1', 'host', 'localhost']
    Select From Combo Box    hostCombo    127.0.0.1
    ${selected}=    Get Selected Item From Combo Box    hostCombo
    Should Be Equal As Strings    ${selected}    127.0.0.1
    Remove File    ${path}

test_count_hosts_default
    ${path}=    Setup
    Check hosts count   ${path}     127.1.1.3\n127.1.1.2\n127.1.1.1\nhost2

test_count_hosts_max
    ${path}=    Set Count Hosts    9
    Check hosts count   ${path}     127.1.1.3\n127.1.1.2\n127.1.1.1\nhost2\nhost4\nhost3\nhost0\n127.0.0.1\nhost
    Restore Hosts Count

test_count_hosts_min
    ${path}=    Set Count Hosts    1
    Check hosts count   ${path}     127.1.1.3
    Restore Hosts Count

*** Keywords ***
Setup
    ${path}=    Get Hosts History File
    Remove File    ${path}
    Setup before every tests
    Select From Tree Node Popup Menu    0    New Connection    Duplicate connection
    Sleep   2s
    Select From Tree Node Popup Menu    0    New Connection (Copy)    Connection properties
    Sleep   2s
    RETURN    ${path}

Add Hosts
    Type Into Combobox    hostCombo    localhost231
    Type Into Combobox    hostCombo    host
    Push Button    saveButton
    Type Into Combobox    hostCombo    127.0.0.1
    Push Button    saveButton

Add More Hosts
    Type Into Combobox    hostCombo    host0
    Push Button    saveButton
    Type Into Combobox    hostCombo    host3
    Push Button    saveButton
    Type Into Combobox    hostCombo    host4
    Push Button    saveButton
    Type Into Combobox    hostCombo    host2
    Push Button    saveButton
    Type Into Combobox    hostCombo    127.1.1.1
    Push Button    saveButton
    Type Into Combobox    hostCombo    127.1.1.2
    Push Button    saveButton
    Type Into Combobox    hostCombo    127.1.1.3
    Push Button    saveButton

Set Count Hosts
    [Arguments]    ${count}
    ${path}=    Get Hosts History File
    Remove File    ${path}
    Setup before every tests
    Select From Main Menu    System|Preferences
    Select Dialog    Preferences
    Click On Tree Node    0    General
    Sleep    1s
    ${row}=    Find Table Row    0    Recent hosts to store
    Type Into Table Cell    0    ${row}    2    ${count}
    Push Button    applyButton
    Close Dialog    Message
    Close Dialog    Preferences
    Select Main Window
    Select From Tree Node Popup Menu    0    New Connection    Duplicate connection
    Sleep   2s
    Select From Tree Node Popup Menu    0    New Connection (Copy)    Connection properties
    Sleep   2s
    RETURN    ${path}

Check hosts count
    [Arguments]    ${path}    ${expected_content}
    Add Hosts
    Add More Hosts
    ${content}=    Get File    ${path}
    Should Be Equal As Strings    ${content}    ${expected_content}
    Remove File    ${path}

Restore Hosts Count
    Select From Main Menu    System|Preferences
    Select Dialog    Preferences
    Push Button    restoreButton
    Click On Tree Node    0    General
    Sleep    1s
    ${row}=    Find Table Row    0    Recent hosts to store
    ${value}=   Get Table Cell Value    0    ${row}    2
    Should Be Equal As Integers    ${value}    4
    Push Button    OK
    Select Dialog    Message
    Push Button    OK