*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../../files/keywords.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
alter_ddl
    Lock Employee
    Execute Immediate    CREATE OR ALTER PROCEDURE TEST RETURNS ( TOT INTEGER ) AS BEGIN tot = 55; END
    Open connection
    Click On Tree Node   0    New Connection|Procedures (11)|TEST   2
    Clear Text Field    1
    Type Into Text Field    1    CREATE OR ALTER PROCEDURE TEST RETURNS ( TOT INTEGER ) AS BEGIN tot = 66; END
    Push Button    submitButton
    Select Dialog    Commiting changes
    Push Button    commitButton
    Select Main Window
    ${ddl}=    Get Text Field Value    1
    ${authid}=    Get Authid
    Should Be Equal As Strings    ${ddl}    CREATE OR ALTER PROCEDURE TEST${authid}RETURNS ( TOT INTEGER ) AS BEGIN tot = 66; END;    strip_spaces=${True}    collapse_spaces=${True}
    Push Button    actionButton
    Select Dialog    Execute Procedure
    Push Button    executeButton
    @{value}=    Get Table Values    1
    Should Be Equal As Strings    ${value}    [['66']]

alter_add_input_par
    ${authid}=    Get Authid
    Add par    CREATE OR ALTER PROCEDURE TEST (PAR0 INTEGER) RETURNS ( TOT INTEGER ) AS BEGIN tot = 55; END    Input Parameters    CREATE OR ALTER PROCEDURE TEST${authid}( PAR0 INTEGER, PAR1 EMPNO, PAR2 TYPE OF CUSTNO, PAR3 TYPE OF COLUMN COUNTRY.COUNTRY, PAR4 VARCHAR(10) CHARACTER SET UTF8 NOT NULL DEFAULT 'test' ) RETURNS ( TOT INTEGER ) AS BEGIN tot = 55; END;
    
alter_add_out_par
    ${authid}=    Get Authid
    Add par    CREATE OR ALTER PROCEDURE TEST RETURNS ( PAR0 INTEGER ) AS BEGIN PAR0 = 55; END    Output Parameters    CREATE OR ALTER PROCEDURE TEST${authid}RETURNS ( PAR0 INTEGER, PAR1 EMPNO, PAR2 TYPE OF CUSTNO, PAR3 TYPE OF COLUMN COUNTRY.COUNTRY, PAR4 VARCHAR(10) CHARACTER SET UTF8 NOT NULL ) AS BEGIN PAR0 = 55; END;

alter_add_var
    ${authid}=    Get Authid
    Add par    CREATE OR ALTER PROCEDURE TEST RETURNS ( TOT INTEGER ) AS DECLARE PAR0 INTEGER; BEGIN tot = 55; END    Variables    CREATE OR ALTER PROCEDURE TEST${authid}RETURNS ( TOT INTEGER ) AS DECLARE PAR0 INTEGER; DECLARE PAR1 EMPNO; DECLARE PAR2 TYPE OF CUSTNO; DECLARE PAR3 TYPE OF COLUMN COUNTRY.COUNTRY; DECLARE PAR4 VARCHAR(10) CHARACTER SET UTF8 NOT NULL DEFAULT 'test'; BEGIN tot = 55; END;

alter_add_cursor
    Lock Employee
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    Execute Immediate    CREATE OR ALTER PROCEDURE TEST RETURNS ( PAR0 INTEGER ) AS BEGIN PAR0 = 55; END
    Open connection
    Click On Tree Node   0    New Connection|Procedures (11)|TEST   2
    Select Tab As Context    Cursors
    Push Button    addRowButton
    Type Into Table Cell    0    0    Name    PAR1
    Click On Table Cell     0    0    Select operator
    Type Into Text Field    0    SELECT * FROM EMPLOYEE
    
    Push Button    addRowButton
    Type Into Table Cell    0    1    Name    PAR2
    IF   ${{$ver != '2.6'}}
        Click On Table Cell     0    1    Scroll
    END
    Click On Table Cell     0    1    Select operator
    Type Into Text Field    0    SELECT * FROM COUNTRY

    Select Main Window
    ${new_ddl1}=    Get Text Field Value    2
    Sleep    1s
    Push Button    submitButton
    Select Dialog    Commiting changes
    Push Button    commitButton
    IF   ${{$ver != '2.6'}}
        VAR    ${expected_ddl}    CREATE OR ALTER PROCEDURE TEST RETURNS ( PAR0 INTEGER ) AS DECLARE PAR1 CURSOR FOR (SELECT * FROM EMPLOYEE); DECLARE PAR2 SCROLL CURSOR FOR (SELECT * FROM COUNTRY); BEGIN PAR0 = 55; END;
    ELSE
        VAR    ${expected_ddl}    CREATE OR ALTER PROCEDURE TEST AUTHID OWNER RETURNS ( PAR0 INTEGER ) AS DECLARE PAR1 CURSOR FOR (SELECT * FROM EMPLOYEE); DECLARE PAR2 CURSOR FOR (SELECT * FROM COUNTRY); BEGIN PAR0 = 55; END;
    END
    Should Be Equal As Strings    ${new_ddl1}    ${expected_ddl}    strip_spaces=${True}    collapse_spaces=${True}
    Select Main Window
    ${new_ddl2}=    Get Text Field Value    2
    Should Be Equal As Strings    ${new_ddl2}    ${expected_ddl}   strip_spaces=${True}    collapse_spaces=${True}

