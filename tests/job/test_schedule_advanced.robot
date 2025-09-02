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
    Init Create
    
    Select Tab As Context    minutes
    ${comboboxValues}=    Get Selected Item From Combo Box    5
    Should Be Equal As Integers    ${comboboxValues}    59
    
    Select Dialog    Create job
    Select Tab As Context    Schedule
    Select Tab As Context    hours
    ${comboboxValues}=    Get Selected Item From Combo Box    5
    Should Be Equal As Integers    ${comboboxValues}    23
    
    Select Dialog    Create job
    Select Tab As Context    Schedule
    Select Tab As Context    days
    ${comboboxValues}=    Get Selected Item From Combo Box    5
    Should Be Equal As Strings    ${comboboxValues}    11

    Select Dialog    Create job
    Select Tab As Context    Schedule
    Select Tab As Context    months
    ${comboboxValues}=    Get Selected Item From Combo Box    5
    Should Be Equal As Strings    ${comboboxValues}    February

    Select Dialog    Create job
    Select Tab As Context    Schedule
    Select Tab As Context    weekdays
    ${comboboxValues}=    Get Selected Item From Combo Box    5
    Should Be Equal As Strings    ${comboboxValues}    Wednesday
    
    Select Dialog    Create job
    Push Button    submitButton
    Select Dialog    Commiting changes
    ${row}=    Find Table Row    0    Success    Status
    ${script}=    Get Text Field Value    0
    Should Not Be Equal As Integers    ${row}    -1
    Should Be Equal As Strings    ${script}    CREATE JOB NEW_JOB_1 '59 23 11 2 3' ACTIVE START DATE NULL END DATE NULL AS begin /*job is here*/ end    collapse_spaces=${True}

