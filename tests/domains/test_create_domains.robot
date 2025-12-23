*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../files/keywords.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_name
    Init
    Check    CREATE DOMAIN TEST_DOMAIN AS BIGINT

test_check_box
    Init
    Check Check Box    0
    Check    CREATE DOMAIN TEST_DOMAIN AS BIGINT NOT NULL

test_data_type
    Init
    Select Tab As Context    Type
    Select From Combo Box    typesCombo    BIGINT
    Text Field Should Be Disabled    sizeField
    Text Field Should Be Disabled    scaleField
    Text Field Should Be Disabled    subtypeField
    Combo Box Should Be Disabled    encodingsCombo
    Combo Box Should Be Disabled    collatesCombo
    Check Data Type    CREATE DOMAIN TEST_DOMAIN AS BIGINT

    Select From Combo Box    typesCombo    BLOB SUB_TYPE <0    
    Text Field Should Be Enabled    sizeField
    Text Field Should Be Disabled    scaleField
    Text Field Should Be Enabled    subtypeField
    Combo Box Should Be Disabled    encodingsCombo
    Combo Box Should Be Disabled    collatesCombo
    Clear Text Field    sizeField
    Type Into Text Field    sizeField    30
    Clear Text Field    subtypeField
    Type Into Text Field    subtypeField    -2
    Check Data Type    CREATE DOMAIN TEST_DOMAIN AS BLOB SUB_TYPE -2 SEGMENT SIZE 30

    Select From Combo Box    typesCombo    BLOB SUB_TYPE BINARY
    Text Field Should Be Enabled    sizeField
    Text Field Should Be Disabled    scaleField
    Text Field Should Be Disabled    subtypeField
    Combo Box Should Be Disabled    encodingsCombo
    Combo Box Should Be Disabled    collatesCombo
    Clear Text Field    sizeField
    Type Into Text Field    sizeField    20
    Check Data Type    CREATE DOMAIN TEST_DOMAIN AS BLOB SUB_TYPE BINARY SEGMENT SIZE 20

    Select From Combo Box    typesCombo    BLOB SUB_TYPE TEXT
    Text Field Should Be Enabled    sizeField
    Text Field Should Be Disabled    scaleField
    Text Field Should Be Disabled    subtypeField
    Combo Box Should Be Enabled    encodingsCombo
    Combo Box Should Be Enabled    collatesCombo
    Clear Text Field    sizeField
    Type Into Text Field    sizeField    128
    Select From Combo Box    encodingsCombo    ASCII
    Check Data Type    CREATE DOMAIN TEST_DOMAIN AS BLOB SUB_TYPE TEXT SEGMENT SIZE 128 CHARACTER SET ASCII

    Select From Combo Box    typesCombo    BOOLEAN
    Text Field Should Be Disabled    sizeField
    Text Field Should Be Disabled    scaleField
    Text Field Should Be Disabled    subtypeField
    Combo Box Should Be Disabled    encodingsCombo
    Combo Box Should Be Disabled    collatesCombo
    Check Data Type    CREATE DOMAIN TEST_DOMAIN AS BOOLEAN

    Select From Combo Box    typesCombo    CHAR
    Text Field Should Be Enabled    sizeField
    Text Field Should Be Disabled    scaleField
    Text Field Should Be Disabled    subtypeField
    Combo Box Should Be Enabled    encodingsCombo
    Combo Box Should Be Enabled    collatesCombo
    Clear Text Field    sizeField
    Type Into Text Field    sizeField    111
    Select From Combo Box    encodingsCombo    WIN1254
    Select From Combo Box    collatesCombo    WIN1254
    Check Data Type    CREATE DOMAIN TEST_DOMAIN AS CHAR(111) CHARACTER SET WIN1254 COLLATE WIN1254

    Select From Combo Box    typesCombo    DATE
    Text Field Should Be Disabled    sizeField
    Text Field Should Be Disabled    scaleField
    Text Field Should Be Disabled    subtypeField
    Combo Box Should Be Disabled    encodingsCombo
    Combo Box Should Be Disabled    collatesCombo
    Check Data Type    CREATE DOMAIN TEST_DOMAIN AS DATE

    Select From Combo Box    typesCombo    DECFLOAT
    Text Field Should Be Enabled    sizeField
    Text Field Should Be Disabled    scaleField
    Text Field Should Be Disabled    subtypeField
    Combo Box Should Be Disabled    encodingsCombo
    Combo Box Should Be Disabled    collatesCombo
    Clear Text Field    sizeField
    Type Into Text Field    sizeField    16
    Check Data Type    CREATE DOMAIN TEST_DOMAIN AS DECFLOAT(16)

    Select From Combo Box    typesCombo    DECFLOAT
    Text Field Should Be Enabled    sizeField
    Text Field Should Be Disabled    scaleField
    Text Field Should Be Disabled    subtypeField
    Combo Box Should Be Disabled    encodingsCombo
    Combo Box Should Be Disabled    collatesCombo
    Clear Text Field    sizeField
    Type Into Text Field    sizeField    5
    Check Data Type    CREATE DOMAIN TEST_DOMAIN AS DECFLOAT

    Select From Combo Box    typesCombo    DECIMAL
    Text Field Should Be Enabled    sizeField
    Text Field Should Be Enabled    scaleField
    Text Field Should Be Disabled    subtypeField
    Combo Box Should Be Disabled    encodingsCombo    
    Combo Box Should Be Disabled    collatesCombo
    Clear Text Field    sizeField
    Type Into Text Field    sizeField    10
    Clear Text Field    scaleField
    Type Into Text Field    scaleField    6
    Check Data Type    CREATE DOMAIN TEST_DOMAIN AS DECIMAL(10,6)

    Select From Combo Box    typesCombo    DOUBLE PRECISION
    Text Field Should Be Disabled    sizeField
    Text Field Should Be Disabled    scaleField
    Text Field Should Be Disabled    subtypeField
    Combo Box Should Be Disabled    encodingsCombo
    Combo Box Should Be Disabled    collatesCombo
    Check Data Type    CREATE DOMAIN TEST_DOMAIN AS DOUBLE PRECISION

    Select From Combo Box    typesCombo    FLOAT
    Text Field Should Be Disabled    sizeField
    Text Field Should Be Disabled    scaleField
    Text Field Should Be Disabled    subtypeField
    Combo Box Should Be Disabled    encodingsCombo
    Combo Box Should Be Disabled    collatesCombo
    Check Data Type    CREATE DOMAIN TEST_DOMAIN AS FLOAT

    Select From Combo Box    typesCombo    INT128
    Text Field Should Be Disabled    sizeField
    Text Field Should Be Disabled    scaleField
    Text Field Should Be Disabled    subtypeField
    Combo Box Should Be Disabled    encodingsCombo
    Combo Box Should Be Disabled    collatesCombo
    Check Data Type    CREATE DOMAIN TEST_DOMAIN AS INT128

    Select From Combo Box    typesCombo    INTEGER
    Text Field Should Be Disabled    sizeField
    Text Field Should Be Disabled    scaleField
    Text Field Should Be Disabled    subtypeField
    Combo Box Should Be Disabled    encodingsCombo
    Combo Box Should Be Disabled    collatesCombo
    Check Data Type    CREATE DOMAIN TEST_DOMAIN AS INTEGER

    Select From Combo Box    typesCombo    NUMERIC
    Text Field Should Be Enabled    sizeField
    Text Field Should Be Enabled    scaleField
    Text Field Should Be Disabled    subtypeField
    Combo Box Should Be Disabled    encodingsCombo
    Combo Box Should Be Disabled    collatesCombo
    Clear Text Field    sizeField
    Type Into Text Field    sizeField    38
    Clear Text Field    scaleField
    Type Into Text Field    scaleField    3
    Check Data Type    CREATE DOMAIN TEST_DOMAIN AS NUMERIC(38,3)

    Select From Combo Box    typesCombo    SMALLINT
    Text Field Should Be Disabled    sizeField
    Text Field Should Be Disabled    scaleField
    Text Field Should Be Disabled    subtypeField
    Combo Box Should Be Disabled    encodingsCombo
    Combo Box Should Be Disabled    collatesCombo
    Check Data Type    CREATE DOMAIN TEST_DOMAIN AS SMALLINT

    Select From Combo Box    typesCombo    TIME
    Text Field Should Be Disabled    sizeField
    Text Field Should Be Disabled    scaleField
    Text Field Should Be Disabled    subtypeField
    Combo Box Should Be Disabled    encodingsCombo
    Combo Box Should Be Disabled    collatesCombo
    Check Data Type    CREATE DOMAIN TEST_DOMAIN AS TIME

    Select From Combo Box    typesCombo    TIME WITH TIME ZONE
    Text Field Should Be Disabled    sizeField
    Text Field Should Be Disabled    scaleField
    Text Field Should Be Disabled    subtypeField
    Combo Box Should Be Disabled    encodingsCombo
    Combo Box Should Be Disabled    collatesCombo
    Check Data Type    CREATE DOMAIN TEST_DOMAIN AS TIME WITH TIME ZONE

    Select From Combo Box    typesCombo    TIMESTAMP
    Text Field Should Be Disabled    sizeField
    Text Field Should Be Disabled    scaleField
    Text Field Should Be Disabled    subtypeField
    Combo Box Should Be Disabled    encodingsCombo
    Combo Box Should Be Disabled    collatesCombo
    Check Data Type    CREATE DOMAIN TEST_DOMAIN AS TIMESTAMP

    Select From Combo Box    typesCombo    TIMESTAMP WITH TIME ZONE
    Text Field Should Be Disabled    sizeField
    Text Field Should Be Disabled    scaleField
    Text Field Should Be Disabled    subtypeField
    Combo Box Should Be Disabled    encodingsCombo
    Combo Box Should Be Disabled    collatesCombo
    Check Data Type    CREATE DOMAIN TEST_DOMAIN AS TIMESTAMP WITH TIME ZONE

    Select From Combo Box    typesCombo    VARCHAR
    Text Field Should Be Enabled    sizeField
    Text Field Should Be Disabled    scaleField
    Text Field Should Be Disabled    subtypeField
    Combo Box Should Be Enabled    encodingsCombo
    Combo Box Should Be Enabled    collatesCombo
    Clear Text Field    sizeField
    Type Into Text Field    sizeField    123
    Select From Combo Box    encodingsCombo    UTF8
    Select From Combo Box    collatesCombo    UTF8
    Check Data Type    CREATE DOMAIN TEST_DOMAIN AS VARCHAR(123) CHARACTER SET UTF8 COLLATE UTF8

