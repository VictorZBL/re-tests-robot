*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../files/keywords.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_1
    Init    NEW_EXP    NEW_EXP
    Select Tab As Context    Text
    Clear Text Field    0
    Type Into Text Field    0    new_message
    Select Main Window
    Check    CREATE OR ALTER EXCEPTION NEW_EXP 'new_message'

test_2
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    Skip If    ${{$ver == '2.6'}}
    Init    "NEW EXP"    NEW EXP
    Select Tab As Context    Privileges
    Sleep    1s
    # Check Box Should Be Enabled    Show System Objects
    @{values}=    Get Table Column Values    0    User
    Should Be Equal As Strings    ${values}    ['SYSDBA', 'PUBLIC', 'PHONE_LIST', 'POST_NEW_ORDER', 'SAVE_SALARY_CHANGE', 'SET_CUST_NO', 'SET_EMP_NO', 'ADD_EMP_PROJ', 'ALL_LANGS', 'DELETE_EMPLOYEE', 'DEPT_BUDGET', 'GET_EMP_PROJ', 'MAIL_LABEL', 'ORG_CHART', 'SHIP_ORDER', 'SHOW_LANGS', 'SUB_TOT_BUDGET']

test_3
    Init    """NEW EXP"""    "NEW EXP"
    Select Tab As Context    DDL to create
    ${res}=    Get Text Field Value    0
    Should Be Equal As Strings    ${res}    CREATE EXCEPTION """NEW EXP""" 'message';    strip_spaces=${True}    collapse_spaces=${True}

*** Keywords ***
Init
    [Arguments]    ${create_name}    ${tree_name}
    Lock Employee
    Execute Immediate  CREATE OR ALTER EXCEPTION ${create_name} 'message'
    Open connection
    Click On Tree Node    0    New Connection|Exceptions (6)|${tree_name}    2
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