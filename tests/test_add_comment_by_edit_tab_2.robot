*** Settings ***
Library    RemoteSwingLibrary
Resource    ../files/keywords.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_alter_domain
    Init Alter    Domains (15)|ADDRESSLINE
    Check Comment

test_alter_table
    Init Alter    Tables (10)|EMPLOYEE
    Check Table Comment
    
test_alter_gtt
    Lock Employee
    Execute Immediate    CREATE GLOBAL TEMPORARY TABLE NEW_GTT (TESTS BIGINT) ON COMMIT DELETE ROWS
    Init Alter    Global Temporary Tables (1)|NEW_GTT
    Check Table Comment

test_alter_procedure
    Init Alter    Procedures (10)|ALL_LANGS
    Check Comment

test_alter_procedure_input_p
    Check Proc Tab Comment    Procedures (10)|ADD_EMP_PROJ    Input Parameters    EMP_NO

test_alter_procedure_output_p
    Check Proc Tab Comment    Procedures (10)|ALL_LANGS    Output Parameters    CODE    

test_alter_procedure_variables
    Check Proc Tab Comment    Procedures (10)|DELETE_EMPLOYEE    Variables    any_sales 

test_alter_procedure_cursor
    Lock Employee
    Execute Immediate    CREATE OR ALTER PROCEDURE NEW_PROC AS DECLARE test CURSOR FOR (select * from employee); BEGIN END
    Check Proc Tab Comment     Procedures (11)|NEW_PROC    Cursors    test

test_alter_function
    Check Skip 2.6
    Lock Employee
    Execute Immediate    CREATE OR ALTER FUNCTION NEW_FUNC RETURNS VARCHAR(5) AS begin RETURN 'five'; end
    Init Alter    Functions (1)|NEW_FUNC
    Check Comment

test_alter_package
    Check Skip 2.6
    Lock Employee
    Execute Immediate    CREATE OR ALTER PACKAGE NEW_PACK AS BEGIN END
    Execute Immediate    RECREATE PACKAGE BODY NEW_PACK AS BEGIN END
    Init Alter    Packages (1)|NEW_PACK
    Check Comment

test_alter_trigger_for_table
    Init Alter    Table Triggers (4)|POST_NEW_ORDER
    Check Comment

test_alter_trigger_for_ddl
    Check Skip 2.6
    Lock Employee
    Execute Immediate    CREATE OR ALTER TRIGGER NEW_TRIGGER ACTIVE BEFORE ANY DDL STATEMENT POSITION 0 AS BEGIN END
    Init Alter    DDL Triggers (1)|NEW_TRIGGER
    Check Comment

test_alter_trigger_for_db
    Lock Employee
    Execute Immediate    CREATE OR ALTER TRIGGER NEW_TRIGGER ACTIVE ON CONNECT POSITION 0 AS BEGIN END
    Init Alter    DB Triggers (1)|NEW_TRIGGER
    Check Comment

test_alter_sequence
    Init Alter    Sequences (2)|EMP_NO_GEN
    Check Comment

test_alter_exception
    Init Alter    Exceptions (5)|CUSTOMER_CHECK
    Check Comment

test_alter_udf
    Lock Employee
    Execute Immediate    DECLARE EXTERNAL FUNCTION NEW_UDF RETURNS BIGINT ENTRY_POINT '123' MODULE_NAME '123'
    Init alter    UDFs (1)|NEW_UDF
    Check Comment

test_alter_user
    Check Skip 2.6
    Init Alter    Users (1)|SYSDBA
    Check Comment

test_alter_role
    Lock Employee
    Execute Immediate    CREATE ROLE NEW_ROLE
    Init Alter    Roles (1)|NEW_ROLE
    Check Comment

test_alter_ts
    Check Skip
    Lock Employee
    Execute Immediate    CREATE TABLESPACE NEW_TS FILE 'test_alter.ts'
    Init Alter    Tablespaces (1)|NEW_TS
    Check Comment

test_alter_job
    Check Skip
    Execute Immediate    CREATE JOB NEW_JOB '* * * * *' COMMAND ''
    Init Alter    Jobs (1)|NEW_JOB
    Check Comment
    Execute Immediate    DROP JOB NEW_JOB

*** Keywords ***
Check Skip
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    ${srv_ver}=    Set Variable    ${info}[2]
    Skip If    ${{not($ver == '5' and $srv_ver == 'RedDatabase')}}

Check Skip 2.6
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    Skip If    ${{$ver == '2.6'}}

Init Alter
    [Arguments]    ${object}
    Open connection
    Click On Tree Node   0    New Connection|${object}    2

Check Comment
    Select Tab As Context    Comment
    Clear Text Field    0
    Type Into Text Field    0    test_comment
    Init Commit Window

Init Commit Window
    Select Main Window
    Push Button    submitButton
    Select Dialog    dialog0
    Sleep    1s
    ${res}=    Get Text Field Value    0
    Should Not Be Equal As Integers    ${{$res.find('test_comment')}}    -1

Check Table Comment
    Select Tab As Context    Properties
    Clear Text Field    1
    Type Into Text Field    1    test_comment
    Push Button    Save
    ${res}=    Execute    select RDB$DESCRIPTION from RDB$RELATIONS where RDB$DESCRIPTION is not NULL
    Sleep    1s
    Clear Text Field    1
    Push Button    Save
    Should Be Equal    ${res}    [('test_comment',)]

Check Proc Tab Comment
    [Arguments]    ${proc_name}    ${tab}    ${name}
    Init Alter    ${proc_name}
    Select Tab As Context    ${tab}
    ${row}=    Find Table Row    0    ${name}    Name
    Type Into Table Cell    0   ${row}    Comment     test_comment
    Send Keyboard Event    VK_ENTER
    Init Commit Window
