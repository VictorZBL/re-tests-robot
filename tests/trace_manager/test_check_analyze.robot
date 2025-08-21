*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../files/keywords.resource
Resource    keys.resource
Test Setup       Setup
Test Teardown    Teardown
Test Timeout    200s


*** Test Cases ***
test_1
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
    Check Check Box    checkBoxprint_plan
    IF    $ver != '2.6'
        Check Check Box    checkBoxexplain_plan
    END
    Type Into Text Field    nameField    NEW_CONFIG
    Push Button    saveButton
    
    Select Main Window
    Insert Into Text Field    numberTextFieldtime_threshold    0    
    Select From Combo Box    databaseBox    New Connection
    Check Check Box    hideShowPropsCheckBox
    
    Push Button    startStopSessionButton
    Sleep    20s

    Execute    SELECT * from EMPLOYEE AS EM JOIN DEPARTMENT AS DEP ON EM.DEPT_NO = DEP.DEPT_NO
    Execute    SELECT * from EMPLOYEE

    Sleep    5s
    Select Tab As Context    Analyze
    
    Sleep    2s
    # Check Check Box    READ
    # Check Check Box    FETCH
    # Check Check Box    WRITE
    # Check Check Box    MARK
    # Check Check Box    RSORT
    # Check Check Box    DSORT
    # Check Check Box    Show more parameters
    # Check Check Box    Round values
    # Check Check Box    Show more parameters
    
    ${old}=    Set Jemmy Timeouts	0.5s
    Run Keyword And Continue On Failure    Check All Checkboxes
    Set Jemmy Timeouts    ${old}

    Push Button    Filter events
    
    ${row}=    Find Table Row    0    SELECT * from EMPLOYEE AS EM JOIN DEPARTMENT AS DEP ON EM.DEPT_NO = DEP.DEPT_NO\n    QUERY
    Click On Table Cell    0    ${row}    QUERY
    ${plan}=    Get Text Field Value    6
    Should Be Equal As Strings    ${plan}    Select Expression -> Filter -> Hash Join (inner) -> Table "EMPLOYEE" as "EM" Full Scan -> Record Buffer (record length: 105) -> Table "DEPARTMENT" as "DEP" Full Scan    strip_spaces=${True}    collapse_spaces=${True}

    ${query}=    Get Text Field Value    5
    Should Be Equal As Strings    ${query}    SELECT * from EMPLOYEE AS EM JOIN DEPARTMENT AS DEP ON EM.DEPT_NO = DEP.DEPT_NO    strip_spaces=${true}    collapse_spaces=${True}

    Check Check Box    Compare queries of N symbols
    
    Push Button    Rebuild