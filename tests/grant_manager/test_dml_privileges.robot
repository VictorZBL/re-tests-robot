*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../files/keywords.resource 
Resource    ./key.resource
Test Setup       Init DML
Test Teardown    Teardown after every tests

*** Test Cases ***
test_check_filter
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

test_check_for_privileges_list
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    ${srv_ver} =    Set Variable    ${info}[2]
    IF    $ver != '2.6'
        Execute Immediate    CREATE OR ALTER FUNCTION NEW_FUNC RETURNS VARCHAR(5) AS begin RETURN 'five'; end
        Execute Immediate    CREATE PACKAGE NEW_PACK AS BEGIN END
        Execute Immediate    RECREATE PACKAGE BODY NEW_PACK AS BEGIN END
    END
    @{privileges_for_list}=    Get List Values    0
    @{expected_privileges_for_list}=    Create List    SYSDBA
    Should Be Equal As Strings    ${privileges_for_list}    ${expected_privileges_for_list}
    
    Select From Combo Box    userTypeCombo    Roles
    @{privileges_for_list}=    Get List Values    0
    IF    $ver == '2.6'
        @{expected_privileges_for_list}=    Create List    RDB$ADMIN    SECADMIN    PUBLIC
    ELSE IF    $srv_ver == 'Firebird'
        @{expected_privileges_for_list}=    Create List    RDB$ADMIN    PUBLIC
    ELSE
        @{expected_privileges_for_list}=    Create List    RDB$ADMIN    RDB$DBADMIN    RDB$SYSADMIN    RDB$USER    PUBLIC
    END
    Should Be Equal As Strings    ${privileges_for_list}    ${expected_privileges_for_list}
    
    Select From Combo Box    userTypeCombo    Views
    @{privileges_for_list}=    Get List Values    0
    @{expected_privileges_for_list}=    Create List    PHONE_LIST
    Should Be Equal As Strings    ${privileges_for_list}    ${expected_privileges_for_list}
    
    Select From Combo Box    userTypeCombo    Triggers
    @{privileges_for_list}=    Get List Values    0
    @{expected_privileges_for_list}=    Create List    POST_NEW_ORDER    SAVE_SALARY_CHANGE    SET_CUST_NO    SET_EMP_NO
    Should Be Equal As Strings    ${privileges_for_list}    ${expected_privileges_for_list}

    Select From Combo Box    userTypeCombo    Procedures
    @{privileges_for_list}=    Get List Values    0
    Log Variables
    @{expected_privileges_for_list}=    Create List    ADD_EMP_PROJ    ALL_LANGS    DELETE_EMPLOYEE    DEPT_BUDGET    GET_EMP_PROJ    MAIL_LABEL    ORG_CHART    SHIP_ORDER    SHOW_LANGS    SUB_TOT_BUDGET
    Should Be Equal As Strings    ${privileges_for_list}    ${expected_privileges_for_list}
    
    IF    $ver != '2.6'
        Select From Combo Box    userTypeCombo    Functions
        @{privileges_for_list}=    Get List Values    0
        @{expected_privileges_for_list}=    Create List    NEW_FUNC
        Should Be Equal As Strings    ${privileges_for_list}    ${expected_privileges_for_list}

        Select From Combo Box    userTypeCombo    Packages
        @{privileges_for_list}=    Get List Values    0
        @{expected_privileges_for_list}=    Create List    NEW_PACK
        Should Be Equal As Strings    ${privileges_for_list}    ${expected_privileges_for_list}
    END

