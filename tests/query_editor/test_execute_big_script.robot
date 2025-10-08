*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../files/keywords.resource
Test Setup       Setup before every tests
Test Teardown    Teardown


*** Test Cases ***
test_execute
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    ${srv_ver}=    Set Variable    ${info}[2]
    IF    ${{$ver == '5' and $srv_ver == 'RedDatabase'}}
        Init    test_script5.sql
    ELSE IF    ${{$ver == '2.6'}}
        Init    test_script26.sql
    ELSE
        Init    test_script3.sql
    END
    Sleep    5s
    Push Button    editor-stop-on-error-command


test_cancel
    Init    test_script26.sql
    Sleep    0.5s
    Push Button    stop-execution-command
    Sleep    5s
    Push Button    editor-stop-on-error-command


*** Keywords ***
Init
    [Arguments]    ${file}
    Lock Employee
    Open connection
    Sleep    2s
    Clear Text Field    0
    Select From Main Menu    Edit|Open file
    Select Dialog    Open
    ${script_path}=    Catenate    SEPARATOR=    ${EXECDIR}    /files/${file}
    Type Into Text Field    0    ${script_path}
    Push Button    Open
    Select Main Window
    Push Button    editor-stop-on-error-command
    Run Keyword In Separate Thread    Push Button    execute-script-command

Teardown
    Teardown after every tests
    Run Keyword And Ignore Error    Execute Immediate    DROP USER TEST_USER