*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../files/keywords.resource
Resource    ./key.resource
Test Setup       Setup
Test Teardown    Teardown after every tests

*** Test Cases ***
test_1
    Select From Combo Box    userTypeCombo    Roles
    Select From Combo Box    privilegesTypeCombo    DDL privileges
    Click On List Item    0    TEST_ROLE
    Sleep    1s

    Select Context    DDLPrivilegesPanel
    ${values}=    Get Table Column Values    tableDDLPrivileges    Object
    VAR    ${index}    ${{$values.index('SEQUENCE')}}
    Click On Table Cell    tableDDLPrivileges    ${index}    Create    clickCountString=2
    Click On Table Cell    tableDDLPrivileges    ${index}    Drop    clickCountString=2
    Click On Table Cell    tableDDLPrivileges    ${index}    Drop    clickCountString=2

    #create seq and drop wgo seq
    ${result}=    Get DDL Privileges
    Should Be Equal As Strings    ${result}    [('C', 0, 'SQL$GENERATORS '), ('O', 1, 'SQL$GENERATORS ')]    strip_spaces=${true}    collapse_spaces=${true}

    Click On Component    icon_grant_row
    Sleep    1s

    #all seq
    ${result}=    Get DDL Privileges
    Should Be Equal As Strings    ${result}    [('C', 0, 'SQL$GENERATORS '), ('L', 0, 'SQL$GENERATORS '), ('O', 0, 'SQL$GENERATORS ')]    strip_spaces=${true}    collapse_spaces=${true}

    Click On Table Cell    tableDDLPrivileges    ${index}    Alter
    Click On Component    icon_revoke_row

    Click On Table Cell    tableDDLPrivileges    ${index}    Alter
    Click On Component    icon_grant_column
    Sleep    1s

    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    ${srv_version}=    Set Variable    ${info}[2]
    IF    ${{$ver == '5' and $srv_version == 'RedDatabase'}}
        VAR    ${expected_result_1}        [('L', 0, 'SQL$CHARSETS '), ('L', 0, 'SQL$COLLATIONS '), ('L', 0, 'SQL$DATABASE '), ('L', 0, 'SQL$DOMAINS '), ('L', 0, 'SQL$EXCEPTIONS '), ('L', 0, 'SQL$FILTERS '), ('L', 0, 'SQL$FUNCTIONS '), ('L', 0, 'SQL$GENERATORS '), ('L', 0, 'SQL$JOBS '), ('L', 0, 'SQL$PACKAGES '), ('L', 0, 'SQL$PROCEDURES '), ('L', 0, 'SQL$ROLES '), ('L', 0, 'SQL$TABLES '), ('L', 0, 'SQL$TABLESPACES '), ('L', 0, 'SQL$VIEWS ')]
        
        VAR    ${expected_result_2}    [('L', 1, 'SQL$CHARSETS '), ('L', 1, 'SQL$COLLATIONS '), ('L', 1, 'SQL$DATABASE '), ('L', 1, 'SQL$DOMAINS '), ('L', 1, 'SQL$EXCEPTIONS '), ('L', 1, 'SQL$FILTERS '), ('L', 1, 'SQL$FUNCTIONS '), ('C', 1, 'SQL$GENERATORS '), ('L', 1, 'SQL$GENERATORS '), ('O', 1, 'SQL$GENERATORS '), ('L', 1, 'SQL$JOBS '), ('L', 1, 'SQL$PACKAGES '), ('L', 1, 'SQL$PROCEDURES '), ('L', 1, 'SQL$ROLES '), ('L', 1, 'SQL$TABLES '), ('L', 1, 'SQL$TABLESPACES '), ('L', 1, 'SQL$VIEWS ')]

        VAR    ${expected_result_3}    [('C', 0, 'SQL$CHARSETS '), ('L', 0, 'SQL$CHARSETS '), ('O', 0, 'SQL$CHARSETS '), ('C', 0, 'SQL$COLLATIONS '), ('L', 0, 'SQL$COLLATIONS '), ('O', 0, 'SQL$COLLATIONS '), ('L', 0, 'SQL$DATABASE '), ('O', 0, 'SQL$DATABASE '), ('C', 0, 'SQL$DOMAINS '), ('L', 0, 'SQL$DOMAINS '), ('O', 0, 'SQL$DOMAINS '), ('C', 0, 'SQL$EXCEPTIONS '), ('L', 0, 'SQL$EXCEPTIONS '), ('O', 0, 'SQL$EXCEPTIONS '), ('C', 0, 'SQL$FILTERS '), ('L', 0, 'SQL$FILTERS '), ('O', 0, 'SQL$FILTERS '), ('C', 0, 'SQL$FUNCTIONS '), ('L', 0, 'SQL$FUNCTIONS '), ('O', 0, 'SQL$FUNCTIONS '), ('C', 0, 'SQL$GENERATORS '), ('L', 0, 'SQL$GENERATORS '), ('O', 0, 'SQL$GENERATORS '), ('C', 0, 'SQL$JOBS '), ('L', 0, 'SQL$JOBS '), ('O', 0, 'SQL$JOBS '), ('C', 0, 'SQL$PACKAGES '), ('L', 0, 'SQL$PACKAGES '), ('O', 0, 'SQL$PACKAGES '), ('C', 0, 'SQL$PROCEDURES '), ('L', 0, 'SQL$PROCEDURES '), ('O', 0, 'SQL$PROCEDURES '), ('C', 0, 'SQL$ROLES '), ('L', 0, 'SQL$ROLES '), ('O', 0, 'SQL$ROLES '), ('C', 0, 'SQL$TABLES '), ('L', 0, 'SQL$TABLES '), ('O', 0, 'SQL$TABLES '), ('C', 0, 'SQL$TABLESPACES '), ('L', 0, 'SQL$TABLESPACES '), ('O', 0, 'SQL$TABLESPACES '), ('C', 0, 'SQL$VIEWS '), ('L', 0, 'SQL$VIEWS '), ('O', 0, 'SQL$VIEWS ')]

        VAR    ${expected_result_4}    [('C', 1, 'SQL$CHARSETS '), ('L', 1, 'SQL$CHARSETS '), ('O', 1, 'SQL$CHARSETS '), ('C', 1, 'SQL$COLLATIONS '), ('L', 1, 'SQL$COLLATIONS '), ('O', 1, 'SQL$COLLATIONS '), ('L', 1, 'SQL$DATABASE '), ('O', 1, 'SQL$DATABASE '), ('C', 1, 'SQL$DOMAINS '), ('L', 1, 'SQL$DOMAINS '), ('O', 1, 'SQL$DOMAINS '), ('C', 1, 'SQL$EXCEPTIONS '), ('L', 1, 'SQL$EXCEPTIONS '), ('O', 1, 'SQL$EXCEPTIONS '), ('C', 1, 'SQL$FILTERS '), ('L', 1, 'SQL$FILTERS '), ('O', 1, 'SQL$FILTERS '), ('C', 1, 'SQL$FUNCTIONS '), ('L', 1, 'SQL$FUNCTIONS '), ('O', 1, 'SQL$FUNCTIONS '), ('C', 1, 'SQL$GENERATORS '), ('L', 1, 'SQL$GENERATORS '), ('O', 1, 'SQL$GENERATORS '), ('C', 1, 'SQL$JOBS '), ('L', 1, 'SQL$JOBS '), ('O', 1, 'SQL$JOBS '), ('C', 1, 'SQL$PACKAGES '), ('L', 1, 'SQL$PACKAGES '), ('O', 1, 'SQL$PACKAGES '), ('C', 1, 'SQL$PROCEDURES '), ('L', 1, 'SQL$PROCEDURES '), ('O', 1, 'SQL$PROCEDURES '), ('C', 1, 'SQL$ROLES '), ('L', 1, 'SQL$ROLES '), ('O', 1, 'SQL$ROLES '), ('C', 1, 'SQL$TABLES '), ('L', 1, 'SQL$TABLES '), ('O', 1, 'SQL$TABLES '), ('C', 1, 'SQL$TABLESPACES '), ('L', 1, 'SQL$TABLESPACES '), ('O', 1, 'SQL$TABLESPACES '), ('C', 1, 'SQL$VIEWS '), ('L', 1, 'SQL$VIEWS '), ('O', 1, 'SQL$VIEWS ')]
    ELSE
        VAR    ${expected_result_1}    [('L', 0, 'SQL$CHARSETS '), ('L', 0, 'SQL$COLLATIONS '), ('L', 0, 'SQL$DATABASE '), ('L', 0, 'SQL$DOMAINS '), ('L', 0, 'SQL$EXCEPTIONS '), ('L', 0, 'SQL$FILTERS '), ('L', 0, 'SQL$FUNCTIONS '), ('L', 0, 'SQL$GENERATORS '), ('L', 0, 'SQL$PACKAGES '), ('L', 0, 'SQL$PROCEDURES '), ('L', 0, 'SQL$ROLES '), ('L', 0, 'SQL$TABLES '), ('L', 0, 'SQL$VIEWS ')]

        VAR    ${expected_result_2}    [('L', 1, 'SQL$CHARSETS '), ('L', 1, 'SQL$COLLATIONS '), ('L', 1, 'SQL$DATABASE '), ('L', 1, 'SQL$DOMAINS '), ('L', 1, 'SQL$EXCEPTIONS '), ('L', 1, 'SQL$FILTERS '), ('L', 1, 'SQL$FUNCTIONS '), ('C', 1, 'SQL$GENERATORS '), ('L', 1, 'SQL$GENERATORS '), ('O', 1, 'SQL$GENERATORS '), ('L', 1, 'SQL$PACKAGES '), ('L', 1, 'SQL$PROCEDURES '), ('L', 1, 'SQL$ROLES '), ('L', 1, 'SQL$TABLES '), ('L', 1, 'SQL$VIEWS ')]

        VAR    ${expected_result_3}    [('C', 0, 'SQL$CHARSETS '), ('L', 0, 'SQL$CHARSETS '), ('O', 0, 'SQL$CHARSETS '), ('C', 0, 'SQL$COLLATIONS '), ('L', 0, 'SQL$COLLATIONS '), ('O', 0, 'SQL$COLLATIONS '), ('L', 0, 'SQL$DATABASE '), ('O', 0, 'SQL$DATABASE '), ('C', 0, 'SQL$DOMAINS '), ('L', 0, 'SQL$DOMAINS '), ('O', 0, 'SQL$DOMAINS '), ('C', 0, 'SQL$EXCEPTIONS '), ('L', 0, 'SQL$EXCEPTIONS '), ('O', 0, 'SQL$EXCEPTIONS '), ('C', 0, 'SQL$FILTERS '), ('L', 0, 'SQL$FILTERS '), ('O', 0, 'SQL$FILTERS '), ('C', 0, 'SQL$FUNCTIONS '), ('L', 0, 'SQL$FUNCTIONS '), ('O', 0, 'SQL$FUNCTIONS '), ('C', 0, 'SQL$GENERATORS '), ('L', 0, 'SQL$GENERATORS '), ('O', 0, 'SQL$GENERATORS '), ('C', 0, 'SQL$PACKAGES '), ('L', 0, 'SQL$PACKAGES '), ('O', 0, 'SQL$PACKAGES '), ('C', 0, 'SQL$PROCEDURES '), ('L', 0, 'SQL$PROCEDURES '), ('O', 0, 'SQL$PROCEDURES '), ('C', 0, 'SQL$ROLES '), ('L', 0, 'SQL$ROLES '), ('O', 0, 'SQL$ROLES '), ('C', 0, 'SQL$TABLES '), ('L', 0, 'SQL$TABLES '), ('O', 0, 'SQL$TABLES ') ('C', 0, 'SQL$VIEWS '), ('L', 0, 'SQL$VIEWS '), ('O', 0, 'SQL$VIEWS ')]

        VAR    ${expected_result_4}    [('C', 1, 'SQL$CHARSETS '), ('L', 1, 'SQL$CHARSETS '), ('O', 1, 'SQL$CHARSETS '), ('C', 1, 'SQL$COLLATIONS '), ('L', 1, 'SQL$COLLATIONS '), ('O', 1, 'SQL$COLLATIONS '), ('L', 1, 'SQL$DATABASE '), ('O', 1, 'SQL$DATABASE '), ('C', 1, 'SQL$DOMAINS '), ('L', 1, 'SQL$DOMAINS '), ('O', 1, 'SQL$DOMAINS '), ('C', 1, 'SQL$EXCEPTIONS '), ('L', 1, 'SQL$EXCEPTIONS '), ('O', 1, 'SQL$EXCEPTIONS '), ('C', 1, 'SQL$FILTERS '), ('L', 1, 'SQL$FILTERS '), ('O', 1, 'SQL$FILTERS '), ('C', 1, 'SQL$FUNCTIONS '), ('L', 1, 'SQL$FUNCTIONS '), ('O', 1, 'SQL$FUNCTIONS '), ('C', 1, 'SQL$GENERATORS '), ('L', 1, 'SQL$GENERATORS '), ('O', 1, 'SQL$GENERATORS '), ('C', 1, 'SQL$PACKAGES '), ('L', 1, 'SQL$PACKAGES '), ('O', 1, 'SQL$PACKAGES '), ('C', 1, 'SQL$PROCEDURES '), ('L', 1, 'SQL$PROCEDURES '), ('O', 1, 'SQL$PROCEDURES '), ('C', 1, 'SQL$ROLES '), ('L', 1, 'SQL$ROLES '), ('O', 1, 'SQL$ROLES '), ('C', 1, 'SQL$TABLES '), ('L', 1, 'SQL$TABLES '), ('O', 1, 'SQL$TABLES ') ('C', 1, 'SQL$VIEWS '), ('L', 1, 'SQL$VIEWS '), ('O', 1, 'SQL$VIEWS ')]
    END

    #all alter
    ${result}=    Get DDL Privileges
    Should Be Equal As Strings    ${result}    ${expected_result_1}    strip_spaces=${true}    collapse_spaces=${true}

    Click On Table Cell    tableDDLPrivileges    ${index}    Alter
    Click On Component    icon_revoke_column

    Click On Table Cell    tableDDLPrivileges    ${index}    Alter
    Click On Component    icon_grant_column_admin

    Click On Table Cell    tableDDLPrivileges    ${index}    Alter
    Click On Component    icon_grant_row_admin
    Sleep    1s

    #all alter wgo + create drop seq wgo
    ${result}=    Get DDL Privileges
    Should Be Equal As Strings    ${result}    ${expected_result_2}    strip_spaces=${true}    collapse_spaces=${true}

    Click On Table Cell    tableDDLPrivileges    ${index}    Alter
    Click On Component    icon_grant_all
    Sleep    1s

    #all
    ${result}=    Get DDL Privileges
    Should Be Equal As Strings    ${result}    ${expected_result_3}    strip_spaces=${true}    collapse_spaces=${true}

    Click On Table Cell    tableDDLPrivileges    ${index}    Alter
    Click On Component    icon_grant_all_admin
    Sleep    1s

    #all wgo
    ${result}=    Get DDL Privileges
    Should Be Equal As Strings    ${result}    ${expected_result_4}    strip_spaces=${true}    collapse_spaces=${true}

    Click On Table Cell    tableDDLPrivileges    ${index}    Alter
    Click On Component    icon_revoke_all
    Sleep    1s
    
    #revoke all
    ${result}=    Get DDL Privileges
    Should Be Equal As Strings    ${result}    []    strip_spaces=${true}    collapse_spaces=${true}

    
*** Keywords ***
Setup
    Lock Employee
    Execute Immediate    CREATE ROLE TEST_ROLE;
    Init Grant Manager
    
Get DDL Privileges
    ${result}=    Execute    SELECT CAST(RDB$PRIVILEGE as VARCHAR(1)), RDB$GRANT_OPTION, CAST(RDB$RELATION_NAME as VARCHAR(20)) FROM RDB$USER_PRIVILEGES WHERE RDB$USER='TEST_ROLE' ORDER BY RDB$RELATION_NAME, RDB$PRIVILEGE
    RETURN    ${result}