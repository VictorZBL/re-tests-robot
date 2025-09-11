*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../files/keywords.resource
Resource    keys.resource
Test Setup       Setup
Test Teardown    Teardown after every tests

*** Test Cases ***
test_1
    Init    NEW_PACK    NEW_PACK    Body
    Select Tab As Context    Header
    ${value}=    Get Text Field Value    0
    Should Be Equal As Strings    ${value}    BEGIN END
    Clear Text Field    0
    Type Into Text Field    0    BEGIN PROCEDURE TEST_PROC; END

    Select Main Window
    Select Tab As Context    Body
    ${value}=    Get Text Field Value    0
    Should Be Equal As Strings    ${value}    BEGIN END
    Clear Text Field    0
    Type Into Text Field    0    BEGIN PROCEDURE TEST_PROC as begin end END
    
    Select Main Window    
    Check    CREATE OR ALTER PACKAGE NEW_PACK AS BEGIN PROCEDURE TEST_PROC; END    RECREATE PACKAGE BODY NEW_PACK AS BEGIN PROCEDURE TEST_PROC as begin end END

test_2
    Init    "NEW PACK"    NEW PACK    ${None}
    Select Tab As Context    Header
    ${value}=    Get Text Field Value    0
    Should Be Equal As Strings    ${value}    BEGIN END
    Clear Text Field    0
    Type Into Text Field    0    BEGIN PROCEDURE TEST_PROC; END
    
    Select Main Window
    Select Tab As Context    Body
    ${value}=    Get Text Field Value    0
    Should Be Equal As Strings    ${value}    ${EMPTY}
    Select Main Window
    Check    CREATE OR ALTER PACKAGE "NEW PACK" AS BEGIN PROCEDURE TEST_PROC; END    ${None}

test_3
    Init    NEW_PACK    NEW_PACK    Body
    Select Tab As Context    Privileges
    Sleep    1s
    Select Tab As Context    User->Objects
    Sleep    1s
    @{values}=    Get Table Column Values    0    Object
    Should Be Equal As Strings    ${values}    ['COUNTRY', 'CUSTOMER', 'DEPARTMENT', 'EMPLOYEE', 'EMPLOYEE_PROJECT', 'JOB', 'PROJECT', 'PROJ_DEPT_BUDGET', 'SALARY_HISTORY', 'SALES', 'PHONE_LIST', 'ADD_EMP_PROJ', 'ALL_LANGS', 'DELETE_EMPLOYEE', 'DEPT_BUDGET', 'GET_EMP_PROJ', 'MAIL_LABEL', 'ORG_CHART', 'SHIP_ORDER', 'SHOW_LANGS', 'SUB_TOT_BUDGET', 'NEW_PACK', 'CUST_NO_GEN', 'EMP_NO_GEN', 'CUSTOMER_CHECK', 'CUSTOMER_ON_HOLD', 'ORDER_ALREADY_SHIPPED', 'REASSIGN_SALES', 'UNKNOWN_EMP_ID']
    Select Main Window
    Select Tab As Context    Privileges
    Sleep    1s
    Select Tab As Context    Object->Users
    Sleep    1s
    @{values}=    Get Table Column Values    0    User
    Should Be Equal As Strings    ${values}    ['SYSDBA', 'PUBLIC', 'PHONE_LIST', 'POST_NEW_ORDER', 'SAVE_SALARY_CHANGE', 'SET_CUST_NO', 'SET_EMP_NO', 'ADD_EMP_PROJ', 'ALL_LANGS', 'DELETE_EMPLOYEE', 'DEPT_BUDGET', 'GET_EMP_PROJ', 'MAIL_LABEL', 'ORG_CHART', 'SHIP_ORDER', 'SHOW_LANGS', 'SUB_TOT_BUDGET', 'NEW_PACK']

