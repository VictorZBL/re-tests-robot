*** Settings ***
Library    RemoteSwingLibrary
Library    OperatingSystem
Resource    ../../files/keywords.resource
Resource    key.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_1
    Setup before export data
    ${export_path_csv}=     Catenate    SEPARATOR=    ${TEMPDIR}    ${/}export.csv
    ${export_path_xlsx}=    Catenate    SEPARATOR=    ${TEMPDIR}    ${/}export.xlsx
    ${export_path_xml}=     Catenate    SEPARATOR=    ${TEMPDIR}    ${/}export.xml
    ${export_path_sql}=     Catenate    SEPARATOR=    ${TEMPDIR}    ${/}export.sql
    
    Select From Combo Box    typeCombo    CSV
    Select Export File Path
    ${current_export_path}=    Get Text Field Value    filePathField
    Should Be Equal As Strings    ${current_export_path}    ${export_path_csv}    collapse_spaces=${True}    strip_spaces=${True}

    Select From Combo Box    typeCombo    XLSX
    Select Export File Path
    ${current_export_path}=    Get Text Field Value    filePathField
    Should Be Equal As Strings    ${current_export_path}    ${export_path_xlsx}    collapse_spaces=${True}    strip_spaces=${True}

    Select From Combo Box    typeCombo    XML
    Select Export File Path
    ${current_export_path}=    Get Text Field Value    filePathField
    Should Be Equal As Strings    ${current_export_path}    ${export_path_xml}    collapse_spaces=${True}    strip_spaces=${True}

    Select From Combo Box    typeCombo    SQL
    Select Export File Path
    ${current_export_path}=    Get Text Field Value    filePathField
    Should Be Equal As Strings    ${current_export_path}    ${export_path_sql}    collapse_spaces=${True}    strip_spaces=${True}

test_blob
    Open connection
    Clear Text Field    0
    Insert Into Text Field    0    select * from PROJECT
    Push Button    execute-script-command
    Sleep    1s
    Select Table Cell Area    0    1    2    0    2    
    Select From Table Cell Popup Menu On Selected Cells    0    Export|Selection
    Select Dialog    Export Data
    Select From Combo Box    typeCombo    CSV
    
    Clear Text Field    filePathField
    Type Into Text Field    filePathField    ${TEMPDIR}/export.csv

    Push Button    browseFolderButton   
    Select Dialog    Select Export File Path
    Clear Text Field    0
    Type Into Text Field    0    ${TEMPDIR}/export
    Push Button    Select
    Select Dialog    Export Data

    ${export_path_blob}=     Catenate    SEPARATOR=    ${TEMPDIR}    ${/}export.lob
    ${current_export_path}=    Get Text Field Value    folderPathField
    Should Be Equal As Strings    ${current_export_path}    ${export_path_blob}    collapse_spaces=${True}    strip_spaces=${True}


*** Keywords ***
Select Export File Path
    Clear Text Field    filePathField  
    Push Button    browseFileButton   
    Select Dialog    Select Export File Path
    Clear Text Field    0
    Type Into Text Field    0    ${TEMPDIR}/export
    Push Button    Select
    Select Dialog    Export Data
