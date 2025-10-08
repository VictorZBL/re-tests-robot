*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../../files/keywords.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_check_types
    Init
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    Check type    BIGINT
    Check type    BLOB SUB_TYPE <0    expected_size=80
    Check type    BLOB SUB_TYPE BINARY    expected_size=80
    Check type    BLOB SUB_TYPE TEXT    expected_size=80    expected_subtype=1
    Check type    CHAR    expected_size=1
    Check type    DATE
    Check type    DECIMAL    expected_size=1    expected_scale=1
    Check type    DOUBLE PRECISION
    Check type    FLOAT
    Check type    INTEGER
    Check type    NUMERIC    expected_size=1    expected_scale=1
    Check type    SMALLINT
    Check type    TIME
    Check type    TIMESTAMP
    Check type    VARCHAR    expected_size=1
    IF    ${{$ver == '5'}}
        Check type    BOOLEAN
        Check type    DECFLOAT    expected_size=1
        Check type    TIME WITH TIME ZONE
        Check type    TIMESTAMP WITH TIME ZONE
        Check type    INT128
    ELSE IF    ${{$ver == '3'}}
        Check type    BOOLEAN
    END

test_check_domain
    Init
    Check Check Box    useDomainCheck
    Switch domain    ADDRESSLINE    VARCHAR    expected_size=30
    Push Button    editDomainButton
    Select Dialog    Edit domain
    ${name}=    Get Text Field Value    nameField
    Should Be Equal As Strings    ${name}    ADDRESSLINE
    Close Dialog    Edit domain
    Select Dialog    Create table column

    Push Button    addDomainButton
    Select Dialog    Create domain
    ${name}=    Get Text Field Value    nameField
    Should Be Equal As Strings    ${name}    NEW_DOMAIN_1
    Close Dialog    Create domain

    Select Dialog    Create table column
        
    Switch domain    DEPTNO    CHAR    expected_size=3
    Check commit    ALTER TABLE TEST_TABLE ADD NEW_TABLE_COLUMN_1 DEPTNO    dialog3
    ${row}=    Check in table    data_type=CHAR
    ${size}=    Get Table Cell Value    0    ${row}    Size or precision
    Should Be Equal As Strings    ${size}    3
    ${domain}=    Get Table Cell Value    0    ${row}    Domain
    Should Be Equal As Strings    ${domain}    DEPTNO

test_check_empty_domain
    Init
    Check Check Box    useDomainCheck
    Switch domain    EMPNO    SMALLINT    expected_size=2
    Select From Combo Box    domainCombo    ${EMPTY}
    Check commit    ALTER TABLE TEST_TABLE ADD NEW_TABLE_COLUMN_1 SMALLINT
    ${row}=    Check in table    data_type=SMALLINT
    ${size}=    Get Table Cell Value    0    ${row}    Size or precision
    Should Be Equal As Strings    ${size}    2
    ${domain}=    Get Table Cell Value    0    ${row}    Domain
    Should Not Be Equal As Strings    ${domain}    EMPNO

test_check_encoding
    Init
    Clear Text Field    nameField
    Type Into Text Field    nameField    NEW_COLUMN
    Select From Combo Box    typesCombo    VARCHAR
    Select From Combo Box    encodingsCombo    UTF8
    Select From Combo Box    collatesCombo    UTF8
    Check commit    ALTER TABLE TEST_TABLE ADD NEW_COLUMN VARCHAR(1) CHARACTER SET UTF8 COLLATE UTF8
    Check in table    NEW_COLUMN    VARCHAR

test_check_scale
    Init
    Clear Text Field    nameField
    Type Into Text Field    nameField    NEW COLUMN
    Select From Combo Box    typesCombo    DECIMAL
    
    # Clear Text Field    sizeField
    Insert Into Text Field    sizeField    18
    # Clear Text Field    scaleField
    Insert Into Text Field    scaleField    15
    
    Check commit    ALTER TABLE TEST_TABLE ADD "NEW COLUMN" DECIMAL(18,15)
    ${row}=    Check in table    NEW COLUMN    DECIMAL
    ${size}=    Get Table Cell Value    0    ${row}    Size or precision
    Should Be Equal As Strings    ${size}    18
    ${scale}=    Get Table Cell Value    0    ${row}    Scale
    Should Be Equal As Strings    ${scale}    15

