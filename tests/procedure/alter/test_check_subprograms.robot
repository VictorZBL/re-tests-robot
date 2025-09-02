*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../../files/keywords.resource
Resource    keys.resource
Test Setup       Setup
Test Teardown    Teardown after every tests

*** Test Cases ***
test_1
    Init proc
    @{value}=    Get Table Values    0
    Should Be Equal As Strings    ${value}    [['TEST_SUB', 'PROCEDURE'], ['TEST_FUNC', 'FUNCTION']]
    ${row_proc}=    Find Table Row    0    PROCEDURE    Datatype
    ${row_func}=    Find Table Row    0    FUNCTION    Datatype
    Click On Table Cell    0    ${row_proc}    Name
    ${sub_proc}=    Get Text Field Value    0
    Click On Table Cell    0    ${row_func}    Name
    ${sub_func}=    Get Text Field Value    0
    Should Be Equal As Strings    ${sub_proc}    DECLARE PROCEDURE TEST_SUB ( PAR1 INTEGER ) RETURNS ( PAR2 INTEGER ) AS DECLARE PAR3 TYPE OF CUSTNO; BEGIN PAR2 = 2; END    strip_spaces=${True}    collapse_spaces=${True}
    Should Be Equal As Strings    ${sub_func}    DECLARE FUNCTION TEST_FUNC RETURNS INTEGER AS DECLARE PAR3 TYPE OF CUSTNO; BEGIN RETURN 123; END    strip_spaces=${True}    collapse_spaces=${True}

test_alter
    Init proc
    ${row_proc}=    Find Table Row    0    PROCEDURE    Datatype
    ${row_func}=    Find Table Row    0    FUNCTION    Datatype
    Click On Table Cell    0    ${row_proc}    Name
    Clear Text Field    0
    Type Into Text Field    0    DECLARE PROCEDURE TEST_SUB AS BEGIN END\n 

    Check ddl    CREATE OR ALTER PROCEDURE TEST AS DECLARE PROCEDURE TEST_SUB AS BEGIN END DECLARE FUNCTION TEST_FUNC RETURNS INTEGER AS DECLARE PAR3 TYPE OF CUSTNO; BEGIN RETURN 123; END BEGIN END;
    
    Select Tab As Context    Subprograms
    Click On Table Cell    0    ${row_func}    Name
    Clear Text Field    0
    Type Into Text Field    0    DECLARE FUNCTION TEST_FUNC RETURNS INTEGER AS BEGIN END\n 

    Check ddl    CREATE OR ALTER PROCEDURE TEST AS DECLARE PROCEDURE TEST_SUB AS BEGIN END DECLARE FUNCTION TEST_FUNC RETURNS INTEGER AS BEGIN END BEGIN END;
    
test_remove
    Init proc
    ${row_proc}=    Find Table Row    0    PROCEDURE    Datatype
    Click On Table Cell    0    ${row_proc}    Name
    Push Button    deleteRowButton
    ${row_func}=    Find Table Row    0    FUNCTION    Datatype
    Click On Table Cell    0    ${row_func}    Name
    Push Button    deleteRowButton
    Check ddl    CREATE OR ALTER PROCEDURE TEST AS BEGIN END;

test_empty_remove
    Lock Employee
    Execute Immediate    CREATE OR ALTER PROCEDURE TEST AS BEGIN END
    Open connection
    Click On Tree Node   0    New Connection|Procedures (11)|TEST    2
    Select Tab As Context    Subprograms

    Push Button    addRowButton
    Push Button    addRowButton
    Sleep    2s
    Click On Table Cell    0    1    Name
    Push Button    deleteRowButton
    Sleep    2s

*** Keywords ***
Init proc
    Lock Employee
    Execute Immediate    CREATE OR ALTER PROCEDURE TEST AS DECLARE PROCEDURE TEST_SUB ( PAR1 INTEGER ) RETURNS ( PAR2 INTEGER ) AS DECLARE PAR3 TYPE OF CUSTNO; BEGIN PAR2 = 2; END DECLARE FUNCTION TEST_FUNC RETURNS INTEGER AS DECLARE PAR3 TYPE OF CUSTNO; BEGIN RETURN 123; END BEGIN END
    Open connection
    Click On Tree Node   0    New Connection|Procedures (11)|TEST    2
    Select Tab As Context    Subprograms

Check ddl
    [Arguments]    ${ddl}
    Select Main Window
    ${new_ddl}=    Get Text Field Value    2
    Should Be Equal As Strings    ${new_ddl}    ${ddl}    strip_spaces=${True}    collapse_spaces=${True}
    Push Button    submitButton
    Select Dialog    Commiting changes
    Push Button    commitButton
    Select Main Window
    ${new_ddl}=    Get Text Field Value    2
    Should Be Equal As Strings    ${new_ddl}    ${ddl}    strip_spaces=${True}    collapse_spaces=${True}