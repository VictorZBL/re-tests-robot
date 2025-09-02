*** Settings ***
Library    RemoteSwingLibrary
Library    OperatingSystem
Resource    ../../files/keywords.resource
Resource    key.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_CSV_export_to_folder
    Init    
    Select From Combo Box    typeCombo    CSV
    ${export_path}=     Catenate    SEPARATOR=    ${TEMPDIR}    ${/}export.csv
    ${export_blob}=     Catenate    SEPARATOR=    ${TEMPDIR}    ${/}export_blob
    Remove Files    ${export_path}
    Remove Directory    ${export_blob}    ${True}

    Clear Text Field    filePathField
    Type Into Text Field    filePathField    ${export_path}

    Clear Text Field    folderPathField
    Type Into Text Field    folderPathField    ${export_blob}

    Check Check Box    saveBlobsIndividuallyCheck
    
    ${blob_path1}    ${blob_path2}    ${blob_path3}=    Check blobs in folder    ${export_blob}

    ${expected_content}=    Catenate    SEPARATOR=\n    Video Database;${blob_path1}    DigiPizza;${blob_path2}    AutoMap;${blob_path3}    ${EMPTY}
    File Should Exist    ${export_path}
    ${content}=    Get File    ${export_path}
    Should Be Equal As Strings    ${content}    ${expected_content}

test_XML_export_to_folder
    Init
    Select From Combo Box    typeCombo    XML
    ${export_path}=     Catenate    SEPARATOR=    ${TEMPDIR}    ${/}export.xml
    ${export_blob}=     Catenate    SEPARATOR=    ${TEMPDIR}    ${/}export_blob
    Remove Files    ${export_path}
    Remove Directory    ${export_blob}    ${True}
    Clear Text Field    filePathField
    Type Into Text Field    filePathField    ${export_path}

    Clear Text Field    folderPathField
    Type Into Text Field    folderPathField    ${export_blob}
    Check Check Box    saveBlobsIndividuallyCheck
    
    ${blob_path1}    ${blob_path2}    ${blob_path3}=    Check blobs in folder    ${export_blob}

    VAR    ${expected_content}    <?xml version="1.0" encoding="UTF-8" standalone="no"?> <result-set> <data> <row number="1"> <PROJ_NAME><![CDATA[Video Database]]></PROJ_NAME> <PROJ_DESC>${blob_path1}</PROJ_DESC> </row> <row number="2"> <PROJ_NAME><![CDATA[DigiPizza]]></PROJ_NAME> <PROJ_DESC>${blob_path2}</PROJ_DESC> </row> <row number="3"> <PROJ_NAME><![CDATA[AutoMap]]></PROJ_NAME> <PROJ_DESC>${blob_path3}</PROJ_DESC> </row> </data> </result-set>
    File Should Exist    ${export_path}
    ${content}=    Get File    ${export_path}
    Should Be Equal As Strings    ${content}    ${expected_content}    strip_spaces=${True}    collapse_spaces=${True}

test_XLSX_export_to_folder
    Init
    Select From Combo Box    typeCombo    XLSX
    ${export_path}=     Catenate    SEPARATOR=    ${TEMPDIR}    ${/}export.xlsx
    ${export_blob}=     Catenate    SEPARATOR=    ${TEMPDIR}    ${/}export_blob
    Remove Files    ${export_path}
    Remove Directory    ${export_blob}    ${True}
    Clear Text Field    filePathField
    Type Into Text Field    filePathField    ${export_path}

    Clear Text Field    folderPathField
    Type Into Text Field    folderPathField    ${export_blob}
    Check Check Box    saveBlobsIndividuallyCheck
    Check Check Box    addColumnHeadersCheck
    
    ${blob_path1}    ${blob_path2}    ${blob_path3}=    Check blobs in folder    ${export_blob}

    VAR    ${expected_content}    PROJ_NAME PROJ_DESC Video Database ${blob_path1} DigiPizza ${blob_path2} AutoMap ${blob_path3}
    File Should Exist    ${export_path}
    ${content}=    Check Xlsx    ${export_path}
    Should Be Equal As Strings    ${content}    ${expected_content}    strip_spaces=${True}    collapse_spaces=${True}

