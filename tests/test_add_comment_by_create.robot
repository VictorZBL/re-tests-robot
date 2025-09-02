*** Settings ***
Library    RemoteSwingLibrary
Resource    ../files/keywords.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_create_domain
    Init Create    Domains (15)    Create domain
    Check Comment

test_create_table
    Init Create    Tables (10)    Create table
    Init Column
    Check Comment

test_create_table_columns
    Init Create    Tables (10)    Create table
    Init Column
    Check Column Comment

test_create_gtt
    Init Create    Global Temporary Tables (0)    Create global temporary table
    Init Column
    Check Comment

test_create_gtt_columns
    Init Create    Global Temporary Tables (0)    Create global temporary table
    Init Column
    Check Column Comment

test_create_view
    Init Create    Views (1)    Create view
    Select Tab As Context    Select Statement
    Clear Text Field    0
    Type Into Text Field    0    SELECT emp_no FROM employee
    Select Dialog    dialog0
    Check Comment

test_create_procedure
    Init Create    Procedures (10)    Create procedure
    Check Comment

test_create_procedure_input_p
    Init Create    Procedures (10)    Create procedure
    Check Procedure    Input Parameters

test_create_procedure_output_p
    Init Create    Procedures (10)    Create procedure
    Check Procedure    Output Parameters

test_create_procedure_variables
    Init Create    Procedures (10)    Create procedure
    Check Procedure    Variables

test_create_procedure_cursors
    Skip    Sometimes we got java NPE
    Init Create    Procedures (10)    Create procedure
    Select Tab As Context    Cursors
    List Components In Context
    Type Into Table Cell    0    0    Name    TEST
    Type Into Table Cell    0    0    Comment    test_comment
    Click On Table Cell    0    0    Name    2
    Send Keyboard Event    VK_ENTER
    Type Into Text Field    0    select * from employee
    Send Keyboard Event    VK_ENTER
    Select Dialog    dialog0
    Push Button    submitButton
    Select Dialog    Commiting changes
    ${res}=    Get Text Field Value    0
    Sleep    1s
    Should Not Be Equal As Integers    ${{$res.find('test_comment')}}    -1

test_create_function
    Check Skip 2.6
    Init Create    Functions (0)    Create function
    Check Comment

test_create_function_arg
    Check Skip 2.6
    Init Create    Functions (0)    Create function
    Check Procedure    Arguments

test_create_function_variables
    Check Skip 2.6
    Init Create    Functions (0)    Create function
    Check Procedure    Variables

test_create_function_cursors
    Skip    Sometimes we got java NPE
    Init Create    Functions (0)    Create function

test_create_package
    Check Skip 2.6
    Init Create    Packages (0)    Create package
    Check Comment

test_create_trigger_for_table
    Init Create    Table Triggers (4)    Create table trigger
    Check Check Box    insertCheck
    Check Comment

test_create_trigger_for_ddl
    Check Skip 2.6
    Init Create    DDL Triggers (0)    Create DDL trigger
    Check Check Box    anyStatementCheck
    Check Comment

test_create_trigger_for_db
    Init Create    DB Triggers (0)    Create DB trigger
    Check Comment

test_create_sequence
    Init Create    Sequences (2)    Create sequence
    Check Comment

test_create_exception
    Init Create    Exceptions (5)    Create exception
    Check Comment

test_create_udf
    Init Create    UDFs (0)    Create UDF
    Check Comment 

test_create_index
    Init Create    Indices (38)    Create index
    Push Button    selectAllButton
    Check Comment

test_create_ts
    Check Skip
    Init Create    Tablespaces (0)    Create tablespace
    Check Comment

test_create_job
    Check Skip
    Init Create    Jobs (0)    Create job
    Select From Combo Box    jobTypeCombo    BASH
    Check Comment

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

Init Create
    [Arguments]    ${object}    ${menu}
    Open connection
    Select From Tree Node Popup Menu   0    New Connection|${object}    ${menu}
    Select Dialog    dialog0

Check Procedure
    [Arguments]    ${tab}
    Select Tab As Context    ${tab}
    IF    '${tab}' == 'Variables'
        Push Button    addRowButton    
    END
    Type Into Table Cell    0    0    Name    TEST
    Set Table Cell Value    0    0    Datatype    BIGINT
    Type Into Table Cell    0    0    Comment    test_comment
    Click On Table Cell    0    0    Name    2
    Send Keyboard Event    VK_ENTER
    Select Dialog    dialog0
    Push Button    submitButton
    Select Dialog    Commiting changes
    Sleep    1s
    ${res}=    Get Text Field Value    0
    Should Not Be Equal As Integers    ${{$res.find('test_comment')}}    -1


Init Column
    Type Into Table Cell    0    0    Name    TEST
    Set Table Cell Value    0    0    Datatype    BIGINT
    Click On Table Cell    0    0    Name    2      
    Send Keyboard Event    VK_ENTER

Check Column Comment
    Type Into Table Cell    0    0    Comment    test_comment
    Send Keyboard Event    VK_ENTER
    Push Button    submitButton
    Select Dialog    Commiting changes
    Sleep    1s
    ${res}=    Get Text Field Value    0
    Should Not Be Equal As Integers    ${{$res.find('\'test_comment\'')}}    -1

Check Comment
    Select Tab As Context    Comment
    Clear Text Field    0
    Type Into Text Field    0    test_comment
    Select Dialog    dialog0
    Push Button    submitButton
    Select Dialog    Commiting changes
    Sleep    1s
    ${res}=    Get Text Field Value    0
    Should Not Be Equal As Integers    ${{$res.find('\'test_comment\'')}}    -1