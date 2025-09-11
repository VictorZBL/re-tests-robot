*** Settings ***
Library    RemoteSwingLibrary
Library    Process
Library    Collections
Resource    ../files/keywords.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_create_table
    Create Table    Tables (10)    Create table

test_create_gtt
    Create Table    Global Temporary Tables    Create global temporary table

*** Keywords ***
Create Table
    [Arguments]    ${type}    ${create}
    Open connection
    Expand Tree Node    0    New Connection    
    Select From Tree Node Popup Menu    0    New Connection|${type}    ${create}
    Select Dialog    Create table
    Clear Text Field    nameField
    Type Into Text Field    nameField    TEST TABLE
    Type Into Table Cell    0    0    Name    TEST
    Set Table Cell Value    0    0    Datatype    BIGINT
    Click On Table Cell    0    0    Name    2      
    Send Keyboard Event    VK_ENTER                
    Push Button    submitButton
    Select Dialog    Commiting changes
    ${textFieldValue}=    Get Textfield Value    0
    Should Not Be Equal As Integers    ${{$textFieldValue.find('"TEST TABLE"')}}    -1