test_check_not_null
    Init
    Clear Text Field    nameField
    Type Into Text Field    nameField    "NEW COLUMN"
    Check Check Box    requiredCheck
    Check commit    ALTER TABLE TEST_TABLE ADD """NEW COLUMN""" BIGINT NOT NULL
    ${row}=    Check in table    column_name="NEW COLUMN"
    ${required}=    Get Table Cell Value    0    ${row}    Required    model
    Should Be Equal As Strings    ${required}    true    
    
test_check_default_1
    Init default    BIGINT    BIGINT    2

test_check_default_2
    Init default    CHAR    CHAR(1)    '2'

test_check_auto_name
    Init
    Check commit    ALTER TABLE TEST_TABLE ADD NEW_TABLE_COLUMN_1 BIGINT
    Check in table
    Push Button    addColumnButton
    Select Dialog    Create table column
    ${name}=    Get Text Field Value    nameField
    Should Be Equal As Strings    ${name}    NEW_TABLE_COLUMN_2
    Check commit    ALTER TABLE TEST_TABLE ADD NEW_TABLE_COLUMN_2 BIGINT    dialog=dialog3
    Check in table    column_name=NEW_TABLE_COLUMN_2

test_computed
    Init
    Check Check Box    computedCheck
    Select Tab As Context    Computed by
    Clear Text Field    0
    Type Into Text Field    0    COMPUTED BY ( ID * 2 )
    Select Main Window
    Select Dialog    Create table column
    Check commit    ALTER TABLE TEST_TABLE ADD NEW_TABLE_COLUMN_1 COMPUTED BY ( ID * 2 )
    ${row}=    Check in table
    ${computed}=    Get Table Cell Value    0    ${row}    Computed Source
    Should Be Equal As Strings    ${computed}    ID * 2    strip_spaces=${True}
    Execute Immediate    INSERT INTO TEST_TABLE VALUES (2)
    ${res}=    Execute    SELECT * FROM TEST_TABLE
    Should Be Equal As Strings    ${res}    [(2, 4)]

test_check
    Init
    Check Check Box    verifyCheck
    Select Tab As Context    Check
    Clear Text Field    0
    Type Into Text Field    0    CHECK ( NEW_TABLE_COLUMN_1 BETWEEN 1 AND 5 )
    Select Main Window
    Select Dialog    Create table column
    Check commit    ALTER TABLE TEST_TABLE ADD NEW_TABLE_COLUMN_1 BIGINT CHECK ( NEW_TABLE_COLUMN_1 BETWEEN 1 AND 5 )
    Check in table
    Select Tab    Constraints
    ${row}=    Find Table Row    0    CHECK    Type
    ${check}=    Get Table Cell Value    0    ${row}    Check
    Should Be Equal As Strings    ${check}    CHECK ( NEW_TABLE_COLUMN_1 BETWEEN 1 AND 5 )

    Execute Immediate    INSERT INTO TEST_TABLE VALUES (1,2)
    Run Keyword And Expect Error    STARTS:DatabaseError:    Execute Immediate    INSERT INTO TEST_TABLE VALUES (1,6)
    ${res}=    Execute    SELECT * FROM TEST_TABLE
    Should Be Equal As Strings    ${res}    [(1, 2)]

test_autoincrement_always_identity
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    Skip If    ${{$ver != '5'}}
    Init autoincrement    identityRadio
    Select From Combo Box    identityCombo    GENERATED ALWAYS
    Check commit    ALTER TABLE TEST_TABLE ADD NEW_TABLE_COLUMN_1 BIGINT GENERATED ALWAYS AS IDENTITY
    ${row}=    Check in table
    ${required}=    Get Table Cell Value    0    ${row}    Required    model
    Should Be Equal As Strings    ${required}    true    
    Execute Immediate    INSERT INTO TEST_TABLE (ID) VALUES (2)
    Execute Immediate    INSERT INTO TEST_TABLE (ID) VALUES (6)
    Run Keyword And Expect Error    STARTS:DatabaseError:    Execute Immediate    INSERT INTO TEST_TABLE VALUES (6, 10)
    ${res}=    Execute    SELECT * FROM TEST_TABLE
    Should Be Equal As Strings    ${res}    [(2, 1), (6, 2)]

