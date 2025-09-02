*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../../files/keywords.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_open_About
    Set Shortcut    About
    Send Keyboard Event    VK_Q    	CTRL_MASK
    Close Dialog    About

test_open_update
    Set Shortcut    Check for Update
    Send Keyboard Event    VK_Q    	CTRL_MASK
    Sleep    2s
    Dialog Should Not Be Open    Check for update
    # Select Dialog    Check for update

test_open_compare_db
    Set Shortcut    Compare database metadata
    Send Keyboard Event    VK_Q    	CTRL_MASK
    Sleep    2s
    Component Should Exist    compareButton

test_open_create_db
    Set Shortcut    Create Database
    Send Keyboard Event    VK_Q    	CTRL_MASK
    Sleep    5s
    Component Should Exist    nameField

test_open_data_generator
    Set Shortcut    Data Generator
    Open connection
    Send Keyboard Event    VK_Q    	CTRL_MASK
    Sleep    2s
    Component Should Exist    startButton

test_open_db_stat
    Set Shortcut    Database Statistic
    Send Keyboard Event    VK_Q    	CTRL_MASK
    Sleep    2s
    Component Should Exist    getStatButton

test_open_drivers
    Set Shortcut    Drivers
    Send Keyboard Event    VK_Q    	CTRL_MASK
    Sleep    2s
    Component Should Exist    addDriverButton

test_open_erd
    Set Shortcut    ER-diagram editor
    Send Keyboard Event    VK_Q    	CTRL_MASK
    Sleep    2s
    Component Should Exist    createTableButton

test_open_extract_md
    Set Shortcut    Extract database metadata into SQL script
    Send Keyboard Event    VK_Q    	CTRL_MASK
    Sleep    2s
    Component Should Exist    extractButton

test_open_grant_manager
    Set Shortcut    Grant Manager
    Open connection
    Send Keyboard Event    VK_Q    	CTRL_MASK
    Sleep    2s
    Label Text Should Be    1    Privileges For

test_open_memory_status
    Set Shortcut    Heap Memory Status
    Send Keyboard Event    VK_Q    	CTRL_MASK
    Sleep    2s
    Dialog Should Be Open    Java Heap Memory

test_open_new_conn
    Set Shortcut    New Connection
    Send Keyboard Event    VK_Q    	CTRL_MASK
    Sleep    5s
    Component Should Exist    driverCombo

test_open_file
    Click On Tree Node    0    New Connection    1
    Send Keyboard Event    VK_O    	CTRL_MASK
    Sleep    2s
    Dialog Should Be Open    Open

test_open_preferences
    Set Shortcut    Preferences
    Send Keyboard Event    VK_Q    	CTRL_MASK
    Sleep    2s
    Dialog Should Be Open    Preferences

test_open_print
    Click On Tree Node    0    New Connection    1
    Send Keyboard Event    VK_P    	CTRL_MASK
    Sleep    2s
    Run Keyword And Continue On Failure    Dialog Should Be Open    Print

test_open_profile
    Set Shortcut    Profiler
    Open connection
    Send Keyboard Event    VK_Q    	CTRL_MASK
    Sleep    2s
    Component Should Exist    connectionCombo

test_open_editor
    Set Shortcut    Query Editor
    Send Keyboard Event    VK_Q    	CTRL_MASK
    Sleep    2s
    Component Should Exist    execute-script-command

test_open_trace_manager
    Set Shortcut    Trace Manager
    Send Keyboard Event    VK_Q    	CTRL_MASK
    Sleep    5s
    Component Should Exist    databaseBox

test_open_user_manager
    Set Shortcut    User Manager
    Open connection
    Send Keyboard Event    VK_Q    	CTRL_MASK
    Sleep    2s
    Component Should Exist    databasesCombo

*** Keywords ***
Set Shortcut
    [Arguments]    ${command}
    Select From Main Menu    System|Preferences
    Select Dialog    Preferences
    Click On Tree Node    0    Shortcuts
    ${row}=    Find Table Row    0    ${command}    Command
    Run Keyword In Separate Thread    Click On Table Cell    0    ${row}    Shortcut    1    BUTTON1_MASK
    Select Dialog    Select Shortcut
    Click On Component    shortcutField
    Send Keyboard Event    VK_Q    	CTRL_MASK
    Push Button    OK
    Select Dialog    Preferences
    Push Button    applyButton
    Close Dialog    Message
    Close Dialog    Preferences
    Select Main Window
    Focus To Component    0
