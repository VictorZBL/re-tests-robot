*** Settings ***
Library    RemoteSwingLibrary
Library    OperatingSystem
Library    Collections
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

    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    ${ser_ver}=    Set Variable    ${info}[2]
    @{blob_paths}=    Check blobs in folder    ${export_blob}

    IF  ${{$ser_ver == 'Firebird'}}
        ${expected_content}=    Catenate    SEPARATOR=\n    VBASE;Video Database;${blob_paths}[0];45;software    DGPII;DigiPizza;${blob_paths}[1];24;other    GUIDE;AutoMap;${blob_paths}[2];20;hardware    MAPDB;MapBrowser port;${blob_paths}[3];4;software    HWRII;Translator upgrade;${blob_paths}[4];;software    MKTPR;Marketing project 3;${blob_paths}[5];85;N/A    FCORE;Firebird engine;${blob_paths}[6];146;software    FBDOC;Documentation;${blob_paths}[7];;other    PYTHN;Python drivers;${blob_paths}[8];151;software    DTNET;.NET drivers;${blob_paths}[9];152;software    ODBCD;ODBC drivers;${blob_paths}[10];;software    PHPDR;PHP drivers;${blob_paths}[11];;software    JAVAD;Java drivers;${blob_paths}[12];153;software    FB-QA;Firebrid QA;${blob_paths}[13];150;software    INFRA;Infrastructure;${blob_paths}[14];;other    BTLER;Firebrid Butler;${blob_paths}[15];151;software    ${EMPTY}
    ELSE
        ${expected_content}=    Catenate    SEPARATOR=\n    VBASE;Video Database;${blob_paths}[0];45;software    DGPII;DigiPizza;${blob_paths}[1];24;other    GUIDE;AutoMap;${blob_paths}[2];20;hardware    MAPDB;MapBrowser port;${blob_paths}[3];4;software    HWRII;Translator upgrade;${blob_paths}[4];;software    MKTPR;Marketing project 3;${blob_paths}[5];85;N/A    ${EMPTY}
    END
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

    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    ${ser_ver}=    Set Variable    ${info}[2]
    @{blob_paths}=    Check blobs in folder    ${export_blob}

    IF  ${{$ser_ver == 'Firebird'}}
        VAR    ${expected_content}    <?xml version="1.0" encoding="UTF-8" standalone="no"?> <result-set> <data> <row number="1"> <PROJ_ID><![CDATA[VBASE]]></PROJ_ID> <PROJ_NAME><![CDATA[Video Database]]></PROJ_NAME> <PROJ_DESC>${blob_paths}[0]</PROJ_DESC> <TEAM_LEADER>45</TEAM_LEADER> <PRODUCT><![CDATA[software]]></PRODUCT> </row> <row number="2"> <PROJ_ID><![CDATA[DGPII]]></PROJ_ID> <PROJ_NAME><![CDATA[DigiPizza]]></PROJ_NAME> <PROJ_DESC>${blob_paths}[1]</PROJ_DESC> <TEAM_LEADER>24</TEAM_LEADER> <PRODUCT><![CDATA[other]]></PRODUCT> </row> <row number="3"> <PROJ_ID><![CDATA[GUIDE]]></PROJ_ID> <PROJ_NAME><![CDATA[AutoMap]]></PROJ_NAME> <PROJ_DESC>${blob_paths}[2]</PROJ_DESC> <TEAM_LEADER>20</TEAM_LEADER> <PRODUCT><![CDATA[hardware]]></PRODUCT> </row> <row number="4"> <PROJ_ID><![CDATA[MAPDB]]></PROJ_ID> <PROJ_NAME><![CDATA[MapBrowser port]]></PROJ_NAME> <PROJ_DESC>${blob_paths}[3]</PROJ_DESC> <TEAM_LEADER>4</TEAM_LEADER> <PRODUCT><![CDATA[software]]></PRODUCT> </row> <row number="5"> <PROJ_ID><![CDATA[HWRII]]></PROJ_ID> <PROJ_NAME><![CDATA[Translator upgrade]]></PROJ_NAME> <PROJ_DESC>${blob_paths}[4]</PROJ_DESC> <TEAM_LEADER/> <PRODUCT><![CDATA[software]]></PRODUCT> </row> <row number="6"> <PROJ_ID><![CDATA[MKTPR]]></PROJ_ID> <PROJ_NAME><![CDATA[Marketing project 3]]></PROJ_NAME> <PROJ_DESC>${blob_paths}[5]</PROJ_DESC> <TEAM_LEADER>85</TEAM_LEADER> <PRODUCT><![CDATA[N/A]]></PRODUCT> </row> <row number="7"> <PROJ_ID><![CDATA[FCORE]]></PROJ_ID> <PROJ_NAME><![CDATA[Firebird engine]]></PROJ_NAME> <PROJ_DESC>${blob_paths}[6]</PROJ_DESC> <TEAM_LEADER>146</TEAM_LEADER> <PRODUCT><![CDATA[software]]></PRODUCT> </row> <row number="8"> <PROJ_ID><![CDATA[FBDOC]]></PROJ_ID> <PROJ_NAME><![CDATA[Documentation]]></PROJ_NAME> <PROJ_DESC>${blob_paths}[7]</PROJ_DESC> <TEAM_LEADER/> <PRODUCT><![CDATA[other]]></PRODUCT> </row> <row number="9"> <PROJ_ID><![CDATA[PYTHN]]></PROJ_ID> <PROJ_NAME><![CDATA[Python drivers]]></PROJ_NAME> <PROJ_DESC>${blob_paths}[8]</PROJ_DESC> <TEAM_LEADER>151</TEAM_LEADER> <PRODUCT><![CDATA[software]]></PRODUCT> </row> <row number="10"> <PROJ_ID><![CDATA[DTNET]]></PROJ_ID> <PROJ_NAME><![CDATA[.NET drivers]]></PROJ_NAME> <PROJ_DESC>${blob_paths}[9]</PROJ_DESC> <TEAM_LEADER>152</TEAM_LEADER> <PRODUCT><![CDATA[software]]></PRODUCT> </row> <row number="11"> <PROJ_ID><![CDATA[ODBCD]]></PROJ_ID> <PROJ_NAME><![CDATA[ODBC drivers]]></PROJ_NAME> <PROJ_DESC>${blob_paths}[10]</PROJ_DESC> <TEAM_LEADER/> <PRODUCT><![CDATA[software]]></PRODUCT> </row> <row number="12"> <PROJ_ID><![CDATA[PHPDR]]></PROJ_ID> <PROJ_NAME><![CDATA[PHP drivers]]></PROJ_NAME> <PROJ_DESC>${blob_paths}[11]</PROJ_DESC> <TEAM_LEADER/> <PRODUCT><![CDATA[software]]></PRODUCT> </row> <row number="13"> <PROJ_ID><![CDATA[JAVAD]]></PROJ_ID> <PROJ_NAME><![CDATA[Java drivers]]></PROJ_NAME> <PROJ_DESC>${blob_paths}[12]</PROJ_DESC> <TEAM_LEADER>153</TEAM_LEADER> <PRODUCT><![CDATA[software]]></PRODUCT> </row> <row number="14"> <PROJ_ID><![CDATA[FB-QA]]></PROJ_ID> <PROJ_NAME><![CDATA[Firebrid QA]]></PROJ_NAME> <PROJ_DESC>${blob_paths}[13]</PROJ_DESC> <TEAM_LEADER>150</TEAM_LEADER> <PRODUCT><![CDATA[software]]></PRODUCT> </row> <row number="15"> <PROJ_ID><![CDATA[INFRA]]></PROJ_ID> <PROJ_NAME><![CDATA[Infrastructure]]></PROJ_NAME> <PROJ_DESC>${blob_paths}[14]</PROJ_DESC> <TEAM_LEADER/> <PRODUCT><![CDATA[other]]></PRODUCT> </row> <row number="16"> <PROJ_ID><![CDATA[BTLER]]></PROJ_ID> <PROJ_NAME><![CDATA[Firebrid Butler]]></PROJ_NAME> <PROJ_DESC>${blob_paths}[15]</PROJ_DESC> <TEAM_LEADER>151</TEAM_LEADER> <PRODUCT><![CDATA[software]]></PRODUCT> </row> </data> </result-set>
    ELSE
        VAR    ${expected_content}    <?xml version="1.0" encoding="UTF-8" standalone="no"?> <result-set> <data> <row number="1"> <PROJ_ID><![CDATA[VBASE]]></PROJ_ID> <PROJ_NAME><![CDATA[Video Database]]></PROJ_NAME> <PROJ_DESC>${blob_paths}[0]</PROJ_DESC> <TEAM_LEADER>45</TEAM_LEADER> <PRODUCT><![CDATA[software]]></PRODUCT> </row> <row number="2"> <PROJ_ID><![CDATA[DGPII]]></PROJ_ID> <PROJ_NAME><![CDATA[DigiPizza]]></PROJ_NAME> <PROJ_DESC>${blob_paths}[1]</PROJ_DESC> <TEAM_LEADER>24</TEAM_LEADER> <PRODUCT><![CDATA[other]]></PRODUCT> </row> <row number="3"> <PROJ_ID><![CDATA[GUIDE]]></PROJ_ID> <PROJ_NAME><![CDATA[AutoMap]]></PROJ_NAME> <PROJ_DESC>${blob_paths}[2]</PROJ_DESC> <TEAM_LEADER>20</TEAM_LEADER> <PRODUCT><![CDATA[hardware]]></PRODUCT> </row> <row number="4"> <PROJ_ID><![CDATA[MAPDB]]></PROJ_ID> <PROJ_NAME><![CDATA[MapBrowser port]]></PROJ_NAME> <PROJ_DESC>${blob_paths}[3]</PROJ_DESC> <TEAM_LEADER>4</TEAM_LEADER> <PRODUCT><![CDATA[software]]></PRODUCT> </row> <row number="5"> <PROJ_ID><![CDATA[HWRII]]></PROJ_ID> <PROJ_NAME><![CDATA[Translator upgrade]]></PROJ_NAME> <PROJ_DESC>${blob_paths}[4]</PROJ_DESC> <TEAM_LEADER/> <PRODUCT><![CDATA[software]]></PRODUCT> </row> <row number="6"> <PROJ_ID><![CDATA[MKTPR]]></PROJ_ID> <PROJ_NAME><![CDATA[Marketing project 3]]></PROJ_NAME> <PROJ_DESC>${blob_paths}[5]</PROJ_DESC> <TEAM_LEADER>85</TEAM_LEADER> <PRODUCT><![CDATA[N/A]]></PRODUCT> </row> </data> </result-set>
    END

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

    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    ${ser_ver}=    Set Variable    ${info}[2]
    @{blob_paths}=    Check blobs in folder    ${export_blob}

    IF  ${{$ser_ver == 'Firebird'}}
        VAR    ${expected_content}    PROJ_ID PROJ_NAME PROJ_DESC TEAM_LEADER PRODUCT VBASE Video Database ${blob_paths}[0] 45.0 software DGPII DigiPizza ${blob_paths}[1] 24.0 other GUIDE AutoMap ${blob_paths}[2] 20.0 hardware MAPDB MapBrowser port ${blob_paths}[3] 4.0 software HWRII Translator upgrade ${blob_paths}[4] software MKTPR Marketing project 3 ${blob_paths}[5] 85.0 N/A FCORE Firebird engine ${blob_paths}[6] 146.0 software FBDOC Documentation ${blob_paths}[7] other PYTHN Python drivers ${blob_paths}[8] 151.0 software DTNET .NET drivers ${blob_paths}[9] 152.0 software ODBCD ODBC drivers ${blob_paths}[10] software PHPDR PHP drivers ${blob_paths}[11] software JAVAD Java drivers ${blob_paths}[12] 153.0 software FB-QA Firebrid QA ${blob_paths}[13] 150.0 software INFRA Infrastructure ${blob_paths}[14] other BTLER Firebrid Butler ${blob_paths}[15] 151.0 software
    ELSE
        VAR    ${expected_content}    PROJ_ID PROJ_NAME PROJ_DESC TEAM_LEADER PRODUCT VBASE Video Database ${blob_paths}[0] 45.0 software DGPII DigiPizza ${blob_paths}[1] 24.0 other GUIDE AutoMap ${blob_paths}[2] 20.0 hardware MAPDB MapBrowser port ${blob_paths}[3] 4.0 software HWRII Translator upgrade ${blob_paths}[4] software MKTPR Marketing project 3 ${blob_paths}[5] 85.0 N/A    
    END
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

    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    ${ser_ver}=    Set Variable    ${info}[2]
    @{blob_paths}=    Check blobs in folder    ${export_blob}

    IF  ${{$ser_ver == 'Firebird'}}
        VAR    ${expected_content}    -- table creating -- CREATE TABLE TEST_TABLE ( PROJ_ID CHAR(5), PROJ_NAME VARCHAR(20), PROJ_DESC BLOB SUB_TYPE 1, TEAM_LEADER SMALLINT, PRODUCT VARCHAR(12) ); -- inserting data -- INSERT INTO TEST_TABLE ( PROJ_ID, PROJ_NAME, PROJ_DESC, TEAM_LEADER, PRODUCT ) VALUES ( 'VBASE', 'Video Database', ?'${blob_paths}[0]', 45, 'software' ); INSERT INTO TEST_TABLE ( PROJ_ID, PROJ_NAME, PROJ_DESC, TEAM_LEADER, PRODUCT ) VALUES ( 'DGPII', 'DigiPizza', ?'${blob_paths}[1]', 24, 'other' ); INSERT INTO TEST_TABLE ( PROJ_ID, PROJ_NAME, PROJ_DESC, TEAM_LEADER, PRODUCT ) VALUES ( 'GUIDE', 'AutoMap', ?'${blob_paths}[2]', 20, 'hardware' ); INSERT INTO TEST_TABLE ( PROJ_ID, PROJ_NAME, PROJ_DESC, TEAM_LEADER, PRODUCT ) VALUES ( 'MAPDB', 'MapBrowser port', ?'${blob_paths}[3]', 4, 'software' ); INSERT INTO TEST_TABLE ( PROJ_ID, PROJ_NAME, PROJ_DESC, TEAM_LEADER, PRODUCT ) VALUES ( 'HWRII', 'Translator upgrade', ?'${blob_paths}[4]', NULL, 'software' ); INSERT INTO TEST_TABLE ( PROJ_ID, PROJ_NAME, PROJ_DESC, TEAM_LEADER, PRODUCT ) VALUES ( 'MKTPR', 'Marketing project 3', ?'${blob_paths}[5]', 85, 'N/A' ); INSERT INTO TEST_TABLE ( PROJ_ID, PROJ_NAME, PROJ_DESC, TEAM_LEADER, PRODUCT ) VALUES ( 'FCORE', 'Firebird engine', ?'${blob_paths}[6]', 146, 'software' ); INSERT INTO TEST_TABLE ( PROJ_ID, PROJ_NAME, PROJ_DESC, TEAM_LEADER, PRODUCT ) VALUES ( 'FBDOC', 'Documentation', ?'${blob_paths}[7]', NULL, 'other' ); INSERT INTO TEST_TABLE ( PROJ_ID, PROJ_NAME, PROJ_DESC, TEAM_LEADER, PRODUCT ) VALUES ( 'PYTHN', 'Python drivers', ?'${blob_paths}[8]', 151, 'software' ); INSERT INTO TEST_TABLE ( PROJ_ID, PROJ_NAME, PROJ_DESC, TEAM_LEADER, PRODUCT ) VALUES ( 'DTNET', '.NET drivers', ?'${blob_paths}[9]', 152, 'software' ); INSERT INTO TEST_TABLE ( PROJ_ID, PROJ_NAME, PROJ_DESC, TEAM_LEADER, PRODUCT ) VALUES ( 'ODBCD', 'ODBC drivers', ?'${blob_paths}[10]', NULL, 'software' ); INSERT INTO TEST_TABLE ( PROJ_ID, PROJ_NAME, PROJ_DESC, TEAM_LEADER, PRODUCT ) VALUES ( 'PHPDR', 'PHP drivers', ?'${blob_paths}[11]', NULL, 'software' ); INSERT INTO TEST_TABLE ( PROJ_ID, PROJ_NAME, PROJ_DESC, TEAM_LEADER, PRODUCT ) VALUES ( 'JAVAD', 'Java drivers', ?'${blob_paths}[12]', 153, 'software' ); INSERT INTO TEST_TABLE ( PROJ_ID, PROJ_NAME, PROJ_DESC, TEAM_LEADER, PRODUCT ) VALUES ( 'FB-QA', 'Firebrid QA', ?'${blob_paths}[13]', 150, 'software' ); INSERT INTO TEST_TABLE ( PROJ_ID, PROJ_NAME, PROJ_DESC, TEAM_LEADER, PRODUCT ) VALUES ( 'INFRA', 'Infrastructure', ?'${blob_paths}[14]', NULL, 'other' ); INSERT INTO TEST_TABLE ( PROJ_ID, PROJ_NAME, PROJ_DESC, TEAM_LEADER, PRODUCT ) VALUES ( 'BTLER', 'Firebrid Butler', ?'${blob_paths}[15]', 151, 'software' );
    ELSE
        VAR    ${expected_content}    -- table creating -- CREATE TABLE TEST_TABLE ( PROJ_ID CHAR(5), PROJ_NAME VARCHAR(20), PROJ_DESC BLOB SUB_TYPE 1, TEAM_LEADER SMALLINT, PRODUCT VARCHAR(12) ); -- inserting data -- INSERT INTO TEST_TABLE ( PROJ_ID, PROJ_NAME, PROJ_DESC, TEAM_LEADER, PRODUCT ) VALUES ( 'VBASE', 'Video Database', ?'${blob_paths}[0]', 45, 'software' ); INSERT INTO TEST_TABLE ( PROJ_ID, PROJ_NAME, PROJ_DESC, TEAM_LEADER, PRODUCT ) VALUES ( 'DGPII', 'DigiPizza', ?'${blob_paths}[1]', 24, 'other' ); INSERT INTO TEST_TABLE ( PROJ_ID, PROJ_NAME, PROJ_DESC, TEAM_LEADER, PRODUCT ) VALUES ( 'GUIDE', 'AutoMap', ?'${blob_paths}[2]', 20, 'hardware' ); INSERT INTO TEST_TABLE ( PROJ_ID, PROJ_NAME, PROJ_DESC, TEAM_LEADER, PRODUCT ) VALUES ( 'MAPDB', 'MapBrowser port', ?'${blob_paths}[3]', 4, 'software' ); INSERT INTO TEST_TABLE ( PROJ_ID, PROJ_NAME, PROJ_DESC, TEAM_LEADER, PRODUCT ) VALUES ( 'HWRII', 'Translator upgrade', ?'${blob_paths}[4]', NULL, 'software' ); INSERT INTO TEST_TABLE ( PROJ_ID, PROJ_NAME, PROJ_DESC, TEAM_LEADER, PRODUCT ) VALUES ( 'MKTPR', 'Marketing project 3', ?'${blob_paths}[5]', 85, 'N/A' );  
    END
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
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    ${ser_ver}=    Set Variable    ${info}[2]
    IF  ${{$ser_ver == 'Firebird'}}
        ${expected_content}=    Catenate    SEPARATOR=\n    VBASE;Video Database;:h00000000_00000059;45;software    DGPII;DigiPizza;:h00000059_00000077;24;other    GUIDE;AutoMap;:h000000d0_00000055;20;hardware    MAPDB;MapBrowser port;:h00000125_00000048;4;software    HWRII;Translator upgrade;:h0000016d_00000056;;software    MKTPR;Marketing project 3;:h000001c3_00000061;85;N/A    FCORE;Firebird engine;:h00000224_00000087;146;software    FBDOC;Documentation;:h000002ab_00000046;;other    PYTHN;Python drivers;:h000002f1_00000028;151;software    DTNET;.NET drivers;:h00000319_00000026;152;software    ODBCD;ODBC drivers;:h0000033f_00000015;;software    PHPDR;PHP drivers;:h00000354_00000025;;software    JAVAD;Java drivers;:h00000379_00000026;153;software    FB-QA;Firebrid QA;:h0000039f_0000001d;150;software    INFRA;Infrastructure;:h000003bc_00000021;;other    BTLER;Firebrid Butler;:h000003dd_0000002d;151;software    ${EMPTY}
    ELSE
        ${expected_content}=    Catenate    SEPARATOR=\n    VBASE;Video Database;:h00000000_00000059;45;software    DGPII;DigiPizza;:h00000059_00000077;24;other    GUIDE;AutoMap;:h000000d0_00000055;20;hardware    MAPDB;MapBrowser port;:h00000125_00000048;4;software    HWRII;Translator upgrade;:h0000016d_00000056;;software    MKTPR;Marketing project 3;:h000001c3_00000061;85;N/A    ${EMPTY}
    END
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
    
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    ${ser_ver}=    Set Variable    ${info}[2]
    IF  ${{$ser_ver == 'Firebird'}}
        VAR    ${expected_content}    <?xml version="1.0" encoding="UTF-8" standalone="no"?> <result-set> <data> <row number="1"> <PROJ_ID><![CDATA[VBASE]]></PROJ_ID> <PROJ_NAME><![CDATA[Video Database]]></PROJ_NAME> <PROJ_DESC>:h00000000_00000059</PROJ_DESC> <TEAM_LEADER>45</TEAM_LEADER> <PRODUCT><![CDATA[software]]></PRODUCT> </row> <row number="2"> <PROJ_ID><![CDATA[DGPII]]></PROJ_ID> <PROJ_NAME><![CDATA[DigiPizza]]></PROJ_NAME> <PROJ_DESC>:h00000059_00000077</PROJ_DESC> <TEAM_LEADER>24</TEAM_LEADER> <PRODUCT><![CDATA[other]]></PRODUCT> </row> <row number="3"> <PROJ_ID><![CDATA[GUIDE]]></PROJ_ID> <PROJ_NAME><![CDATA[AutoMap]]></PROJ_NAME> <PROJ_DESC>:h000000d0_00000055</PROJ_DESC> <TEAM_LEADER>20</TEAM_LEADER> <PRODUCT><![CDATA[hardware]]></PRODUCT> </row> <row number="4"> <PROJ_ID><![CDATA[MAPDB]]></PROJ_ID> <PROJ_NAME><![CDATA[MapBrowser port]]></PROJ_NAME> <PROJ_DESC>:h00000125_00000048</PROJ_DESC> <TEAM_LEADER>4</TEAM_LEADER> <PRODUCT><![CDATA[software]]></PRODUCT> </row> <row number="5"> <PROJ_ID><![CDATA[HWRII]]></PROJ_ID> <PROJ_NAME><![CDATA[Translator upgrade]]></PROJ_NAME> <PROJ_DESC>:h0000016d_00000056</PROJ_DESC> <TEAM_LEADER/> <PRODUCT><![CDATA[software]]></PRODUCT> </row> <row number="6"> <PROJ_ID><![CDATA[MKTPR]]></PROJ_ID> <PROJ_NAME><![CDATA[Marketing project 3]]></PROJ_NAME> <PROJ_DESC>:h000001c3_00000061</PROJ_DESC> <TEAM_LEADER>85</TEAM_LEADER> <PRODUCT><![CDATA[N/A]]></PRODUCT> </row> <row number="7"> <PROJ_ID><![CDATA[FCORE]]></PROJ_ID> <PROJ_NAME><![CDATA[Firebird engine]]></PROJ_NAME> <PROJ_DESC>:h00000224_00000087</PROJ_DESC> <TEAM_LEADER>146</TEAM_LEADER> <PRODUCT><![CDATA[software]]></PRODUCT> </row> <row number="8"> <PROJ_ID><![CDATA[FBDOC]]></PROJ_ID> <PROJ_NAME><![CDATA[Documentation]]></PROJ_NAME> <PROJ_DESC>:h000002ab_00000046</PROJ_DESC> <TEAM_LEADER/> <PRODUCT><![CDATA[other]]></PRODUCT> </row> <row number="9"> <PROJ_ID><![CDATA[PYTHN]]></PROJ_ID> <PROJ_NAME><![CDATA[Python drivers]]></PROJ_NAME> <PROJ_DESC>:h000002f1_00000028</PROJ_DESC> <TEAM_LEADER>151</TEAM_LEADER> <PRODUCT><![CDATA[software]]></PRODUCT> </row> <row number="10"> <PROJ_ID><![CDATA[DTNET]]></PROJ_ID> <PROJ_NAME><![CDATA[.NET drivers]]></PROJ_NAME> <PROJ_DESC>:h00000319_00000026</PROJ_DESC> <TEAM_LEADER>152</TEAM_LEADER> <PRODUCT><![CDATA[software]]></PRODUCT> </row> <row number="11"> <PROJ_ID><![CDATA[ODBCD]]></PROJ_ID> <PROJ_NAME><![CDATA[ODBC drivers]]></PROJ_NAME> <PROJ_DESC>:h0000033f_00000015</PROJ_DESC> <TEAM_LEADER/> <PRODUCT><![CDATA[software]]></PRODUCT> </row> <row number="12"> <PROJ_ID><![CDATA[PHPDR]]></PROJ_ID> <PROJ_NAME><![CDATA[PHP drivers]]></PROJ_NAME> <PROJ_DESC>:h00000354_00000025</PROJ_DESC> <TEAM_LEADER/> <PRODUCT><![CDATA[software]]></PRODUCT> </row> <row number="13"> <PROJ_ID><![CDATA[JAVAD]]></PROJ_ID> <PROJ_NAME><![CDATA[Java drivers]]></PROJ_NAME> <PROJ_DESC>:h00000379_00000026</PROJ_DESC> <TEAM_LEADER>153</TEAM_LEADER> <PRODUCT><![CDATA[software]]></PRODUCT> </row> <row number="14"> <PROJ_ID><![CDATA[FB-QA]]></PROJ_ID> <PROJ_NAME><![CDATA[Firebrid QA]]></PROJ_NAME> <PROJ_DESC>:h0000039f_0000001d</PROJ_DESC> <TEAM_LEADER>150</TEAM_LEADER> <PRODUCT><![CDATA[software]]></PRODUCT> </row> <row number="15"> <PROJ_ID><![CDATA[INFRA]]></PROJ_ID> <PROJ_NAME><![CDATA[Infrastructure]]></PROJ_NAME> <PROJ_DESC>:h000003bc_00000021</PROJ_DESC> <TEAM_LEADER/> <PRODUCT><![CDATA[other]]></PRODUCT> </row> <row number="16"> <PROJ_ID><![CDATA[BTLER]]></PROJ_ID> <PROJ_NAME><![CDATA[Firebrid Butler]]></PROJ_NAME> <PROJ_DESC>:h000003dd_0000002d</PROJ_DESC> <TEAM_LEADER>151</TEAM_LEADER> <PRODUCT><![CDATA[software]]></PRODUCT> </row> </data> </result-set>
    ELSE
        VAR    ${expected_content}    <?xml version="1.0" encoding="UTF-8" standalone="no"?> <result-set> <data> <row number="1"> <PROJ_ID><![CDATA[VBASE]]></PROJ_ID> <PROJ_NAME><![CDATA[Video Database]]></PROJ_NAME> <PROJ_DESC>:h00000000_00000059</PROJ_DESC> <TEAM_LEADER>45</TEAM_LEADER> <PRODUCT><![CDATA[software]]></PRODUCT> </row> <row number="2"> <PROJ_ID><![CDATA[DGPII]]></PROJ_ID> <PROJ_NAME><![CDATA[DigiPizza]]></PROJ_NAME> <PROJ_DESC>:h00000059_00000077</PROJ_DESC> <TEAM_LEADER>24</TEAM_LEADER> <PRODUCT><![CDATA[other]]></PRODUCT> </row> <row number="3"> <PROJ_ID><![CDATA[GUIDE]]></PROJ_ID> <PROJ_NAME><![CDATA[AutoMap]]></PROJ_NAME> <PROJ_DESC>:h000000d0_00000055</PROJ_DESC> <TEAM_LEADER>20</TEAM_LEADER> <PRODUCT><![CDATA[hardware]]></PRODUCT> </row> <row number="4"> <PROJ_ID><![CDATA[MAPDB]]></PROJ_ID> <PROJ_NAME><![CDATA[MapBrowser port]]></PROJ_NAME> <PROJ_DESC>:h00000125_00000048</PROJ_DESC> <TEAM_LEADER>4</TEAM_LEADER> <PRODUCT><![CDATA[software]]></PRODUCT> </row> <row number="5"> <PROJ_ID><![CDATA[HWRII]]></PROJ_ID> <PROJ_NAME><![CDATA[Translator upgrade]]></PROJ_NAME> <PROJ_DESC>:h0000016d_00000056</PROJ_DESC> <TEAM_LEADER/> <PRODUCT><![CDATA[software]]></PRODUCT> </row> <row number="6"> <PROJ_ID><![CDATA[MKTPR]]></PROJ_ID> <PROJ_NAME><![CDATA[Marketing project 3]]></PROJ_NAME> <PROJ_DESC>:h000001c3_00000061</PROJ_DESC> <TEAM_LEADER>85</TEAM_LEADER> <PRODUCT><![CDATA[N/A]]></PRODUCT> </row> </data> </result-set>    
    END
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
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    ${ser_ver}=    Set Variable    ${info}[2]
    IF  ${{$ser_ver == 'Firebird'}}
        VAR    ${expected_content}    None None None None None VBASE Video Database :h00000000_00000059 45.0 software DGPII DigiPizza :h00000059_00000077 24.0 other GUIDE AutoMap :h000000d0_00000055 20.0 hardware MAPDB MapBrowser port :h00000125_00000048 4.0 software HWRII Translator upgrade :h0000016d_00000056 software MKTPR Marketing project 3 :h000001c3_00000061 85.0 N/A FCORE Firebird engine :h00000224_00000087 146.0 software FBDOC Documentation :h000002ab_00000046 other PYTHN Python drivers :h000002f1_00000028 151.0 software DTNET .NET drivers :h00000319_00000026 152.0 software ODBCD ODBC drivers :h0000033f_00000015 software PHPDR PHP drivers :h00000354_00000025 software JAVAD Java drivers :h00000379_00000026 153.0 software FB-QA Firebrid QA :h0000039f_0000001d 150.0 software INFRA Infrastructure :h000003bc_00000021 other BTLER Firebrid Butler :h000003dd_0000002d 151.0 software
    ELSE
        VAR    ${expected_content}    None None None None None VBASE Video Database :h00000000_00000059 45.0 software DGPII DigiPizza :h00000059_00000077 24.0 other GUIDE AutoMap :h000000d0_00000055 20.0 hardware MAPDB MapBrowser port :h00000125_00000048 4.0 software HWRII Translator upgrade :h0000016d_00000056 software MKTPR Marketing project 3 :h000001c3_00000061 85.0 N/A    
    END
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
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    ${ser_ver}=    Set Variable    ${info}[2]
    IF  ${{$ser_ver == 'Firebird'}}
        VAR    ${expected_content}    -- table creating -- CREATE TABLE TEST_TABLE ( PROJ_ID CHAR(5), PROJ_NAME VARCHAR(20), PROJ_DESC BLOB SUB_TYPE 1, TEAM_LEADER SMALLINT, PRODUCT VARCHAR(12) ); -- inserting data -- SET BLOBFILE '${export_blob}'; INSERT INTO TEST_TABLE ( PROJ_ID, PROJ_NAME, PROJ_DESC, TEAM_LEADER, PRODUCT ) VALUES ( 'VBASE', 'Video Database', :h00000000_00000059, 45, 'software' ); INSERT INTO TEST_TABLE ( PROJ_ID, PROJ_NAME, PROJ_DESC, TEAM_LEADER, PRODUCT ) VALUES ( 'DGPII', 'DigiPizza', :h00000059_00000077, 24, 'other' ); INSERT INTO TEST_TABLE ( PROJ_ID, PROJ_NAME, PROJ_DESC, TEAM_LEADER, PRODUCT ) VALUES ( 'GUIDE', 'AutoMap', :h000000d0_00000055, 20, 'hardware' ); INSERT INTO TEST_TABLE ( PROJ_ID, PROJ_NAME, PROJ_DESC, TEAM_LEADER, PRODUCT ) VALUES ( 'MAPDB', 'MapBrowser port', :h00000125_00000048, 4, 'software' ); INSERT INTO TEST_TABLE ( PROJ_ID, PROJ_NAME, PROJ_DESC, TEAM_LEADER, PRODUCT ) VALUES ( 'HWRII', 'Translator upgrade', :h0000016d_00000056, NULL, 'software' ); INSERT INTO TEST_TABLE ( PROJ_ID, PROJ_NAME, PROJ_DESC, TEAM_LEADER, PRODUCT ) VALUES ( 'MKTPR', 'Marketing project 3', :h000001c3_00000061, 85, 'N/A' ); INSERT INTO TEST_TABLE ( PROJ_ID, PROJ_NAME, PROJ_DESC, TEAM_LEADER, PRODUCT ) VALUES ( 'FCORE', 'Firebird engine', :h00000224_00000087, 146, 'software' ); INSERT INTO TEST_TABLE ( PROJ_ID, PROJ_NAME, PROJ_DESC, TEAM_LEADER, PRODUCT ) VALUES ( 'FBDOC', 'Documentation', :h000002ab_00000046, NULL, 'other' ); INSERT INTO TEST_TABLE ( PROJ_ID, PROJ_NAME, PROJ_DESC, TEAM_LEADER, PRODUCT ) VALUES ( 'PYTHN', 'Python drivers', :h000002f1_00000028, 151, 'software' ); INSERT INTO TEST_TABLE ( PROJ_ID, PROJ_NAME, PROJ_DESC, TEAM_LEADER, PRODUCT ) VALUES ( 'DTNET', '.NET drivers', :h00000319_00000026, 152, 'software' ); INSERT INTO TEST_TABLE ( PROJ_ID, PROJ_NAME, PROJ_DESC, TEAM_LEADER, PRODUCT ) VALUES ( 'ODBCD', 'ODBC drivers', :h0000033f_00000015, NULL, 'software' ); INSERT INTO TEST_TABLE ( PROJ_ID, PROJ_NAME, PROJ_DESC, TEAM_LEADER, PRODUCT ) VALUES ( 'PHPDR', 'PHP drivers', :h00000354_00000025, NULL, 'software' ); INSERT INTO TEST_TABLE ( PROJ_ID, PROJ_NAME, PROJ_DESC, TEAM_LEADER, PRODUCT ) VALUES ( 'JAVAD', 'Java drivers', :h00000379_00000026, 153, 'software' ); INSERT INTO TEST_TABLE ( PROJ_ID, PROJ_NAME, PROJ_DESC, TEAM_LEADER, PRODUCT ) VALUES ( 'FB-QA', 'Firebrid QA', :h0000039f_0000001d, 150, 'software' ); INSERT INTO TEST_TABLE ( PROJ_ID, PROJ_NAME, PROJ_DESC, TEAM_LEADER, PRODUCT ) VALUES ( 'INFRA', 'Infrastructure', :h000003bc_00000021, NULL, 'other' ); INSERT INTO TEST_TABLE ( PROJ_ID, PROJ_NAME, PROJ_DESC, TEAM_LEADER, PRODUCT ) VALUES ( 'BTLER', 'Firebrid Butler', :h000003dd_0000002d, 151, 'software' );
    ELSE
        VAR    ${expected_content}    -- table creating -- CREATE TABLE TEST_TABLE ( PROJ_ID CHAR(5), PROJ_NAME VARCHAR(20), PROJ_DESC BLOB SUB_TYPE 1, TEAM_LEADER SMALLINT, PRODUCT VARCHAR(12) ); -- inserting data -- SET BLOBFILE '${export_blob}'; INSERT INTO TEST_TABLE ( PROJ_ID, PROJ_NAME, PROJ_DESC, TEAM_LEADER, PRODUCT ) VALUES ( 'VBASE', 'Video Database', :h00000000_00000059, 45, 'software' ); INSERT INTO TEST_TABLE ( PROJ_ID, PROJ_NAME, PROJ_DESC, TEAM_LEADER, PRODUCT ) VALUES ( 'DGPII', 'DigiPizza', :h00000059_00000077, 24, 'other' ); INSERT INTO TEST_TABLE ( PROJ_ID, PROJ_NAME, PROJ_DESC, TEAM_LEADER, PRODUCT ) VALUES ( 'GUIDE', 'AutoMap', :h000000d0_00000055, 20, 'hardware' ); INSERT INTO TEST_TABLE ( PROJ_ID, PROJ_NAME, PROJ_DESC, TEAM_LEADER, PRODUCT ) VALUES ( 'MAPDB', 'MapBrowser port', :h00000125_00000048, 4, 'software' ); INSERT INTO TEST_TABLE ( PROJ_ID, PROJ_NAME, PROJ_DESC, TEAM_LEADER, PRODUCT ) VALUES ( 'HWRII', 'Translator upgrade', :h0000016d_00000056, NULL, 'software' ); INSERT INTO TEST_TABLE ( PROJ_ID, PROJ_NAME, PROJ_DESC, TEAM_LEADER, PRODUCT ) VALUES ( 'MKTPR', 'Marketing project 3', :h000001c3_00000061, 85, 'N/A' );
    END
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
    Push Button    editor-execute-to-file-command
    Push Button    execute-script-command
    Sleep    1s
    Select Dialog    Export Data    