test_data_type_blob
    Init
    Select Tab As Context    Type
    Select From Combo Box    typesCombo    BLOB SUB_TYPE <0
    Check Data Type    CREATE DOMAIN TEST_DOMAIN AS BLOB SUB_TYPE 0
    Select From Combo Box    typesCombo    BLOB SUB_TYPE BINARY
    Check Data Type    CREATE DOMAIN TEST_DOMAIN AS BLOB SUB_TYPE BINARY
    Select From Combo Box    typesCombo    BLOB SUB_TYPE TEXT
    Check Data Type    CREATE DOMAIN TEST_DOMAIN AS BLOB SUB_TYPE TEXT

test_default_value
    Init
    Select Tab As Context    Default Value
    Type Into Text Field    0    12
    Check    CREATE DOMAIN TEST_DOMAIN AS BIGINT DEFAULT 12

test_check
    Init
    Select Tab As Context    Check
    Type Into Text Field    0    VALUE > 5
    Check    CREATE DOMAIN TEST_DOMAIN AS BIGINT CHECK (VALUE > 5)

test_comment
    Init
    Select Tab As Context    Comment
    Type Into Text Field    0    Test Comment Text
    Push Button    rollbackCommentButton
    ${res}=    Get Text Field Value    0
    Should Be Equal As Strings    ${res}    ${EMPTY}    strip_spaces=${True}    collapse_spaces=${True}
    Type Into Text Field    0    Test Comment Text
    Check    COMMENT ON DOMAIN TEST_DOMAIN IS 'Test Comment Text'
    
