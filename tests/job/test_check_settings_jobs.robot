*** Settings ***
Library    RemoteSwingLibrary
Library    Process
Library    Collections
Resource    ../../files/keywords.resource
Resource    keys.resource
Test Setup       Setup
Test Teardown    Teardown after every tests

*** Test Cases ***
test_cron_false
    Open connection
    Select From Tree Node Popup Menu    0    New Connection|Jobs (0)    Create job
    Select Dialog    Create job
    Clear Text Field    nameField
    Type Into Text Field    nameField    NEWJOB0
    
    Clear Text Field    1
    Type Into Text Field    1    July 6, 2024
    Clear Text Field    3
    Type Into Text Field    3    July 6, 2023

    Clear Text Field    2
    Type Into Text Field    2    12:00:00.000
    Increase Spinner Value   0    2 

    Clear Text Field    4
    Type Into Text Field    4    25:00:00.000

    Select Tab As Context    Task
    Select From Combo Box    0    BASH
    Check Check Box    Active
    
    Select Dialog    Create job
    Select Tab As Context    Schedule
    Clear Text Field        cronField
    Type Into Text Field    cronField    59 23 11 2 3

    Select Dialog    Create job
    Push Button    submitButton
    Select Dialog    Commiting changes
    ${row}=    Find Table Row    0    Success    Status
    ${script}=    Get Text Field Value    0
    Should Not Be Equal As Integers    ${row}    -1
    Should Be Equal As Strings    ${script}    CREATE JOB NEWJOB0 '59 23 11 2 3' ACTIVE START DATE '06.07.2024 13:00' END DATE '06.07.2023 01:00' COMMAND ''    collapse_spaces=${True}