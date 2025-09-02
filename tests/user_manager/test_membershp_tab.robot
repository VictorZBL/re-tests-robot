*** Settings ***
Library    RemoteSwingLibrary
Library    Process
Library    Collections
Resource   ../../files/keywords.resource 
Test Setup       Setup before every tests
Test Teardown    Teardown
*** Test Cases ***
test_check_membership_role_to_user
    Action    USER    0

test_check_membership_role_to_role
    Action    ROLE    1


*** Keywords ***
Action
    [Arguments]    ${type}    ${row_number}
    IF    '${type}' == 'USER'
        Execute Immediate    CREATE USER ATEST_MEMBERSHIP PASSWORD 'pass'
    ELSE
        Execute Immediate    CREATE ROLE ATEST_MEMBERSHIP
    END
    Execute Immediate    CREATE ROLE ATEST_ROLE
    Open connection
    Select From Menu        Tools|User Manager
    IF    '${type}' == 'ROLE'
        Check Check Box    roleToRoleCheck
    END
    Sleep    1s

    Select Tab    Membership
    Click On Table Cell    membershipTable    ${row_number}    ATEST_ROLE
    Push Button    grantRoleButton
    ${result1}=    Check membership
    
    Click On Table Cell    membershipTable    ${row_number}    ATEST_ROLE
    Push Button    grandAdminRoleButton
    ${result2}=    Check membership 
    
    Click On Table Cell    membershipTable    ${row_number}    ATEST_ROLE
    Push Button    revokeRoleButton
    ${result3}=    Check membership

    Execute Immediate    DROP ${type} ATEST_MEMBERSHIP
    Execute Immediate    DROP ROLE ATEST_ROLE

    Should Be Equal    ${result1}    [('ATEST_MEMBERSHIP', 'M', 0, 'ATEST_ROLE')]
    Should Be Equal    ${result2}    [('ATEST_MEMBERSHIP', 'M', 2, 'ATEST_ROLE')]
    Should Be Equal    ${result3}    []

Check membership
    ${result}=    Execute    select CAST(rdb$user as VARCHAR(16)), CAST(rdb$privilege as VARCHAR(1)), rdb$grant_option, CAST(rdb$relation_name as VARCHAR(10)) from RDB$USER_PRIVILEGES where rdb$user='ATEST_MEMBERSHIP'
    RETURN     ${result}

Teardown
    Teardown after every tests
    Run Keyword And Ignore Error    Execute Immediate    DROP USER ATEST_MEMBERSHIP