alter_remove_input_par
    ${authid}=    Get Authid
    Remove par    CREATE OR ALTER PROCEDURE TEST ( PAR0 INTEGER, PAR1 VARCHAR(10) CHARACTER SET UTF8 NOT NULL, PAR2 EMPNO, PAR3 TYPE OF CUSTNO, PAR4 TYPE OF COLUMN COUNTRY.COUNTRY ) RETURNS ( TOT INTEGER ) AS BEGIN tot = 55; END    Input Parameters    CREATE OR ALTER PROCEDURE TEST${authid}( PAR0 INTEGER ) RETURNS ( TOT INTEGER ) AS BEGIN tot = 55; END;    
    
alter_remove_out_par
    ${authid}=    Get Authid
    Remove par    CREATE OR ALTER PROCEDURE TEST RETURNS ( PAR0 INTEGER, PAR1 VARCHAR(10) CHARACTER SET UTF8 NOT NULL, PAR2 EMPNO, PAR3 TYPE OF CUSTNO, PAR4 TYPE OF COLUMN COUNTRY.COUNTRY ) AS BEGIN PAR0 = 55; END    Output Parameters    CREATE OR ALTER PROCEDURE TEST${authid}RETURNS ( PAR0 INTEGER ) AS BEGIN PAR0 = 55; END;  

alter_remove_var
    ${authid}=    Get Authid
    Remove par    CREATE OR ALTER PROCEDURE TEST RETURNS ( TOT INTEGER ) AS DECLARE PAR0 INTEGER; DECLARE PAR1 VARCHAR(10) CHARACTER SET UTF8 NOT NULL; DECLARE PAR2 EMPNO; DECLARE PAR3 TYPE OF CUSTNO; DECLARE PAR4 TYPE OF COLUMN COUNTRY.COUNTRY; BEGIN tot = 55; END    Variables    CREATE OR ALTER PROCEDURE TEST${authid}RETURNS ( TOT INTEGER ) AS DECLARE PAR0 INTEGER; BEGIN tot = 55; END;    

alter_remove_cursor
    Lock Employee
    Execute Immediate    CREATE OR ALTER PROCEDURE TEST RETURNS ( TOT INTEGER ) AS DECLARE PAR0 INTEGER; DECLARE PAR1 CURSOR FOR (SELECT * FROM EMPLOYEE); DECLARE PAR2 CURSOR FOR (SELECT * FROM EMPLOYEE); DECLARE PAR3 CURSOR FOR (SELECT * FROM EMPLOYEE); DECLARE PAR4 CURSOR FOR (SELECT * FROM EMPLOYEE); BEGIN tot = 55; END
    Open connection
    Click On Tree Node   0    New Connection|Procedures (11)|TEST   2
    Select Tab As Context    Cursors
    FOR  ${par}  IN  PAR4   PAR2    PAR1    PAR3
        ${row}=    Find Table Row    0    ${par}    Name
        Click On Table Cell    0    ${row}    Name
        Push Button    deleteRowButton
    END

    Select Main Window
    ${new_ddl1}=    Get Text Field Value    2
    Sleep    1s
    Push Button    submitButton
    Select Dialog    Commiting changes
    Push Button    commitButton
    ${authid}=    Get Authid
    Should Be Equal As Strings    ${new_ddl1}    CREATE OR ALTER PROCEDURE TEST${authid}RETURNS ( TOT INTEGER ) AS DECLARE PAR0 INTEGER; BEGIN tot = 55; END;    strip_spaces=${True}    collapse_spaces=${True}
    Select Main Window
    ${new_ddl2}=    Get Text Field Value    2
    Should Be Equal As Strings    ${new_ddl2}    CREATE OR ALTER PROCEDURE TEST${authid}RETURNS ( TOT INTEGER ) AS DECLARE PAR0 INTEGER; BEGIN tot = 55; END;    strip_spaces=${True}    collapse_spaces=${True}

move_input_par
    ${authid}=    Get Authid
    Move par    CREATE OR ALTER PROCEDURE TEST ( PAR1 INTEGER, PAR2 INTEGER, PAR3 INTEGER, PAR4 INTEGER ) AS BEGIN END    Input Parameters    CREATE OR ALTER PROCEDURE TEST${authid}( PAR1 INTEGER, PAR3 INTEGER, PAR2 INTEGER, PAR4 INTEGER ) AS BEGIN END; 