test_cron_true
    Init Create
    #minutes
    Select Tab As Context    minutes
    Push Radio Button    eachUnitRadio
    Select Dialog    Create job
    Select Tab As Context    Schedule
    ${cron}=    Get Text Field Value    cronField
    Should Be Equal As Strings    ${cron}    * 23 11 2 3
    
    Select Tab As Context    minutes
    Push Radio Button    intervalUnitRadio
    Select From Combo Box    0    5
    Check Check Box    from
    Select From Combo Box    1    10
    Check Check Box    to    
    Select From Combo Box    2    20
    Select Dialog    Create job
    Select Tab As Context    Schedule
    ${cron}=    Get Text Field Value    cronField
    Should Be Equal As Strings    ${cron}    10-20/6 23 11 2 3

    Select Tab As Context    minutes
    Push Radio Button    betweenUnitRadio
    Select From Combo Box    3    12
    Select From Combo Box    4    58
    Select Dialog    Create job
    Select Tab As Context    Schedule
    ${cron}=    Get Text Field Value    cronField
    Should Be Equal As Strings    ${cron}    12-58 23 11 2 3

    #hours
    Select Tab As Context    hours
    Push Radio Button    eachUnitRadio
    Select Dialog    Create job
    Select Tab As Context    Schedule
    ${cron}=    Get Text Field Value    cronField
    Should Be Equal As Strings    ${cron}    12-58 * 11 2 3
    
    Select Tab As Context    hours
    Push Radio Button    intervalUnitRadio
    Select From Combo Box    0    5
    Check Check Box    from
    Select From Combo Box    1    10
    Check Check Box    to    
    Select From Combo Box    2    20
    Select Dialog    Create job
    Select Tab As Context    Schedule
    ${cron}=    Get Text Field Value    cronField
    Should Be Equal As Strings    ${cron}    12-58 10-20/6 11 2 3

    Select Tab As Context    hours
    Push Radio Button    betweenUnitRadio
    Select From Combo Box    3    12
    Select From Combo Box    4    23
    Select Dialog    Create job
    Select Tab As Context    Schedule
    ${cron}=    Get Text Field Value    cronField
    Should Be Equal As Strings    ${cron}    12-58 12-23 11 2 3

    #days
    Select Tab As Context    days
    Push Radio Button    eachUnitRadio
    Select Dialog    Create job
    Select Tab As Context    Schedule
    ${cron}=    Get Text Field Value    cronField
    Should Be Equal As Strings    ${cron}    12-58 12-23 * 2 3
    
    Select Tab As Context    days
    Push Radio Button    intervalUnitRadio
    Select From Combo Box    0    5
    Check Check Box    from
    Select From Combo Box    1    10
    Check Check Box    to    
    Select From Combo Box    2    20
    Select Dialog    Create job
    Select Tab As Context    Schedule
    ${cron}=    Get Text Field Value    cronField
    Should Be Equal As Strings    ${cron}    12-58 12-23 11-21/6 2 3

    Select Tab As Context    days
    Push Radio Button    betweenUnitRadio
    Select From Combo Box    3    12
    Select From Combo Box    4    30
    Select Dialog    Create job
    Select Tab As Context    Schedule
    ${cron}=    Get Text Field Value    cronField
    Should Be Equal As Strings    ${cron}    12-58 12-23 13-31 2 3

    #months
    Select Tab As Context    months
    Push Radio Button    eachUnitRadio
    Select Dialog    Create job
    Select Tab As Context    Schedule
    ${cron}=    Get Text Field Value    cronField
    Should Be Equal As Strings    ${cron}    12-58 12-23 13-31 * 3
    
    Select Tab As Context    months
    Push Radio Button    intervalUnitRadio
    Select From Combo Box    0    5
    Check Check Box    from
    Select From Combo Box    1    May
    Check Check Box    to    
    Select From Combo Box    2    July
    Select Dialog    Create job
    Select Tab As Context    Schedule
    ${cron}=    Get Text Field Value    cronField
    Should Be Equal As Strings    ${cron}    12-58 12-23 13-31 5-7/6 3

    Select Tab As Context    months
    Push Radio Button    betweenUnitRadio
    Select From Combo Box    3    March
    Select From Combo Box    4    October
    Select Dialog    Create job
    Select Tab As Context    Schedule
    ${cron}=    Get Text Field Value    cronField
    Should Be Equal As Strings    ${cron}    12-58 12-23 13-31 3-10 3

    #weekdays
    Select Tab As Context    weekdays
    Push Radio Button    eachUnitRadio
    Select Dialog    Create job
    Select Tab As Context    Schedule
    ${cron}=    Get Text Field Value    cronField
    Should Be Equal As Strings    ${cron}    12-58 12-23 13-31 3-10 *
    
    Select Tab As Context    weekdays
    Push Radio Button    intervalUnitRadio
    Select From Combo Box    0    5
    Check Check Box    from
    Select From Combo Box    1    Monday
    Check Check Box    to    
    Select From Combo Box    2    Friday
    Select Dialog    Create job
    Select Tab As Context    Schedule
    ${cron}=    Get Text Field Value    cronField
    Should Be Equal As Strings    ${cron}    12-58 12-23 13-31 3-10 1-5/6

    Select Tab As Context    weekdays
    Push Radio Button    betweenUnitRadio
    Select From Combo Box    3    Tuesday
    Select From Combo Box    4    Saturday
    Select Dialog    Create job
    Select Tab As Context    Schedule
    ${cron}=    Get Text Field Value    cronField
    Should Be Equal As Strings    ${cron}    12-58 12-23 13-31 3-10 2-6

    Select Dialog    Create job
    Push Button    submitButton
    Select Dialog    Commiting changes
    ${row}=    Find Table Row    0    Success    Status
    ${script}=    Get Text Field Value    0
    Should Not Be Equal As Integers    ${row}    -1
    Should Be Equal As Strings    ${script}    CREATE JOB NEW_JOB_1 '12-58 12-23 13-31 3-10 2-6' ACTIVE START DATE NULL END DATE NULL AS begin /*job is here*/ end    collapse_spaces=${True}

*** Keywords ***    
Init Create
    Open connection
    Select From Tree Node Popup Menu    0    New Connection|Jobs (0)    Create job
    Select Dialog    Create job
    Check All Checkboxes
    Select Tab As Context    Task
    Type Into Text Field    0    begin /*job is here*/ end
    Select Dialog    Create job
    Select Tab As Context    Schedule
    Clear Text Field    cronField
    Type Into Text Field    cronField    59 23 11 2 3
    Check Check Box    advancedCheck