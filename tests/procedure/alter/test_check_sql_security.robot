*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../../files/keywords.resource
Resource    keys.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_1
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    ${srv_ver}=     Set Variable    ${info}[2]
    Skip If    ${{$ver == '3' and $srv_ver == 'Firebird'}}
    Lock Employee
    Execute Immediate    CREATE OR ALTER PROCEDURE TEST AS BEGIN END
    Open connection
    Click On Tree Node   0    New Connection|Procedures (11)|TEST    2
    IF    ${{$ver == '2.6'}}
        Check SQL    CALLER    CREATE OR ALTER PROCEDURE TEST AUTHID CALLER AS BEGIN END;
        Check SQL    OWNER    CREATE OR ALTER PROCEDURE TEST AUTHID OWNER AS BEGIN END;
    ELSE
        Check SQL    DEFINER    CREATE OR ALTER PROCEDURE TEST SQL SECURITY DEFINER AS BEGIN END;
        Check SQL    INVOKER    CREATE OR ALTER PROCEDURE TEST SQL SECURITY INVOKER AS BEGIN END;
    END
    
*** Keywords ***
Check SQL
    [Arguments]    ${type}    ${ddl}
    Select From Combo Box    userContextComboBox    ${type}
    ${new_ddl}=    Get Text Field Value    1
    Should Be Equal As Strings    ${new_ddl}    ${ddl}    strip_spaces=${True}    collapse_spaces=${True}
    Push Button    submitButton
    Select Dialog    Commiting changes
    Push Button    commitButton
    Select Main Window
    ${new_ddl}=    Get Text Field Value    1
    Should Be Equal As Strings    ${new_ddl}    ${ddl}    strip_spaces=${True}    collapse_spaces=${True}