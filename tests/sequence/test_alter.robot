*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../files/keywords.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_1
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    Skip if   ${{$ver == '2.6'}}
    Init    NEW_SEQ    NEW_SEQ
    Clear Text Field    1
    Type Into Text Field    1    100

    Clear Text Field    2
    Type Into Text Field    2    10

    Check    CREATE OR ALTER SEQUENCE NEW_SEQ START WITH 100 INCREMENT BY 10

    Select Main Window
    ${start_value}=    Get Text Field Value    1
    ${increment}=    Get Text Field Value    2
    ${current_value}=    Get Text Field Value    3
    Should Be Equal As Strings    ${start_value}    100
    IF  ${{$ver == '5'}}
        Should Be Equal As Strings    ${current_value}    90
    ELSE
        Should Be Equal As Strings    ${current_value}    100
    END
    Should Be Equal As Strings    ${increment}    10

    Select Tab As Context    DDL to create
    ${res}=    Get Text Field Value    0
    Should Be Equal As Strings    ${res}    CREATE OR ALTER SEQUENCE NEW_SEQ START WITH 100 INCREMENT BY 10    strip_spaces=${True}    collapse_spaces=${True}


test_2
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    Skip if   ${{$ver == '2.6'}}
    Init    NEW_SEQ    NEW_SEQ
    ${start_value}=    Get Text Field Value    1
    ${increment}=    Get Text Field Value    2
    ${current_value}=    Get Text Field Value    3
    Should Be Equal As Strings    ${start_value}    10
    ${info}=    Get Server Info
    IF  ${{$ver == '5'}}
        Should Be Equal As Strings    ${current_value}    9
    ELSE
        Should Be Equal As Strings    ${current_value}    10
    END
    Should Be Equal As Strings    ${increment}    1

test_3
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    Skip if   ${{$ver == '2.6'}}
    Init    "NEW SEQ"    NEW SEQ
    Select Tab As Context    Privileges
    Sleep    1s
    @{values}=    Get Table Column Values    0    User
    Should Be Equal As Strings    ${values}    ['SYSDBA', 'PUBLIC', 'PHONE_LIST', 'POST_NEW_ORDER', 'SAVE_SALARY_CHANGE', 'SET_CUST_NO', 'SET_EMP_NO', 'ADD_EMP_PROJ', 'ALL_LANGS', 'DELETE_EMPLOYEE', 'DEPT_BUDGET', 'GET_EMP_PROJ', 'MAIL_LABEL', 'ORG_CHART', 'SHIP_ORDER', 'SHOW_LANGS', 'SUB_TOT_BUDGET']

