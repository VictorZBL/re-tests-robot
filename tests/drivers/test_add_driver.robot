*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../files/keywords.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_empty_name
    Select From Main Menu    System|Drivers
    Push Button    addDriverButton
    Select Dialog    Add New Driver
    Clear Text Field    nameField
    Push Button    Save
    Select Main Window
    ${row}=    Find Table Row    driversTable    ${EMPTY}   Driver Name
    Click On Table Cell    driversTable     ${row}    Driver Name
    Push Button    removeDriverButton
    Select Dialog    Confirmation
    Push Button    Yes
    Select Main Window
    Should Not Be Equal As Integers    ${row}    -1 

test_check_combo
    Select From Main Menu    System|Drivers
    Push Button    addDriverButton
    Select Dialog    Add New Driver
    Type Into Text Field    descField    This is Description
    ${dbvalues}=    Get Combobox Values    databaseNameCombo
    Should Be Equal As Strings    ${dbvalues}    ['Red Database', 'Firebird', 'InterBase', 'Other']
    
    Select From Combo Box    databaseNameCombo    Other
    ${urlsvalues}=    Get Combobox Values    driverUrlCombo
    Should Be Equal As Strings    ${urlsvalues}    []
    
    Select From Combo Box    databaseNameCombo    Firebird
    ${urlsvalues}=    Get Combobox Values    driverUrlCombo
    Should Be Equal As Strings    ${urlsvalues}    ['jdbc:firebirdsql://[host]:[port]/[source]', 'jdbc:firebirdsql:[source]']

    Push Button    Save
    Select Main Window
    ${row}=    Find Table Row    driversTable    New Driver   Driver Name
    ${table_values}=    Get Table Row Values    driversTable    ${row}
    Should Be Equal As Strings    ${table_values}    ['New Driver', 'This is Description', 'Firebird', '']

    Click On Table Cell    driversTable     ${row}    Driver Name
    Push Button    removeDriverButton
    Select Dialog    Confirmation
    Push Button    Yes

test_check_library
    Select From Main Menu    System|Drivers
    Push Button    addDriverButton
    Select Dialog    Add New Driver
    Push Button    browseButton
    Select Dialog    Select JDBC Drivers...
    ${path_to_lib}=    Get Path To Lib 
    Clear Text Field    0
    Type Into Text Field    0    ${path_to_lib}/jaybird-5.jar
    Push Button    Select
    Select Dialog    Add New Driver
    Sleep    2s
    ${classvalues}=    Get Combobox Values    classField
    Should Be Equal As Strings    ${classvalues}    ['org.firebirdsql.jdbc.FBDriver']
    Push Button    Find
    Sleep    0.5s
    Select Dialog    Select JDBC Driver
    ${class_list}=    Get List Values    0    
    Should Be Equal As Strings    ${class_list}    ['org.firebirdsql.jdbc.FBDriver']
    Push Button    OK

    Select Dialog    Add New Driver
    Click On List Item    0    0
    Push Button    removeButton
    ${lib_list}=    Get List Values    0    
    Should Be Equal As Strings    ${lib_list}    []

    Select Dialog    Add New Driver
    Push Button    browseButton
    Select Dialog    Select JDBC Drivers...
    Clear Text Field    0
    Type Into Text Field    0    ${path_to_lib}/batik-dom-1.16.jar
    Push Button    Select
    
    Select Dialog    Add New Driver
    Push Button    Find
    Sleep    0.5s
    Select Dialog    Warning
    Label Text Should Be    0    No valid classes implementing java.sql.Driver were found in the specified
    Label Text Should Be    1    resource paths
    Push Button    OK    
    

test_connect_with_new_driver
    Select From Main Menu    System|Drivers
    Push Button    addDriverButton
    Select Dialog    Add New Driver
    Select From Combo Box    databaseNameCombo    Firebird
    Push Button    browseButton
    Select Dialog    Select JDBC Drivers...
    ${path_to_lib}=    Get Path To Lib 
    Clear Text Field    0
    Type Into Text Field    0    ${path_to_lib}/jaybird-5.jar
    Push Button    Select
    Sleep    10s
    Select Dialog    Add New Driver
    Push Button    Save
    
    Select Main Window
    Select From Tree Node Popup Menu    0    New Connection    Duplicate connection
    Sleep    2s
    Select From Combo Box    driverCombo    New Driver
    Push Button    Test
    Select Dialog    Message
    Label Text Should Be    0    The connection test was successful!
    Push Button    OK

    Teardown after every tests
    Setup before every tests
    Select From Main Menu    System|Drivers
    Sleep    1s
    ${row}=    Find Table Row    driversTable    New Driver   Driver Name
    Click On Table Cell    driversTable     ${row}    Driver Name
    Push Button    removeDriverButton
    Select Dialog    Confirmation
    Push Button    Yes

add_new_driver_with_same_name
    Select From Main Menu    System|Drivers
    Push Button    addDriverButton
    Select Dialog    Add New Driver
    Clear Text Field    nameField
    Type Into Text Field    nameField    Jaybird 3 Driver
    Push Button    Save
    Select Dialog    Error message
    Label Text Should Be    0    The driver name Jaybird 3 Driver already exists
    Push Button    OK
    Select Dialog    Add New Driver
    Push Button    Cancel