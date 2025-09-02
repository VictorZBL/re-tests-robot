*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../../files/keywords.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests


*** Test Cases ***
test_check_types
    Init
    ${name_table}=    Get Text Field Value    tableNameField
    Should Be Equal As Strings    ${name_table}    TEST_TABLE
    ${value}=    Get Selected Item From Combo Box    typesCombo
    ${name}=    Get Text Field Value    nameField
    Should Be Equal As Strings    ${value}    PRIMARY
    Should Be Equal As Strings    ${name}    PK_TEST_TABLE_1

    Select From Combo Box    typesCombo    FOREIGN
    ${name}=    Get Text Field Value    nameField
    Should Be Equal As Strings    ${name}    FK_TEST_TABLE_1

    Select From Combo Box    typesCombo    UNIQUE
    ${name}=    Get Text Field Value    nameField
    Should Be Equal As Strings    ${name}    UQ_TEST_TABLE_1

    Select From Combo Box    typesCombo    CHECK
    ${name}=    Get Text Field Value    nameField
    Should Be Equal As Strings    ${name}    CHECK_TEST_TABLE_1

test_primary_empty_index
    Init
    Select From Combo Box    typesCombo    PRIMARY
    Click On List Item    0    ID    2
    Check commit    ALTER TABLE TEST_TABLE ADD CONSTRAINT PK_TEST_TABLE_1 PRIMARY KEY (ID)
    Check in table    PK_TEST_TABLE_1    PRIMARY
    Check Index    PK_TEST_TABLE_1

test_primary_ascending
    Init
    Select From Combo Box    typesCombo    PRIMARY
    Clear Text Field    nameField
    Type Into Text Field    nameField    PK_TEST TABLE_1
    Clear Text Field    usingIndexField
    Type Into Text Field    usingIndexField    TEST_INDEX
    Select From Combo Box    sortingCombo    ASCENDING
    Click On List Item    0    ID    2
    Check commit    ALTER TABLE TEST_TABLE ADD CONSTRAINT "PK_TEST TABLE_1" PRIMARY KEY (ID) USING ASCENDING INDEX TEST_INDEX
    Check in table    PK_TEST TABLE_1    PRIMARY
    Check Index    TEST_INDEX

test_primary_descending
    Init
    Select From Combo Box    typesCombo    PRIMARY
    Clear Text Field    nameField
    Type Into Text Field    nameField    "PK_TEST TABLE_1"
    Clear Text Field    usingIndexField
    Type Into Text Field    usingIndexField    TEST INDEX
    Select From Combo Box    sortingCombo    DESCENDING
    Click On List Item    0    ID    2
    Check commit    ALTER TABLE TEST_TABLE ADD CONSTRAINT """PK_TEST TABLE_1""" PRIMARY KEY (ID) USING DESCENDING INDEX "TEST INDEX"
    Check in table    "PK_TEST TABLE_1"    PRIMARY
    Check Index    TEST INDEX
    
test_primary_select_ts
    Skip
    Init    ${True}
    Select From Combo Box    typesCombo    PRIMARY
    Select From Combo Box    tablespacesCombo    TEST_TS
    Click On List Item    0    ID    2
    Check commit    ALTER TABLE TEST_TABLE ADD CONSTRAINT "PK_TEST TABLE_1" PRIMARY KEY (ID)    TEST_TS
    Check in table    PK_TEST_TABLE_1    PRIMARY

test_foreign_empty_index
    Init
    Select From Combo Box    typesCombo    FOREIGN
    Select References
    Check commit    ALTER TABLE TEST_TABLE ADD CONSTRAINT FK_TEST_TABLE_1 FOREIGN KEY (ID) REFERENCES CUSTOMER (CUST_NO)
    ${row}=    Check in table    FK_TEST_TABLE_1    FOREIGN
    ${ref}=    Get Table Cell Value    0    ${row}    Reference Table
    Should Be Equal As Strings    ${ref}    CUSTOMER
    ${ref}=    Get Table Cell Value    0    ${row}    Reference Columns
    Should Be Equal As Strings    ${ref}    CUST_NO
    Check Rules    ${row}    RESTRICT
    Check Index    FK_TEST_TABLE_1

