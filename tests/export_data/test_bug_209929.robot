*** Settings ***
# See https://tracker.red-soft.ru/issues/209929
Library    RemoteSwingLibrary
Library    OperatingSystem
Resource    ../../files/keywords.resource
Resource    key.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_couldnot_create_folder
    VAR    ${blob_path}    ${TEMPDIR}/blobls
    VAR    ${export_path}    ${TEMPDIR}/export.csv
    Remove Files    ${blob_path}    ${export_path}
    Create File    ${blob_path}
    Init
    Clear Text Field    filePathField
    Type Into Text Field    filePathField    ${export_path}

    Clear Text Field    folderPathField
    Type Into Text Field    folderPathField    ${blob_path}

    Check Check Box    saveBlobsIndividuallyCheck
    Push Button    exportButton

    Select Dialog    Warning
    Label Text Should Be    0    Could not create directory for exported BLOBs
    Push Button    OK
    Remove File    ${blob_path}

test_export_in_existing_folder
    VAR    ${blob_path}    ${TEMPDIR}${/}blobls_folder
    VAR    ${export_path}    ${TEMPDIR}${/}export.csv

    VAR    ${blob_path1}=     ${blob_path}${/}PROJ_DESC_0.txt
    VAR    ${blob_path2}=     ${blob_path}${/}PROJ_DESC_1.txt
    VAR    ${blob_path3}=     ${blob_path}${/}PROJ_DESC_2.txt
    Remove File    ${export_path}
    Remove Directory    ${blob_path}    ${True}
    Init
    Clear Text Field    filePathField
    Type Into Text Field    filePathField    ${export_path}

    Clear Text Field    folderPathField
    Type Into Text Field    folderPathField    ${blob_path}

    Check Check Box    saveBlobsIndividuallyCheck
    Push Button    exportButton
    
    Sleep    5s
    Close Dialog    Message

    ${content1}=    Get File    ${blob_path1}
    ${content2}=    Get File    ${blob_path2}
    ${content3}=    Get File    ${blob_path3}

    Should Be Equal As Strings    ${content1}    Design a video data base management system for controlling on-demand video distribution.    strip_spaces=${True}    collapse_spaces=${True}
    Should Be Equal As Strings    ${content2}    Develop second generation digital pizza maker with flash-bake heating element and digital ingredient measuring system.    strip_spaces=${True}    collapse_spaces=${True}
    Should Be Equal As Strings    ${content3}    Develop a prototype for the automobile version of the hand-held map browsing device.    strip_spaces=${True}    collapse_spaces=${True}
    

    Select Main Window
    Clear Table Selection    0
    Select Table Cell Area    0    1    2    3    4    
    Select From Table Cell Popup Menu On Selected Cells    0    Export|Selection
    
    Select Dialog    Export Data
    Push Button    exportButton
    Select Dialog    Confirmation
    Push Button    Yes
    Select Dialog    Confirmation
    Label Text Should Be    0    Specified BLOBs folder is not empty, some files may be overridden.
    Label Text Should Be    1    Continue anyway?
    Push Button    Yes
    Sleep   5s
    Close Dialog    Message

    ${content1}=    Get File    ${blob_path1}
    ${content2}=    Get File    ${blob_path2}
    ${content3}=    Get File    ${blob_path3}
    Should Be Equal As Strings    ${content1}    Port the map browsing database software to run on the automobile model.    strip_spaces=${True}    collapse_spaces=${True}
    Should Be Equal As Strings    ${content2}    Integrate the hand-writing recognition module into the universal language translator.    strip_spaces=${True}    collapse_spaces=${True}
    Should Be Equal As Strings    ${content3}    Develop a prototype for the automobile version of the hand-held map browsing device.    strip_spaces=${True}    collapse_spaces=${True}

    Remove File    ${export_path}
    Remove Directory    ${blob_path}    ${True}

*** Keywords ***
Init
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    IF   ${{$ver == '2.6'}}
        Lock Employee
        Set blobs
    END
    Open connection
    Clear Text Field    0
    Insert Into Text Field    0    select * from PROJECT
    Push Button    execute-script-command
    Sleep    1s
    Select Table Cell Area    0    1    2    0    2    
    Select From Table Cell Popup Menu On Selected Cells    0    Export|Selection
    Select Dialog    Export Data