test_4
    Init    NEW_PACK    NEW_PACK    Body
    Select Tab As Context    Dependencies
    Sleep    1s
    
    @{tree1}=    Get Tree Node Child Names    0    New Connection
    @{tree2}=    Get Tree Node Child Names    1    New Connection
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    ${srv_ver}=    Set Variable    ${info}[2]
    IF  ${{$ver == '5.0' and $srv_ver == 'RedDatabase'}}
        Should Be Equal As Strings    ${tree1}    ['Domains', 'Tables', 'Global Temporary Tables', 'Views', 'Procedures', 'Functions', 'Packages', 'Table Triggers', 'DDL Triggers', 'DB Triggers', 'Sequences', 'Exceptions', 'UDFs', 'Users', 'Roles', 'Indices', 'Tablespaces', 'Jobs']
        Should Be Equal As Strings    ${tree2}    ['Domains', 'Tables', 'Global Temporary Tables', 'Views', 'Procedures', 'Functions', 'Packages', 'Table Triggers', 'DDL Triggers', 'DB Triggers', 'Sequences', 'Exceptions', 'UDFs', 'Users', 'Roles', 'Indices', 'Tablespaces', 'Jobs']
    ELSE
        Should Be Equal As Strings    ${tree1}    ['Domains', 'Tables', 'Global Temporary Tables', 'Views', 'Procedures', 'Functions', 'Packages', 'Table Triggers', 'DDL Triggers', 'DB Triggers', 'Sequences', 'Exceptions', 'UDFs', 'Users', 'Roles', 'Indices']
        Should Be Equal As Strings    ${tree2}    ['Domains', 'Tables', 'Global Temporary Tables', 'Views', 'Procedures', 'Functions', 'Packages', 'Table Triggers', 'DDL Triggers', 'DB Triggers', 'Sequences', 'Exceptions', 'UDFs', 'Users', 'Roles', 'Indices']
    END

test_5
    Init    """NEW PACK"""    "NEW PACK"    Body
    Select Tab As Context    DDL to create
    ${res}=    Get Text Field Value    0
    Should Be Equal As Strings    ${res}    CREATE OR ALTER PACKAGE """NEW PACK""" AS BEGIN END; RECREATE PACKAGE BODY """NEW PACK""" AS BEGIN END;    strip_spaces=${True}    collapse_spaces=${True}

*** Keywords ***
Init
    [Arguments]    ${create_name}    ${tree_name}    ${body}
    Lock Employee
    Execute Immediate    CREATE OR ALTER PACKAGE ${create_name} AS BEGIN END
    IF    $body != None
        Execute Immediate    RECREATE PACKAGE BODY ${create_name} AS BEGIN END
    END
    Open connection
    Click On Tree Node    0    New Connection|Packages (1)|${tree_name}    2
    ${name}=    Get Text Field Value    nameField
    Should Be Equal As Strings    ${tree_name}    ${name}


Check
    [Arguments]    ${create_header}    ${create_body}
    Push Button    submitButton
    Select Dialog    Commiting changes    
    ${row_header}=     Find Table Row    0    CREATE OR ALTER PACKAGE
    ${value}=    Get Table Cell Value    0    ${row_header}    Status
    Should Be Equal As Strings    ${value}    Success
    Click On Table Cell    0    ${row_header}    Name operation
    ${res}=    Get Text Field Value    0
    Should Be Equal As Strings    ${res}    ${create_header}    strip_spaces=${True}    collapse_spaces=${True}
    Log Variables
    ${row_body}=     Find Table Row    0    OPERATION
    
    IF    $create_body != None
        ${value}=    Get Table Cell Value    0    ${row_body}    Status
        Should Be Equal As Strings    ${value}    Success
        Click On Table Cell    0    ${row_body}    Name operation 
        ${res}=    Get Text Field Value    0
        Should Be Equal As Strings    ${res}    ${create_body}    strip_spaces=${True}    collapse_spaces=${True}
    ELSE
        Should Be Equal As Integers    ${row_body}    -1
    END

    Push Button    commitButton
    Sleep    0.1s
    ${old}=    Set Jemmy Timeout    DialogWaiter.WaitDialogTimeout	0
    Run Keyword And Expect Error    org.netbeans.jemmy.TimeoutExpiredException: Dialog with name or title 'Commiting changes'    Select Dialog    Commiting changes
