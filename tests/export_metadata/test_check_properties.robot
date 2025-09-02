*** Settings ***
Library    RemoteSwingLibrary
Resource   ../../files/keywords.resource 
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_check_no_ignore
    Init extract
    ${script_without_properties}=    Extract
    Log Variables
    @{result}=    Check Ignore    ${script_without_properties}
    # Delete Objects    ${rdb5}
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    IF    '${ver}' == '2.6'
        Should Be Equal As Strings    ${result}    [12, 3, 10, 14, 3, 23]
    ELSE
        Should Be Equal As Strings    ${result}    [15, 3, 10, 14, 3, 23]
    END

test_check_ignore
    Init extract
    Push Button    selectAllExtractPropertiesButton
    ${script_without_properties}=    Extract
    Log Variables
    @{result}=    Check Ignore    ${script_without_properties}
    # Delete Objects    ${rdb5}
    Should Be Equal As Strings    ${result}    [0, 0, 0, 0, 1, 9]


*** Keywords ***
Init extract
    Lock Employee
    Create Objects
    Push Button    extract-metadata-command

Extract
    Push Button    extractButton
    Sleep    5s
    Close Dialog    Message
    Select Tab As Context    SQL
    ${script}=    Get Text Field Value    0
    RETURN    ${script}
    
Check Ignore
    [Arguments]    ${script}
    @{result}    Create List    ${{$script.count("COMMENT ON")}}    ${{$script.count("COMPUTED BY")}}    ${{$script.count("PRIMARY KEY")}}    ${{$script.count("FOREIGN KEY")}}    ${{$script.count("UNIQUE")}}    ${{$script.count("CHECK (")}}
    RETURN    @{result}