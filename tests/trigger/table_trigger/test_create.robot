*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../../files/keywords.resource
Resource    ../keys.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_basic
    Init
    Check Check Box    insertCheck
    Check    CREATE OR ALTER TRIGGER TEST_TRIGGER FOR COUNTRY ACTIVE BEFORE INSERT POSITION 0 AS BEGIN /* Trigger impl */ END

test_inactive
    Init    name=TEST TRIGGER
    Uncheck Check Box    activeCheck
    Check Check Box    updateCheck
    Check    CREATE OR ALTER TRIGGER "TEST TRIGGER" FOR COUNTRY INACTIVE BEFORE UPDATE POSITION 0 AS BEGIN /* Trigger impl */ END    name=TEST TRIGGER

test_multi_events
    Init    name="TEST TRIGGER"
    Select From Combo Box    beforeAfterCombo    AFTER
    Check Check Box    insertCheck
    Check Check Box    updateCheck
    Check Check Box    deleteCheck
    Check    CREATE OR ALTER TRIGGER """TEST TRIGGER""" FOR COUNTRY ACTIVE AFTER INSERT OR UPDATE OR DELETE POSITION 0 AS BEGIN /* Trigger impl */ END    name="TEST TRIGGER"

test_select_table
    Init
    Select From Combo Box    tableCombo    EMPLOYEE
    Check Check Box    deleteCheck
    Check    CREATE OR ALTER TRIGGER TEST_TRIGGER FOR EMPLOYEE ACTIVE BEFORE DELETE POSITION 0 AS BEGIN /* Trigger impl */ END

test_position
    Init
    Clear Text Field    1
    Type Into Text Field    1    100
    Select From Combo Box    beforeAfterCombo    AFTER
    Check Check Box    updateCheck
    Check    CREATE OR ALTER TRIGGER TEST_TRIGGER FOR COUNTRY ACTIVE AFTER UPDATE POSITION 100 AS BEGIN /* Trigger impl */ END

test_sql
    Init
    Check Check Box    insertCheck
    Select Tab As Context    SQL
    Clear Text Field    0
    Type Into Text Field    0    AS BEGIN POST_EVENT 'cool!'; END
    Select Main Window
    Select Dialog    Create table trigger
    Check    CREATE OR ALTER TRIGGER TEST_TRIGGER FOR COUNTRY ACTIVE BEFORE INSERT POSITION 0 AS BEGIN POST_EVENT 'cool!'; END

test_sql_security_definer
    Check Skip
    Init
    Select From Combo Box    userContextComboBox    DEFINER
    Check Check Box    insertCheck
    Check Check Box    updateCheck
    Check    CREATE OR ALTER TRIGGER TEST_TRIGGER FOR COUNTRY ACTIVE BEFORE INSERT OR UPDATE POSITION 0 SQL SECURITY DEFINER AS BEGIN /* Trigger impl */ END

test_sql_security_invoker
    Check Skip
    Init
    Select From Combo Box    userContextComboBox    INVOKER
    Check Check Box    insertCheck
    Check Check Box    updateCheck
    Check    CREATE OR ALTER TRIGGER TEST_TRIGGER FOR COUNTRY ACTIVE BEFORE INSERT OR UPDATE POSITION 0 SQL SECURITY INVOKER AS BEGIN /* Trigger impl */ END

test_list_tables
    Init
    @{tables}=    Get Combobox Values    tableCombo
    Should Be Equal As Strings    ${tables}    ['COUNTRY', 'CUSTOMER', 'DEPARTMENT', 'EMPLOYEE', 'EMPLOYEE_PROJECT', 'JOB', 'PROJECT', 'PROJ_DEPT_BUDGET', 'SALARY_HISTORY', 'SALES', 'PHONE_LIST']

test_external_module
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    Skip If    ${{$ver == '2.6'}}
    Init
    Check Check Box    useExternalCheck
    Check Check Box    insertCheck
    Clear Text Field    externalField
    Type Into Text Field    externalField    external_code
    Clear Text Field    engineField
    Type Into Text Field    engineField    external_engine
    Check    CREATE OR ALTER TRIGGER TEST_TRIGGER FOR COUNTRY ACTIVE BEFORE INSERT POSITION 0 EXTERNAL NAME 'external_code' ENGINE external_engine 

*** Keywords ***
Init
    [Arguments]    ${name}=TEST_TRIGGER
    Lock Employee
    Open connection
    Select From Tree Node Popup Menu   0    New Connection|Table Triggers (4)    Create table trigger
    Select Dialog    Create table trigger
    Clear Text Field    nameField
    Type Into Text Field    nameField    ${name}


Check
    [Arguments]    ${text}    ${name}=TEST_TRIGGER
    Push Button    submitButton
    Select Dialog    Commiting changes
    Sleep    1s
    ${res}=    Get Text Field Value    0
    Should Be Equal As Strings    ${res}    ${text}    strip_spaces=${True}    collapse_spaces=${True}

    Push Button    commitButton
    Sleep    0.1s
    ${old}=    Set Jemmy Timeout    DialogWaiter.WaitDialogTimeout	0
    Run Keyword And Expect Error    org.netbeans.jemmy.TimeoutExpiredException: Dialog with name or title 'Create table trigger'    Select Dialog    Create table trigger

    Select Main Window
    Tree Node Should Exist    0     New Connection|Table Triggers (5)|${name}