Check blobs in folder
    [Arguments]       ${export_blob}
    Push Button    exportButton
    Sleep    5s
    Close Dialog    Message
    Directory Should Exist    ${export_blob}
    Directory Should Not Be Empty    ${export_blob}

    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    ${ser_ver}=    Set Variable    ${info}[2]

    IF  ${{$ser_ver == 'Firebird'}}
        VAR    ${count}    16
    ELSE
        VAR    ${count}    6
    END

    @{blob_paths}=    Create List
    @{contents}=    Create List
    FOR    ${index}    IN RANGE    ${count}
        ${blob_path}=    Catenate    SEPARATOR=    ${export_blob}    ${/}PROJ_DESC_${index}.txt
        Append To List    ${blob_paths}    ${blob_path}

        ${content}=    Get File    ${blob_path}
        Append To List    ${contents}    ${content}
    END

    Should Be Equal As Strings    ${contents}[0]    Design a video data base management system for controlling on-demand video distribution.    strip_spaces=${True}    collapse_spaces=${True}
    Should Be Equal As Strings    ${contents}[1]    Develop second generation digital pizza maker with flash-bake heating element and digital ingredient measuring system.    strip_spaces=${True}    collapse_spaces=${True}
    Should Be Equal As Strings    ${contents}[2]    Develop a prototype for the automobile version of the hand-held map browsing device.    strip_spaces=${True}    collapse_spaces=${True}
    Should Be Equal As Strings    ${contents}[3]    Port the map browsing database software to run on the automobile model.    strip_spaces=${True}    collapse_spaces=${True}
    Should Be Equal As Strings    ${contents}[4]    Integrate the hand-writing recognition module into the universal language translator.    strip_spaces=${True}    collapse_spaces=${True}
    Should Be Equal As Strings    ${contents}[5]    Expand marketing and sales in the Pacific Rim. Set up a field office in Australia and Singapore.    strip_spaces=${True}    collapse_spaces=${True}  
    
    IF  ${{$ser_ver == 'Firebird'}}
        Should Be Equal As Strings    ${contents}[6]    Everything that makes core Firebird distributions: - Firebird server - Utilities - Plugins, UDF, UDR - Ports, packaging and installers    strip_spaces=${True}    collapse_spaces=${True}
        Should Be Equal As Strings    ${contents}[7]    Firebird documentation: - Release Notes - Guides and books - Articles    strip_spaces=${True}    collapse_spaces=${True}
        Should Be Equal As Strings    ${contents}[8]    Python drivers and extension libraries.    strip_spaces=${True}    collapse_spaces=${True}
        Should Be Equal As Strings    ${contents}[9]    .NET drivers and extension libraries.    strip_spaces=${True}    collapse_spaces=${True}
        Should Be Equal As Strings    ${contents}[10]    ODBC/OLE DB drivers.    strip_spaces=${True}    collapse_spaces=${True}
        Should Be Equal As Strings    ${contents}[11]    PHP drivers and extension libraries.    strip_spaces=${True}    collapse_spaces=${True}  
        Should Be Equal As Strings    ${contents}[12]    Java drivers and extension libraries.    strip_spaces=${True}    collapse_spaces=${True}  
        Should Be Equal As Strings    ${contents}[13]    Firebird QA: - tools - tests    strip_spaces=${True}    collapse_spaces=${True}  
        Should Be Equal As Strings    ${contents}[14]    Firebird Project infrastructure.    strip_spaces=${True}    collapse_spaces=${True}  
        Should Be Equal As Strings    ${contents}[15]    Firebird Butler: - Specifications - Saturnin    strip_spaces=${True}    collapse_spaces=${True}  
    END

    RETURN    ${blob_paths}

