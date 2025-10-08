*** Settings ***
Library    RemoteSwingLibrary
Library    OperatingSystem
Resource    ../../files/keywords.resource
Resource    key.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_without
    Setup before export data
    ${export_path}=    Init SQL
    Clear Text Field    exportTableNameField
    VAR    ${expected_content}    INSERT INTO  ( FIRST_NAME, LAST_NAME, PHONE_EXT, HIRE_DATE ) VALUES ( 'Carol', 'Nordstrom', '420', '1991-10-02 00:00' ); INSERT INTO  ( FIRST_NAME, LAST_NAME, PHONE_EXT, HIRE_DATE ) VALUES ( 'Luke', 'Leung', '3', '1992-02-18 00:00' ); INSERT INTO  ( FIRST_NAME, LAST_NAME, PHONE_EXT, HIRE_DATE ) VALUES ( 'Sue Anne', 'O''Brien', '877', '1992-03-23 00:00' ); INSERT INTO  ( FIRST_NAME, LAST_NAME, PHONE_EXT, HIRE_DATE ) VALUES ( 'Jennifer M.', 'Burbank', '289', '1992-04-15 00:00' ); INSERT INTO  ( FIRST_NAME, LAST_NAME, PHONE_EXT, HIRE_DATE ) VALUES ( 'Claudia', 'Sutherland', NULL, '1992-04-20 00:00' ); INSERT INTO  ( FIRST_NAME, LAST_NAME, PHONE_EXT, HIRE_DATE ) VALUES ( 'Dana', 'Bishop', '290', '1992-06-01 00:00' );
    Check content    ${export_path}    ${expected_content}

test_table_name
    Setup before export data
    ${export_path}=    Init SQL
    Clear Text Field    exportTableNameField
    Type Into Text Field    exportTableNameField    TEST_TABLE
    VAR    ${expected_content}    INSERT INTO TEST_TABLE ( FIRST_NAME, LAST_NAME, PHONE_EXT, HIRE_DATE ) VALUES ( 'Carol', 'Nordstrom', '420', '1991-10-02 00:00' ); INSERT INTO TEST_TABLE ( FIRST_NAME, LAST_NAME, PHONE_EXT, HIRE_DATE ) VALUES ( 'Luke', 'Leung', '3', '1992-02-18 00:00' ); INSERT INTO TEST_TABLE ( FIRST_NAME, LAST_NAME, PHONE_EXT, HIRE_DATE ) VALUES ( 'Sue Anne', 'O''Brien', '877', '1992-03-23 00:00' ); INSERT INTO TEST_TABLE ( FIRST_NAME, LAST_NAME, PHONE_EXT, HIRE_DATE ) VALUES ( 'Jennifer M.', 'Burbank', '289', '1992-04-15 00:00' ); INSERT INTO TEST_TABLE ( FIRST_NAME, LAST_NAME, PHONE_EXT, HIRE_DATE ) VALUES ( 'Claudia', 'Sutherland', NULL, '1992-04-20 00:00' ); INSERT INTO TEST_TABLE ( FIRST_NAME, LAST_NAME, PHONE_EXT, HIRE_DATE ) VALUES ( 'Dana', 'Bishop', '290', '1992-06-01 00:00' );
    Check content    ${export_path}    ${expected_content}

test_open_query_editor_yes
    Setup before export data
    ${export_path}=    Init SQL
    Check Check Box    openQueryEditorCheck
    Clear Text Field    exportTableNameField
    Type Into Text Field    exportTableNameField    TEST_TABLE
    VAR    ${expected_content}    INSERT INTO TEST_TABLE ( FIRST_NAME, LAST_NAME, PHONE_EXT, HIRE_DATE ) VALUES ( 'Carol', 'Nordstrom', '420', '1991-10-02 00:00' ); INSERT INTO TEST_TABLE ( FIRST_NAME, LAST_NAME, PHONE_EXT, HIRE_DATE ) VALUES ( 'Luke', 'Leung', '3', '1992-02-18 00:00' ); INSERT INTO TEST_TABLE ( FIRST_NAME, LAST_NAME, PHONE_EXT, HIRE_DATE ) VALUES ( 'Sue Anne', 'O''Brien', '877', '1992-03-23 00:00' ); INSERT INTO TEST_TABLE ( FIRST_NAME, LAST_NAME, PHONE_EXT, HIRE_DATE ) VALUES ( 'Jennifer M.', 'Burbank', '289', '1992-04-15 00:00' ); INSERT INTO TEST_TABLE ( FIRST_NAME, LAST_NAME, PHONE_EXT, HIRE_DATE ) VALUES ( 'Claudia', 'Sutherland', NULL, '1992-04-20 00:00' ); INSERT INTO TEST_TABLE ( FIRST_NAME, LAST_NAME, PHONE_EXT, HIRE_DATE ) VALUES ( 'Dana', 'Bishop', '290', '1992-06-01 00:00' );
    Check content    ${export_path}    ${expected_content}
    Select Dialog    ${EMPTY}
    Push Button    Yes
    
    Select Main Window
    ${content_query_editor}=    Get Text Field Value    0
    Should Be Equal As Strings    ${content_query_editor}    ${expected_content}    strip_spaces=${True}    collapse_spaces=${True}

