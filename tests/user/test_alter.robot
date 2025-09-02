*** Settings ***
Library    RemoteSwingLibrary
Resource   ../../files/keywords.resource
Test Setup       Setup
Test Teardown    Teardown

*** Variables ***
${TEST_USERNAME}    TEST_USER
${TEST_USER_PASSWORD}    TEST
${TEST_NEW_USER_FIRST_NAME}    TEST_USER_FNAME
${TEST_NEW_USER_MIDDLE_NAME}    TEST_USER_MNAME
${TEST_NEW_USER_LAST_NAME}    TEST_USER_LNAME
${FIELD_INDEX_FIRST_NAME}    firstNameField
${FIELD_INDEX_MIDDLE_NAME}    middleNameField
${FIELD_INDEX_LAST_NAME}    lastNameField

*** Test Cases ***
test_edit_name
    Create User
    Open connection
    Expand Tree Node    0    New Connection
    Select From Tree Node Popup Menu    0    New Connection|Users (2)|${TEST_USERNAME}    Edit user
    Sleep    2s
    Select Tab    Properties
    Sleep    1s
    Type Into Text Field    ${FIELD_INDEX_FIRST_NAME}     ${TEST_NEW_USER_FIRST_NAME}
    Type Into Text Field    ${FIELD_INDEX_MIDDLE_NAME}    ${TEST_NEW_USER_MIDDLE_NAME}
    Type Into Text Field    ${FIELD_INDEX_LAST_NAME}    ${TEST_NEW_USER_LAST_NAME}
    Check    ALTER USER TEST_USER USING PLUGIN Srp FIRSTNAME '${TEST_NEW_USER_FIRST_NAME}' MIDDLENAME '${TEST_NEW_USER_MIDDLE_NAME}' LASTNAME '${TEST_NEW_USER_LAST_NAME}'
    Sleep    1s

    Check Updated Text Field    ${FIELD_INDEX_FIRST_NAME}     ${TEST_NEW_USER_FIRST_NAME}
    Check Updated Text Field    ${FIELD_INDEX_MIDDLE_NAME}    ${TEST_NEW_USER_MIDDLE_NAME}
    Check Updated Text Field    ${FIELD_INDEX_LAST_NAME}    ${TEST_NEW_USER_LAST_NAME}

test_edit_flags
    Create User
    Lock Employee
    Open connection
    Expand Tree Node    0    New Connection
    Select From Tree Node Popup Menu    0    New Connection|Users (2)|${TEST_USERNAME}    Edit user
    Sleep    2s
    UnCheck Check Box    isActiveCheck
    Check Check Box      isAdminCheck
    Sleep    2s
    Push Button    Apply
    Sleep    0.1s
    Select Dialog    Commiting changes
    Push Button    commitButton
    Select Main Window
    Checkbox Should Be Unchecked    isActiveCheck
    Checkbox Should Be Checked      isAdminCheck

test_add_new_tags
    Create User
    Lock Employee
    Open connection
    Expand Tree Node    0    New Connection
    Select From Tree Node Popup Menu    0    New Connection|Users (2)|${TEST_USERNAME}    Edit user
    Sleep    1s

    Push Button    addTagButton
    Type Into Table Cell    tagTable    0    Tag      pc
    Type Into Table Cell    tagTable    0    Value    123

    Push Button    addTagButton
    Type Into Table Cell    tagTable    1    Tag    Card

    Sleep    0.5s
    Push Button    Apply
    Sleep    0.2s
    Select Dialog    Commiting changes
    Push Button    commitButton
    Sleep    2s

    Select Main Window
    @{values}=    Get Table Values    tagTable
    Should Be Equal As Strings    ${values}    [['PC', '123']]

