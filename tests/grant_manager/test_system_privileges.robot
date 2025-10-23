*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../files/keywords.resource
Resource    key.resource
Test Setup       Setup
Test Teardown    Teardown

*** Test Cases ***
test_1
    Select From Combo Box    privilegesTypeCombo    System privileges
    Click On List Item    0    TEST_ROLE
    Sleep    1s

    ${values}=    Get Table Column Values    tableSystemPrivileges    System privileges
    VAR    ${index}    ${{$values.index('READ_RAW_PAGES')}}
    Click On Table Cell    tableSystemPrivileges    ${index}    System privileges    clickCountString=2

    ${values}=    Get Table Column Values    tableSystemPrivileges    System privileges
    VAR    ${index}    ${{$values.index('CREATE_USER_TYPES')}}
    Click On Table Cell    tableSystemPrivileges    ${index}    System privileges    clickCountString=2

    @{priv}=    Get System Privileges
    Should Be Equal As Strings    ${priv}    ['READ_RAW_PAGES', 'CREATE_USER_TYPES']

    Click On Table Cell    tableSystemPrivileges    ${index}    System privileges    clickCountString=2
    @{priv}=    Get System Privileges
    Should Be Equal As Strings    ${priv}    ['READ_RAW_PAGES']

    Select Context    SystemPrivilegesPanel
    Click On Component    icon_grant_column
    
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    ${srv_ver}=     Set Variable    ${info}[2]
    IF    ${{$srv_ver == 'RedDatabase'}}
        VAR    ${expected_roles}    ['USER_MANAGEMENT', 'READ_RAW_PAGES', 'CREATE_USER_TYPES', 'USE_NBACKUP_UTILITY', 'CHANGE_SHUTDOWN_MODE', 'TRACE_ANY_ATTACHMENT', 'MONITOR_ANY_ATTACHMENT', 'CREATE_DATABASE', 'DROP_DATABASE', 'USE_GBAK_UTILITY', 'USE_GSTAT_UTILITY', 'USE_GFIX_UTILITY', 'IGNORE_DB_TRIGGERS', 'CHANGE_HEADER_SETTINGS', 'SELECT_ANY_OBJECT_IN_DATABASE', 'ACCESS_ANY_OBJECT_IN_DATABASE', 'MODIFY_ANY_OBJECT_IN_DATABASE', 'CHANGE_MAPPING_RULES', 'USE_GRANTED_BY_CLAUSE', 'GRANT_REVOKE_ON_ANY_OBJECT', 'GRANT_REVOKE_ANY_DDL_RIGHT', 'CREATE_PRIVILEGED_ROLES', 'GET_DBCRYPT_INFO', 'MODIFY_EXT_CONN_POOL', 'REPLICATE_INTO_DATABASE', 'PROFILE_ANY_ATTACHMENT', 'EXECUTE_ANY_OBJECT_IN_DATABASE', 'UPDATE_ANY_OBJECT_IN_DATABASE']
    ELSE
        VAR    ${expected_roles}    ['USER_MANAGEMENT', 'READ_RAW_PAGES', 'CREATE_USER_TYPES', 'USE_NBACKUP_UTILITY', 'CHANGE_SHUTDOWN_MODE', 'TRACE_ANY_ATTACHMENT', 'MONITOR_ANY_ATTACHMENT', 'CREATE_DATABASE', 'DROP_DATABASE', 'USE_GBAK_UTILITY', 'USE_GSTAT_UTILITY', 'USE_GFIX_UTILITY', 'IGNORE_DB_TRIGGERS', 'CHANGE_HEADER_SETTINGS', 'SELECT_ANY_OBJECT_IN_DATABASE', 'ACCESS_ANY_OBJECT_IN_DATABASE', 'MODIFY_ANY_OBJECT_IN_DATABASE', 'CHANGE_MAPPING_RULES', 'USE_GRANTED_BY_CLAUSE', 'GRANT_REVOKE_ON_ANY_OBJECT', 'GRANT_REVOKE_ANY_DDL_RIGHT', 'CREATE_PRIVILEGED_ROLES', 'GET_DBCRYPT_INFO', 'MODIFY_EXT_CONN_POOL', 'REPLICATE_INTO_DATABASE', 'PROFILE_ANY_ATTACHMENT', 'ACCESS_SHUTDOWN_DATABASE']
    END
    
    @{priv}=    Get System Privileges
    Should Be Equal As Strings    ${priv}    ${expected_roles}

    Push Button    icon_revoke_column

    @{priv}=    Get System Privileges
    Should Be Equal As Strings    ${priv}    []

*** Keywords ***
Setup
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    Skip If    ${{$ver != '5'}}
    Lock Employee
    Execute Immediate    CREATE ROLE TEST_ROLE;
    Execute Immediate    CREATE USER TEST_USER PASSWORD 'pass'
    Execute Immediate    GRANT TEST_ROLE TO USER TEST_USER
    Init Grant Manager

Teardown
    Execute Immediate    REVOKE TEST_ROLE FROM USER TEST_USER
    Execute Immediate    DROP USER TEST_USER
    Teardown after every tests
    