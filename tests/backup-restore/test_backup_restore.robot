*** Settings ***
Library    RemoteSwingLibrary
Library    OperatingSystem
Resource    ../../files/keywords.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_full_check
    ${log_path}=    Catenate    SEPARATOR=    ${TEMPDIR}    /test_log.txt
    ${bk_path}=    Catenate    SEPARATOR=    ${TEMPDIR}    /employee_backup.fbk
    Remove Files   ${log_path}    ${bk_path}
    Open connection
    Select From Main Menu    Database|Database Backup/Restore
    
    Check All Checkboxes
    Select Tab    Backup
    Check All Checkboxes
    Sleep    3s
    Clear Text Field     fileLogFieldBackup
    Type Into Text Field    fileLogFieldBackup    ${log_path}
    # ${home_dir} =	Normalize Path    ~
    # ${current_path}=    Get Text Field Value    backupFileField
    # Should Be Equal As Strings    ${current_path}    ${home_dir}${/}backup.fbk
    Clear Text Field     backupFileField
    Type Into Text Field    backupFileField    ${bk_path}

    Push Button    backupButton
    Sleep    2s
    Select Dialog    Message
    Label Text Should Be    0    Backup completed successfully!
    Push Button    OK
       
    File Should Exist    ${log_path}
    File Should Exist    ${bk_path} 
    Select Main Window
    ${mew_db_path}=    Catenate    SEPARATOR=    ${TEMPDIR}    /employee_restore.fdb1
    Clear Text Field    databaseFileField
    Type Into Text Field    databaseFileField    ${mew_db_path}

    Select Tab    Restore   
    Check All Checkboxes
    Push Button    restoreButton
    Sleep    2s
    Select Dialog    Confirmation
    Label Text Should Be    0    Restore completed successfully!
    Label Text Should Be    1    Register restored database?
    Push Button    No

    #delete files
    Remove Files    ${log_path}    ${bk_path}    ${mew_db_path}