test_sql
    Init
    Select Tab As Context    SQL
    ${res}=    Get Text Field Value    0
    ${expectation}=    Set Variable    CREATE DOMAIN TEST_DOMAIN AS BIGINT;
    Should Be Equal As Strings    ${res}    ${expectation}    strip_spaces=${True}    collapse_spaces=${True}
    Clear Text Field    0
    Type Into Text Field    0    CREATE DOMAIN TEST_DOMAIN AS CHAR(111) CHARACTER SET WIN1254 COLLATE WIN1254
    Check    CREATE DOMAIN TEST_DOMAIN AS CHAR(111) CHARACTER SET WIN1254 COLLATE WIN1254

*** Keywords ***
Init
    [Arguments]    ${name}=TEST_DOMAIN
    Lock Employee
    Open connection
    Select From Tree Node Popup Menu   0    New Connection|Domains (15)    Create domain
    Sleep    0.5s
    Select Dialog    Create domain
    Clear Text Field    nameField
    Type Into Text Field    nameField    ${name}

Check
    [Arguments]    ${text}    ${name}=TEST_DOMAIN
    Select Dialog    Create domain
    Push Button    submitButton
    Sleep    0.5s
    Select Dialog    Commiting changes
    ${res}=    Get Text Field Value    0
    Should Be Equal As Strings    ${res}    ${text}    strip_spaces=${True}    collapse_spaces=${True}
    Push Button    commitButton
    Select Main Window
    Tree Node Should Exist    0     New Connection|Domains (16)|${name}

Check Data Type
    [Arguments]    ${text}    ${name}=TEST_DOMAIN
    Select Dialog    Create domain
    Push Button    submitButton
    Sleep    0.5s
    Select Dialog    Commiting changes
    ${res}=    Get Text Field Value    0
    Should Be Equal As Strings    ${res}    ${text}    strip_spaces=${True}    collapse_spaces=${True}
    Close Dialog    Commiting changes
    Select Dialog    Create domain
    Select Tab As Context    Type