test_foreign_ascending
    Init
    Select From Combo Box    typesCombo    FOREIGN
    Clear Text Field    usingIndexField
    Type Into Text Field    usingIndexField    TEST_INDEX
    Select From Combo Box    sortingCombo    ASCENDING
    Select Rules    NO ACTION
    Select References
    Check commit    ALTER TABLE TEST_TABLE ADD CONSTRAINT FK_TEST_TABLE_1 FOREIGN KEY (ID) REFERENCES CUSTOMER (CUST_NO) ON UPDATE NO ACTION ON DELETE NO ACTION USING ASCENDING INDEX TEST_INDEX
    ${row}=    Check in table    FK_TEST_TABLE_1    FOREIGN
    Check Rules    ${row}    NO ACTION
    Check Index    TEST_INDEX

test_foreign_descending
    Init
    Select From Combo Box    typesCombo    FOREIGN
    Clear Text Field    usingIndexField
    Type Into Text Field    usingIndexField    TEST_INDEX
    Select From Combo Box    sortingCombo    DESCENDING
    Select Rules    CASCADE
    Select References
    Check commit    ALTER TABLE TEST_TABLE ADD CONSTRAINT FK_TEST_TABLE_1 FOREIGN KEY (ID) REFERENCES CUSTOMER (CUST_NO) ON UPDATE CASCADE ON DELETE CASCADE USING DESCENDING INDEX TEST_INDEX
    ${row}=    Check in table    FK_TEST_TABLE_1    FOREIGN
    Check Rules    ${row}    CASCADE
    Check Index    TEST_INDEX

test_foreign_select_ts
    Skip
    Init    ${True}
    Select From Combo Box    typesCombo    FOREIGN
    Select From Combo Box    tablespacesCombo    TEST_TS
    Select References    
    Check commit    ALTER TABLE TEST_TABLE ADD CONSTRAINT FK_TEST_TABLE_1 FOREIGN KEY (ID) REFERENCES CUSTOMER (CUST_NO)    TEST_TS
    Check in table    FK_TEST_TABLE_1    FOREIGN

test_foreign_set_default_rules
    Init
    Select From Combo Box    typesCombo    FOREIGN
    Select Rules    SET DEFAULT
    Select References
    Check commit    ALTER TABLE TEST_TABLE ADD CONSTRAINT FK_TEST_TABLE_1 FOREIGN KEY (ID) REFERENCES CUSTOMER (CUST_NO) ON UPDATE SET DEFAULT ON DELETE SET DEFAULT
    ${row}=    Check in table    FK_TEST_TABLE_1    FOREIGN
    Check Rules    ${row}    SET DEFAULT

test_foreign_set_null_rules
    Init
    Select From Combo Box    typesCombo    FOREIGN
    Select Rules    SET NULL
    Select References
    Check commit    ALTER TABLE TEST_TABLE ADD CONSTRAINT FK_TEST_TABLE_1 FOREIGN KEY (ID) REFERENCES CUSTOMER (CUST_NO) ON UPDATE SET NULL ON DELETE SET NULL
    ${row}=    Check in table    FK_TEST_TABLE_1    FOREIGN
    Check Rules    ${row}    SET NULL

test_unique_empty_index
    Init
    Select From Combo Box    typesCombo    UNIQUE
    Click On List Item    0    ID    2
    Check commit    ALTER TABLE TEST_TABLE ADD CONSTRAINT UQ_TEST_TABLE_1 UNIQUE (ID)
    Check in table    UQ_TEST_TABLE_1    UNIQUE

test_unique_ascending
    Init
    Select From Combo Box    typesCombo    UNIQUE
    Clear Text Field    usingIndexField
    Type Into Text Field    usingIndexField    TEST_INDEX
    Select From Combo Box    sortingCombo    ASCENDING
    Click On List Item    0    ID    2
    Check commit    ALTER TABLE TEST_TABLE ADD CONSTRAINT UQ_TEST_TABLE_1 UNIQUE (ID) USING ASCENDING INDEX TEST_INDEX
    Check in table    UQ_TEST_TABLE_1    UNIQUE

test_unique_descending
    Init
    Select From Combo Box    typesCombo    UNIQUE
    Clear Text Field    usingIndexField
    Type Into Text Field    usingIndexField    TEST_INDEX
    Select From Combo Box    sortingCombo    DESCENDING
    Click On List Item    0    ID    2
    Check commit    ALTER TABLE TEST_TABLE ADD CONSTRAINT UQ_TEST_TABLE_1 UNIQUE (ID) USING DESCENDING INDEX TEST_INDEX
    Check in table    UQ_TEST_TABLE_1    UNIQUE

