*** Settings ***
Library    RemoteSwingLibrary
Resource    ../files/keywords.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_alter_domain
    Init Alter    Domains (15)|ADDRESSLINE
    Check Comment    RDB$FIELDS 

test_alter_table
    Init Alter    Tables (10)|EMPLOYEE
    Check Table Comment
    
test_alter_gtt
    Lock Employee
    Execute Immediate    CREATE GLOBAL TEMPORARY TABLE NEW_GTT (TESTS BIGINT) ON COMMIT DELETE ROWS
    Init Alter    Global Temporary Tables (1)|NEW_GTT
    Check Table Comment

test_alter_view
    Init Alter    Views (1)|PHONE_LIST
    Check Comment    RDB$RELATIONS

test_alter_procedure
    Init Alter    Procedures (10)|ALL_LANGS
    Check Comment    RDB$PROCEDURES

test_alter_function
    Check Skip 2.6
    Lock Employee
    Execute Immediate    CREATE OR ALTER FUNCTION NEW_FUNC RETURNS VARCHAR(5) AS begin RETURN 'five'; end
    Init Alter    Functions (1)|NEW_FUNC
    Check Comment    RDB$FUNCTIONS

test_alter_package
    Check Skip 2.6
    Lock Employee
    Execute Immediate    CREATE OR ALTER PACKAGE NEW_PACK AS BEGIN END
    Init Alter    Packages (1)|NEW_PACK
    Check Comment    RDB$PACKAGES

test_alter_trigger_for_table
    Init Alter    Table Triggers (4)|POST_NEW_ORDER
    Check Comment    RDB$TRIGGERS

test_alter_trigger_for_ddl
    Check Skip 2.6
    Lock Employee
    Execute Immediate    CREATE OR ALTER TRIGGER NEW_TRIGGER ACTIVE BEFORE ANY DDL STATEMENT POSITION 0 AS BEGIN END
    Init Alter    DDL Triggers (1)|NEW_TRIGGER
    Check Comment    RDB$TRIGGERS

test_alter_trigger_for_db
    Lock Employee
    Execute Immediate    CREATE OR ALTER TRIGGER NEW_TRIGGER ACTIVE ON CONNECT POSITION 0 AS BEGIN END
    Init Alter    DB Triggers (1)|NEW_TRIGGER
    Check Comment    RDB$TRIGGERS

test_alter_sequence
    Init Alter    Sequences (2)|EMP_NO_GEN
    Select Tab As Context    Comment
    Clear Text Field    0
    Type Into Text Field    0    test_comment
    Push Button    updateCommentButton
    ${res}=    Execute    select RDB$DESCRIPTION from RDB$GENERATORS where RDB$DESCRIPTION is not NULL and RDB$GENERATOR_NAME = 'EMP_NO_GEN'
    Sleep    1s
    Clear Text Field    0
    Push Button    updateCommentButton
    Should Be Equal    ${res}    [('test_comment',)]

test_alter_exception
    Init Alter    Exceptions (5)|CUSTOMER_CHECK
    Check Comment    RDB$EXCEPTIONS

test_alter_udf
    Lock Employee
    Execute Immediate    DECLARE EXTERNAL FUNCTION NEW_UDF RETURNS BIGINT ENTRY_POINT '123' MODULE_NAME '123'
    Init alter    UDFs (1)|NEW_UDF
    Check Comment     RDB$FUNCTIONS

test_alter_user
    Check Skip 2.6
    Init Alter    Users (1)|SYSDBA
    Select Tab As Context    Comment
    Clear Text Field    0
    Type Into Text Field    0    test_comment
    Push Button    updateCommentButton
    ${res}=    Execute    select SEC$DESCRIPTION from SEC$USERS where SEC$DESCRIPTION is not NULL
    Sleep    1s
    Clear Text Field    0
    Push Button    updateCommentButton
    Should Be Equal    ${res}    [('test_comment',)]

test_alter_role
    Lock Employee
    Execute Immediate    CREATE ROLE NEW_ROLE
    Init Alter    Roles (1)|NEW_ROLE
    Check Comment    RDB$ROLES

test_alter_ts
    Check Skip
    Execute Immediate    CREATE TABLESPACE NEW_TS FILE 'test1.ts'
    Init Alter    Tablespaces (1)|NEW_TS
    Check Comment    RDB$TABLESPACES
    Execute Immediate    DROP TABLESPACE NEW_TS

test_alter_job
    Check Skip
    Execute Immediate    CREATE JOB NEW_JOB '* * * * *' COMMAND ''
    Init Alter    Jobs (1)|NEW_JOB
    Check Comment    RDB$JOBS
    Execute Immediate    DROP JOB NEW_JOB

*** Keywords ***
Check Skip
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    ${srv_ver}=    Set Variable    ${info}[2]
    Skip If    ${{not($ver == '5.0' and $srv_ver == 'RedDatabase')}}

Check Skip 2.6
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    Skip If    ${{$ver == '2.6'}}

Init Alter
    [Arguments]    ${object}
    Open connection
    Click On Tree Node   0    New Connection|${object}    2

Check Comment
    [Arguments]    ${object}
    Select Tab As Context    Comment
    Clear Text Field    0
    Type Into Text Field    0    test_comment
    Push Button    updateCommentButton
    ${res}=    Execute    select RDB$DESCRIPTION from ${object} where RDB$DESCRIPTION is not NULL
    Sleep    1s
    Clear Text Field    0
    Push Button    updateCommentButton
    Should Be Equal    ${res}    [('test_comment',)]


Check Table Comment
    Select Tab As Context    Properties
    Clear Text Field    1
    Type Into Text Field    1    test_comment
    Push Button    updateCommentButton
    ${res}=    Execute    select RDB$DESCRIPTION from RDB$RELATIONS where RDB$DESCRIPTION is not NULL
    Sleep    1s
    Clear Text Field    1
    Push Button    updateCommentButton
    Should Be Equal    ${res}    [('test_comment',)]