test_SQL_export_to_folder
    Init
    Select From Combo Box    typeCombo    SQL
    ${export_path}=     Catenate    SEPARATOR=    ${TEMPDIR}    ${/}export.sql
    ${export_blob}=     Catenate    SEPARATOR=    ${TEMPDIR}    ${/}export_blob
    Remove Files    ${export_path}
    Remove Directory    ${export_blob}    ${True}
    Clear Text Field    filePathField
    Type Into Text Field    filePathField    ${export_path}

    Clear Text Field    folderPathField
    Type Into Text Field    folderPathField    ${export_blob}
    Check Check Box    saveBlobsIndividuallyCheck

    Check Check Box    addCreateTableStatementCheck
    Clear Text Field    exportTableNameField
    Type Into Text Field    exportTableNameField    TEST_TABLE
    
    ${blob_path1}    ${blob_path2}    ${blob_path3}=    Check blobs in folder    ${export_blob}

    VAR    ${expected_content}    -- table creating -- CREATE TABLE TEST_TABLE ( PROJ_NAME BLOB SUB_TYPE TEXT, PROJ_DESC BLOB SUB_TYPE TEXT ); -- inserting data -- INSERT INTO TEST_TABLE ( PROJ_NAME, PROJ_DESC ) VALUES ( 'Video Database', ?'${blob_path1}' ); INSERT INTO TEST_TABLE ( PROJ_NAME, PROJ_DESC ) VALUES ( 'DigiPizza', ?'${blob_path2}' ); INSERT INTO TEST_TABLE ( PROJ_NAME, PROJ_DESC ) VALUES ( 'AutoMap', ?'${blob_path3}' );    
    File Should Exist    ${export_path}
    ${content}=    Get File    ${export_path}
    Should Be Equal As Strings    ${content}    ${expected_content}    strip_spaces=${True}    collapse_spaces=${True}


test_CSV_export_to_file
    Init
    Select From Combo Box    typeCombo    CSV
    ${export_path}=     Catenate    SEPARATOR=    ${TEMPDIR}    ${/}export.csv
    ${export_blob}=     Catenate    SEPARATOR=    ${TEMPDIR}    ${/}export_blob.txt
    Remove Files    ${export_path}    ${export_blob}
    Clear Text Field    filePathField
    Type Into Text Field    filePathField    ${export_path}

    Clear Text Field    folderPathField
    Type Into Text Field    folderPathField    ${export_blob}
    Push Button    exportButton
    Sleep    5s
    Close Dialog    Message
    ${expected_content}=    Catenate    SEPARATOR=\n    Video Database;:h00000000_00000059    DigiPizza;:h00000059_00000077    AutoMap;:h000000d0_00000055    ${EMPTY}
    File Should Exist    ${export_path}
    ${content}=    Get File    ${export_path}
    Should Be Equal As Strings    ${content}    ${expected_content}
    
    Check blobs in file    ${export_blob}

test_XML_export_to_file
    Init
    Select From Combo Box    typeCombo    XML
    ${export_path}=     Catenate    SEPARATOR=    ${TEMPDIR}    ${/}export.xml
    ${export_blob}=     Catenate    SEPARATOR=    ${TEMPDIR}    ${/}export_blob.txt
    Remove Files    ${export_path}    ${export_blob}
    Clear Text Field    filePathField
    Type Into Text Field    filePathField    ${export_path}

    Clear Text Field    folderPathField
    Type Into Text Field    folderPathField    ${export_blob}
    Push Button    exportButton
    Sleep    5s
    Close Dialog    Message
    VAR    ${expected_content}    <?xml version="1.0" encoding="UTF-8" standalone="no"?> <result-set> <data> <row number="1"> <PROJ_NAME><![CDATA[Video Database]]></PROJ_NAME> <PROJ_DESC>:h00000000_00000059</PROJ_DESC> </row> <row number="2"> <PROJ_NAME><![CDATA[DigiPizza]]></PROJ_NAME> <PROJ_DESC>:h00000059_00000077</PROJ_DESC> </row> <row number="3"> <PROJ_NAME><![CDATA[AutoMap]]></PROJ_NAME> <PROJ_DESC>:h000000d0_00000055</PROJ_DESC> </row> </data> </result-set>
    File Should Exist    ${export_path}
    ${content}=    Get File    ${export_path}
    Should Be Equal As Strings    ${content}    ${expected_content}    strip_spaces=${True}    collapse_spaces=${True}

    Check blobs in file    ${export_blob}