test_unique_select_ts
    Skip
    Init    ${True}
    Select From Combo Box    typesCombo    UNIQUE
    Select From Combo Box    tablespacesCombo    TEST_TS
    Click On List Item    0    ID    2
    Check commit    ALTER TABLE TEST_TABLE ADD CONSTRAINT UQ_TEST_TABLE_1 UNIQUE (ID)    TEST_TS
    Check in table    UQ_TEST_TABLE_1    UNIQUE

test_check
    Init
    Select From Combo Box    typesCombo    CHECK
    Clear Text Field    2
    Type Into Text Field    2    CHECK(1 = 1)
    Check commit    ALTER TABLE TEST_TABLE ADD CONSTRAINT CHECK_TEST_TABLE_1 CHECK(1 = 1)
    ${row}=    Check in table    CHECK_TEST_TABLE_1    CHECK
    ${check}=    Get Table Cell Value    0    ${row}    Check
    Should Be Equal As Strings    ${check}    CHECK(1 = 1)

*** Keywords ***
Init
    [Arguments]    ${ts}=${False}
    Lock Employee
    IF    ${ts}
        Execute Immediate    CREATE TABLESPACE TEST_TS FILE 'file.ts'
    END
    Execute Immediate    CREATE TABLE TEST_TABLE (ID INT NOT NULL)
    Open connection
    Click On Tree Node    0    New Connection|Tables (11)|TEST_TABLE    2
    Select Tab    Constraints
    Push Button    addConstraintButton
    Select Dialog    Create constraint
    
Check commit
    [Arguments]    ${text}    ${ts}=PRIMARY    ${dialog}=Commiting changes
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    ${srv_ver}=    Set Variable    ${info}[2]
    IF    ${{$ver == '5.0' and $srv_ver == 'RedDatabase'}}
        IF    '${TEST_NAME}' == 'test_check'
            VAR    ${check_ts}    ${EMPTY}
        ELSE
            VAR    ${check_ts}    ${SPACE}TABLESPACE ${ts}
        END
    ELSE
        VAR    ${check_ts}    ${EMPTY}
    END
    Push Button    submitButton
    Sleep    1s
    Select Dialog    ${dialog}
    ${res}=    Get Text Field Value    0
    Should Be Equal As Strings    ${res}    ${text}${check_ts}    strip_spaces=${True}    collapse_spaces=${True}

    Push Button    commitButton
    Sleep    0.1s
    ${old}=    Set Jemmy Timeout    DialogWaiter.WaitDialogTimeout	0
    Run Keyword And Expect Error    org.netbeans.jemmy.TimeoutExpiredException: Dialog with name or title 'Create constraint'    Select Dialog    Create constraint

Check in table
    [Arguments]    ${constraint_name}    ${type}
    Select Main Window
    Select Tab    Constraints
    ${row}=    Find Table Row    0    ${constraint_name}    Name
    Should Not Be Equal As Integers    ${row}    -1
    ${current_type}=    Get Table Cell Value    0    ${row}    Type
    Should Be Equal As Strings    ${current_type}    ${type}
    RETURN    ${row}

Check Index
    [Arguments]    ${constraint_name}
    Select Main Window
    Expand Tree Node    0    New Connection|Indices (39)
    Tree Node Should Exist    0    New Connection|Indices (39)|${constraint_name}

Check Skip
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    ${srv_ver}=    Set Variable    ${info}[2]
    Skip If    ${{not($ver == '5.0' and $srv_ver == 'RedDatabase')}}

Select References
    Select From Combo Box    referenceTablesCombo    CUSTOMER
    Select Tab    On Field    foreignTabbedPane
    Select Dialog    Create constraint
    Click On List Item    0    ID    2
    Select Tab    Reference Column    foreignTabbedPane
    Select Dialog    Create constraint
    Click On List Item    0    CUST_NO    2

Check Rules
    [Arguments]    ${row}    ${rule}
    ${ref}=    Get Table Cell Value    0    ${row}    Update Rule
    Should Be Equal As Strings    ${ref}    ${rule}

    ${ref}=    Get Table Cell Value    0    ${row}    Delete Rule
    Should Be Equal As Strings    ${ref}    ${rule}

Select Rules
    [Arguments]    ${rule}
    Select From Combo Box    updateRulesCombo    ${rule}
    Select From Combo Box    deleteRulesCombo    ${rule}