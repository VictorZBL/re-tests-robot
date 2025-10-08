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
    Select From Tree Node Popup Menu    0    New Connection|Jobs    Create job
    Select Dialog    Create job
    Check All Checkboxes
    Select Tab As Context    Task
    Type Into Text Field    0    begin /*job is here*/ end
    Select Dialog    Create job
    Select Tab As Context    Schedule
    Clear Text Field    cronField
    Type Into Text Field    cronField    59 23 11 2 3
    Push Radio Button    everyYearRadio
    Clear Text Field    2
    Type Into Text Field    2    23:57

    Clear Text Field    1
    Type Into Text Field    1    July 7, 2025
    ${cron}=    Get Text Field Value    cronField
    Should Be Equal As Strings    ${cron}    57 23 7 7 *    collapse_spaces=${True}    strip_spaces=${True}

    Push Radio Button    everyDayRadio
    Decrease Spinner Value    0    1
    Clear Text Field    intervalField
    Type Into Text Field    intervalField    3
    ${cron}=    Get Text Field Value    cronField
    Should Be Equal As Strings    ${cron}    57 22 */3 * *    collapse_spaces=${True}    strip_spaces=${True}
    
    Push Radio Button    everyWeekdayRadio
    Increase Spinner Value    0    2
    Clear Text Field    intervalField
    Type Into Text Field    intervalField    5
    ${cron}=    Get Text Field Value    cronField
    Should Be Equal As Strings    ${cron}    57 0 * * */5    collapse_spaces=${True}    strip_spaces=${True}

    Push Radio Button    everyMonthRadio
    Increase Spinner Value    0    3
    # Select From Combo Box    0    March
    # Select From Combo Box    1    5
    ${cron}=    Get Text Field Value    cronField
    Should Be Equal As Strings    ${cron}    57 3 * * *    collapse_spaces=${True}    strip_spaces=${True}

    Check Check Box    repeatCheck
    Select From Combo Box    2    30 min
    ${cron}=    Get Text Field Value    cronField
    Should Be Equal As Strings    ${cron}    57/30 3 * * *    collapse_spaces=${True}    strip_spaces=${True}

    Select Dialog    Create job
    Push Button    submitButton
    Select Dialog    Commiting changes
    ${row}=    Find Table Row    0    Success    Status
    ${script}=    Get Text Field Value    0
    Should Not Be Equal As Integers    ${row}    -1
    Should Be Equal As Strings    ${script}    CREATE JOB NEW_JOB_1 '57/30 3 * * * ' ACTIVE START DATE NULL END DATE NULL AS begin /*job is here*/ end    collapse_spaces=${True}