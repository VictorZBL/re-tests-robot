*** Settings ***
Library    RemoteSwingLibrary
Resource   ../../files/keywords.resource 
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_1
    Lock Employee
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    ${srv_ver} =    Set Variable    ${info}[2]
    IF    $ver != '2.6'
        Execute Immediate    CREATE OR ALTER FUNCTION NEW_FUNC RETURNS VARCHAR(5) AS begin RETURN 'five'; end
        Execute Immediate    CREATE PACKAGE NEW_PACK AS BEGIN END
        Execute Immediate    RECREATE PACKAGE BODY NEW_PACK AS BEGIN END
    END
    Open connection
    Select From Menu        Tools|Grant Manager
    Sleep    1s
    @{privileges_for_list}=    Get List Values    0
    @{expected_privileges_for_list}=    Create List    SYSDBA
    Should Be Equal As Strings    ${privileges_for_list}    ${expected_privileges_for_list}
    
    Select From Combo Box    1    Roles
    @{privileges_for_list}=    Get List Values    0
    IF    $ver == '2.6'
        @{expected_privileges_for_list}=    Create List    RDB$ADMIN    SECADMIN    PUBLIC
    ELSE IF    $srv_ver == 'Firebird'
        @{expected_privileges_for_list}=    Create List    RDB$ADMIN    PUBLIC
    ELSE
        @{expected_privileges_for_list}=    Create List    RDB$ADMIN    RDB$DBADMIN    RDB$SYSADMIN    RDB$USER    PUBLIC
    END
    Should Be Equal As Strings    ${privileges_for_list}    ${expected_privileges_for_list}
    
    Select From Combo Box    1    Views
    @{privileges_for_list}=    Get List Values    0
    @{expected_privileges_for_list}=    Create List    PHONE_LIST
    Should Be Equal As Strings    ${privileges_for_list}    ${expected_privileges_for_list}
    
    Select From Combo Box    1    Triggers
    @{privileges_for_list}=    Get List Values    0
    @{expected_privileges_for_list}=    Create List    POST_NEW_ORDER    SAVE_SALARY_CHANGE    SET_CUST_NO    SET_EMP_NO
    Should Be Equal As Strings    ${privileges_for_list}    ${expected_privileges_for_list}

    Select From Combo Box    1    Procedures
    @{privileges_for_list}=    Get List Values    0
    Log Variables
    @{expected_privileges_for_list}=    Create List    ADD_EMP_PROJ    ALL_LANGS    DELETE_EMPLOYEE    DEPT_BUDGET    GET_EMP_PROJ    MAIL_LABEL    ORG_CHART    SHIP_ORDER    SHOW_LANGS    SUB_TOT_BUDGET
    Should Be Equal As Strings    ${privileges_for_list}    ${expected_privileges_for_list}
    
    IF    $ver != '2.6'
        Select From Combo Box    1    Functions
        @{privileges_for_list}=    Get List Values    0
        @{expected_privileges_for_list}=    Create List    NEW_FUNC
        Should Be Equal As Strings    ${privileges_for_list}    ${expected_privileges_for_list}

        Select From Combo Box    1    Packages
        @{privileges_for_list}=    Get List Values    0
        @{expected_privileges_for_list}=    Create List    NEW_PACK
        Should Be Equal As Strings    ${privileges_for_list}    ${expected_privileges_for_list}
    END