test_append_tags_to_precreated_user_tags
    Execute Immediate    CREATE USER ${TEST_USERNAME} PASSWORD '${TEST_USER_PASSWORD}' ACTIVE USING PLUGIN Srp TAGS (CARD = '123', PC = '999')

    Lock Employee
    Open connection
    Expand Tree Node    0    New Connection
    Select From Tree Node Popup Menu    0    New Connection|Users (2)|${TEST_USERNAME}    Edit user
    Sleep    1s

    @{tags}=    Get Table Values    tagTable
    ${sorted_initial}=  Evaluate    sorted(${tags})
    Should Be Equal As Strings    ${sorted_initial}    [['CARD', '123'], ['PC', '999']]

    Push Button    addTagButton
    Type Into Table Cell    tagTable    2    Tag      Added1
    Type Into Table Cell    tagTable    2    Value    val1

    Push Button    addTagButton
    Type Into Table Cell    tagTable    3    Tag      Added2
    Type Into Table Cell    tagTable    3    Value    val2

    Sleep    0.2s
    Push Button    Apply
    Sleep    0.1s
    Select Dialog    Commiting changes
    Push Button    commitButton
    Sleep    1s

    Select Main Window
    @{final_tags}=    Get Table Values    tagTable
    ${sorted_final}=  Evaluate    sorted(${final_tags})
    Should Be Equal As Strings    ${sorted_final}    [['ADDED1', 'val1'], ['ADDED2', 'val2'], ['CARD', '123'], ['PC', '999']]

test_add_new_comment_full_commit
    Create User
    Lock Employee
    Open connection
    Expand Tree Node    0    New Connection
    Select From Tree Node Popup Menu    0    New Connection|Users (2)|${TEST_USERNAME}    Edit user
    Sleep    1s
    Select Tab As Context    Comment
    Clear Text Field    0
    Type Into Text Field    0    test_comment
    Sleep    0.2s
    Select Main Window
    Push Button    Apply
    Sleep    0.1s
    Select Dialog    Commiting changes
    Push Button    commitButton
    Sleep    2s
    Check Updated Text Field    1    test_comment

test_add_new_comment_commit
    Create User
    Lock Employee
    Open connection
    Expand Tree Node    0    New Connection
    Select From Tree Node Popup Menu    0    New Connection|Users (2)|${TEST_USERNAME}    Edit user
    Sleep    1s
    Select Tab As Context    Comment
    Clear Text Field    0
    Type Into Text Field    0    test_comment
    Sleep    0.2s
    Select Main Window
    Push Button    updateCommentButton
    Sleep    0.1s
    Check Updated Text Field    1    test_comment

test_user_ddl_after_modification
    Create User
    Lock Employee
    Open connection

    Expand Tree Node    0    New Connection
    Select From Tree Node Popup Menu    0    New Connection|Users (2)|${TEST_USERNAME}    Edit user
    Sleep    1s

    Push Button    addTagButton
    Type Into Table Cell    tagTable    0    Tag    example_tag
    Type Into Table Cell    tagTable    0    Value    value123

    Select Tab As Context    Comment
    Clear Text Field    0
    Type Into Text Field    0    test_comment

    Select Main Window
    Push Button    Apply
    Sleep    0.1s
    Select Dialog    Commiting changes
    Push Button    commitButton
    Sleep    1s

    Select Main Window
    Select From Tree Node Popup Menu    0    New Connection|Users (2)|${TEST_USERNAME}    Edit user
    Sleep    1s
    Select Tab As Context    DDL to create
    ${ddl}=    Get Text Field Value    0
    
    Should Be Equal As Strings    ${ddl}    CREATE USER TEST_USER ACTIVE USING PLUGIN Srp TAGS (EXAMPLE_TAG = 'value123' ); COMMENT ON USER TEST_USER USING PLUGIN Srp IS 'test_comment';    strip_spaces=${True}    collapse_spaces=${True}

*** Keywords ***
Setup
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    Skip if   ${{$ver == '2.6'}}
    Setup before every tests

Create User
    Execute Immediate    CREATE USER ${TEST_USERNAME} PASSWORD '${TEST_USER_PASSWORD}' ACTIVE USING PLUGIN Srp

Drop User
    Teardown after every tests
    Run Keyword And Ignore Error    Execute Immediate    DROP USER ${TEST_USERNAME}

Check Updated Text Field
    [Arguments]    ${field_name}    ${predict}
    Select Main Window
    ${textFieldValue}=    Get Text Field Value    ${field_name}
    Should Be Equal As Strings    ${textFieldValue}    ${predict} 

Check
    [Arguments]    ${expected_sql}    ${comment}=${False}
    Push Button    submitButton
    Select Dialog    Commiting changes
    Sleep    1s
    IF    ${comment}
        ${row}=   Find Table Row    0    ALTER USER
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
    Run Keyword And Expect Error    org.netbeans.jemmy.TimeoutExpiredException: Dialog with name or title 'Commiting changes'    Select Dialog    Commiting changes
    Select Main Window

Teardown
    Drop User
    Teardown after every tests
