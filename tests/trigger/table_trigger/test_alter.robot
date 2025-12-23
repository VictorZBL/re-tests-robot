*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../../files/keywords.resource
Resource    ../keys.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_check_boxs
    Init
    Uncheck Check Box    insertCheck
    Uncheck Check Box    activeCheck
    Check Check Box    updateCheck
    Check Check Box    deleteCheck    
    Check Changes    CREATE OR ALTER TRIGGER TEST_TRIGGER FOR COUNTRY INACTIVE BEFORE UPDATE OR DELETE POSITION 0 AS BEGIN if (new.COUNTRY is null) then new.COUNTRY = 'test'; END

test_combo_boxs
    Init No Dependencies
    Select From Combo Box    userContextComboBox    DEFINER
    Select From Combo Box    tableCombo    PROJECT
    Select From Combo Box    beforeAfterCombo    AFTER
    Check Changes    CREATE OR ALTER TRIGGER TEST_TRIGGER FOR PROJECT ACTIVE AFTER INSERT POSITION 0 SQL SECURITY DEFINER AS BEGIN /* Comment */ END

test_text_fields
    Init
    Clear Text Field    Spinner.formattedTextField
    Type Into Text Field    Spinner.formattedTextField    1
    Clear Text Field    2
    Type Into Text Field    2    AS BEGIN \n-- Test comment for test \nEND
    Check Changes    CREATE OR ALTER TRIGGER TEST_TRIGGER FOR COUNTRY ACTIVE BEFORE INSERT POSITION 1 AS BEGIN -- Test comment for test END

test_external_module
    Init
    Check Check Box    useExternalCheck
    Type Into Text Field    externalField    TestExternalMetod
    Type Into Text Field    engineField    TestEngine
    Check Changes    CREATE OR ALTER TRIGGER TEST_TRIGGER FOR COUNTRY ACTIVE BEFORE INSERT POSITION 0 EXTERNAL NAME 'TestExternalMetod' ENGINE TestEngine

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
    Expand Tree Node    1    New Connection|Tables (1)
    Tree Node Should Exist    1     New Connection|Tables (1)|COUNTRY

test_ddl_to_create
    Init
    Select Tab As Context    DDL to create
    ${res}=    Get Text Field Value    0
    ${text}=    Set Variable    CREATE OR ALTER TRIGGER TEST_TRIGGER FOR COUNTRY ACTIVE BEFORE INSERT POSITION 0 AS BEGIN if (new.COUNTRY is null) then new.COUNTRY = 'test'; END;
    Should Be Equal As Strings    ${res}    ${text}    strip_spaces=${True}    collapse_spaces=${True}

*** Keywords ***
Init
    [Arguments]    ${name}=TEST_TRIGGER
    Lock Employee    
    Execute Immediate    CREATE OR ALTER TRIGGER TEST_TRIGGER FOR COUNTRY ACTIVE BEFORE INSERT POSITION 0 AS BEGIN if (new.COUNTRY is null) then new.COUNTRY = 'test'; END
    Open connection
    Select From Tree Node Popup Menu   0    New Connection|Table Triggers (5)|${name}    Edit table trigger

Init No Dependencies
    [Arguments]    ${name}=TEST_TRIGGER
    Lock Employee    
    Execute Immediate    CREATE OR ALTER TRIGGER TEST_TRIGGER FOR COUNTRY ACTIVE BEFORE INSERT POSITION 0 AS BEGIN /* Comment */ END
    Open connection
    Select From Tree Node Popup Menu   0    New Connection|Table Triggers (5)|${name}    Edit table trigger

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