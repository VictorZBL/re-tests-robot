*** Settings ***
Library    RemoteSwingLibrary
Library    OperatingSystem
Library    Collections
Resource    ../../files/keywords.resource
Resource    keys.resource
Test Setup       Setup
Test Teardown    Teardown

*** Test Cases ***
test_check_database_properties
    Init Build
    FOR    ${dbms}    IN    Firebird 2.5    Firebird 3.0    Firebird 4.0    Firebird 5.0    RedDatabase 2.6    RedDatabase 3.0    RedDatabase 5.0
        Select From Combo Box    0    ${dbms}
        Check Database Properties    ${dbms}
        Check Services Properties    ${dbms}
    END

test_save_to_file_1
    Init Build
    Select From Combo Box    0    RedDatabase 5.0
    Select Tab As Context   database
    Check All Checkboxes
    Uncheck Check Box    autoReplaceCheckBox
    Uncheck Check Box    log_trigger_finish
    Uncheck Check Box    log_context
    Uncheck Check Box    log_errors
    Uncheck Check Box    log_warnings
    Uncheck Check Box    print_plan
    Uncheck Check Box    print_perf
    Uncheck Check Box    log_blr_requests
    Uncheck Check Box    print_blr
    Uncheck Check Box    log_dyn_requests
    Uncheck Check Box    print_dyn
    Uncheck Check Box    log_privilege_changes
    Uncheck Check Box    log_changes_only
    Uncheck Check Box    log_procedure_compile
    Type Into Text Field    textFieldinclude_user_filter    ship
    Type Into Text Field    textFieldexclude_user_filter   819
    Type Into Text Field    textFieldinclude_process_filter    14
    Type Into Text Field    textFieldexclude_process_filter    true
    Type Into Text Field    textFieldinclude_gds_codes    512
    
    Clear Text Field    numberTextFieldmax_sql_length
    Type Into Text Field    numberTextFieldmax_sql_length    4096
    Clear Text Field    numberTextFieldmax_blr_length
    Type Into Text Field    numberTextFieldmax_blr_length    8192
    
    ${conf_path}=    Finish Build
    Check Build Config   ${conf_path}    0
    
test_save_to_file_2
    Init Build
    Select From Combo Box    0    RedDatabase 5.0
    Select Tab As Context   database
    Check All Checkboxes
    Uncheck Check Box    autoReplaceCheckBox
    Uncheck Check Box    log_security_incidents
    Uncheck Check Box    log_initfini
    Uncheck Check Box    log_connections
    Uncheck Check Box    log_transactions
    Uncheck Check Box    log_statement_prepare
    Uncheck Check Box    log_statement_free
    Uncheck Check Box    log_statement_start
    Uncheck Check Box    log_statement_finish
    Uncheck Check Box    log_procedure_start
    Uncheck Check Box    log_procedure_finish
    Uncheck Check Box    log_function_start
    Uncheck Check Box    log_function_finish
    Uncheck Check Box    log_trigger_start
    Uncheck Check Box    log_trigger_compile
    Type Into Text Field    textFieldinclude_filter    ship
    Type Into Text Field    textFieldexclude_filter    819
    Type Into Text Field    textFieldexclude_gds_codes    512
    
    Clear Text Field    numberTextFieldconnection_id
    Type Into Text Field    numberTextFieldconnection_id     14
    Clear Text Field    numberTextFieldmax_dyn_length
    Type Into Text Field    numberTextFieldmax_dyn_length     1024
    Clear Text Field    numberTextFieldmax_arg_length
    Type Into Text Field    numberTextFieldmax_arg_length     2048
    Clear Text Field    numberTextFieldmax_arg_count
    Type Into Text Field    numberTextFieldmax_arg_count    4096

    ${conf_path}=    Finish Build
    Check Build Config   ${conf_path}    1