test_show_system_obj
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    ${srv_ver}=    Set Variable    ${info}[2]
    Check Check Box    Show System Objects
    Sleep    3s
    @{column_values}=    Get Table Column Values    0    Object
    IF    ${{$srv_ver == 'RedDatabase'}}
        IF  ${{$ver == '5'}}
            @{expected_column_values}=    Create List    COUNTRY    CUSTOMER    DEPARTMENT    EMPLOYEE    EMPLOYEE_PROJECT    JOB    PROJECT    PROJ_DEPT_BUDGET    SALARY_HISTORY    SALES    MON$ATTACHMENTS    MON$CALL_STACK    MON$COMPILED_STATEMENTS    MON$CONTEXT_VARIABLES    MON$DATABASE    MON$IO_STATS    MON$MEMORY_USAGE    MON$RECORD_STATS    MON$REPLICATION    MON$STATEMENTS    MON$STATEMENT_PARAMETERS    MON$TABLE_STATS    MON$TEMP_FILES    MON$TEMP_SPACES    MON$TRANSACTIONS    RDB$AUTH_MAPPING    RDB$BACKUP_HISTORY    RDB$CHARACTER_SETS    RDB$CHECK_CONSTRAINTS    RDB$COLLATIONS    RDB$CONFIG    RDB$CONSTANTS    RDB$DATABASE    RDB$DB_CREATORS    RDB$DEPENDENCIES    RDB$EXCEPTIONS    RDB$FIELDS    RDB$FIELD_DIMENSIONS    RDB$FILES    RDB$FILTERS    RDB$FORMATS    RDB$FUNCTIONS    RDB$FUNCTION_ARGUMENTS    RDB$GENERATORS    RDB$INDEX_SEGMENTS    RDB$INDICES    RDB$JOBS    RDB$JOBS_LOG    RDB$KEYWORDS    RDB$LOG_FILES    RDB$PACKAGES    RDB$PAGES    RDB$PROCEDURES    RDB$PROCEDURE_PARAMETERS    RDB$PUBLICATIONS    RDB$PUBLICATION_TABLES    RDB$REF_CONSTRAINTS    RDB$RELATIONS    RDB$RELATION_CONSTRAINTS    RDB$RELATION_FIELDS    RDB$ROLES    RDB$SECURITY_CLASSES    RDB$TABLESPACES    RDB$TIME_ZONES    RDB$TRANSACTIONS    RDB$TRIGGERS    RDB$TRIGGER_MESSAGES    RDB$TYPES    RDB$USER_PRIVILEGES    RDB$VIEW_RELATIONS    SEC$DB_CREATORS    SEC$GLOBAL_AUTH_MAPPING    SEC$POLICIES    SEC$USERS    SEC$USER_ATTRIBUTES    PHONE_LIST    ADD_EMP_PROJ    ALL_LANGS    DELETE_EMPLOYEE    DEPT_BUDGET    GET_EMP_PROJ    MAIL_LABEL    ORG_CHART    SHIP_ORDER    SHOW_LANGS    SUB_TOT_BUDGET    RDB$BLOB_UTIL    RDB$PROFILER    RDB$TIME_ZONE_UTIL    CUST_NO_GEN    EMP_NO_GEN    RDB$BACKUP_HISTORY    RDB$CONSTRAINT_NAME    RDB$EXCEPTIONS    RDB$FIELD_NAME    RDB$FUNCTIONS    RDB$GENERATOR_NAME    RDB$INDEX_NAME    RDB$PROCEDURES    RDB$SECURITY_CLASS    RDB$TABLESPACES    RDB$TRIGGER_NAME    SQL$DEFAULT    CUSTOMER_CHECK    CUSTOMER_ON_HOLD    ORDER_ALREADY_SHIPPED    REASSIGN_SALES    UNKNOWN_EMP_ID
        ELSE IF    ${{$ver == '3'}}
            @{expected_column_values}=    Create List    COUNTRY    CUSTOMER    DEPARTMENT    EMPLOYEE    EMPLOYEE_PROJECT    JOB    PROJECT    PROJ_DEPT_BUDGET    SALARY_HISTORY    SALES    MON$ATTACHMENTS    MON$CALL_STACK    MON$CONTEXT_VARIABLES    MON$DATABASE    MON$IO_STATS    MON$MEMORY_USAGE    MON$RECORD_STATS    MON$REPLICATION    MON$STATEMENTS    MON$TABLE_STATS    MON$TRANSACTIONS    RDB$AUTH_MAPPING    RDB$BACKUP_HISTORY    RDB$CHARACTER_SETS    RDB$CHECK_CONSTRAINTS    RDB$COLLATIONS    RDB$DATABASE    RDB$DB_CREATORS    RDB$DEPENDENCIES    RDB$EXCEPTIONS    RDB$FIELDS    RDB$FIELD_DIMENSIONS    RDB$FILES    RDB$FILTERS    RDB$FORMATS    RDB$FUNCTIONS    RDB$FUNCTION_ARGUMENTS    RDB$GENERATORS    RDB$INDEX_SEGMENTS    RDB$INDICES    RDB$LOG_FILES    RDB$PACKAGES    RDB$PAGES    RDB$PROCEDURES    RDB$PROCEDURE_PARAMETERS    RDB$REF_CONSTRAINTS    RDB$RELATIONS    RDB$RELATION_CONSTRAINTS    RDB$RELATION_FIELDS    RDB$ROLES    RDB$SECURITY_CLASSES    RDB$TRANSACTIONS    RDB$TRIGGERS    RDB$TRIGGER_MESSAGES    RDB$TYPES    RDB$USER_PRIVILEGES    RDB$VIEW_RELATIONS    SEC$DB_CREATORS    SEC$GLOBAL_AUTH_MAPPING    SEC$USERS    SEC$USER_ATTRIBUTES    PHONE_LIST    ADD_EMP_PROJ    ALL_LANGS    DELETE_EMPLOYEE    DEPT_BUDGET    GET_EMP_PROJ    MAIL_LABEL    ORG_CHART    SHIP_ORDER    SHOW_LANGS    SUB_TOT_BUDGET    CUST_NO_GEN    EMP_NO_GEN    RDB$BACKUP_HISTORY    RDB$CONSTRAINT_NAME    RDB$EXCEPTIONS    RDB$FIELD_NAME    RDB$FUNCTIONS    RDB$GENERATOR_NAME    RDB$INDEX_NAME    RDB$PROCEDURES    RDB$SECURITY_CLASS    RDB$TRIGGER_NAME    SQL$DEFAULT    CUSTOMER_CHECK    CUSTOMER_ON_HOLD    ORDER_ALREADY_SHIPPED    REASSIGN_SALES    UNKNOWN_EMP_ID
        ELSE
            @{expected_column_values}=    Create List    COUNTRY    CUSTOMER    DEPARTMENT    EMPLOYEE    EMPLOYEE_PROJECT    JOB    PROJECT    PROJ_DEPT_BUDGET    SALARY_HISTORY    SALES    MON$ATTACHMENTS    MON$CALL_STACK    MON$CONTEXT_VARIABLES    MON$DATABASE    MON$IO_STATS    MON$MEMORY_USAGE    MON$RECORD_STATS    MON$REPLICATION    MON$STATEMENTS    MON$TRANSACTIONS    RDB$BACKUP_HISTORY    RDB$CHARACTER_SETS    RDB$CHECK_CONSTRAINTS    RDB$COLLATIONS    RDB$DATABASE    RDB$DEPENDENCIES    RDB$EXCEPTIONS    RDB$FIELDS    RDB$FIELD_DIMENSIONS    RDB$FILES    RDB$FILTERS    RDB$FORMATS    RDB$FUNCTIONS    RDB$FUNCTION_ARGUMENTS    RDB$GENERATORS    RDB$INDEX_SEGMENTS    RDB$INDICES    RDB$LOG_FILES    RDB$PAGES    RDB$PROCEDURES    RDB$PROCEDURE_PARAMETERS    RDB$REF_CONSTRAINTS    RDB$RELATIONS    RDB$RELATION_CONSTRAINTS    RDB$RELATION_FIELDS    RDB$ROLES    RDB$SECURITY_CLASSES    RDB$TRANSACTIONS    RDB$TRIGGERS    RDB$TRIGGER_MESSAGES    RDB$TYPES    RDB$USER_PRIVILEGES    RDB$VIEW_RELATIONS    PHONE_LIST    ADD_EMP_PROJ    ALL_LANGS    DELETE_EMPLOYEE    DEPT_BUDGET    GET_EMP_PROJ    MAIL_LABEL    ORG_CHART    SHIP_ORDER    SHOW_LANGS    SUB_TOT_BUDGET
        END
    ELSE
        IF  ${{$ver == '5'}}
            @{expected_column_values}=    Create List    COUNTRY    CUSTOMER    DEPARTMENT    EMPLOYEE    EMPLOYEE_PROJECT    JOB    PROJECT    PROJ_DEPT_BUDGET    SALARY_HISTORY    SALES    MON$ATTACHMENTS    MON$CALL_STACK    MON$COMPILED_STATEMENTS    MON$CONTEXT_VARIABLES    MON$DATABASE    MON$IO_STATS    MON$MEMORY_USAGE    MON$RECORD_STATS    MON$STATEMENTS    MON$TABLE_STATS    MON$TRANSACTIONS    RDB$AUTH_MAPPING    RDB$BACKUP_HISTORY    RDB$CHARACTER_SETS    RDB$CHECK_CONSTRAINTS    RDB$COLLATIONS    RDB$CONFIG    RDB$DATABASE    RDB$DB_CREATORS    RDB$DEPENDENCIES    RDB$EXCEPTIONS    RDB$FIELDS    RDB$FIELD_DIMENSIONS    RDB$FILES    RDB$FILTERS    RDB$FORMATS    RDB$FUNCTIONS    RDB$FUNCTION_ARGUMENTS    RDB$GENERATORS    RDB$INDEX_SEGMENTS    RDB$INDICES    RDB$KEYWORDS    RDB$LOG_FILES    RDB$PACKAGES    RDB$PAGES    RDB$PROCEDURES    RDB$PROCEDURE_PARAMETERS    RDB$PUBLICATIONS    RDB$PUBLICATION_TABLES    RDB$REF_CONSTRAINTS    RDB$RELATIONS    RDB$RELATION_CONSTRAINTS    RDB$RELATION_FIELDS    RDB$ROLES    RDB$SECURITY_CLASSES    RDB$TIME_ZONES    RDB$TRANSACTIONS    RDB$TRIGGERS    RDB$TRIGGER_MESSAGES    RDB$TYPES    RDB$USER_PRIVILEGES    RDB$VIEW_RELATIONS    SEC$DB_CREATORS    SEC$GLOBAL_AUTH_MAPPING    SEC$USERS    SEC$USER_ATTRIBUTES    PHONE_LIST    ADD_EMP_PROJ    ALL_LANGS    DELETE_EMPLOYEE    DEPT_BUDGET    GET_EMP_PROJ    MAIL_LABEL    ORG_CHART    SHIP_ORDER    SHOW_LANGS    SUB_TOT_BUDGET    RDB$BLOB_UTIL    RDB$PROFILER    RDB$TIME_ZONE_UTIL    CUST_NO_GEN    EMP_NO_GEN    RDB$BACKUP_HISTORY    RDB$CONSTRAINT_NAME    RDB$EXCEPTIONS    RDB$FIELD_NAME    RDB$FUNCTIONS    RDB$GENERATOR_NAME    RDB$INDEX_NAME    RDB$PROCEDURES    RDB$SECURITY_CLASS    RDB$TRIGGER_NAME    SQL$DEFAULT    CUSTOMER_CHECK    CUSTOMER_ON_HOLD    ORDER_ALREADY_SHIPPED    REASSIGN_SALES    UNKNOWN_EMP_ID
        ELSE
            @{expected_column_values}=    Create List    COUNTRY    CUSTOMER    DEPARTMENT    EMPLOYEE    EMPLOYEE_PROJECT    JOB    PROJECT    PROJ_DEPT_BUDGET    SALARY_HISTORY    SALES    MON$ATTACHMENTS    MON$CALL_STACK    MON$CONTEXT_VARIABLES    MON$DATABASE    MON$IO_STATS    MON$MEMORY_USAGE    MON$RECORD_STATS    MON$STATEMENTS    MON$TABLE_STATS    MON$TRANSACTIONS    RDB$AUTH_MAPPING    RDB$BACKUP_HISTORY    RDB$CHARACTER_SETS    RDB$CHECK_CONSTRAINTS    RDB$COLLATIONS    RDB$DATABASE    RDB$DB_CREATORS    RDB$DEPENDENCIES    RDB$EXCEPTIONS    RDB$FIELDS    RDB$FIELD_DIMENSIONS    RDB$FILES    RDB$FILTERS    RDB$FORMATS    RDB$FUNCTIONS    RDB$FUNCTION_ARGUMENTS    RDB$GENERATORS    RDB$INDEX_SEGMENTS    RDB$INDICES    RDB$LOG_FILES    RDB$PACKAGES    RDB$PAGES    RDB$PROCEDURES    RDB$PROCEDURE_PARAMETERS    RDB$REF_CONSTRAINTS    RDB$RELATIONS    RDB$RELATION_CONSTRAINTS    RDB$RELATION_FIELDS    RDB$ROLES    RDB$SECURITY_CLASSES    RDB$TRANSACTIONS    RDB$TRIGGERS    RDB$TRIGGER_MESSAGES    RDB$TYPES    RDB$USER_PRIVILEGES    RDB$VIEW_RELATIONS    SEC$DB_CREATORS    SEC$GLOBAL_AUTH_MAPPING    SEC$USERS    SEC$USER_ATTRIBUTES    PHONE_LIST    ADD_EMP_PROJ    ALL_LANGS    DELETE_EMPLOYEE    DEPT_BUDGET    GET_EMP_PROJ    MAIL_LABEL    ORG_CHART    SHIP_ORDER    SHOW_LANGS    SUB_TOT_BUDGET    CUST_NO_GEN    EMP_NO_GEN    RDB$BACKUP_HISTORY    RDB$CONSTRAINT_NAME    RDB$EXCEPTIONS    RDB$FIELD_NAME    RDB$FUNCTIONS    RDB$GENERATOR_NAME    RDB$INDEX_NAME    RDB$PROCEDURES    RDB$SECURITY_CLASS    RDB$TRIGGER_NAME    SQL$DEFAULT    CUSTOMER_CHECK    CUSTOMER_ON_HOLD    ORDER_ALREADY_SHIPPED    REASSIGN_SALES    UNKNOWN_EMP_ID
        END
    END
    Should Be Equal As Strings    ${column_values}    ${expected_column_values}

