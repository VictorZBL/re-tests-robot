*** Settings ***
Library    RemoteSwingLibrary
Library    OperatingSystem
Library    platform
Resource   ../../files/keywords.resource 
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests
Suite Setup    Suite Setup
Suite Teardown    Suite Teardown

*** Test Cases ***
test_migrate_employee
    ${system}=    platform.System
    ${path_to_interbase_db}=    Set Variable If    '${system}' == 'Linux'   /opt/interbase/examples    C:\\ProgramData\\Embarcadero\\InterBase\\instance2\\examples\\database
    Test    ${path_to_interbase_db}    employee.gdb
    
    FOR    ${node}    IN    Domains (15)    Tables (10)    Views (1)    Procedures (10)    Table Triggers (4)    Sequences (2)    Exceptions (5)
        @{ib_objects}=    Get Tree Node Child Names    0    New Connection 1|${node}
        @{m_objects}=    Get Tree Node Child Names    0    [migrated] New Connection 1|${node}
        Should Be Equal As Strings    ${ib_objects}    ${m_objects}
    END
    
    @{ib_index_objects}=    Get Tree Node Child Names    0    New Connection 1|Indices (12)
    @{m_index_objects}=    Get Tree Node Child Names    0    [migrated] New Connection 1|Indices (38)
    
    FOR    ${ib_index}    IN    @{ib_index_objects}
        Should Contain    ${m_index_objects}   ${ib_index}
    END

    Compare Data    ${path_to_interbase_db}/employee.gdb

test_migrate_malahit
    Test    ${EXECDIR}/files    STM.GDB

    FOR    ${node}    IN    Domains (8)    Tables (35)    Views (4)    Procedures (48)    Table Triggers (36)    Sequences (1)    Exceptions (1)
        @{ib_objects}=    Get Tree Node Child Names    0    New Connection 1|${node}
        @{m_objects}=    Get Tree Node Child Names    0    [migrated] New Connection 1|${node}
        Should Be Equal As Strings    ${ib_objects}    ${m_objects}
    END

    @{ib_udf_objects}=    Get Tree Node Child Names    0    New Connection 1|UDFs (3)
    @{m_udf_objects}=    Get Tree Node Child Names    0    [migrated] New Connection 1|UDFs (1)
    Should Contain   ${ib_udf_objects}    ${m_udf_objects}[0]

    @{ib_index_objects}=    Get Tree Node Child Names    0    New Connection 1|Indices (30)
    @{m_index_objects}=    Get Tree Node Child Names    0    [migrated] New Connection 1|Indices (107)

    FOR    ${ib_index}    IN    @{ib_index_objects}
        Should Contain    ${m_index_objects}   ${ib_index}
    END

    Compare Data    ${EXECDIR}/files/STM.GDB

test_check_error_and_remove_migrated_db
    Push Button    new-connection-command
    Init connect    InterDriver    5051    ${EXECDIR}/files/STM.GDB
    Select From Combo Box    serverCombo    Other   
    Check Check Box    Store Password

    Select From Main Menu     Database|Convert Database
    
    Select Dialog    Database Conversion
    Click On Component    connectionCombo
    Select From Combo Box    connectionCombo    New Connection
    Insert Into Text Field    2    3051

    Push Button    nextButton

    Close Dialog    Error message

    Select From Combo Box    connectionCombo    New Connection 1
    Sleep    5s

    Push Button    nextButton

    # step 2 (Extract metadata)
    Sleep    5s    
    Push Button    nextButton
    # step 3 (Create database)
    Push Button    nextButton
    Select Dialog    Warning
    Label Text Should Be    0    Fill in all required fields
    Push Button    OK
    
    Select Dialog    Database Conversion
        
    Push Button    1
    Select Dialog    Select database file
    ${value}=    Get Text Field Value    0
    Should Be Equal As Strings    ${value}    database.fdb

    Insert Into Text Field    0    ${TEMPDIR}/mirgated_db
    Push Button    Select

    Select Dialog    Database Conversion

    ${db}=    Get Text Field Value    0
    Should Contain    ${db}    mirgated_db.fdb
    Insert Into Text Field    2    3050
    Insert Into Text Field    3    SYSDBA
    Insert Into Text Field    4    masterkey

    Remove File    ${TEMPDIR}/mirgated_db.fdb
    
    Select From Combo Box    0    InterDriver
    Push Button    nextButton
    Select Dialog    Warning
    Label Text Should Be    0    Failed to create database, selected driver is not supported.
    Push Button    OK
    
    Select Dialog    Database Conversion
    Select From Combo Box    0    Jaybird 5 Driver

    Check Check Box    registerCheck
    
    Insert Into Text Field    5    New Connection
    Push Button    nextButton
    Select Dialog    Warning
    Label Text Should Be    0    The connection name you entered [New Connection] already exists.
    Push Button    OK

    Select Dialog     Database Conversion
    Insert Into Text Field    5    [migrated] New Connection 1

    Push Button    nextButton

    # step 4 (Restore metadata)
    Sleep    5s
    Close Dialog    Error message
    Push Button    nextButton
    
    # step 5 (Restore table data)
    Select Dialog    Warning
    Label Text Should Be    0    Unable to proceed to next step, metadata not restored.
    Label Text Should Be    1    Try again?
    Push Button    Yes
    Close Dialog    Error message
    Select Dialog    Database Conversion
    List Components In Context
    Push Button    cancelButton
    
    Select Dialog    Confirmation
    Label Text Should Be    0    Database migration is not complete. Are you sure you want to abort the process?
    Check Check Box    dropDbCheck
    Push Button    Yes
    
    Select Main Window
    Tree Node Should Not Exist    0    [migrated] New Connection 1

