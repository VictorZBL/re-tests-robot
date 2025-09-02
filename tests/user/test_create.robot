*** Settings ***
Library    RemoteSwingLibrary
Resource   ../../files/keywords.resource
Test Setup       Setup
Test Teardown    Teardown after every tests

*** Test Cases ***
test_create_admin
    Create User    TEST_USER   123
    Check Check Box    isAdminCheck
    Check    CREATE USER TEST_USER PASSWORD '123' ACTIVE GRANT ADMIN ROLE USING PLUGIN Srp    TEST_USER
    [Teardown]    Drop User    TEST_USER

test_create_with_empty_password
    Create User    TEST_USER    ${EMPTY}
    Push Button    submitButton
    Select Dialog    Error message
    Label Text Should Be    0    Password can not be empty

test_create_inactive_with_info
    Create User    TEST USER   12 3
    Uncheck Check Box    isActiveCheck
    Clear Text Field    firstNameField
    Type Into Text Field    firstNameField    first
    Clear Text Field    middleNameField
    Type Into Text Field    middleNameField    mid dle
    Clear Text Field    lastNameField
    Type Into Text Field    lastNameField    last_name
    
    Select Tab As Context    SQL
    ${sql}=    Get Text Field Value    0
    Should Be Equal As Strings    ${sql}    CREATE USER "TEST USER" FIRSTNAME 'first' MIDDLENAME 'mid dle' LASTNAME 'last_name' PASSWORD '123' INACTIVE USING PLUGIN Srp;    strip_spaces=${True}    collapse_spaces=${True}
    Select Dialog    Create user
    Check    CREATE USER "TEST USER" FIRSTNAME 'first' MIDDLENAME 'mid dle' LASTNAME 'last_name' PASSWORD '123' INACTIVE USING PLUGIN Srp    TEST USER
    [Teardown]    Drop User    "TEST USER"

test_create_with_tags_and_comment
    Create User    "TEST USER"    123
    Push Button    addTagButton
    Type Into Table Cell    tagTable    0    Tag    gh
    Type Into Table Cell    tagTable    0    Value    123456
    
    Push Button    addTagButton
    Type Into Table Cell    tagTable    1    Tag    gl
    
    Push Button    addTagButton
    Type Into Table Cell    tagTable    2    Value    123456

    Push Button    addTagButton
    Type Into Table Cell    tagTable    3    Tag    delete
    Type Into Table Cell    tagTable    3    Value    654321
    
    @{values}=    Get Table Values    tagTable
    Should Be Equal As Strings    ${values}    [['gh', '123456'], ['gl', ''], ['', '123456'], ['delete', '654321']]
    Click On Table Cell    tagTable    3    Tag

    Push Button    deleteTagButton
    @{values}=    Get Table Values    tagTable
    Should Be Equal As Strings    ${values}    [['gh', '123456'], ['gl', ''], ['', '123456']]
    
    Select Tab As Context    Comment
    Clear Text Field    0
    Type Into Text Field    0    test_comment
    Select Dialog    Create user
    Check    CREATE USER """TEST USER""" PASSWORD '123' ACTIVE USING PLUGIN Srp TAGS (gh = '123456' )    "TEST USER"   ${True}
    [Teardown]    Drop User    """TEST USER"""

*** Keywords ***
Create User
    [Arguments]    ${user_name}    ${password}=123
    Lock Employee
    Open connection
    Expand Tree Node    0    New Connection
    Select From Tree Node Popup Menu    0    New Connection|Users (1)    Create user
    Sleep    2s
    Select Dialog    Create user
    Clear Text Field    nameField
    Type Into Text Field    nameField    ${user_name}
    IF    '${password}' != ''
        Clear Text Field    passwordField
        Type Into Text Field    passwordField    ${password}
    END    

Check
    [Arguments]    ${expected_sql}    ${user_name}    ${comment}=${False}
    Push Button    submitButton
    Select Dialog    Commiting changes
    Sleep    1s
    IF    ${comment}
        ${row}=   Find Table Row    0    CREATE USER
        Click On Table Cell    0    ${row}    Name operation
        ${res}=    Get Text Field Value    0
        Should Be Equal As Strings    ${res}    ${expected_sql}    strip_spaces=${True}    collapse_spaces=${True}
        
        ${row}=   Find Table Row    0    ADD COMMENT
        Click On Table Cell    0    ${row}    Name operation
        ${res}=    Get Text Field Value    0
        Should Be Equal As Strings    ${res}    COMMENT ON USER """TEST USER""" USING PLUGIN Srp IS 'test_comment'    
    ELSE
        ${res}=    Get Text Field Value    0
        Should Be Equal As Strings    ${res}    ${expected_sql}    strip_spaces=${True}    collapse_spaces=${True}
    END
    
    Push Button    commitButton
    Sleep    0.1s
    ${old}=    Set Jemmy Timeout    DialogWaiter.WaitDialogTimeout	0
    Run Keyword And Expect Error    org.netbeans.jemmy.TimeoutExpiredException: Dialog with name or title 'Create user'    Select Dialog    Create user
    Select Main Window
    Tree Node Should Exist    0     New Connection|Users (2)|${user_name}
    
Drop User
    [Arguments]    ${user_name}
    Teardown after every tests
    Run Keyword And Ignore Error    Execute Immediate    DROP USER ${user_name}

Setup
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    Skip if   ${{$ver == '2.6'}}
    Setup before every tests