test_4
    Log Variables
    Init    NEW_SEQ    NEW_SEQ
    Select Tab As Context    Dependencies
    Sleep    1s
    Expand All Tree Nodes    0
    @{tree1}=    Get Tree Node Child Names    0    New Connection
    @{tree2}=    Get Tree Node Child Names    1    New Connection
    @{tree_proc}=    Get Tree Node Child Names    0    New Connection|Procedures (1)
    Should Be Equal As Strings    ${tree_proc}    ['NEW_PROC']
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    ${srv_ver}=    Set Variable    ${info}[2]
    IF  ${{$ver == '5' and $srv_ver == 'RedDatabase'}}
        Should Be Equal As Strings    ${tree1}    ['Domains', 'Tables', 'Global Temporary Tables', 'Views', 'Procedures (1)', 'Functions', 'Packages', 'Table Triggers', 'DDL Triggers', 'DB Triggers', 'Sequences', 'Exceptions', 'UDFs', 'Users', 'Roles', 'Indices', 'Tablespaces', 'Jobs']
        Should Be Equal As Strings    ${tree2}    ['Domains', 'Tables', 'Global Temporary Tables', 'Views', 'Procedures', 'Functions', 'Packages', 'Table Triggers', 'DDL Triggers', 'DB Triggers', 'Sequences', 'Exceptions', 'UDFs', 'Users', 'Roles', 'Indices', 'Tablespaces', 'Jobs']
    ELSE IF    ${{$ver == '2.6'}}  
        Should Be Equal As Strings    ${tree1}    ['Domains', 'Tables', 'Global Temporary Tables', 'Views', 'Procedures (1)', 'Table Triggers', 'DB Triggers', 'Sequences', 'Exceptions', 'UDFs', 'Roles', 'Indices']
        Should Be Equal As Strings    ${tree2}    ['Domains', 'Tables', 'Global Temporary Tables', 'Views', 'Procedures', 'Table Triggers', 'DB Triggers', 'Sequences', 'Exceptions', 'UDFs', 'Roles', 'Indices']   
    ELSE
        Should Be Equal As Strings    ${tree1}    ['Domains', 'Tables', 'Global Temporary Tables', 'Views', 'Procedures (1)', 'Functions', 'Packages', 'Table Triggers', 'DDL Triggers', 'DB Triggers', 'Sequences', 'Exceptions', 'UDFs', 'Users', 'Roles', 'Indices']
        Should Be Equal As Strings    ${tree2}    ['Domains', 'Tables', 'Global Temporary Tables', 'Views', 'Procedures', 'Functions', 'Packages', 'Table Triggers', 'DDL Triggers', 'DB Triggers', 'Sequences', 'Exceptions', 'UDFs', 'Users', 'Roles', 'Indices']
    END

test_5
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    Init    """NEW SEQ"""    "NEW SEQ"
    Select Tab As Context    DDL to create
    ${res}=    Get Text Field Value    0
    IF   ${{$ver != '2.6'}}
        Should Be Equal As Strings    ${res}    CREATE OR ALTER SEQUENCE """NEW SEQ""" START WITH 10 INCREMENT BY 1;    strip_spaces=${True}    collapse_spaces=${True}
    ELSE
        Should Be Equal As Strings    ${res}    CREATE SEQUENCE """NEW SEQ"""; ALTER SEQUENCE """NEW SEQ""" RESTART WITH 0;    strip_spaces=${True}    collapse_spaces=${True}
    END

*** Keywords ***
Init
    [Arguments]    ${create_name}    ${tree_name}
    Lock Employee
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    IF    ${{$ver == '2.6'}}
        Execute Immediate  CREATE SEQUENCE ${create_name}
        VAR    ${create_proc}     CREATE OR ALTER PROCEDURE NEW_PROC RETURNS ( NEW_GEN INTEGER ) AS BEGIN NEW_GEN = gen_id(NEW_SEQ, 1); END   
    ELSE
        Execute Immediate  CREATE OR ALTER SEQUENCE ${create_name} START WITH 10 INCREMENT BY 1
        VAR    ${create_proc}     CREATE OR ALTER PROCEDURE NEW_PROC RETURNS ( NEW_GEN INTEGER ) AS BEGIN :NEW_GEN = gen_id(NEW_SEQ, 1); END
    END
    Run Keyword If    '${TEST_NAME}' == 'test_4'    Execute Immediate    ${create_proc}
    Open connection
    Click On Tree Node    0    New Connection|Sequences (3)|${tree_name}    2
    ${name}=    Get Text Field Value    nameField
    Should Be Equal As Strings    ${tree_name}    ${name}

Check
    [Arguments]    ${text}
    Push Button    submitButton
    Select Dialog    Commiting changes
    ${res}=    Get Text Field Value    0
    Should Be Equal As Strings    ${res}    ${text}

    Push Button    commitButton
    Sleep    0.1s
    ${old}=    Set Jemmy Timeout    DialogWaiter.WaitDialogTimeout	0
    Run Keyword And Expect Error    org.netbeans.jemmy.TimeoutExpiredException: Dialog with name or title 'Commiting changes'    Select Dialog    Commiting changes