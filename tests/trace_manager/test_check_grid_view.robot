*** Settings ***
Library    RemoteSwingLibrary
Library    OperatingSystem
Resource    ../../files/keywords.resource
Resource    keys.resource
Test Setup       Setup
Test Teardown    Teardown

*** Test Cases ***
test_1
    ${log_path}=    Catenate    SEPARATOR=    ${TEMPDIR}    /test_log.fbtrace_text
    Remove File    ${log_path}
    Lock Employee
    Open connection
    Select From Main Menu    Tools|Trace Manager
    Sleep    5s
    Select Tab    Connection

    Select From Combo Box    profileSelector    default
    Push Button    doubleConfigButton
    Sleep    2s
    Select Dialog    Configuration
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    ${srv_ver}=    Set Variable    ${info}[2]
    Select From Combo Box    0    ${srv_ver} ${ver}
    Check Check Box    checkBoxlog_statement_finish
    Check Check Box    checkBoxprint_perf
    Type Into Text Field    nameField    NEW_CONFIG
    Push Button    saveButton
    
    Select Main Window
    Clear Text Field    numberTextFieldtime_threshold
    Type Into Text Field    numberTextFieldtime_threshold    0    
    Select From Combo Box    databaseBox    New Connection
    Check Check Box    hideShowPropsCheckBox
    
    Check Check Box    logToFileBox
    Clear Text Field    fileLogField
    Type Into Text Field    fileLogField    ${log_path}
    
    Push Button    startStopSessionButton
    Sleep    20s

    Select Tab    Session Manager
    Push Button    Refresh list
    Push Button    Refresh list
    Sleep    2s
    List Should Contain    0    New Connection_trace_session
    
    Push Button    pauseSessionButton

    Push Button    visibleColumnsButton
    Select Dialog    Visible Columns
    Push Button    removeAllButton
    Click On List Item    0    STATEMENT_TEXT
    Push Button    selectOneButton
    Close Dialog    Visible Columns
    
    Select Main Window
    Push Button    pauseSessionButton
    Sleep    2s

    Execute Immediate    CREATE TABLE TEST_TABLE (ID INT)
    Execute Immediate    INSERT INTO TEST_TABLE VALUES (1)
    Execute Immediate    INSERT INTO TEST_TABLE VALUES (2)
    Execute Immediate    INSERT INTO TEST_TABLE VALUES (3)
    Execute Immediate    DELETE FROM TEST_TABLE WHERE ID=2
    Execute Immediate    UPDATE TEST_TABLE SET ID=2 WHERE ID=1
    Execute    SELECT * FROM TEST_TABLE
    
    Sleep    20s

    Select Main Window
    Select Tab    Session Manager
    Click On List Item    0    New Connection_trace_session
    Push Button    Stop session
    
    Select Dialog    Confirmation
    Label Text Should Be    0    This session may be current one. Do you want to continue?
    Push Button    Yes

    Select Main Window
    Select Tab    Grid View

    Check Grid View

    Push Button    clearTableButton

load_from_file
    ${log_path}=    Catenate    SEPARATOR=    ${TEMPDIR}    /test_log.fbtrace_text
    File Should Exist    ${log_path}
    
    Open connection
    Select From Main Menu    Tools|Trace Manager
    Sleep    5s
    Push Button    openLogButton
    Sleep    1s
    Select Dialog    Open
    Type Into Text Field    0    ${log_path}
    Push Button    Open

    Select Main Window
    Select Tab    Grid View

    Check Grid View
    
    # Check Filter

*** Keywords ***
Check Grid View
    Sleep    5s
    ${row}=    Find Table Row    0    CREATE TABLE TEST_TABLE (ID INT)\n
    Click On Table Cell    0    ${row}    STATEMENT_TEXT
    ${body}=    Get Text Field Value    0
    Should Contain    ${body}    CREATE TABLE TEST_TABLE (ID INT)
    
    ${index}=    Get Table Column Values    1    Index
    ${insert}=    Get Table Column Values    1    Insert
    Should Be Equal As Strings    ${index}    ['7', '', '', '10', '', '7', '3', '', '2', '1', '1', '1']
    Should Be Equal As Strings    ${insert}    ['', '', '1', '', '1', '1', '', '6', '', '', '', '']


    ${row}=    Find Table Row    0    INSERT INTO TEST_TABLE VALUES (2)\n
    Click On Table Cell    0    ${row}    STATEMENT_TEXT
    ${body}=    Get Text Field Value    0
    Should Contain    ${body}    INSERT INTO TEST_TABLE VALUES (2)

    ${insert}=    Get Table Column Values    1    Insert

    Should Be Equal As Strings    ${insert}    ['', '1']


    ${row}=    Find Table Row    0    DELETE FROM TEST_TABLE WHERE ID=2\n
    Click On Table Cell    0    ${row}    STATEMENT_TEXT
    ${body}=    Get Text Field Value    0
    Should Contain    ${body}    DELETE FROM TEST_TABLE WHERE ID=2

    ${natural}=    Get Table Column Values    1    Natural
    ${delete}=    Get Table Column Values    1    Delete

    Should Be Equal As Strings    ${natural}    ['3']
    Should Be Equal As Strings    ${delete}    ['1']

    
    ${row}=    Find Table Row    0    UPDATE TEST_TABLE SET ID=2 WHERE ID=1\n
    Click On Table Cell    0    ${row}    STATEMENT_TEXT
    ${body}=    Get Text Field Value    0
    Should Contain    ${body}    UPDATE TEST_TABLE SET ID=2 WHERE ID=1

    ${update}=    Get Table Column Values    1    Update

    Should Be Equal As Strings    ${update}    ['1']
    
    ${row}=    Find Table Row    0    SELECT * FROM TEST_TABLE\n
    
    Run Keyword In Separate Thread    Click On Table Cell    0    ${row}    STATEMENT_TEXT    2    BUTTON1_MASK

    Select Dialog    Record Data Item Viewer
    ${value}=    Get Text Field Value    0
    Should Be Equal As Strings    ${value}    SELECT * FROM TEST_TABLE    collapse_spaces=${True}    strip_spaces=${True}
    Close Dialog    Record Data Item Viewer
    
    Select Main Window
    

Check Filter
    Select Tab As Context    Grid View
    List Components In Context
    # Push Button    2
    Select From Combo Box    0    OR
    Sleep    2s
    Check Check Box    0


    Select From Combo Box    1    STATEMENT_TEXT
    Select From Combo Box    2    Contains
    Type Into Text Field    0    CREATE
    
    Label Text Should Be    0    (STATEMENT_TEXT Contains 'CREATE')
    Push Button    applyButton

    @{filtred_values}=    Get Table Column Values    0    STATEMENT_TEXT
    Should Be Equal    ${filtred_values}    123

    Check Check Box    0
    Label Text Should Be    0    NOT(STATEMENT_TEXT Contains 'CREATE') 
    Push Button    applyButton
    
    @{filtred_values}=    Get Table Column Values    0    STATEMENT_TEXT
    Should Not Contain     ${filtred_values}    CREATE TABLE TEST_TABLE (ID INT)

    
    Check Check Box    1
    Label Text Should Be    0    NOT(STATEMENT_TEXT NOT Contains 'CREATE') 
    Push Button    applyButton
    
    @{filtred_values}=    Get Table Column Values    0    STATEMENT_TEXT
    Should Be Equal    ${filtred_values}    123

    Push Button    clearButton