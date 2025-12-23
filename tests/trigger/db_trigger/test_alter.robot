*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../../files/keywords.resource
Resource    ../keys.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_active
    Init
    Uncheck Check Box    activeCheck
    Check Changes    CREATE OR ALTER TRIGGER TEST_TRIGGER INACTIVE ON CONNECT POSITION 0 AS DECLARE tmp INTEGER; BEGIN SELECT COUNT(*) FROM SHOW_LANGS('ENG', 1, 'USA') INTO tmp; END

test_sql_security_1
    Init 
    Select From Combo Box    userContextComboBox    DEFINER
    Check Changes    CREATE OR ALTER TRIGGER TEST_TRIGGER ACTIVE ON CONNECT POSITION 0 SQL SECURITY DEFINER AS DECLARE tmp INTEGER; BEGIN SELECT COUNT(*) FROM SHOW_LANGS('ENG', 1, 'USA') INTO tmp; END

test_sql_security_2
    Init 
    Select From Combo Box    userContextComboBox    INVOKER
    Check Changes    CREATE OR ALTER TRIGGER TEST_TRIGGER ACTIVE ON CONNECT POSITION 0 SQL SECURITY INVOKER AS DECLARE tmp INTEGER; BEGIN SELECT COUNT(*) FROM SHOW_LANGS('ENG', 1, 'USA') INTO tmp; END

test_external_module
    Init
    Check Check Box    useExternalCheck
    Type Into Text Field    externalField    TestExternalMetod
    Type Into Text Field    engineField    TestEngine
    Check Changes    CREATE OR ALTER TRIGGER TEST_TRIGGER ACTIVE ON CONNECT POSITION 0 EXTERNAL NAME 'TestExternalMetod' ENGINE TestEngine

test_text_field_1
    Init
    Clear Text Field    Spinner.formattedTextField
    Type Into Text Field    Spinner.formattedTextField    3
    Check Changes    CREATE OR ALTER TRIGGER TEST_TRIGGER ACTIVE ON CONNECT POSITION 3 AS DECLARE tmp INTEGER; BEGIN SELECT COUNT(*) FROM SHOW_LANGS('ENG', 1, 'USA') INTO tmp; END

test_text_field_2
    Init
    Clear Text Field    2
    Type Into Text Field    2    AS BEGIN \n-- Test comment for test \nEND
    Check Changes    CREATE OR ALTER TRIGGER TEST_TRIGGER ACTIVE ON CONNECT POSITION 0 AS BEGIN -- Test comment for test END

test_comment_1
    Init
    Select Tab As Context    Comment
    Type Into Text Field    0    TestCommentForTest
    Select Main Window
    Check Changes    COMMENT ON TRIGGER TEST_TRIGGER IS 'TestCommentForTest'

test_comment_2
    Init
    Select Tab As Context    Comment
    Type Into Text Field    0    TestCommentForTest
    Push Button    updateCommentButton
    Check Comment    TestCommentForTest
    
    
test_comment_3
    Init
    Select Tab As Context    Comment
    Type Into Text Field    0    RedoTestComment
    Push Button    rollbackCommentButton
    Check Comment    ${EMPTY}
    
test_privilegs
    Init 
    Select Tab As Context    Privileges
    Select Tab    DDL privileges
    Select Tab    User → Objects

test_dependencies
    Init
    Select Tab As Context    Dependencies
    Collapse Tree Node    0    0
    Expand Tree Node    0    0
    Collapse Tree Node    1    0
    Expand Tree Node    1    New Connection|Procedures (1)
    Tree Node Should Exist    1     New Connection|Procedures (1)|SHOW_LANGS

test_ddl_to_create
    Init
    Select Tab As Context    DDL to create
    ${res}=    Get Text Field Value    0
    ${text}=    Set Variable    CREATE OR ALTER TRIGGER TEST_TRIGGER ACTIVE ON CONNECT POSITION 0 AS DECLARE tmp INTEGER; BEGIN SELECT COUNT(*) FROM SHOW_LANGS('ENG', 1, 'USA') INTO tmp; END;
    Should Be Equal As Strings    ${res}    ${text}    strip_spaces=${True}    collapse_spaces=${True}

*** Keywords ***
Init
    [Arguments]    ${name}=TEST_TRIGGER
    Lock Employee    
    Execute Immediate    CREATE OR ALTER TRIGGER TEST_TRIGGER ACTIVE ON CONNECT POSITION 0 AS DECLARE tmp INTEGER; BEGIN SELECT COUNT(*) FROM SHOW_LANGS('ENG', 1, 'USA') INTO tmp; END
    Open connection
    Select From Tree Node Popup Menu   0    New Connection|DB Triggers (1)|${name}    Edit DB trigger

Check Changes
    [Arguments]    ${text}    ${name}=TEST_TRIGGER 
    Select Main Window
    Push Button    submitButton
    Sleep    0.1s
    Select Dialog    Commiting changes
    ${res}=    Get Text Field Value    0
    Should Be Equal As Strings    ${res}    ${text}    strip_spaces=${True}    collapse_spaces=${True}
    Push Button    commitButton

Check Comment
    [Arguments]    ${text}    
    ${res}=    Get Text Field Value    0
    Should Be Equal As Strings    ${res}    ${text}
    ${res}=    Execute    SELECT RDB$DESCRIPTION FROM RDB$TRIGGERS WHERE RDB$TRIGGER_NAME = 'TEST_TRIGGER'
    ${cleared_res}=    Evaluate    "${res}".replace("[(", "").replace(")]", "").replace(",", "").replace("'", "").replace("None", "")
    Should Be Equal As Strings    ${cleared_res}    ${text}