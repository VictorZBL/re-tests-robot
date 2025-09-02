*** Settings ***
Library    RemoteSwingLibrary
Library    OperatingSystem
Library    Collections
Resource    ../../files/keywords.resource
Resource    keys.resource
Test Setup       Setup
Test Teardown    Teardown after every tests
 

*** Test Cases ***
test_start_finish
    Start Profiler    select * from employee
    Push Button    finishButton
    Start App And Load

test_pause_resume
    Start Profiler    select * from employee
    Push Button    pauseButton
    Clear Text Field    0
    Type Into Text Field    0    select * from country
    Push Button    execute-script-command    
    Sleep    1s
    
    Push Button    resumeButton
    Clear Text Field    0
    Type Into Text Field    0    select * from project
    Push Button    execute-script-command    
    Sleep    1s
    
    Push Button    finishButton
    Start App And Load
    ${row}=    Find Table Row    0    select * from country    PROCESS NAME
    Should Be Equal As Integers    ${row}    -1
    ${row}=    Find Table Row    0    select * from project    PROCESS NAME
    Should Not Be Equal As Integers    ${row}    -1

test_empty_stop
    Check Warning    finishButton

test_empty_pause
    Check Warning    pauseButton

test_cancel
    Start Profiler    select * from employee
    Push Button    cancelButton
    Run Keyword And Expect Error    org.robotframework.swing.table.InvalidCellException: The specified table cell (row: -1, column: ID) is invalid.    Start App And Load

test_save_load_file
    VAR    ${path}    ${TEMPDIR}${/}profile_session.replg
    Remove File    ${path}
    Start Profiler    select * from employee
    Push Button    finishButton
    Push Button    saveButton
    Select Dialog    Save
    Clear Text Field    0
    Type Into Text Field    0    ${path}
    Push Button    Save
    Select Main Window
    Select Dialog    Message
    Label Text Should Be    0    File saved successfully to
    Label Text Should Be    1    ${path}
    Push Button    OK
    System Exit
    File Should Exist    ${path}
    Load
    Check Check Box    fromFileCheck
    Push Button    browseButton
    Select Dialog    Open
    Clear Text Field    0
    Type Into Text Field    0    ${path}
    Push Button    Open
    Select Main Window
    Select Dialog    Select Session
    Check
    Remove File    ${path}

test_discard_yes
    Lock Employee
    Open connection
    FOR    ${i}    IN RANGE    3
        Select From Main Menu    Tools|Profiler
        Push Button    startButton
        Sleep   1s
    END
    Push Button    editor-command
    Clear Text Field    0
    Type Into Text Field    0    select * from employee
    Push Button    execute-script-command
    Sleep    1s
    Push Button    discardButton
    Select Dialog    Confirmation
    Label Text Should Be    0   You are trying to cancel all profiler sessions. Continue?
    Push Button    Yes
    Load
    @{values}=    Get Table Values    sessionsTable
    Should Be Equal As Strings    ${values}    []

test_discard_no
    Start Profiler    select * from employee
    Push Button    discardButton
    Select Dialog    Confirmation
    Label Text Should Be    0   You are trying to cancel all profiler sessions. Continue?
    Push Button    No
    Select Main Window
    Push Button    finishButton
    Start App And Load

test_compact_view
    Start Profiler    execute procedure SUB_TOT_BUDGET(600)
    Push Button    finishButton
    Load
    ${row}=    Find Table Row    sessionsTable    1    ID
    Click On Table Cell    sessionsTable    ${row}    ID
    Push Button    OK
    Select Main Window

    @{values}=    Get Table Column Values    0    PROCESS NAME
    Should Be Equal As Strings    ${values}[:-1]    ['Profiler Session [ID: 1]', 'execute procedure SUB_TOT_BUDGET(600)']
    
    ${row}=    Find Table Row    0    execute procedure SUB_TOT_BUDGET(600)    PROCESS NAME
    Should Not Be Equal As Integers    ${row}    -1
    Click On Table Cell    0    ${row}    PROCESS NAME    2

    @{values}=    Get Table Column Values    0    PROCESS NAME
    Should Be Equal As Strings    ${values}[:-1]    ['Profiler Session [ID: 1]', 'execute procedure SUB_TOT_BUDGET(600)', 'SUB_TOT_BUDGET', 'Self Time']
    
    Click On Proc
    
    @{values}=    Get Table Column Values    0    PROCESS NAME
    Should Be Equal As Strings    ${values}[:-1]    ['Profiler Session [ID: 1]', 'execute procedure SUB_TOT_BUDGET(600)', 'SUB_TOT_BUDGET', '2: SELECT SUM(budget), AVG(budget), MIN(budget), MAX(budget)']