test_open_query_editor_no
    Setup before export data
    ${export_path}=    Init SQL
    Check Check Box    openQueryEditorCheck
    Clear Text Field    exportTableNameField
    Type Into Text Field    exportTableNameField    TEST_TABLE
    VAR    ${expected_content}    INSERT INTO TEST_TABLE ( FIRST_NAME, LAST_NAME, PHONE_EXT, HIRE_DATE ) VALUES ( 'Carol', 'Nordstrom', '420', '1991-10-02 00:00' ); INSERT INTO TEST_TABLE ( FIRST_NAME, LAST_NAME, PHONE_EXT, HIRE_DATE ) VALUES ( 'Luke', 'Leung', '3', '1992-02-18 00:00' ); INSERT INTO TEST_TABLE ( FIRST_NAME, LAST_NAME, PHONE_EXT, HIRE_DATE ) VALUES ( 'Sue Anne', 'O''Brien', '877', '1992-03-23 00:00' ); INSERT INTO TEST_TABLE ( FIRST_NAME, LAST_NAME, PHONE_EXT, HIRE_DATE ) VALUES ( 'Jennifer M.', 'Burbank', '289', '1992-04-15 00:00' ); INSERT INTO TEST_TABLE ( FIRST_NAME, LAST_NAME, PHONE_EXT, HIRE_DATE ) VALUES ( 'Claudia', 'Sutherland', NULL, '1992-04-20 00:00' ); INSERT INTO TEST_TABLE ( FIRST_NAME, LAST_NAME, PHONE_EXT, HIRE_DATE ) VALUES ( 'Dana', 'Bishop', '290', '1992-06-01 00:00' );
    Check content    ${export_path}    ${expected_content}
    Select Dialog    ${EMPTY}
    Push Button    No
    
    Select Main Window
    VAR    ${expected_content}    SELECT * FROM EMPLOYEE
    ${content_query_editor}=    Get Text Field Value    0
    Should Be Equal As Strings    ${content_query_editor}    ${expected_content}    strip_spaces=${True}    collapse_spaces=${True}

test_open_empty_query_editor
    Open connection
    Clear Text Field    0
    Insert Into Text Field    0    SELECT * FROM EMPLOYEE
    Push Button    execute-script-command
    Sleep    1s
    Clear Text Field    0
    Select Table Cell Area    0    1    4    19    24    
    Select From Table Cell Popup Menu On Selected Cells    0    Export|Selection
    Select Dialog    Export Data

    ${export_path}=    Init SQL
    Check Check Box    openQueryEditorCheck
    Clear Text Field    exportTableNameField
    Type Into Text Field    exportTableNameField    TEST_TABLE
    VAR    ${expected_content}    INSERT INTO TEST_TABLE ( FIRST_NAME, LAST_NAME, PHONE_EXT, HIRE_DATE ) VALUES ( 'Carol', 'Nordstrom', '420', '1991-10-02 00:00' ); INSERT INTO TEST_TABLE ( FIRST_NAME, LAST_NAME, PHONE_EXT, HIRE_DATE ) VALUES ( 'Luke', 'Leung', '3', '1992-02-18 00:00' ); INSERT INTO TEST_TABLE ( FIRST_NAME, LAST_NAME, PHONE_EXT, HIRE_DATE ) VALUES ( 'Sue Anne', 'O''Brien', '877', '1992-03-23 00:00' ); INSERT INTO TEST_TABLE ( FIRST_NAME, LAST_NAME, PHONE_EXT, HIRE_DATE ) VALUES ( 'Jennifer M.', 'Burbank', '289', '1992-04-15 00:00' ); INSERT INTO TEST_TABLE ( FIRST_NAME, LAST_NAME, PHONE_EXT, HIRE_DATE ) VALUES ( 'Claudia', 'Sutherland', NULL, '1992-04-20 00:00' ); INSERT INTO TEST_TABLE ( FIRST_NAME, LAST_NAME, PHONE_EXT, HIRE_DATE ) VALUES ( 'Dana', 'Bishop', '290', '1992-06-01 00:00' );
    Check content    ${export_path}    ${expected_content}

    Select Main Window
    ${content_query_editor}=    Get Text Field Value    0
    Should Be Equal As Strings    ${content_query_editor}    ${expected_content}    strip_spaces=${True}    collapse_spaces=${True}

