*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../../files/keywords.resource
Resource    ../keys.resource
Resource    key.resource
Test Setup       Setup
Test Teardown    Teardown after every tests

*** Variables ***
@{list_create_check_boxes}
...    CREATE FUNCTION check    
...    CREATE INDEX check    
...    CREATE PROCEDURE check    
...    CREATE SEQUENCE check    
...    CREATE TABLE check    
...    CREATE TRIGGER check    
...    CREATE VIEW check    
...    CREATE DOMAIN check    
...    CREATE EXCEPTION check    
...    CREATE PACKAGE check    
...    CREATE USER check    
...    CREATE COLLATION check    
...    CREATE MAPPING check    
...    CREATE ROLE check    
...    CREATE PACKAGE BODY check    

@{list_alter_check_boxes}
...    ALTER FUNCTION check    
...    ALTER INDEX check    
...    ALTER PROCEDURE check    
...    ALTER SEQUENCE check    
...    ALTER TABLE check    
...    ALTER TRIGGER check    
...    ALTER VIEW check    
...    ALTER DOMAIN check    
...    ALTER EXCEPTION check    
...    ALTER PACKAGE check    
...    ALTER USER check    
...    ALTER CHARACTER SET check    
...    ALTER MAPPING check    
...    ALTER ROLE check    

@{list_drop_check_boxes}
...    DROP FUNCTION check    
...    DROP INDEX check    
...    DROP PROCEDURE check    
...    DROP SEQUENCE check    
...    DROP TABLE check    
...    DROP TRIGGER check    
...    DROP VIEW check    
...    DROP DOMAIN check    
...    DROP EXCEPTION check    
...    DROP PACKAGE check    
...    DROP USER check    
...    DROP COLLATION check    
...    DROP MAPPING check    
...    DROP ROLE check    
...    DROP PACKAGE BODY check    


*** Test Cases ***
test_check_any_statement
    Init
    Check Check Box    anyStatementCheck
    Check Box Should Be Checked    createAllCheck
    Check Box Should Be Checked    alterAllCheck
    Check Box Should Be Checked    dropAllCheck
    Check Boxes Should Be Checked    @{list_create_check_boxes}
    Check Boxes Should Be Checked    @{list_alter_check_boxes}
    Check Boxes Should Be Checked    @{list_drop_check_boxes}

    Check    CREATE OR ALTER TRIGGER NEW_TRIGGER ACTIVE BEFORE ANY DDL STATEMENT POSITION 0 AS BEGIN /* Trigger impl */ END

test_check_only_create_statements
    Init    NEW TRIGGER
    Select From Combo Box    beforeAfterCombo    AFTER
    Check Check Box    createAllCheck
    Check Box Should Be Checked    createAllCheck
    Check Box Should Not Be Checked    alterAllCheck
    Check Box Should Not Be Checked    dropAllCheck
    Check Boxes Should Be Checked    @{list_create_check_boxes}
    Check Boxes Should Not Be Checked    @{list_alter_check_boxes}
    Check Boxes Should Not Be Checked    @{list_drop_check_boxes}

    Check    CREATE OR ALTER TRIGGER "NEW TRIGGER" ACTIVE AFTER CREATE FUNCTION OR CREATE INDEX OR CREATE PROCEDURE OR CREATE SEQUENCE OR CREATE TABLE OR CREATE TRIGGER OR CREATE VIEW OR CREATE DOMAIN OR CREATE EXCEPTION OR CREATE PACKAGE OR CREATE USER OR CREATE COLLATION OR CREATE MAPPING OR CREATE ROLE OR CREATE PACKAGE BODY POSITION 0 AS BEGIN /* Trigger impl */ END    NEW TRIGGER

test_check_only_alter_statements
    Init    "NEW TRIGGER"
    Uncheck Check Box    activeCheck
    Check Check Box    alterAllCheck
    Check Box Should Not Be Checked    createAllCheck
    Check Box Should Be Checked    alterAllCheck
    Check Box Should Not Be Checked    dropAllCheck
    Check Boxes Should Not Be Checked    @{list_create_check_boxes}
    Check Boxes Should Be Checked    @{list_alter_check_boxes}
    Check Boxes Should Not Be Checked    @{list_drop_check_boxes}

    Check    CREATE OR ALTER TRIGGER """NEW TRIGGER""" INACTIVE BEFORE ALTER FUNCTION OR ALTER INDEX OR ALTER PROCEDURE OR ALTER SEQUENCE OR ALTER TABLE OR ALTER TRIGGER OR ALTER VIEW OR ALTER DOMAIN OR ALTER EXCEPTION OR ALTER PACKAGE OR ALTER USER OR ALTER CHARACTER SET OR ALTER MAPPING OR ALTER ROLE POSITION 0 AS BEGIN /* Trigger impl */ END    "NEW TRIGGER"