test_service_to_file
    Init Build
    Select From Combo Box    0    RedDatabase 5.0
    Select Tab As Context  services
    Check All Checkboxes

    Type Into Text Field    textFieldinclude_filter    ship
    Type Into Text Field    textFieldexclude_filter    819
    Type Into Text Field    textFieldinclude_user_filter    ship
    Type Into Text Field    textFieldexclude_user_filter   819
    Type Into Text Field    textFieldinclude_process_filter    14
    Type Into Text Field    textFieldexclude_process_filter    true
    Type Into Text Field    textFieldinclude_gds_codes    512
    Type Into Text Field    textFieldexclude_gds_codes    512

    ${conf_path}=    Finish Build
    ${conf_context}=    Get File    ${conf_path}
    Should Be Equal As Strings    ${conf_context}    services { log_errors = true include_filter = ship cancel_on_error = true include_user_filter = ship include_process_filter = 14 exclude_filter = 819 log_service_query = true enabled = true log_warnings = true exclude_process_filter = true include_gds_codes = 512 exclude_gds_codes = 512 exclude_user_filter = 819 log_services = true log_initfini = true } database { enabled = true }    strip_spaces=${True}    collapse_spaces=${True}
    
    # load from file
    Push Button    doubleConfigButton
    Sleep    2s
    Select Dialog    Configuration
    Push Button    loadFromFileButton
    Sleep    1s
    Select Dialog    Open
    Type Into Text Field    0    ${conf_path}
    Push Button    Open

    Select Dialog    Configuration
    Select Tab As Context    services

    Check Box Should Be Checked    checkBoxlog_initfini
    Check Box Should Be Checked    checkBoxlog_errors
    Check Box Should Be Checked    checkBoxcancel_on_error
    Check Box Should Be Checked    checkBoxlog_warnings
    Check Box Should Be Checked    checkBoxenabled
    Check Box Should Be Checked    checkBoxlog_services
    Check Box Should Be Checked    checkBoxlog_service_query
    
    VAR    @{list_of_name_filed}    textFieldinclude_user_filter    textFieldexclude_user_filter    textFieldinclude_process_filter    textFieldinclude_process_filter    textFieldexclude_process_filter    textFieldinclude_filter    textFieldexclude_filter    textFieldinclude_gds_codes    textFieldexclude_gds_codes

    ${values}=    Check Text Values    @{list_of_name_filed}
    Should Be Equal As Strings    ${values}    ['ship', '819', '14', '14', 'true', 'ship', '819', '512', '512']

test_save_multiple_database
    Init Build
    Select Tab As Context    database
    Insert Into Text Field    nameField    employee.fdb

    Select Main Window
    Select Dialog    Configuration
    Click On Component    newTabButton
    Click On Component    closeTabButton
    
    Click On Component    newTabButton
    Select Tab As Context   database
    Type Into Text Field    nameField    employee2.fdb
    Select Main Window
    Select Dialog    Configuration

    ${conf_path}=    Finish Build
    ${conf_context}=    Get File    ${conf_path}
    Should Be Equal As Strings    ${conf_context}    services { } database = employee.fdb { enabled = true } database = employee2.fdb { enabled = true }    strip_spaces=${True}    collapse_spaces=${True}

test_load_from_profile
    Init Build
    Type Into Text Field    nameField    NEW_CONFIG

    Check Check Box    checkBoxlog_warnings    
    Check Check Box    checkBoxlog_connections
    Check Check Box    checkBoxlog_statement_prepare
    Check Check Box    checkBoxlog_procedure_finish
    Select Tab As Context    database
    Type Into Text Field    textFieldinclude_filter    true
    Type Into Text Field    textFieldexclude_filter    path
    
    Select Dialog    Configuration
    Push Button    saveButton
    Select Main Window
    # Select From Combo Box    profileSelector    NEW_CONFIG
    Push Button    editConfigButton

    Select Dialog    Configuration
    ${name}=    Get Text Field Value    nameField
    Should Be Equal As Strings    ${name}    NEW_CONFIG

    Push Button    loadFromOtherProfile
    Select Dialog    Load Profile
    Select From Combo Box    0    default
    
    Push Button    OK

    Select Dialog    Configuration
    Select Tab As Context    database
    Check Box Should Be Checked    checkBoxenabled
    Check Box Should Be Checked    checkBoxlog_statement_finish

    Check Box Should Be Unchecked    checkBoxlog_warnings    
    Check Box Should Be Unchecked    checkBoxlog_connections
    Check Box Should Be Unchecked    checkBoxlog_statement_prepare
    Check Box Should Be Unchecked    checkBoxlog_procedure_finish
    
    VAR    @{list_of_name_filed}    textFieldinclude_filter    textFieldexclude_filter

    ${values}=    Check Text Values    @{list_of_name_filed}
    Should Be Equal As Strings    ${values}    ['', '']
    
    Select Dialog    Configuration
    Push Button    cancelButton
    Select Main Window
    Push Button    deleteConfigButton
    Select Dialog    Confirmation
    Push Button    Yes
    Select Main Window

test_incorect_name
    Init Build
    Check Incorrect Name
    Type Into Text Field    nameField    default
    Check Incorrect Name
    Close Dialog    Configuration