test_autoincrement_default_identity
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    Skip If    ${{$ver == '2.6'}}
    Init autoincrement    identityRadio
    IF    ${{$ver == '5'}}
        Select From Combo Box    identityCombo    GENERATED BY DEFAULT
        Clear Text Field    incrementField
        Type Into Text Field    incrementField    2
        VAR    ${expected_increment}    ${SPACE}INCREMENT BY 2
        VAR    ${expected_res}    2, 5
    ELSE
        VAR    ${expected_increment}    ${EMPTY}
        VAR    ${expected_res}    2, 6
    END
    Clear Text Field    startValueField
    Type Into Text Field    startValueField    5
    
    Check commit    ALTER TABLE TEST_TABLE ADD NEW_TABLE_COLUMN_1 BIGINT GENERATED BY DEFAULT AS IDENTITY (START WITH 5${expected_increment})
    ${row}=    Check in table
    ${required}=    Get Table Cell Value    0    ${row}    Required    model
    Should Be Equal As Strings    ${required}    true    
    Execute Immediate    INSERT INTO TEST_TABLE (ID) VALUES (2)
    Execute Immediate    INSERT INTO TEST_TABLE (ID) VALUES (6)
    Execute Immediate    INSERT INTO TEST_TABLE VALUES (6, 10)
    ${res}=    Execute    SELECT * FROM TEST_TABLE
    Should Be Equal As Strings    ${res}    [(${expected_res}), (6, 7), (6, 10)]

test_autoincrement_create_generator
    Init autoincrement    newSequenceRadio
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    IF    ${{$ver != '2.6'}}
        Select Dialog    Warning
        Label Text Should Be    0    Using IDENTITY is preferred when creating an auto-incremented column
        Push Button    OK
        VAR    ${dialog}    dialog2
    ELSE
        VAR    ${dialog}    dialog1
    END
    Select Dialog    Create table column
    Clear Text Field    nameField
    Type Into Text Field    nameField    COL
    Clear Text Field    sequenceNameField
    Type Into Text Field    sequenceNameField    AUTO_GEN
    Clear Text Field    startValueField
    Type Into Text Field    startValueField    10
    Clear Text Field    incrementField
    Type Into Text Field    incrementField    5
    
    Check SQL Statements    ${True}    AUTO_GEN    COL    ${dialog}

    ${row}=    Check in table    column_name=COL
    ${required}=    Get Table Cell Value    0    ${row}    Required    model
    Should Be Equal As Strings    ${required}    true    
    Execute Immediate    INSERT INTO TEST_TABLE (ID) VALUES (1)
    Execute Immediate    INSERT INTO TEST_TABLE (ID) VALUES (2)
    Execute Immediate    INSERT INTO TEST_TABLE VALUES (3, 20)
    ${res}=    Execute    SELECT * FROM TEST_TABLE
    IF    ${{$ver == '5'}}
        Should Be Equal As Strings    ${res}    [(1, 10), (2, 15), (3, 20)]
    ELSE IF     ${{$ver == '3'}}
        Should Be Equal As Strings    ${res}    [(1, 15), (2, 20), (3, 20)]
    ELSE
        Should Be Equal As Strings    ${res}    [(1, 16), (2, 17), (3, 20)]
    END

test_autoincrement_use_generator
    Init autoincrement    existingSequenceRadio
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    IF    ${{$ver != '2.6'}}
        Select Dialog    Warning
        Label Text Should Be    0    Using IDENTITY is preferred when creating an auto-incremented column
        Push Button    OK
        VAR    ${dialog}    dialog2
    ELSE
        VAR    ${dialog}    dialog1
    END
    Select Dialog    Create table column
    Clear Text Field    nameField
    Type Into Text Field    nameField    COL   
    Select From Combo Box    sequencesCombo    EMP_NO_GEN

    Check SQL Statements    ${False}    EMP_NO_GEN    COL    ${dialog}

    ${row}=    Check in table    COL
    ${required}=    Get Table Cell Value    0    ${row}    Required    model
    Should Be Equal As Strings    ${required}    true    

    Execute Immediate    INSERT INTO TEST_TABLE (ID) VALUES (2)
    Execute Immediate    INSERT INTO TEST_TABLE (ID) VALUES (6)
    Execute Immediate    INSERT INTO TEST_TABLE VALUES (6, 25)
    ${res}=    Execute    SELECT * FROM TEST_TABLE
    Should Be Equal As Strings    ${res}    [(2, 146), (6, 147), (6, 25)]