test_display_with_data
    Start Profiler    execute procedure SUB_TOT_BUDGET(600)
    Push Button    finishButton
    Load
    ${row}=    Find Table Row    sessionsTable    1    ID
    Click On Table Cell    sessionsTable    ${row}    ID
    Push Button    OK
    Select Main Window
    Click On Proc
    
    ${row}=    Find Table Row    0    2: SELECT SUM(budget), AVG(budget), MIN(budget), MAX(budget)    PROCESS NAME
    Should Not Be Equal As Integers    ${row}    -1
    Click On Table Cell    0    ${row}    PROCESS NAME

    @{values}=    Get Table Column Values    1    ACCESS PATH
    Should Be Equal As Strings    ${values}    ['Select Expression (line 6, column 2)', 'Singularity Check', 'Aggregate', 'Filter', 'Table "DEPARTMENT" Access By ID\\n Bitmap\\n Index "RDB$FOREIGN6" Range Scan (full match)']    strip_spaces=${True}    collapse_spaces=${True}

    Uncheck Check Box    accessPathCheck
    Run Keyword And Expect Error    org.robotframework.swing.table.InvalidCellException: The specified table cell (row: 0, column: ACCESS PATH) is invalid.    Get Table Column Values    1    ACCESS PATH
    
test_display_no_data
    Lock Employee
    Open connection
    Select From Main Menu    Tools|Profiler
    Sleep    1s
    Label Text Should Be    0    NO ACCESS DATA
    Uncheck Check Box    accessPathCheck
    Label Text Should Be    0    ${SPACE}Active Data Sources: 1

test_round
    Start Profiler    EXECUTE BLOCK AS DECLARE I INTEGER; BEGIN I = 0; WHILE ( I <> 100000) DO BEGIN I = I + 1; END end
    Push Button    finishButton
    Load
    ${row}=    Find Table Row    sessionsTable    1    ID
    Click On Table Cell    sessionsTable    ${row}    ID
    Push Button    OK
    Select Main Window
    Sleep    2s
    ${row}=    Find Table Row    0    EXECUTE BLOCK AS DECLARE I INTEGER; BEGIN I = 0; WHILE ( I <> 100000) DO BEGIN I = I + 1; END end
    Should Not Be Equal As Integers    ${row}    -1
       
    ${value}=    Get Table Cell Value    0    ${row}    AVERAGE TIME
    Should Not Be Equal As Integers    ${{$value.find('ms')}}    -1
    
    Uncheck Check Box    roundValuesCheck
    Sleep    2s
    ${value}=    Get Table Cell Value    0    ${row}    AVERAGE TIME
    Should Be Equal As Integers    ${{$value.find('ms')}}    -1
    Should Not Be Equal As Integers    ${{$value.find('ns')}}    -1

test_popup_copy
    Start Profiler    select * from employee
    Push Button    finishButton
    ${row}=    Start App And Load
    Click On Table Cell    0    ${row}    PROCESS NAME
    Select From Table Cell Popup Menu On Selected Cells    0    Copy
    
    ${row}=    Find Table Row    1    Table "EMPLOYEE" Full Scan    ACCESS PATH
    Should Not Be Equal As Integers    ${row}    -1
    Click On Table Cell    1    ${row}    ACCESS PATH
    Select From Table Cell Popup Menu On Selected Cells    1    Copy

test_popup_show
    Start Profiler    select * from employee
    Push Button    finishButton
    ${row}=    Start App And Load
    Click On Table Cell    0    ${row}    PROCESS NAME
    Select From Table Cell Popup Menu On Selected Cells    0    Show
    Select Dialog    Data Item Viewer
    ${value}=    Get Text Field Value    0
    Should Be Equal As Strings    ${value}    select * from employee    strip_spaces=${True}    collapse_spaces=${False}

    Close Dialog    Data Item Viewer
    Select Main Window
    ${row}=    Find Table Row    1    Table "EMPLOYEE" Full Scan    ACCESS PATH
    Should Not Be Equal As Integers    ${row}    -1
    Click On Table Cell    1    ${row}    ACCESS PATH
    Select From Table Cell Popup Menu On Selected Cells    1    Show
    Select Dialog    Data Item Viewer
    ${value}=    Get Text Field Value    0
    Should Be Equal As Strings    ${value}    Table "EMPLOYEE" Full Scan    strip_spaces=${True}    collapse_spaces=${False}