test_check_grant
    [Setup]
    Lock Employee
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    IF    $ver != '2.6'
        Execute Immediate    CREATE OR ALTER FUNCTION NEW_FUNC RETURNS VARCHAR(5) AS begin RETURN 'five'; end
        Execute Immediate    CREATE PACKAGE NEW_PACK AS BEGIN END
        Execute Immediate    RECREATE PACKAGE BODY NEW_PACK AS BEGIN END
    END
    Execute Immediate    CREATE ROLE TEST_ROLE;
    Init Grant Manager
    Select From Combo Box    privilegesTypeCombo    DML privileges
    Select From Combo Box    userTypeCombo    Roles
    Click On List Item    0    TEST_ROLE
    Sleep    2s

    Select Context    DMLPrivilegesPanel
    ${values}=    Get Table Column Values    tableDMLPrivileges    Object
    VAR    ${index}    ${{$values.index('JOB')}}
    Click On Table Cell    tableDMLPrivileges    ${index}    Update    clickCountString=2
    Click On Table Cell    tableDMLPrivileges    ${index}    Insert    clickCountString=2
    Click On Table Cell    tableDMLPrivileges    ${index}    Insert    clickCountString=2

    #Update JOB t and insert wgo JOB t
    ${result}=    Get DML Privileges
    Should Be Equal As Strings    ${result}    [('I', 1, 'JOB '), ('U', 0, 'JOB ')]    strip_spaces=${true}    collapse_spaces=${true}

    Click On Component    icon_grant_row
    Sleep    2s
    
    #all JOB t
    ${result}=    Get DML Privileges
    Should Be Equal As Strings    ${result}    [('D', 0, 'JOB '), ('I', 0, 'JOB '), ('R', 0, 'JOB '), ('S', 0, 'JOB '), ('U', 0, 'JOB ')]    strip_spaces=${true}    collapse_spaces=${true}

    Click On Table Cell    tableDMLPrivileges    ${index}    Update
    Click On Component    icon_revoke_row
    Sleep    2s
    Click On Table Cell    tableDMLPrivileges    ${index}    Update
    Click On Component    icon_grant_column
    Sleep    2s

    #all update t
    ${result}=    Get DML Privileges
    Should Be Equal As Strings    ${result}    [('U', 0, 'COUNTRY '), ('U', 0, 'CUSTOMER '), ('U', 0, 'DEPARTMENT '), ('U', 0, 'EMPLOYEE '), ('U', 0, 'EMPLOYEE_PROJECT '), ('U', 0, 'JOB '), ('U', 0, 'PHONE_LIST '), ('U', 0, 'PROJECT '), ('U', 0, 'PROJ_DEPT_BUDGET '), ('U', 0, 'SALARY_HISTORY '), ('U', 0, 'SALES ')]    strip_spaces=${true}    collapse_spaces=${true}

    Click On Table Cell    tableDMLPrivileges    ${index}    Update
    Click On Component    icon_revoke_column
    Sleep    2s
    
    Click On Table Cell    tableDMLPrivileges    ${index}    Update
    Click On Component    icon_grant_column_admin
    Sleep    2s
    
    Click On Table Cell    tableDMLPrivileges    ${index}    Update
    Click On Component    icon_grant_row_admin
    Sleep    2s

    #all Update wgo + all job t wgo
    ${result}=    Get DML Privileges
    Should Be Equal As Strings    ${result}    [('U', 1, 'COUNTRY '), ('U', 1, 'CUSTOMER '), ('U', 1, 'DEPARTMENT '), ('U', 1, 'EMPLOYEE '), ('U', 1, 'EMPLOYEE_PROJECT '), ('D', 1, 'JOB '), ('I', 1, 'JOB '), ('R', 1, 'JOB '), ('S', 1, 'JOB '), ('U', 1, 'JOB '), ('U', 1, 'PHONE_LIST '), ('U', 1, 'PROJECT '), ('U', 1, 'PROJ_DEPT_BUDGET '), ('U', 1, 'SALARY_HISTORY '), ('U', 1, 'SALES ')]    strip_spaces=${true}    collapse_spaces=${true}

    Click On Table Cell    tableDMLPrivileges    ${index}    Update
    Click On Component    icon_grant_all
    Sleep    2s

    IF    ${{$ver != '2.6'}}
        VAR    ${expected_result_3}    [('X', 0, 'ADD_EMP_PROJ '), ('X', 0, 'ALL_LANGS '), ('D', 0, 'COUNTRY '), ('I', 0, 'COUNTRY '), ('R', 0, 'COUNTRY '), ('S', 0, 'COUNTRY '), ('U', 0, 'COUNTRY '), ('D', 0, 'CUSTOMER '), ('I', 0, 'CUSTOMER '), ('R', 0, 'CUSTOMER '), ('S', 0, 'CUSTOMER '), ('U', 0, 'CUSTOMER '), ('G', 0, 'CUSTOMER_CHECK '), ('G', 0, 'CUSTOMER_ON_HOLD '), ('G', 0, 'CUST_NO_GEN '), ('X', 0, 'DELETE_EMPLOYEE '), ('D', 0, 'DEPARTMENT '), ('I', 0, 'DEPARTMENT '), ('R', 0, 'DEPARTMENT '), ('S', 0, 'DEPARTMENT '), ('U', 0, 'DEPARTMENT '), ('X', 0, 'DEPT_BUDGET '), ('D', 0, 'EMPLOYEE '), ('I', 0, 'EMPLOYEE '), ('R', 0, 'EMPLOYEE '), ('S', 0, 'EMPLOYEE '), ('U', 0, 'EMPLOYEE '), ('D', 0, 'EMPLOYEE_PROJECT '), ('I', 0, 'EMPLOYEE_PROJECT '), ('R', 0, 'EMPLOYEE_PROJECT '), ('S', 0, 'EMPLOYEE_PROJECT '), ('U', 0, 'EMPLOYEE_PROJECT '), ('G', 0, 'EMP_NO_GEN '), ('X', 0, 'GET_EMP_PROJ '), ('D', 0, 'JOB '), ('I', 0, 'JOB '), ('R', 0, 'JOB '), ('S', 0, 'JOB '), ('U', 0, 'JOB '), ('X', 0, 'MAIL_LABEL '), ('X', 0, 'NEW_FUNC '), ('X', 0, 'NEW_PACK '), ('G', 0, 'ORDER_ALREADY_SHIPPED'), ('X', 0, 'ORG_CHART '), ('D', 0, 'PHONE_LIST '), ('I', 0, 'PHONE_LIST '), ('R', 0, 'PHONE_LIST '), ('S', 0, 'PHONE_LIST '), ('U', 0, 'PHONE_LIST '), ('D', 0, 'PROJECT '), ('I', 0, 'PROJECT '), ('R', 0, 'PROJECT '), ('S', 0, 'PROJECT '), ('U', 0, 'PROJECT '), ('D', 0, 'PROJ_DEPT_BUDGET '), ('I', 0, 'PROJ_DEPT_BUDGET '), ('R', 0, 'PROJ_DEPT_BUDGET '), ('S', 0, 'PROJ_DEPT_BUDGET '), ('U', 0, 'PROJ_DEPT_BUDGET '), ('G', 0, 'REASSIGN_SALES '), ('D', 0, 'SALARY_HISTORY '), ('I', 0, 'SALARY_HISTORY '), ('R', 0, 'SALARY_HISTORY '), ('S', 0, 'SALARY_HISTORY '), ('U', 0, 'SALARY_HISTORY '), ('D', 0, 'SALES '), ('I', 0, 'SALES '), ('R', 0, 'SALES '), ('S', 0, 'SALES '), ('U', 0, 'SALES '), ('X', 0, 'SHIP_ORDER '), ('X', 0, 'SHOW_LANGS '), ('X', 0, 'SUB_TOT_BUDGET '), ('G', 0, 'UNKNOWN_EMP_ID ')]

        VAR    ${expected_result_4}    [('X', 1, 'ADD_EMP_PROJ '), ('X', 1, 'ALL_LANGS '), ('D', 1, 'COUNTRY '), ('I', 1, 'COUNTRY '), ('R', 1, 'COUNTRY '), ('S', 1, 'COUNTRY '), ('U', 1, 'COUNTRY '), ('D', 1, 'CUSTOMER '), ('I', 1, 'CUSTOMER '), ('R', 1, 'CUSTOMER '), ('S', 1, 'CUSTOMER '), ('U', 1, 'CUSTOMER '), ('G', 1, 'CUSTOMER_CHECK '), ('G', 1, 'CUSTOMER_ON_HOLD '), ('G', 1, 'CUST_NO_GEN '), ('X', 1, 'DELETE_EMPLOYEE '), ('D', 1, 'DEPARTMENT '), ('I', 1, 'DEPARTMENT '), ('R', 1, 'DEPARTMENT '), ('S', 1, 'DEPARTMENT '), ('U', 1, 'DEPARTMENT '), ('X', 1, 'DEPT_BUDGET '), ('D', 1, 'EMPLOYEE '), ('I', 1, 'EMPLOYEE '), ('R', 1, 'EMPLOYEE '), ('S', 1, 'EMPLOYEE '), ('U', 1, 'EMPLOYEE '), ('D', 1, 'EMPLOYEE_PROJECT '), ('I', 1, 'EMPLOYEE_PROJECT '), ('R', 1, 'EMPLOYEE_PROJECT '), ('S', 1, 'EMPLOYEE_PROJECT '), ('U', 1, 'EMPLOYEE_PROJECT '), ('G', 1, 'EMP_NO_GEN '), ('X', 1, 'GET_EMP_PROJ '), ('D', 1, 'JOB '), ('I', 1, 'JOB '), ('R', 1, 'JOB '), ('S', 1, 'JOB '), ('U', 1, 'JOB '), ('X', 1, 'MAIL_LABEL '), ('X', 1, 'NEW_FUNC '), ('X', 1, 'NEW_PACK '), ('G', 1, 'ORDER_ALREADY_SHIPPED'), ('X', 1, 'ORG_CHART '), ('D', 1, 'PHONE_LIST '), ('I', 1, 'PHONE_LIST '), ('R', 1, 'PHONE_LIST '), ('S', 1, 'PHONE_LIST '), ('U', 1, 'PHONE_LIST '), ('D', 1, 'PROJECT '), ('I', 1, 'PROJECT '), ('R', 1, 'PROJECT '), ('S', 1, 'PROJECT '), ('U', 1, 'PROJECT '), ('D', 1, 'PROJ_DEPT_BUDGET '), ('I', 1, 'PROJ_DEPT_BUDGET '), ('R', 1, 'PROJ_DEPT_BUDGET '), ('S', 1, 'PROJ_DEPT_BUDGET '), ('U', 1, 'PROJ_DEPT_BUDGET '), ('G', 1, 'REASSIGN_SALES '), ('D', 1, 'SALARY_HISTORY '), ('I', 1, 'SALARY_HISTORY '), ('R', 1, 'SALARY_HISTORY '), ('S', 1, 'SALARY_HISTORY '), ('U', 1, 'SALARY_HISTORY '), ('D', 1, 'SALES '), ('I', 1, 'SALES '), ('R', 1, 'SALES '), ('S', 1, 'SALES '), ('U', 1, 'SALES '), ('X', 1, 'SHIP_ORDER '), ('X', 1, 'SHOW_LANGS '), ('X', 1, 'SUB_TOT_BUDGET '), ('G', 1, 'UNKNOWN_EMP_ID ')]
    ELSE
        VAR    ${expected_result_3}    [('X', 0, 'ADD_EMP_PROJ '), ('X', 0, 'ALL_LANGS '), ('D', 0, 'COUNTRY '), ('I', 0, 'COUNTRY '), ('R', 0, 'COUNTRY '), ('S', 0, 'COUNTRY '), ('U', 0, 'COUNTRY '), ('D', 0, 'CUSTOMER '), ('I', 0, 'CUSTOMER '), ('R', 0, 'CUSTOMER '), ('S', 0, 'CUSTOMER '), ('U', 0, 'CUSTOMER '), ('G', 0, 'CUSTOMER_CHECK '), ('G', 0, 'CUSTOMER_ON_HOLD '), ('G', 0, 'CUST_NO_GEN '), ('X', 0, 'DELETE_EMPLOYEE '), ('D', 0, 'DEPARTMENT '), ('I', 0, 'DEPARTMENT '), ('R', 0, 'DEPARTMENT '), ('S', 0, 'DEPARTMENT '), ('U', 0, 'DEPARTMENT '), ('X', 0, 'DEPT_BUDGET '), ('D', 0, 'EMPLOYEE '), ('I', 0, 'EMPLOYEE '), ('R', 0, 'EMPLOYEE '), ('S', 0, 'EMPLOYEE '), ('U', 0, 'EMPLOYEE '), ('D', 0, 'EMPLOYEE_PROJECT '), ('I', 0, 'EMPLOYEE_PROJECT '), ('R', 0, 'EMPLOYEE_PROJECT '), ('S', 0, 'EMPLOYEE_PROJECT '), ('U', 0, 'EMPLOYEE_PROJECT '), ('G', 0, 'EMP_NO_GEN '), ('X', 0, 'GET_EMP_PROJ '), ('D', 0, 'JOB '), ('I', 0, 'JOB '), ('R', 0, 'JOB '), ('S', 0, 'JOB '), ('U', 0, 'JOB '), ('X', 0, 'MAIL_LABEL '), ('G', 0, 'ORDER_ALREADY_SHIPPED'), ('X', 0, 'ORG_CHART '), ('D', 0, 'PHONE_LIST '), ('I', 0, 'PHONE_LIST '), ('R', 0, 'PHONE_LIST '), ('S', 0, 'PHONE_LIST '), ('U', 0, 'PHONE_LIST '), ('D', 0, 'PROJECT '), ('I', 0, 'PROJECT '), ('R', 0, 'PROJECT '), ('S', 0, 'PROJECT '), ('U', 0, 'PROJECT '), ('D', 0, 'PROJ_DEPT_BUDGET '), ('I', 0, 'PROJ_DEPT_BUDGET '), ('R', 0, 'PROJ_DEPT_BUDGET '), ('S', 0, 'PROJ_DEPT_BUDGET '), ('U', 0, 'PROJ_DEPT_BUDGET '), ('G', 0, 'REASSIGN_SALES '), ('D', 0, 'SALARY_HISTORY '), ('I', 0, 'SALARY_HISTORY '), ('R', 0, 'SALARY_HISTORY '), ('S', 0, 'SALARY_HISTORY '), ('U', 0, 'SALARY_HISTORY '), ('D', 0, 'SALES '), ('I', 0, 'SALES '), ('R', 0, 'SALES '), ('S', 0, 'SALES '), ('U', 0, 'SALES '), ('X', 0, 'SHIP_ORDER '), ('X', 0, 'SHOW_LANGS '), ('X', 0, 'SUB_TOT_BUDGET '), ('G', 0, 'UNKNOWN_EMP_ID ')]

        VAR    ${expected_result_4}    [('X', 1, 'ADD_EMP_PROJ '), ('X', 1, 'ALL_LANGS '), ('D', 1, 'COUNTRY '), ('I', 1, 'COUNTRY '), ('R', 1, 'COUNTRY '), ('S', 1, 'COUNTRY '), ('U', 1, 'COUNTRY '), ('D', 1, 'CUSTOMER '), ('I', 1, 'CUSTOMER '), ('R', 1, 'CUSTOMER '), ('S', 1, 'CUSTOMER '), ('U', 1, 'CUSTOMER '), ('G', 1, 'CUSTOMER_CHECK '), ('G', 1, 'CUSTOMER_ON_HOLD '), ('G', 1, 'CUST_NO_GEN '), ('X', 1, 'DELETE_EMPLOYEE '), ('D', 1, 'DEPARTMENT '), ('I', 1, 'DEPARTMENT '), ('R', 1, 'DEPARTMENT '), ('S', 1, 'DEPARTMENT '), ('U', 1, 'DEPARTMENT '), ('X', 1, 'DEPT_BUDGET '), ('D', 1, 'EMPLOYEE '), ('I', 1, 'EMPLOYEE '), ('R', 1, 'EMPLOYEE '), ('S', 1, 'EMPLOYEE '), ('U', 1, 'EMPLOYEE '), ('D', 1, 'EMPLOYEE_PROJECT '), ('I', 1, 'EMPLOYEE_PROJECT '), ('R', 1, 'EMPLOYEE_PROJECT '), ('S', 1, 'EMPLOYEE_PROJECT '), ('U', 1, 'EMPLOYEE_PROJECT '), ('G', 1, 'EMP_NO_GEN '), ('X', 1, 'GET_EMP_PROJ '), ('D', 1, 'JOB '), ('I', 1, 'JOB '), ('R', 1, 'JOB '), ('S', 1, 'JOB '), ('U', 1, 'JOB '), ('X', 1, 'MAIL_LABEL '), ('G', 1, 'ORDER_ALREADY_SHIPPED'), ('X', 1, 'ORG_CHART '), ('D', 1, 'PHONE_LIST '), ('I', 1, 'PHONE_LIST '), ('R', 1, 'PHONE_LIST '), ('S', 1, 'PHONE_LIST '), ('U', 1, 'PHONE_LIST '), ('D', 1, 'PROJECT '), ('I', 1, 'PROJECT '), ('R', 1, 'PROJECT '), ('S', 1, 'PROJECT '), ('U', 1, 'PROJECT '), ('D', 1, 'PROJ_DEPT_BUDGET '), ('I', 1, 'PROJ_DEPT_BUDGET '), ('R', 1, 'PROJ_DEPT_BUDGET '), ('S', 1, 'PROJ_DEPT_BUDGET '), ('U', 1, 'PROJ_DEPT_BUDGET '), ('G', 1, 'REASSIGN_SALES '), ('D', 1, 'SALARY_HISTORY '), ('I', 1, 'SALARY_HISTORY '), ('R', 1, 'SALARY_HISTORY '), ('S', 1, 'SALARY_HISTORY '), ('U', 1, 'SALARY_HISTORY '), ('D', 1, 'SALES '), ('I', 1, 'SALES '), ('R', 1, 'SALES '), ('S', 1, 'SALES '), ('U', 1, 'SALES '), ('X', 1, 'SHIP_ORDER '), ('X', 1, 'SHOW_LANGS '), ('X', 1, 'SUB_TOT_BUDGET '), ('G', 1, 'UNKNOWN_EMP_ID ')]
    END

    #all
    ${result}=    Get DML Privileges
    Should Be Equal As Strings    ${result}    ${expected_result_3}    strip_spaces=${true}    collapse_spaces=${true}

    Click On Table Cell    tableDMLPrivileges    ${index}    Update
    Click On Component    icon_grant_all_admin
    Sleep    2s

    #all wgo
    ${result}=    Get DML Privileges
    Should Be Equal As Strings    ${result}    ${expected_result_4}    strip_spaces=${true}    collapse_spaces=${true}

    Click On Table Cell    tableDMLPrivileges    ${index}    Update
    Click On Component    icon_revoke_all
    Sleep    2s
    
    #revoke all
    ${result}=    Get DML Privileges
    Should Be Equal As Strings    ${result}    []    strip_spaces=${true}    collapse_spaces=${true}