test_add_create_table_statement
    Setup before export data
    ${export_path}=    Init SQL
    Check Check Box    addCreateTableStatementCheck
    Clear Text Field    exportTableNameField
    Type Into Text Field    exportTableNameField    TEST_TABLE
    VAR    ${expected_content}    -- table creating -- CREATE TABLE TEST_TABLE ( FIRST_NAME BLOB SUB_TYPE TEXT, LAST_NAME BLOB SUB_TYPE TEXT, PHONE_EXT BLOB SUB_TYPE TEXT, HIRE_DATE BLOB SUB_TYPE TEXT ); -- inserting data -- INSERT INTO TEST_TABLE ( FIRST_NAME, LAST_NAME, PHONE_EXT, HIRE_DATE ) VALUES ( 'Carol', 'Nordstrom', '420', '1991-10-02 00:00' ); INSERT INTO TEST_TABLE ( FIRST_NAME, LAST_NAME, PHONE_EXT, HIRE_DATE ) VALUES ( 'Luke', 'Leung', '3', '1992-02-18 00:00' ); INSERT INTO TEST_TABLE ( FIRST_NAME, LAST_NAME, PHONE_EXT, HIRE_DATE ) VALUES ( 'Sue Anne', 'O''Brien', '877', '1992-03-23 00:00' ); INSERT INTO TEST_TABLE ( FIRST_NAME, LAST_NAME, PHONE_EXT, HIRE_DATE ) VALUES ( 'Jennifer M.', 'Burbank', '289', '1992-04-15 00:00' ); INSERT INTO TEST_TABLE ( FIRST_NAME, LAST_NAME, PHONE_EXT, HIRE_DATE ) VALUES ( 'Claudia', 'Sutherland', NULL, '1992-04-20 00:00' ); INSERT INTO TEST_TABLE ( FIRST_NAME, LAST_NAME, PHONE_EXT, HIRE_DATE ) VALUES ( 'Dana', 'Bishop', '290', '1992-06-01 00:00' );
    Check content    ${export_path}    ${expected_content}

