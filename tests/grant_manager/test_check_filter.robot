*** Settings ***
Library    RemoteSwingLibrary
Resource   ../../files/keywords.resource 
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_1
    Open connection
    Select From Menu        Tools|Grant Manager
    Sleep    2s
    Type Into Text Field    0    W
    Sleep    2s
    Push Button    refreshButton
    Sleep    2s
    @{column_values}=    Get Table Column Values    0    Object
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    IF    $ver == '2.6'   
        @{expected_column_values1}=    Create List    SHOW_LANGS
        @{expected_column_values2}=    Create List    COUNTRY    CUSTOMER    DEPARTMENT    EMPLOYEE    EMPLOYEE_PROJECT    JOB    PROJECT    PROJ_DEPT_BUDGET    SALARY_HISTORY    SALES    PHONE_LIST    ADD_EMP_PROJ    ALL_LANGS    DELETE_EMPLOYEE    DEPT_BUDGET    GET_EMP_PROJ    MAIL_LABEL    ORG_CHART    SHIP_ORDER    SUB_TOT_BUDGET
    ELSE
        @{expected_column_values1}=    Create List    SHOW_LANGS    UNKNOWN_EMP_ID
        @{expected_column_values2}=    Create List    COUNTRY    CUSTOMER    DEPARTMENT    EMPLOYEE    EMPLOYEE_PROJECT    JOB    PROJECT    PROJ_DEPT_BUDGET    SALARY_HISTORY    SALES    PHONE_LIST    ADD_EMP_PROJ    ALL_LANGS    DELETE_EMPLOYEE    DEPT_BUDGET    GET_EMP_PROJ    MAIL_LABEL    ORG_CHART    SHIP_ORDER    SUB_TOT_BUDGET    CUST_NO_GEN    EMP_NO_GEN    CUSTOMER_CHECK    CUSTOMER_ON_HOLD    ORDER_ALREADY_SHIPPED    REASSIGN_SALES    
    END
    
    Should Be Equal As Strings    ${column_values}    ${expected_column_values1}
    Check Check Box    Invert Filter
    Sleep    2s
    Push Button    refreshButton
    Sleep    2s
    @{column_values}=    Get Table Column Values    0    Object
    Should Be Equal As Strings    ${column_values}    ${expected_column_values2}