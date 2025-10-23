*** Settings ***
Library    RemoteSwingLibrary
Resource   ../../files/keywords.resource 
Test Setup       Setup before every tests
Test Teardown    Teardown


*** Test Cases ***
test_check_membership
    Lock Employee
    Execute Immediate    CREATE USER ATEST_MEMBERSHIP_USER PASSWORD 'pass'
    Execute Immediate    CREATE USER BTEST_MEMBERSHIP_USER PASSWORD 'pass'

    Execute Immediate    CREATE ROLE ATEST_MEMBERSHIP_ROLE
    Execute Immediate    CREATE ROLE BTEST_MEMBERSHIP_ROLE

    Open connection
    Select From Menu        Tools|User Manager
    Sleep    1s
    Select Tab As Context    Membership

    Select Tab As Context    Users → Roles

    ${values}=    Get Table Values    usersRolesListTable
    VAR    ${index}    ${{$values.index(['ATEST_MEMBERSHIP_USER'])}}
    Click On Table Cell    usersRolesListTable    ${index}    0
    ${row}=    Find Table Row    membershipTable    ATEST_MEMBERSHIP_ROLE    Roles
    Click On Table Cell    membershipTable    ${row}    Grant    2

    ${values}=    Get Table Values    usersRolesListTable
    VAR    ${index}    ${{$values.index(['BTEST_MEMBERSHIP_USER'])}}
    Click On Table Cell    usersRolesListTable    ${index}    0
    ${row}=    Find Table Row    membershipTable    ATEST_MEMBERSHIP_ROLE    Roles
    Click On Table Cell    membershipTable    ${row}    Admin Option    2
    ${cell_value}=    Get Table Cell Value    membershipTable    ${row}    Grant    model
    Should Be Equal As Strings    ${cell_value}    true

    ${values}=    Get Table Values    usersRolesListTable
    VAR    ${index}    ${{$values.index(['BTEST_MEMBERSHIP_ROLE'])}}
    Click On Table Cell    usersRolesListTable    ${index}    0
    
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    ${srv_version}=    Set Variable    ${info}[2]
    IF    ${{not(($srv_version == 'Firebird' and $ver == '3') or $ver == '2.6')}}
        ${row}=    Find Table Row    membershipTable    ATEST_MEMBERSHIP_ROLE    Roles
        Click On Table Cell    membershipTable    ${row}    Default    2
        ${cell_value}=    Get Table Cell Value    membershipTable    ${row}    Grant    model
        Should Be Equal As Strings    ${cell_value}    true
        VAR    ${expected_result}    [('ATEST_MEMBERSHIP_USER', 'M', 0, 8), ('BTEST_MEMBERSHIP_ROLE', 'M', 0, 13), ('BTEST_MEMBERSHIP_USER', 'M', 2, 8)]
    ELSE
        VAR    ${expected_result}    [('ATEST_MEMBERSHIP_USER', 'M', 0, 8), ('BTEST_MEMBERSHIP_USER', 'M', 2, 8)]
    END

    ${result}=    Check membership
    Should Be Equal As Strings    ${result}    ${expected_result}

    Select Main Window
    Select Tab As Context    Membership
    Select Tab As Context    Roles → Users
    
    ${values}=    Get Table Values    usersRolesListTable

    VAR    ${index}    ${{$values.index(['ATEST_MEMBERSHIP_ROLE'])}}
    Click On Table Cell    usersRolesListTable    ${index}    0

    ${row}=    Find Table Row    membershipTable    ATEST_MEMBERSHIP_USER    Users/Roles
    ${cell_value}=    Get Table Cell Value    membershipTable    ${row}    User Type
    Should Be Equal As Strings    ${cell_value}    User
    ${cell_value}=    Get Table Cell Value    membershipTable    ${row}    Grant    model
    Should Be Equal As Strings    ${cell_value}    true
    Click On Table Cell    membershipTable    ${row}    Grant    2

    ${row}=    Find Table Row    membershipTable    BTEST_MEMBERSHIP_USER    Users/Roles
    ${cell_value}=    Get Table Cell Value    membershipTable    ${row}    User Type
    Should Be Equal As Strings    ${cell_value}    User
    ${cell_value}=    Get Table Cell Value    membershipTable    ${row}    Grant    model
    Should Be Equal As Strings    ${cell_value}    true
    ${cell_value}=    Get Table Cell Value    membershipTable    ${row}    Admin Option    model
    Should Be Equal As Strings    ${cell_value}    true
    Click On Table Cell    membershipTable    ${row}    Grant    2
    ${cell_value}=    Get Table Cell Value    membershipTable    ${row}    Admin Option    model
    Should Be Equal As Strings    ${cell_value}    false

    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    ${srv_version}=    Set Variable    ${info}[2]
    IF    ${{not(($srv_version == 'Firebird' and $ver == '3') or $ver == '2.6')}}
        ${row}=    Find Table Row    membershipTable    BTEST_MEMBERSHIP_ROLE    Users/Roles
        ${cell_value}=    Get Table Cell Value    membershipTable    ${row}    User Type
        Should Be Equal As Strings    ${cell_value}    Role
        ${cell_value}=    Get Table Cell Value    membershipTable    ${row}    Grant    model
        Should Be Equal As Strings    ${cell_value}    true
        ${cell_value}=    Get Table Cell Value    membershipTable    ${row}    Default    model
        Should Be Equal As Strings    ${cell_value}    true
        Click On Table Cell    membershipTable    ${row}    Grant    2
        ${cell_value}=    Get Table Cell Value    membershipTable    ${row}    Default    model
        Should Be Equal As Strings    ${cell_value}    false
    END

    ${result}=    Check membership
    Should Be Equal As Strings    ${result}    []

*** Keywords ***
Check membership    
    ${result}=    Execute    select CAST(rdb$user as VARCHAR(21)), CAST(rdb$privilege as VARCHAR(1)), rdb$grant_option, rdb$user_type from RDB$USER_PRIVILEGES where rdb$relation_name='ATEST_MEMBERSHIP_ROLE' order by rdb$user
    RETURN     ${result}

Teardown
    Teardown after every tests
    Run Keyword And Ignore Error    Execute Immediate    DROP USER ATEST_MEMBERSHIP_USER
    Run Keyword And Ignore Error    Execute Immediate    DROP USER BTEST_MEMBERSHIP_USER