test_check_only_drop_statements
    Init
    Clear Text Field    1
    Type Into Text Field    1    10
    Check Check Box    dropAllCheck
    Check Box Should Not Be Checked    createAllCheck
    Check Box Should Not Be Checked    alterAllCheck
    Check Box Should Be Checked    dropAllCheck
    Check Boxes Should Not Be Checked    @{list_create_check_boxes}
    Check Boxes Should Not Be Checked    @{list_alter_check_boxes}
    Check Boxes Should Be Checked    @{list_drop_check_boxes}
    
    Check    CREATE OR ALTER TRIGGER NEW_TRIGGER ACTIVE BEFORE DROP FUNCTION OR DROP INDEX OR DROP PROCEDURE OR DROP SEQUENCE OR DROP TABLE OR DROP TRIGGER OR DROP VIEW OR DROP DOMAIN OR DROP EXCEPTION OR DROP PACKAGE OR DROP USER OR DROP COLLATION OR DROP MAPPING OR DROP ROLE OR DROP PACKAGE BODY POSITION 10 AS BEGIN /* Trigger impl */ END

test_use_external_module
    Init
    Check Check Box    anyStatementCheck
    Check Check Box    useExternalCheck
    Type Into Text Field    externalField    external_point
    Type Into Text Field    engineField    external_engine
    Check    CREATE OR ALTER TRIGGER NEW_TRIGGER ACTIVE BEFORE ANY DDL STATEMENT POSITION 0 EXTERNAL NAME 'external_point' ENGINE external_engine

test_sql_security_definer
    Check Skip
    Init
    Select From Combo Box    userContextComboBox    DEFINER
    Check Check Box    anyStatementCheck
    Check    CREATE OR ALTER TRIGGER NEW_TRIGGER ACTIVE BEFORE ANY DDL STATEMENT POSITION 0 SQL SECURITY DEFINER AS BEGIN /* Trigger impl */ END

test_sql_security_invoker
    Check Skip
    Init
    Select From Combo Box    userContextComboBox    INVOKER
    Check Check Box    anyStatementCheck
    Check    CREATE OR ALTER TRIGGER NEW_TRIGGER ACTIVE BEFORE ANY DDL STATEMENT POSITION 0 SQL SECURITY INVOKER AS BEGIN /* Trigger impl */ END

*** Keywords ***
Init
    [Arguments]    ${name}=NEW_TRIGGER
    Lock Employee
    Open connection
    Select From Tree Node Popup Menu   0    New Connection|DDL Triggers (0)    Create DDL trigger
    Select Dialog    Create DDL trigger
    Clear Text Field    nameField
    Type Into Text Field    nameField    ${name}

Check Boxes Should Be Checked
    [Arguments]    @{list_checkboxes}
    FOR    ${check_box}    IN    @{list_checkboxes}
        Check Box Should Be Checked    ${check_box}
    END

Check Boxes Should Not Be Checked
    [Arguments]    @{list_checkboxes}
    FOR    ${check_box}    IN    @{list_checkboxes}
        Check Box Should Not Be Checked   ${check_box}
    END

Check
    [Arguments]    ${text}    ${name}=NEW_TRIGGER
    Push Button    submitButton
    Select Dialog    Commiting changes
    Sleep    1s
    ${res}=    Get Text Field Value    0
    Should Be Equal As Strings    ${res}    ${text}    strip_spaces=${True}    collapse_spaces=${True}

    Push Button    commitButton
    Sleep    0.1s
    ${old}=    Set Jemmy Timeout    DialogWaiter.WaitDialogTimeout    0
    Run Keyword And Expect Error    org.netbeans.jemmy.TimeoutExpiredException: Dialog with name or title 'Create DDL trigger'    Select Dialog    Create DDL trigger

    Select Main Window
    Tree Node Should Exist    0     New Connection|DDL Triggers (1)|${name}