test_execute_to_file
    Open connection
    Clear Text Field    0
    Insert Into Text Field    0    SELECT * FROM COUNTRY
    Push Button    editor-execute-to-file-command
    Push Button    execute-script-command
    Sleep    1s  
    Select Dialog    Export Data
    ${export_path}=    Init SQL
    Check Check Box    addCreateTableStatementCheck
    Clear Text Field    exportTableNameField
    Type Into Text Field    exportTableNameField    TEST_TABLE
    
     ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    ${ser_ver}=    Set Variable    ${info}[2]
    IF    ${{$ver == '2.6'}}
        VAR    ${expected_content}    -- table creating -- CREATE TABLE TEST_TABLE ( COUNTRY VARCHAR(15), CURRENCY VARCHAR(10) ); -- inserting data -- INSERT INTO TEST_TABLE ( COUNTRY, CURRENCY ) VALUES ( 'USA', 'Dollar' ); INSERT INTO TEST_TABLE ( COUNTRY, CURRENCY ) VALUES ( 'England', 'Pound' ); INSERT INTO TEST_TABLE ( COUNTRY, CURRENCY ) VALUES ( 'Canada', 'CdnDlr' ); INSERT INTO TEST_TABLE ( COUNTRY, CURRENCY ) VALUES ( 'Switzerland', 'SFranc' ); INSERT INTO TEST_TABLE ( COUNTRY, CURRENCY ) VALUES ( 'Japan', 'Yen' ); INSERT INTO TEST_TABLE ( COUNTRY, CURRENCY ) VALUES ( 'Italy', 'Lira' ); INSERT INTO TEST_TABLE ( COUNTRY, CURRENCY ) VALUES ( 'France', 'FFranc' ); INSERT INTO TEST_TABLE ( COUNTRY, CURRENCY ) VALUES ( 'Germany', 'D-Mark' ); INSERT INTO TEST_TABLE ( COUNTRY, CURRENCY ) VALUES ( 'Australia', 'ADollar' ); INSERT INTO TEST_TABLE ( COUNTRY, CURRENCY ) VALUES ( 'Hong Kong', 'HKDollar' ); INSERT INTO TEST_TABLE ( COUNTRY, CURRENCY ) VALUES ( 'Netherlands', 'Guilder' ); INSERT INTO TEST_TABLE ( COUNTRY, CURRENCY ) VALUES ( 'Belgium', 'BFranc' ); INSERT INTO TEST_TABLE ( COUNTRY, CURRENCY ) VALUES ( 'Austria', 'Schilling' ); INSERT INTO TEST_TABLE ( COUNTRY, CURRENCY ) VALUES ( 'Fiji', 'FDollar' );
    ELSE
        VAR    ${expected_content}    -- table creating -- CREATE TABLE TEST_TABLE ( COUNTRY VARCHAR(15), CURRENCY VARCHAR(10) ); -- inserting data -- INSERT INTO TEST_TABLE ( COUNTRY, CURRENCY ) VALUES ( 'USA', 'Dollar' ); INSERT INTO TEST_TABLE ( COUNTRY, CURRENCY ) VALUES ( 'England', 'Pound' ); INSERT INTO TEST_TABLE ( COUNTRY, CURRENCY ) VALUES ( 'Canada', 'CdnDlr' ); INSERT INTO TEST_TABLE ( COUNTRY, CURRENCY ) VALUES ( 'Switzerland', 'SFranc' ); INSERT INTO TEST_TABLE ( COUNTRY, CURRENCY ) VALUES ( 'Japan', 'Yen' ); INSERT INTO TEST_TABLE ( COUNTRY, CURRENCY ) VALUES ( 'Italy', 'Euro' ); INSERT INTO TEST_TABLE ( COUNTRY, CURRENCY ) VALUES ( 'France', 'Euro' ); INSERT INTO TEST_TABLE ( COUNTRY, CURRENCY ) VALUES ( 'Germany', 'Euro' ); INSERT INTO TEST_TABLE ( COUNTRY, CURRENCY ) VALUES ( 'Australia', 'ADollar' ); INSERT INTO TEST_TABLE ( COUNTRY, CURRENCY ) VALUES ( 'Hong Kong', 'HKDollar' ); INSERT INTO TEST_TABLE ( COUNTRY, CURRENCY ) VALUES ( 'Netherlands', 'Euro' ); INSERT INTO TEST_TABLE ( COUNTRY, CURRENCY ) VALUES ( 'Belgium', 'Euro' ); INSERT INTO TEST_TABLE ( COUNTRY, CURRENCY ) VALUES ( 'Austria', 'Euro' ); INSERT INTO TEST_TABLE ( COUNTRY, CURRENCY ) VALUES ( 'Fiji', 'FDollar' ); INSERT INTO TEST_TABLE ( COUNTRY, CURRENCY ) VALUES ( 'Russia', 'Ruble' ); INSERT INTO TEST_TABLE ( COUNTRY, CURRENCY ) VALUES ( 'Romania', 'RLeu' ); INSERT INTO TEST_TABLE ( COUNTRY, CURRENCY ) VALUES ( 'Ukraine', 'Hryvnia' ); INSERT INTO TEST_TABLE ( COUNTRY, CURRENCY ) VALUES ( 'Czechia', 'CzKoruna' ); INSERT INTO TEST_TABLE ( COUNTRY, CURRENCY ) VALUES ( 'Brazil', 'Real' ); INSERT INTO TEST_TABLE ( COUNTRY, CURRENCY ) VALUES ( 'Chile', 'ChPeso' ); INSERT INTO TEST_TABLE ( COUNTRY, CURRENCY ) VALUES ( 'Spain', 'Euro' ); INSERT INTO TEST_TABLE ( COUNTRY, CURRENCY ) VALUES ( 'Hungary', 'Forint' ); INSERT INTO TEST_TABLE ( COUNTRY, CURRENCY ) VALUES ( 'Sweden', 'SKrona' ); INSERT INTO TEST_TABLE ( COUNTRY, CURRENCY ) VALUES ( 'Greece', 'Euro' ); INSERT INTO TEST_TABLE ( COUNTRY, CURRENCY ) VALUES ( 'Slovakia', 'Euro' ); INSERT INTO TEST_TABLE ( COUNTRY, CURRENCY ) VALUES ( 'Portugal', 'Euro' );
    END

    Check content    ${export_path}    ${expected_content}


*** Keywords ***
Init SQL
    Select From Combo Box    typeCombo    SQL
    ${export_path}=    Catenate    SEPARATOR=    ${TEMPDIR}    /export.sql
    Remove Files    ${export_path}
    Clear Text Field    filePathField
    Type Into Text Field    filePathField    ${export_path}
    Uncheck All Checkboxes
    RETURN    ${export_path}

Check content
    [Arguments]   ${export_path}    ${expected_content}
    Push Button    exportButton
    Sleep    5s
    # Close Dialog    Message
    File Should Exist    ${export_path}
    ${content}=    Get File    ${export_path}
    Should Be Equal As Strings    ${content}    ${expected_content}    strip_spaces=${True}    collapse_spaces=${True}