*** Keywords ***
Suite Setup
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    Skip If    ${{$ver == '2.6'}}
    ${system}=    platform.System
    ${path_to_interclient}=    Set Variable If    '${system}' == 'Linux'    /opt/interbase/lib/interclient.jar     C:\\Program Files\\Embarcadero\\InterBase\\SDK\\lib\\interclient.jar 
    
    Backup Drivers
    ${path_to_exe}=    Get Path
    Start Application    rdb_expert    ${path_to_exe}    timeout=20    remote_port=60900
    Select Main Window
    
    Select From Main Menu    System|Drivers
    Push Button    addDriverButton
    Select Dialog    Add New Driver
    Clear Text Field    nameField
    Type Into Text Field    nameField    InterDriver
    Select From Combo Box    databaseNameCombo    InterBase
    Select From Combo Box    driverUrlCombo    jdbc:interbase://[host]:[port]/[source]
    Push Button    browseButton
    Select Dialog    Select JDBC Drivers...
    ${path_to_lib}=    Get Path To Lib 
    Clear Text Field    0
    Type Into Text Field    0    ${path_to_interclient}
    Push Button    Select
    Select Dialog    Add New Driver
    Sleep    2s
    ${classvalues}=    Get Combobox Values    classField
    Should Be Equal As Strings    ${classvalues}    ['interbase.interclient.Driver']
    Push Button    Save
    Select Main Window

    System Exit    0

Suite Teardown
    Restore Drivers

Test
    [Arguments]    ${path_to_interbase_db}    ${interbase_db}
    Push Button    new-connection-command

    Init connect    InterDriver    5051    ${path_to_interbase_db}/${interbase_db}
    Select From Combo Box    charsetsCombo    WIN1251
    Select From Combo Box    serverCombo    Other   
    Check Check Box    Store Password

    Push Button    connectButton
    Sleep    1s
    # Select From Main Menu     Database|Convert Database
    Select From Tree Node Popup Menu In Separate Thread    0    New Connection 1    Migrate to Red Database

    Select Dialog    Database Conversion
    Select From Combo Box    connectionCombo    New Connection 1
    Push Button    nextButton

    # step 2 (Extract metadata)
    Sleep    5s    
    Push Button    nextButton
    # step 3 (Create database)
    
    Insert Into Text Field    0    ${TEMPDIR}/mirgated_db.fdb
    Insert Into Text Field    2    3050
    Insert Into Text Field    3    SYSDBA
    Insert Into Text Field    4    masterkey

    Remove File    ${TEMPDIR}/mirgated_db.fdb
    
    Check Check Box    registerCheck
    ${connection_name}=    Get Text Field Value    connectionName
    Should Contain    ${connection_name}    migrated
    Push Button    nextButton
    
    # step 4 (Restore metadata)
    Sleep    5s
    IF    '${TEST_NAME}' == 'test_migrate_malahit'
        Push Button    nextButton
        Select Dialog    Warning
        Label Text Should Be    0    Restoring database objects, please wait.
        Push Button    OK
        Select Dialog    Database Conversion
        Sleep    10s
    END
    
    Push Button    nextButton
    
    # step 5 (Restore table data)
    Sleep    5s
    Push Button    nextButton
    
    # step 6 (Enable constraints)
    Sleep    5s
    Push Button    finishButton
    
    Select Main Window
    Tree Node Should Not Be Leaf    0    [migrated] New Connection 1
    
    Expand Tree Node    0    New Connection 1
    Expand Tree Node    0    [migrated] New Connection 1
    
Init connect
    [Arguments]    ${driver}    ${port}    ${db}
    Clear Text Field    portField
    Type Into Text Field    portField    ${port}
    Clear Text Field    fileField
    Type Into Text Field    fileField    ${db}
    Select From Combo Box    driverCombo    ${driver}
    Type Into Text Field    userField    sysdba
    Type Into Text Field    passwordField    masterkey   
    Check Check Box    Store Password