test_check_grant_column
    [Setup]
    Lock Employee
    Execute Immediate    CREATE ROLE TEST_ROLE;
    Init Grant Manager
    Select From Combo Box    privilegesTypeCombo    DML privileges
    Select From Combo Box    userTypeCombo    Roles
    Click On List Item    0    TEST_ROLE
    Sleep    2s

    Select Context    DMLPrivilegesPanel

    ${values}=    Get Table Column Values    tableDMLPrivileges    Object
    VAR    ${index}    ${{$values.index('JOB')}}
    Click On Table Cell    tableDMLPrivileges    ${index}    Object

    Select Context    columnsOfPanel

    ${values}=    Get Table Column Values    privilegesForFieldTable    Field
    VAR    ${index}    ${{$values.index('JOB_TITLE')}}
    
    Click On Table Cell    privilegesForFieldTable    ${index}    Update    clickCountString=2
    Click On Table Cell    privilegesForFieldTable    ${index}    References    clickCountString=2
    Click On Table Cell    privilegesForFieldTable    ${index}    References    clickCountString=2
    Sleep    2s

    #Update JOB_TITLE c and References wgo JOB_TITLE
    ${result}=    Get DML Privileges For Field
    Should Be Equal As Strings    ${result}    [('R', 1, 'JOB_TITLE '), ('U', 0, 'JOB_TITLE ')]    strip_spaces=${true}    collapse_spaces=${true}

    Click On Table Cell    privilegesForFieldTable    ${index}    Update
    Click On Component    icon_grant_column
    Sleep    2s
    
    Click On Component    icon_grant_row
    Sleep    2s

    #all Update JOB c and References JOB_TITLE
    ${result}=    Get DML Privileges For Field
    Should Be Equal As Strings    ${result}    [('U', 0, 'JOB_CODE '), ('U', 0, 'JOB_COUNTRY '), ('U', 0, 'JOB_GRADE '), ('U', 0, 'JOB_REQUIREMENT '), ('R', 0, 'JOB_TITLE '), ('U', 0, 'JOB_TITLE '), ('U', 0, 'LANGUAGE_REQ '), ('U', 0, 'MAX_SALARY '), ('U', 0, 'MIN_SALARY ')]    strip_spaces=${true}    collapse_spaces=${true}

    Click On Table Cell    privilegesForFieldTable    ${index}    Update
    Click On Component    icon_grant_column_admin
    Sleep    2s
    
    Click On Component    icon_grant_row_admin
    Sleep    2s

    #all wgo Update JOB c and wgo References JOB_TITLE
    ${result}=    Get DML Privileges For Field
    Should Be Equal As Strings    ${result}    [('U', 1, 'JOB_CODE '), ('U', 1, 'JOB_COUNTRY '), ('U', 1, 'JOB_GRADE '), ('U', 1, 'JOB_REQUIREMENT '), ('R', 1, 'JOB_TITLE '), ('U', 1, 'JOB_TITLE '), ('U', 1, 'LANGUAGE_REQ '), ('U', 1, 'MAX_SALARY '), ('U', 1, 'MIN_SALARY ')]    strip_spaces=${true}    collapse_spaces=${true}

    Click On Table Cell    privilegesForFieldTable    ${index}    Update
    Click On Component    icon_revoke_column
    Sleep    2s
    
    Click On Component    icon_revoke_row
    Sleep    2s

    #all revoke
    ${result}=    Get DML Privileges For Field
    Should Be Equal As Strings    ${result}    []    strip_spaces=${true}    collapse_spaces=${true}


*** Keywords ***
Init DML
    Lock Employee
    Init Grant Manager
    Select From Combo Box    privilegesTypeCombo    DML privileges
    
Get DML Privileges
    ${result}=    Execute    SELECT CAST(RDB$PRIVILEGE as VARCHAR(1)), RDB$GRANT_OPTION, CAST(RDB$RELATION_NAME as VARCHAR(21)) FROM RDB$USER_PRIVILEGES WHERE RDB$USER='TEST_ROLE' ORDER BY RDB$RELATION_NAME, RDB$PRIVILEGE
    RETURN    ${result}

Get DML Privileges For Field
    ${result}=    Execute    SELECT CAST(RDB$PRIVILEGE as VARCHAR(1)), RDB$GRANT_OPTION, CAST(RDB$FIELD_NAME as VARCHAR(16)) FROM RDB$USER_PRIVILEGES WHERE RDB$USER='TEST_ROLE' ORDER BY RDB$FIELD_NAME, RDB$PRIVILEGE
    RETURN    ${result}