Check blobs in file
    [Arguments]    ${export_blob}
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    ${ser_ver}=    Set Variable    ${info}[2]

    IF  ${{$ser_ver == 'Firebird'}}
        ${expected_content}=    Catenate    SEPARATOR=\n    Design a video data base management system for    controlling on-demand video distribution.    Develop second generation digital pizza maker    with flash-bake heating element and    digital ingredient measuring system.    Develop a prototype for the automobile version of    the hand-held map browsing device.    Port the map browsing database software to run    on the automobile model.    Integrate the hand-writing recognition module into the    universal language translator.    Expand marketing and sales in the Pacific Rim.    Set up a field office in Australia and Singapore.    Everything that makes core Firebird distributions:    - Firebird server  - Utilities    - Plugins, UDF, UDR    - Ports, packaging and installers    Firebird documentation:    - Release Notes   - Guides and books    - Articles    Python drivers and extension libraries.    .NET drivers and extension libraries.    ODBC/OLE DB drivers.    PHP drivers and extension libraries.    Java drivers and extension libraries.    Firebird QA:   - tools    - tests    Firebird Project infrastructure.    Firebird Butler:    - Specifications    - Saturnin    ${EMPTY}
    ELSE
        ${expected_content}=    Catenate    SEPARATOR=\n    Design a video data base management system for    controlling on-demand video distribution.    Develop second generation digital pizza maker    with flash-bake heating element and    digital ingredient measuring system.    Develop a prototype for the automobile version of    the hand-held map browsing device.    Port the map browsing database software to run    on the automobile model.    Integrate the hand-writing recognition module into the    universal language translator.    Expand marketing and sales in the Pacific Rim.    Set up a field office in Australia and Singapore.    ${EMPTY}
    END
    
    File Should Exist    ${export_blob}
    ${content}=    Get File    ${export_blob}
    Should Be Equal As Strings    ${content}    ${expected_content}