test_show_double_click
    Start Profiler    select * from employee
    Push Button    finishButton
    ${row}=    Start App And Load
    Click On Table Cell    0    ${row}    PROCESS NAME
    Run Keyword In Separate Thread    Click On Table Cell    0    ${row}    PROCESS NAME    2    BUTTON1_MASK
    Select Dialog    Data Item Viewer
    ${value}=    Get Text Field Value    0
    Should Be Equal As Strings    ${value}    select * from employee    strip_spaces=${True}    collapse_spaces=${False}
    
    Close Dialog    Data Item Viewer
    Select Main Window
    ${row}=    Find Table Row    1    Table "EMPLOYEE" Full Scan    ACCESS PATH
    Should Not Be Equal As Integers    ${row}    -1
    Run Keyword In Separate Thread    Click On Table Cell    1    ${row}    ACCESS PATH    2    BUTTON1_MASK
    Select Dialog    Data Item Viewer
    ${value}=    Get Text Field Value    0
    Should Be Equal As Strings    ${value}    Table "EMPLOYEE" Full Scan    strip_spaces=${True}    collapse_spaces=${False}

test_pause_after_lose_connect
    Lock Employee
    Open connection
    Select From Main Menu    Tools|Profiler
    Push Button    startButton
    Sleep    1s
    Open connection
    Push Button    pauseButton
    Check Warning After Lose Connect

test_resume_after_lose_connect
    Lock Employee
    Open connection
    Select From Main Menu    Tools|Profiler
    Push Button    startButton
    Sleep    1s
    Push Button    pauseButton
    Close Dialog    Warning
    Open connection
    Push Button    resumeButton
    Check Warning After Lose Connect

test_stop_after_lose_connect
    Lock Employee
    Open connection
    Select From Main Menu    Tools|Profiler
    Push Button    startButton
    Sleep    1s
    Open connection
    Push Button    finishButton
    Check Warning After Lose Connect

test_auto-reload_tree
    Start Profiler    select * from employee
    Push Button    finishButton
    Push Button    reload-connection-tree-selection-command    # temp
    Expand All Tree Nodes    0
    Sleep   1s
    @{values}=    Get Tree Node Child Names    0    New Connection|Tables (17)
    Should Be Equal As Strings    ${values}    ['COUNTRY', 'CUSTOMER', 'DEPARTMENT', 'EMPLOYEE', 'EMPLOYEE_PROJECT', 'JOB', 'PLG$PROF_CURSORS', 'PLG$PROF_PSQL_STATS', 'PLG$PROF_RECORD_SOURCES', 'PLG$PROF_RECORD_SOURCE_STATS', 'PLG$PROF_REQUESTS', 'PLG$PROF_SESSIONS', 'PLG$PROF_STATEMENTS', 'PROJECT', 'PROJ_DEPT_BUDGET', 'SALARY_HISTORY', 'SALES']

    @{values}=    Get Tree Node Child Names    0    New Connection|Views (4)
    Should Be Equal As Strings    ${values}    ['PHONE_LIST', 'PLG$PROF_PSQL_STATS_VIEW', 'PLG$PROF_RECORD_SOURCE_STATS_VIEW', 'PLG$PROF_STATEMENT_STATS_VIEW']
    
    @{values}=    Get Tree Node Child Names    0    New Connection|Sequences (3)
    Should Be Equal As Strings    ${values}    ['CUST_NO_GEN', 'EMP_NO_GEN', 'PLG$PROF_PROFILE_ID']
      
    @{values}=    Get Tree Node Child Names    0    New Connection|Roles (1)
    Should Be Equal As Strings    ${values}    ['PLG$PROFILER']
    
    @{values}=    Get Tree Node Child Names    0    New Connection|Indices (65)
    
    @{filtered_values}=    Create List
    FOR    ${item}    IN    @{values}
        ${starts_with}=    Evaluate    $item.startswith('PLG$PROF_')
        Run Keyword If    ${starts_with}    Append To List    ${filtered_values}    ${item}
    END
    Log    ${filtered_values}
    Should Be Equal As Strings    ${filtered_values}    ['PLG$PROF_CURSORS_PROFILE', 'PLG$PROF_CURSORS_PROFILE_STATEMENT', 'PLG$PROF_CURSORS_PROFILE_STATEMENT_CURSOR', 'PLG$PROF_PSQL_STATS_PROFILE', 'PLG$PROF_PSQL_STATS_PROFILE_REQUEST', 'PLG$PROF_PSQL_STATS_PROFILE_STATEMENT', 'PLG$PROF_PSQL_STATS_PROFILE_STATEMENT_REQUEST_LINE_COLUMN', 'PLG$PROF_RECORD_SOURCES_PROFILE', 'PLG$PROF_RECORD_SOURCES_PROFILE_STATEMENT', 'PLG$PROF_RECORD_SOURCES_PROFILE_STATEMENT_CURSOR', 'PLG$PROF_RECORD_SOURCES_PROFILE_STATEMENT_CURSOR_PARENT_REC_SRC', 'PLG$PROF_RECORD_SOURCES_PROFILE_STATEMENT_CURSOR_RECSOURCE', 'PLG$PROF_RECORD_SOURCE_STATS_PROFILE_ID', 'PLG$PROF_RECORD_SOURCE_STATS_PROFILE_REQUEST', 'PLG$PROF_RECORD_SOURCE_STATS_PROFILE_STATEMENT', 'PLG$PROF_RECORD_SOURCE_STATS_PROFILE_STAT_REQ_CUR_RECSOURCE', 'PLG$PROF_RECORD_SOURCE_STATS_STATEMENT_CURSOR', 'PLG$PROF_RECORD_SOURCE_STATS_STATEMENT_CURSOR_RECORD_SOURCE', 'PLG$PROF_REQUESTS_PROFILE', 'PLG$PROF_REQUESTS_PROFILE_CALLER_STATEMENT', 'PLG$PROF_REQUESTS_PROFILE_CALLER_STATEMENT_CALLER_REQUEST', 'PLG$PROF_REQUESTS_PROFILE_REQUEST_STATEMENT', 'PLG$PROF_REQUESTS_PROFILE_STATEMENT', 'PLG$PROF_SESSIONS_PROFILE', 'PLG$PROF_STATEMENTS_PARENT_STATEMENT', 'PLG$PROF_STATEMENTS_PROFILE', 'PLG$PROF_STATEMENTS_PROFILE_STATEMENT']