*** Keywords ***
Check Incorrect Name
    Push Button    saveButton
    Select Dialog    Error message
    Label Text Should Be    0    Incorrect name configuration!
    Push Button    OK

    Select Dialog    Configuration

Check Text Values
    [Arguments]    @{list_of_name_filed}
    VAR    @{values}
    FOR    ${par}    IN    @{list_of_name_filed}
        ${value}=    Get Text Field Value    ${par}
        Append To List    ${values}    ${value}
    END
    RETURN    ${values}

Init Build
    Open connection
    Select From Main Menu    Tools|Trace Manager
    Sleep    5s
    # Select From Combo Box    profileSelector    default
    # Push Button    doubleConfigButton
    # Push Button    7
    Run Keyword In Separate Thread    Select From Combo Box    profileSelector    Create
    Sleep    5s
    Select Dialog    Configuration

Finish Build
    VAR    ${conf_path}    ${TEMPDIR}/test_conf.conf      
    Select Dialog    Configuration
    Push Button    saveFileButton
    Select Dialog    Save
    Type Into Text Field    0    ${conf_path}
    IF    '${TEST_NAME}' != 'test_save_to_file_2'
        Remove File    ${conf_path}
        Push Button    Save
    ELSE
        Push Button    Save
        Select Dialog    Confirmation
        Push Button    Yes
    END
    Select Dialog    Message
    Push Button    OK
    Close Dialog    Configuration
    Select Main Window
    RETURN    ${conf_path}

Check Database Properties
    [Arguments]    ${dbms_version}
    Select Tab    database
    IF    '${dbms_version}' == 'Firebird 2.5'
        Check FB2.5
    ELSE IF    '${dbms_version}' == 'Firebird 3.0' or '${dbms_version}' == 'Firebird 4.0'
        Check FB3.0
    ELSE IF    '${dbms_version}' == 'Firebird 5.0'
        Check FB5.0
    ELSE IF    '${dbms_version}' == 'RedDatabase 2.6'
        Check RDB2.6
    ELSE IF    '${dbms_version}' == 'RedDatabase 3.0' or '${dbms_version}' == 'RedDatabase 5.0'
        Check Services RDB3.0
    END

Check Common Prop
    Check Box Should Be Enabled    checkBoxlog_warnings    
    Check Box Should Be Enabled    checkBoxenabled
    Check Box Should Be Enabled    checkBoxlog_connections
    Check Box Should Be Enabled    checkBoxlog_transactions
    Check Box Should Be Enabled    checkBoxlog_statement_prepare
    Check Box Should Be Enabled    checkBoxlog_statement_free
    Check Box Should Be Enabled    checkBoxlog_statement_start
    Check Box Should Be Enabled    checkBoxlog_statement_finish
    Check Box Should Be Enabled    checkBoxlog_procedure_start
    Check Box Should Be Enabled    checkBoxlog_procedure_finish
    Check Box Should Be Enabled    checkBoxlog_trigger_start
    Check Box Should Be Enabled    checkBoxlog_trigger_finish
    Check Box Should Be Enabled    checkBoxprint_plan
    Check Box Should Be Enabled    checkBoxprint_perf
    Check Box Should Be Enabled    checkBoxlog_context
    Check Box Should Be Enabled    checkBoxlog_blr_requests
    Check Box Should Be Enabled    checkBoxprint_blr
    Check Box Should Be Enabled    checkBoxlog_dyn_requests
    Check Box Should Be Enabled    checkBoxprint_dyn

    Text Field Should Be Enabled    textFieldinclude_filter
    Text Field Should Be Enabled    textFieldexclude_filter

    Text Field Should Be Enabled    numberTextFieldconnection_id
    Text Field Should Be Enabled    numberTextFieldmax_sql_length
    Text Field Should Be Enabled    numberTextFieldmax_blr_length
    Text Field Should Be Enabled    numberTextFieldmax_dyn_length
    Text Field Should Be Enabled    numberTextFieldmax_arg_length
    Text Field Should Be Enabled    numberTextFieldmax_arg_count
    Text Field Should Be Enabled    numberTextFieldtime_threshold

Check FB2.5
    Check Common Prop
    Check Box Should Be Enabled    checkBoxlog_errors
    Check Box Should Be Enabled    checkBoxlog_initfini
    Check Box Should Be Enabled    checkBoxlog_sweep

Check FB3.0
    Check FB2.5
    Check Box Should Be Enabled    checkBoxlog_function_start
    Check Box Should Be Enabled    checkBoxlog_function_finish
    Check Box Should Be Enabled    checkBoxexplain_plan

    Text Field Should Be Enabled    textFieldinclude_gds_codes
    Text Field Should Be Enabled    textFieldexclude_gds_codes