test_XLSX_export_to_file
    Init
    Select From Combo Box    typeCombo    XLSX
    ${export_path}=     Catenate    SEPARATOR=    ${TEMPDIR}    ${/}export.xlsx
    ${export_blob}=     Catenate    SEPARATOR=    ${TEMPDIR}    ${/}export_blob.txt
    Remove Files    ${export_path}    ${export_blob}
    Clear Text Field    filePathField
    Type Into Text Field    filePathField    ${export_path}

    Clear Text Field    folderPathField
    Type Into Text Field    folderPathField    ${export_blob}

    Push Button    exportButton
    Sleep    5s
    Close Dialog    Message
    VAR    ${expected_content}    None None Video Database :h00000000_00000059 DigiPizza :h00000059_00000077 AutoMap :h000000d0_00000055
    File Should Exist    ${export_path}
    ${content}=    Check Xlsx    ${export_path}
    Should Be Equal As Strings    ${content}    ${expected_content}    strip_spaces=${True}    collapse_spaces=${True}

    Check blobs in file    ${export_blob}

test_SQL_export_to_file
    Init
    Select From Combo Box    typeCombo    SQL
    ${export_path}=     Catenate    SEPARATOR=    ${TEMPDIR}    ${/}export.sql
    ${export_blob}=     Catenate    SEPARATOR=    ${TEMPDIR}    ${/}export_blob.txt
    Remove Files    ${export_path}    ${export_blob}
    Clear Text Field    filePathField
    Type Into Text Field    filePathField    ${export_path}

    Clear Text Field    folderPathField
    Type Into Text Field    folderPathField    ${export_blob}

    Check Check Box    addCreateTableStatementCheck
    Clear Text Field    exportTableNameField
    Type Into Text Field    exportTableNameField    TEST_TABLE

    Push Button    exportButton
    Sleep    5s
    Close Dialog    Message
    VAR    ${expected_content}    -- table creating -- CREATE TABLE TEST_TABLE ( PROJ_NAME BLOB SUB_TYPE TEXT, PROJ_DESC BLOB SUB_TYPE TEXT ); -- inserting data -- SET BLOBFILE '${export_blob}'; INSERT INTO TEST_TABLE ( PROJ_NAME, PROJ_DESC ) VALUES ( 'Video Database', :h00000000_00000059 ); INSERT INTO TEST_TABLE ( PROJ_NAME, PROJ_DESC ) VALUES ( 'DigiPizza', :h00000059_00000077 ); INSERT INTO TEST_TABLE ( PROJ_NAME, PROJ_DESC ) VALUES ( 'AutoMap', :h000000d0_00000055 );
    File Should Exist    ${export_path}
    ${content}=    Get File    ${export_path}
    Should Be Equal As Strings    ${content}    ${expected_content}     strip_spaces=${True}    collapse_spaces=${True}

    Check blobs in file    ${export_blob}

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
    RETURN    ${ver}


Check blobs in folder
    [Arguments]       ${export_blob}
    Push Button    exportButton
    Sleep    5s
    Close Dialog    Message
    Directory Should Exist    ${export_blob}
    Directory Should Not Be Empty    ${export_blob}
    ${blob_path1}=     Catenate    SEPARATOR=    ${export_blob}    ${/}PROJ_DESC_0.txt
    ${blob_path2}=     Catenate    SEPARATOR=    ${export_blob}    ${/}PROJ_DESC_1.txt
    ${blob_path3}=     Catenate    SEPARATOR=    ${export_blob}    ${/}PROJ_DESC_2.txt
    
    ${content1}=    Get File    ${blob_path1}
    ${content2}=    Get File    ${blob_path2}
    ${content3}=    Get File    ${blob_path3}

    Should Be Equal As Strings    ${content1}    Design a video data base management system for controlling on-demand video distribution.    strip_spaces=${True}    collapse_spaces=${True}
    Should Be Equal As Strings    ${content2}    Develop second generation digital pizza maker with flash-bake heating element and digital ingredient measuring system.    strip_spaces=${True}    collapse_spaces=${True}
    Should Be Equal As Strings    ${content3}    Develop a prototype for the automobile version of the hand-held map browsing device.    strip_spaces=${True}    collapse_spaces=${True}
    
    RETURN    ${blob_path1}    ${blob_path2}    ${blob_path3}

Check blobs in file
    [Arguments]    ${export_blob}
    ${expected_content}=    Catenate    SEPARATOR=\n    Design a video data base management system for    controlling on-demand video distribution.    Develop second generation digital pizza maker    with flash-bake heating element and    digital ingredient measuring system.    Develop a prototype for the automobile version of    the hand-held map browsing device.    ${EMPTY}
    File Should Exist    ${export_blob}
    ${content}=    Get File    ${export_blob}
    Should Be Equal As Strings    ${content}    ${expected_content}