*** Keywords ***
Start Profiler
    [Arguments]    ${script}
    Lock Employee
    Open connection
    Select From Main Menu    Tools|Profiler
    Push Button    startButton
    Push Button    editor-command
    Clear Text Field    0
    Type Into Text Field    0    ${script}
    Push Button    execute-script-command
    Sleep    1s

Start App And Load
    Load
    ${row}=    Find Table Row    sessionsTable    1    ID
    Click On Table Cell    sessionsTable    ${row}    ID
    ${row}=    Check
    RETURN    ${row}

Load
    System Exit
    ${path_to_exe}=    Get Path
    Start Application    red_expert    ${path_to_exe}    timeout=20   
    Select Main Window
    Open connection
    Select From Main Menu    Tools|Profiler
    Push Button    loadButton
    Select Dialog    Select Session

Check
    Push Button    OK
    Select Main Window
    Sleep    2s
    Uncheck Check Box    compactViewCheck
    ${row}=    Find Table Row    0    select * from employee    PROCESS NAME
    Should Not Be Equal As Integers    ${row}    -1
    RETURN    ${row}

Click On Proc
    Uncheck Check Box    compactViewCheck

    ${row}=    Find Table Row    0    execute procedure SUB_TOT_BUDGET(600)    PROCESS NAME
    Should Not Be Equal As Integers    ${row}    -1
    Click On Table Cell    0    ${row}    PROCESS NAME    2

    ${row}=    Find Table Row    0    SUB_TOT_BUDGET    PROCESS NAME
    Should Not Be Equal As Integers    ${row}    -1
    Click On Table Cell    0    ${row}    PROCESS NAME    2

Check Warning
    [Arguments]    ${button}    
    Lock Employee
    Open connection
    Select From Main Menu    Tools|Profiler
    Push Button    startButton
    Sleep   1s
    Push Button    ${button}
    Select Dialog    Warning
    Label Text Should Be    0   The profiler did not collect any data
    Label Text Should Be    1   Please check the selected connection
    Push Button    OK

Check Warning After Lose Connect
    Select Dialog    Warning
    Label Text Should Be    0   Selected connection is unavailable.
    Label Text Should Be    1   Profiler session discarded.
    Push Button    OK