Check FB5.0
    Check FB3.0
    Check Box Should Be Enabled    checkBoxlog_procedure_compile
    Check Box Should Be Enabled    checkBoxlog_function_compile
    Check Box Should Be Enabled    checkBoxlog_trigger_compile

Check filters RDB
    Text Field Should Be Enabled    textFieldinclude_user_filter
    Text Field Should Be Enabled    textFieldexclude_user_filter
    Text Field Should Be Enabled    textFieldinclude_process_filter
    Text Field Should Be Enabled    textFieldexclude_process_filter

Check RDB2.6
    Check Common Prop
    Check Box Should Be Enabled    checkBoxlog_init
    Check Box Should Be Enabled    checkBoxlog_auth_factors
    Check Box Should Be Enabled    checkBoxprint_stack_trace
    Check Box Should Be Enabled    checkBoxlog_errors_only
    Check Box Should Be Enabled    checkBoxlog_changes_only
    Check Box Should Be Enabled    checkBoxlog_security_incidents
    Check Box Should Be Enabled    checkBoxlog_privilege_changes
    Check Box Should Be Enabled    checkBoxlog_mandatory_access
    Check Box Should Be Enabled    checkBoxlog_record_mandatory_access
    Check Box Should Be Enabled    checkBoxlog_object_relabeling
    Check Box Should Be Enabled    checkBoxlog_record_relabeling

    Check filters RDB

Check RDB3.0
    Check FB5.0
    Check Box Should Be Enabled    checkBoxcancel_on_error
    Check Box Should Be Enabled    checkBoxlog_changes_only
    Check Box Should Be Enabled    checkBoxlog_security_incidents
    Check Box Should Be Enabled    checkBoxlog_privilege_changes
    Check Box Should Be Enabled    checkBoxlog_security_level
    Check Box Should Be Enabled    checkBoxlog_security_type
    Check Box Should Be Enabled    checkBoxreset_counters

    Check filters RDB
    
Check RDB5.0
    Check RDB3.0
    Check Box Should Be Enabled    checkBoxlog_message
    Check Box Should Be Enabled    checkBoxprint_hostname
    Combo Box Should Be Enabled    comboBoxtime_format

Check Services Properties
    [Arguments]    ${dbms_version}
    Select Tab    services
    IF    '${dbms_version}' == 'Firebird 2.5'
        Check Services FB2.5
    ELSE IF    '${dbms_version}' == 'Firebird 3.0' or '${dbms_version}' == 'Firebird 4.0' or '${dbms_version}' == 'Firebird 5.0'
        Check Services FB3.0
    ELSE IF    '${dbms_version}' == 'RedDatabase 2.6'
        Check Services RDB2.6
    ELSE IF    '${dbms_version}' == 'RedDatabase 3.0' or '${dbms_version}' == 'RedDatabase 5.0'
        Check Services RDB3.0
    END

Check Common Services Prop
    Check Box Should Be Enabled    checkBoxlog_warnings
    Check Box Should Be Enabled    checkBoxenabled
    Check Box Should Be Enabled    checkBoxlog_services
    Check Box Should Be Enabled    checkBoxlog_service_query

    Text Field Should Be Enabled    textFieldinclude_filter
    Text Field Should Be Enabled    textFieldexclude_filter

Check Services FB2.5
    Check Common Services Prop
    Check Box Should Be Enabled    checkBoxlog_initfini
    Check Box Should Be Enabled    checkBoxlog_errors
    
Check Services FB3.0
    Check Services FB2.5
    Text Field Should Be Enabled    textFieldinclude_gds_codes
    Text Field Should Be Enabled    textFieldexclude_gds_codes

Check Services RDB2.6
    Check Common Services Prop
    Text Field Should Be Enabled    textFieldinclude_user_filter
    Text Field Should Be Enabled    textFieldexclude_user_filter
    Text Field Should Be Enabled    textFieldinclude_process_filter
    Text Field Should Be Enabled    textFieldexclude_process_filter

Check Services RDB3.0
    Check Services RDB2.6
    Check Box Should Be Enabled    checkBoxlog_initfini
    Check Box Should Be Enabled    checkBoxlog_errors
    Check Box Should Be Enabled    checkBoxcancel_on_error

    Text Field Should Be Enabled    textFieldinclude_gds_codes
    Text Field Should Be Enabled    textFieldexclude_gds_codes