test_check_autoupdate_object_tree
    Init autoincrement    newSequenceRadio
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    IF    ${{$ver != '2.6'}}
        Select Dialog    Warning
        Label Text Should Be    0    Using IDENTITY is preferred when creating an auto-incremented column
        Push Button    OK
        VAR    ${dialog}    dialog2
    ELSE
        VAR    ${dialog}    dialog1
    END
    Select Dialog    Create table column
    Clear Text Field    nameField
    Type Into Text Field    nameField    COL
    Clear Text Field    sequenceNameField
    Type Into Text Field    sequenceNameField    AUTO_GEN
    Clear Text Field    startValueField
    Type Into Text Field    startValueField    10
    Clear Text Field    incrementField
    Type Into Text Field    incrementField    5
    Check SQL Statements    ${True}    AUTO_GEN    COL    ${dialog}
    Select Main Window
    Expand Tree Node    0    New Connection|Table Triggers (5)
    Tree Node Should Exist    0   New Connection|Table Triggers (5)|TRIGGER_BI_TEST_TABLE_COL
    Expand Tree Node    0    New Connection|Sequences (3)
    Tree Node Should Exist    0   New Connection|Sequences (3)|AUTO_GEN

*** Keywords ***
Init
    Lock Employee
    Execute Immediate    CREATE TABLE TEST_TABLE (ID INT)
    Open connection
    Click On Tree Node    0    New Connection|Tables (11)|TEST_TABLE    2
    Select Tab    Columns
    Push Button    addColumnButton
    Select Dialog    Create table column

Init autoincrement
    [Arguments]    ${increment_type}
    Init
    Check Check Box    incrementedCheck
    Check Box Should Be Checked    requiredCheck
    Select Tab    Autoincrement
    Push Radio Button    ${increment_type}

Init default
    [Arguments]    ${type1}    ${type2}    ${default}
    Init
    Select From Combo Box    typesCombo    ${type1}
    Select Tab As Context    Default Value
    Clear Text Field    0
    Type Into Text Field    0    2
    Select Main Window
    Select Dialog    Create table column
    Check commit    ALTER TABLE TEST_TABLE ADD NEW_TABLE_COLUMN_1 ${type2} DEFAULT ${default}
    ${row}=    Check in table    data_type=${type1}
    ${default_value}=    Get Table Cell Value    0    ${row}    Default
    Should Be Equal As Strings    ${default_value}    ${default}

Switch domain
    [Arguments]    ${domain}    ${expected_type}    ${expected_size}=0    ${expected_scale}=0    ${expected_subtype}=0
    Select From Combo Box    domainCombo    ${domain}
    ${type}=    Get Selected Item From Combo Box    typesCombo
    ${size}=    Get Text Field Value    sizeField
    ${scale}=    Get Text Field Value    scaleField
    ${subtype}=    Get Text Field Value    subtypeField
    Should Be Equal As Strings    ${type}    ${expected_type}
    Should Be Equal As Strings    ${size}    ${expected_size}
    Should Be Equal As Strings    ${scale}    ${expected_scale}
    Should Be Equal As Strings    ${subtype}    ${expected_subtype}

Check type
    [Arguments]    ${type}    ${expected_size}=0    ${expected_scale}=0    ${expected_subtype}=0
    Select From Combo Box    typesCombo    ${type}
    ${size}=    Get Text Field Value    sizeField
    ${scale}=    Get Text Field Value    scaleField
    ${subtype}=    Get Text Field Value    subtypeField
    Should Be Equal As Strings    ${size}    ${expected_size}
    Should Be Equal As Strings    ${scale}    ${expected_scale}
    Should Be Equal As Strings    ${subtype}    ${expected_subtype}

Check commit
    [Arguments]    ${text}    ${dialog}=Commiting changes
    Push Button    submitButton
    Sleep    1s
    Select Dialog    ${dialog}
    ${res}=    Get Text Field Value    0
    Should Be Equal As Strings    ${res}    ${text}    strip_spaces=${True}    collapse_spaces=${True}

    Push Button    commitButton
    Sleep    0.1s
    ${old}=    Set Jemmy Timeout    DialogWaiter.WaitDialogTimeout	0
    Run Keyword And Expect Error    org.netbeans.jemmy.TimeoutExpiredException: Dialog with name or title 'Create table column'    Select Dialog    Create table column