move_out_par
    ${authid}=    Get Authid
    Move par    CREATE OR ALTER PROCEDURE TEST RETURNS ( PAR1 INTEGER, PAR2 INTEGER, PAR3 INTEGER, PAR4 INTEGER ) AS BEGIN END    Output Parameters    CREATE OR ALTER PROCEDURE TEST${authid}RETURNS ( PAR1 INTEGER, PAR3 INTEGER, PAR2 INTEGER, PAR4 INTEGER ) AS BEGIN END;

*** Keywords ***
Add par
    [Arguments]    ${init_proc}    ${tab}    ${ddl}
    Lock Employee
    Execute Immediate    ${init_proc}
    Open connection
    Click On Tree Node   0    New Connection|Procedures (11)|TEST   2
    Select Tab As Context    ${tab}

    Push Button    addRowButton
    Type Into Table Cell    0    1    Name    PAR1
    Set Table Cell Value    0    1    Domain    EMPNO

    Push Button    addRowButton
    Type Into Table Cell    0    2    Name    PAR2
    Click On Table Cell     0    2    Type of
    Set Table Cell Value    0    2    Domain    CUSTNO
    
    Push Button    addRowButton
    Type Into Table Cell    0    3    Name    PAR3
    Click On Table Cell     0    3    Type of
    Set Table Cell Value    0    3    Table    COUNTRY
    
    Push Button    addRowButton
    Type Into Table Cell    0    4    Name    PAR4
    Set Table Cell Value    0    4    Datatype    VARCHAR
    Type Into Table Cell    0    4    Size or precision    10
    Type Into Table Cell    0    4    Default Value   'test'
    Set Table Cell Value    0    4    Encoding    UTF8
    Click On Table Cell     0    4    NOT NULL

    Select Main Window
    ${new_ddl1}=    Get Text Field Value    1
    Sleep    1s
    Push Button    submitButton
    Select Dialog    Commiting changes
    Push Button    commitButton
    Should Be Equal As Strings    ${new_ddl1}    ${ddl}    strip_spaces=${True}    collapse_spaces=${True}
    Select Main Window
    ${new_ddl2}=    Get Text Field Value    1
    Should Be Equal As Strings    ${new_ddl2}    ${ddl}    strip_spaces=${True}    collapse_spaces=${True}

Remove par
    [Arguments]    ${init_proc}    ${tab}    ${ddl}
    Lock Employee
    Execute Immediate    ${init_proc}
    Open connection
    Click On Tree Node   0    New Connection|Procedures (11)|TEST   2
    Select Tab As Context    ${tab}
    FOR  ${par}  IN  PAR4   PAR2    PAR1    PAR3
        ${row}=    Find Table Row    0    ${par}    Name
        Click On Table Cell    0    ${row}    Name
        Push Button    deleteRowButton
    END
    Select Main Window
    ${new_ddl1}=    Get Text Field Value    1
    Sleep    1s
    Push Button    submitButton
    Select Dialog    Commiting changes
    Push Button    commitButton
    Should Be Equal As Strings    ${new_ddl1}    ${ddl}    strip_spaces=${True}    collapse_spaces=${True}
    Select Main Window
    ${new_ddl2}=    Get Text Field Value    1
    Should Be Equal As Strings    ${new_ddl2}    ${ddl}    strip_spaces=${True}    collapse_spaces=${True}


Move par
    [Arguments]    ${init_proc}    ${tab}    ${ddl}
    Lock Employee
    Execute Immediate    ${init_proc}
    Open connection
    Click On Tree Node   0    New Connection|Procedures (11)|TEST   2
    Select Tab As Context    ${tab}
    ${row}=    Find Table Row    0    PAR2    Name
    Click On Table Cell    0    ${row}    Name
    Push Button    moveDownButton
    Push Button    moveDownButton
    Push Button    moveUpButton
        Select Main Window
    ${new_ddl1}=    Get Text Field Value    1
    Sleep    1s
    Push Button    submitButton
    Select Dialog    Commiting changes
    Push Button    commitButton
    Should Be Equal As Strings    ${new_ddl1}    ${ddl}    strip_spaces=${True}    collapse_spaces=${True}
    Select Main Window
    ${new_ddl2}=    Get Text Field Value    1
    Should Be Equal As Strings    ${new_ddl2}    ${ddl}    strip_spaces=${True}    collapse_spaces=${True}

Get Authid
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    IF    ${{$ver == '2.6'}}
        VAR    ${authid}    ${SPACE}AUTHID OWNER${SPACE}
    ELSE
        VAR    ${authid}    ${SPACE}
    END
    RETURN    ${authid}