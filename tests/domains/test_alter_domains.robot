*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../files/keywords.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_name
    Init    CREATE DOMAIN TEST_DOMAIN AS BIGINT
    Clear Text Field    nameField
    Type Into Text Field    nameField    TEST_DOMAIN_ALTER
    Check    ALTER DOMAIN TEST_DOMAIN TO TEST_DOMAIN_ALTER
    Check SQL    SELECT RDB$FIELD_NAME FROM RDB$FIELDS WHERE RDB$FIELD_NAME = 'TEST_DOMAIN_ALTER'    TEST_DOMAIN_ALTER

test_data_type
    Init    CREATE DOMAIN TEST_DOMAIN AS BIGINT
    Select Tab As Context    Type
    Select From Combo Box    typesCombo    INT128
    Check    ALTER DOMAIN TEST_DOMAIN TYPE INT128
    Check SQL    SELECT t.RDB$TYPE_NAME FROM RDB$FIELDS f JOIN RDB$TYPES t ON f.RDB$FIELD_TYPE = t.RDB$TYPE WHERE f.RDB$FIELD_NAME = 'TEST_DOMAIN' AND t.RDB$FIELD_NAME = 'RDB$FIELD_TYPE'    INT128
    ${res}=    Get Selected Item From Combo Box    typesCombo
    Should Be Equal As Strings    ${res}    INT128

test_default_value
    Init    CREATE DOMAIN TEST_DOMAIN AS BIGINT
    Select Tab As Context    Default Value
    Type Into Text Field    0    12
    Check    ALTER DOMAIN TEST_DOMAIN SET DEFAULT 12
    Check SQL    SELECT RDB$DEFAULT_SOURCE FROM RDB$FIELDS WHERE RDB$FIELD_NAME = 'TEST_DOMAIN'    DEFAULT 12

test_check
    Init    CREATE DOMAIN TEST_DOMAIN AS BIGINT
    Select Tab As Context    Check
    Type Into Text Field    0    VALUE > 5
    Check    ALTER DOMAIN TEST_DOMAIN DROP CONSTRAINT ADD CHECK (VALUE > 5)
    Check SQL    SELECT RDB$VALIDATION_SOURCE FROM RDB$FIELDS WHERE RDB$FIELD_NAME = 'TEST_DOMAIN'    CHECK (VALUE > 5)

test_comment
    Init    CREATE DOMAIN TEST_DOMAIN AS BIGINT
    Select Tab As Context    Comment
    Type Into Text Field    0    Test Comment Text
    Push Button    rollbackCommentButton
    ${res}=    Get Text Field Value    0
    Should Be Equal As Strings    ${res}    ${EMPTY}    strip_spaces=${True}    collapse_spaces=${True}

    Type Into Text Field    0    Test Comment Text
    Check    COMMENT ON DOMAIN TEST_DOMAIN IS 'Test Comment Text'
    Check SQL    SELECT RDB$DESCRIPTION FROM RDB$FIELDS WHERE RDB$FIELD_NAME = 'TEST_DOMAIN'    Test Comment Text
    
    Select Tab As Context    Comment
    Type Into Text Field    0    Test Comment Text For Special Button
    Push Button    updateCommentButton
    Check SQL    SELECT RDB$DESCRIPTION FROM RDB$FIELDS WHERE RDB$FIELD_NAME = 'TEST_DOMAIN'    Test Comment Text For Special Button
    
test_sql
    Init    CREATE DOMAIN TEST_DOMAIN AS BIGINT
    Select Tab As Context    Type
    Select From Combo Box    typesCombo    INT128
    Select Main Window
    Select Tab As Context    Check
    Type Into Text Field    0    VALUE > 5
    Select Main Window
    Select Tab As Context    SQL
    ${res}=    Get Text Field Value    0
    Should Be Equal As Strings    ${res}    ALTER DOMAIN TEST_DOMAIN DROP CONSTRAINT ADD CHECK (VALUE > 5) TYPE INT128;    strip_spaces=${True}    collapse_spaces=${True}
    Clear Text Field    0
    Type Into Text Field    0    ALTER DOMAIN TEST_DOMAIN DROP CONSTRAINT ADD CHECK (VALUE > 5);
    Check    ALTER DOMAIN TEST_DOMAIN DROP CONSTRAINT ADD CHECK (VALUE > 5)

test_dependencies
    Init    CREATE DOMAIN TEST_DOMAIN AS BIGINT
    Select Tab As Context    Dependencies
    Collapse Tree Node    0    0
    Collapse Tree Node    1    0

test_ddl_to_create
    Init    CREATE DOMAIN TEST_DOMAIN AS BIGINT
    Select Tab As Context    DDL to create
    ${res}=    Get Text Field Value    0
    ${text}=    Set Variable    CREATE DOMAIN TEST_DOMAIN AS BIGINT;
    Should Be Equal As Strings    ${res}    ${text}    strip_spaces=${True}    collapse_spaces=${True}

test_collation
    Init    CREATE DOMAIN TEST_DOMAIN AS VARCHAR(123) CHARACTER SET UTF8 COLLATE UTF8
    Select From Tree Node Popup Menu   0    New Connection|Domains (16)|TEST_DOMAIN    Edit domain
    ${res}=    Get Selected Item From Combo Box    collatesCombo
    Should Be Equal As Strings    ${res}    UTF8

test_default_value_check_comment
    Lock Employee
    Execute Immediate    CREATE DOMAIN TEST_DOMAIN AS BIGINT DEFAULT 3 CHECK (VALUE<10)
    Execute Immediate    COMMENT ON DOMAIN TEST_DOMAIN IS 'Test Comment';
    Open connection
    Select From Tree Node Popup Menu   0    New Connection|Domains (16)|TEST_DOMAIN    Edit domain    
    Select Tab As Context    Default Value
    ${res}=    Get Text Field Value    0
    Should Be Equal As Strings    ${res}    10
    Select Main Window
    Select Tab As Context    Check
    ${res}=    Get Text Field Value    0
    Should Be Equal As Strings    ${res}    VALUE<10
    Select Main Window
    Select Tab As Context    Comment
    ${res}=    Get Text Field Value    0
    Should Be Equal As Strings    ${res}    Test Comment
    Select Main Window

*** Keywords ***
Init
    [Arguments]    ${text}    ${name}=TEST_DOMAIN
    Lock Employee
    Execute Immediate    ${text}
    Open connection
    Select From Tree Node Popup Menu   0    New Connection|Domains (16)|${name}    Edit domain

Check
    [Arguments]    ${text}
    Select Main Window
    Sleep    0.5s
    Push Button    submitButton
    Sleep    0.5s
    Select Dialog    Commiting changes
    ${res}=    Get Text Field Value    0
    Should Be Equal As Strings    ${res}    ${text}    strip_spaces=${True}    collapse_spaces=${True}
    Push Button    commitButton
    Select Main Window

Check SQL
    [Arguments]    ${sql}    ${check}
    ${res}=    Execute    ${sql}
    ${cleared_res}=    Evaluate    "${res}".replace("[(", "").replace(")]", "").replace(",", "").replace("'", "")
    Should Be Equal As Strings    ${cleared_res}    ${check}    strip_spaces=${True}    collapse_spaces=${True}    

