*** Settings ***
Library    RemoteSwingLibrary
Library    OperatingSystem
Resource    ../../files/keywords.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_1
    ${bk_path}=    Catenate    SEPARATOR=    ${TEMPDIR}    /employee_backup.fbk
    ${log_path}=    Catenate    SEPARATOR=    ${EMPTY}    log_file.log
    Remove Files    ${bk_path}    ${log_path}
    Open connection
    Select From Main Menu    Database|Database Backup/Restore
    Clear Text Field     backupFileField
    Type Into Text Field    backupFileField    ${bk_path}
    
    Uncheck All Checkboxes
    Check Check Box    logToFileBoxBackup
    Clear Text Field     fileLogFieldBackup
    Type Into Text Field    fileLogFieldBackup    ${log_path}

    Push Button    backupButton
    Sleep    2s
    Select Dialog    Message
    Label Text Should Be    0    Backup completed successfully!
    Push Button    OK

    File Should Exist    ${bk_path}

    #delete files
    Remove Files    ${bk_path}    ${log_path}