Check in table
    [Arguments]    ${column_name}=NEW_TABLE_COLUMN_1    ${data_type}=BIGINT
    Select Main Window
    Select Tab    Columns
    ${row}=    Find Table Row    0    ${column_name}    Name
    Should Not Be Equal As Integers    ${row}    -1
    ${dt}=    Get Table Cell Value    0    ${row}    Data Type
    Should Be Equal As Strings    ${dt}    ${data_type}
    RETURN    ${row}

Check SQL Statements
    [Arguments]    ${check_sequence}    ${gen_name}    ${column_name}=NEW_TABLE_COLUMN_1    ${dialog}=Commiting changes
    Push Button    submitButton
    Sleep    1s
    List Dialogs
    Select Dialog    ${dialog}
    # Check ALTER TABLE statement
    ${alter_row}=    Find Table Row    0    ALTER TABLE    Name operation
    Click On Table Cell    0    ${alter_row}    Name operation
    ${alter_table}=    Get Text Field Value    0
    Should Be Equal As Strings    ${alter_table}    ALTER TABLE TEST_TABLE ADD ${column_name} BIGINT NOT NULL    strip_spaces=${True}    collapse_spaces=${True}
    
    # Check CREATE OR ALTER SEQUENCE statement (only if check_sequence is TRUE)
    IF    ${check_sequence}
        ${info}=    Get Server Info
        ${ver}=     Set Variable    ${info}[1]
        IF    ${{$ver != '2.6'}}
            ${sequence_row}=    Find Table Row    0    CREATE OR ALTER SEQUENCE    Name operation
            Click On Table Cell    0    ${sequence_row}    Name operation
            ${create_sequence}=    Get Text Field Value    0
            Should Be Equal As Strings    ${create_sequence}    CREATE OR ALTER SEQUENCE AUTO_GEN START WITH 10 INCREMENT BY 5    strip_spaces=${True}    collapse_spaces=${True}
        ELSE
            # Check CREATE SEQUENCE statement
            ${create_sequence_row}=    Find Table Row    0    CREATE SEQUENCE    Name operation
            Click On Table Cell    0    ${create_sequence_row}    Name operation
            ${create_sequence}=    Get Text Field Value    0
            Should Be Equal As Strings    ${create_sequence}    CREATE SEQUENCE ${gen_name}    strip_spaces=${True}    collapse_spaces=${True}
            
            # Check ALTER SEQUENCE statement
            ${alter_sequence_row}=    Find Table Row    0    ALTER SEQUENCE    Name operation
            Click On Table Cell    0    ${alter_sequence_row}    Name operation
            ${alter_sequence}=    Get Text Field Value    0
            Should Be Equal As Strings    ${alter_sequence}    ALTER SEQUENCE ${gen_name} RESTART WITH 15    strip_spaces=${True}    collapse_spaces=${True}
        END
    END
    
    # Check CREATE TRIGGER statement
    ${trigger_row}=    Find Table Row    0    CREATE TRIGGER    Name operation
    Click On Table Cell    0    ${trigger_row}    Name operation
    ${create_trigger}=    Get Text Field Value    0
    ${expected_trigger}=    Catenate    SEPARATOR=${SPACE}
    ...    CREATE TRIGGER TRIGGER_BI_TEST_TABLE_${column_name}
    ...    FOR TEST_TABLE
    ...    ACTIVE BEFORE INSERT POSITION 0
    ...    AS BEGIN
    ...    IF (NEW.${column_name} IS NULL) THEN
    ...    NEW.${column_name} = NEXT VALUE FOR ${gen_name};
    ...    END
    Should Be Equal As Strings    ${create_trigger}    ${expected_trigger}    strip_spaces=${True}    collapse_spaces=${True}

    Push Button    commitButton
    Sleep    0.1s
    ${old}=    Set Jemmy Timeout    DialogWaiter.WaitDialogTimeout    0
    Run Keyword And Expect Error    org.netbeans.jemmy.TimeoutExpiredException: Dialog with name or title 'Create table column'    Select Dialog    Create table column