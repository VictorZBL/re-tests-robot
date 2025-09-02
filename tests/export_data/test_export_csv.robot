*** Settings ***
Library    RemoteSwingLibrary
Library    OperatingSystem
Resource    ../../files/keywords.resource
Resource    key.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_without
    Setup before export data
    ${export_path}=    Init CSV

    ${expected_content}=    Catenate    SEPARATOR=\n    Carol;Nordstrom;420;1991-10-02T00:00    Luke;Leung;3;1992-02-18T00:00    Sue Anne;O''Brien;877;1992-03-23T00:00    Jennifer M.;Burbank;289;1992-04-15T00:00    Claudia;Sutherland;;1992-04-20T00:00    Dana;Bishop;290;1992-06-01T00:00    ${EMPTY}
    Check content    ${export_path}    ${expected_content}

test_include_column_name
    Setup before export data
    ${export_path}=    Init CSV
    Check Check Box    addColumnHeadersCheck

    ${expected_content}=    Catenate    SEPARATOR=\n    FIRST_NAME;LAST_NAME;PHONE_EXT;HIRE_DATE    Carol;Nordstrom;420;1991-10-02T00:00    Luke;Leung;3;1992-02-18T00:00    Sue Anne;O''Brien;877;1992-03-23T00:00    Jennifer M.;Burbank;289;1992-04-15T00:00    Claudia;Sutherland;;1992-04-20T00:00    Dana;Bishop;290;1992-06-01T00:00    ${EMPTY}
    Check content    ${export_path}    ${expected_content}

test_double_quotes
    Setup before export data
    ${export_path}=    Init CSV
    Check Check Box    addQuotesCheck

    ${expected_content}=    Catenate    SEPARATOR=\n    "Carol";"Nordstrom";"420";1991-10-02T00:00    "Luke";"Leung";"3";1992-02-18T00:00    "Sue Anne";"O''Brien";"877";1992-03-23T00:00    "Jennifer M.";"Burbank";"289";1992-04-15T00:00    "Claudia";"Sutherland";;1992-04-20T00:00    "Dana";"Bishop";"290";1992-06-01T00:00    ${EMPTY}
    Check content    ${export_path}    ${expected_content}

test_replace_null
    Setup before export data
    ${export_path}=    Init CSV
    Check Check Box    replaceNullCheck
    Clear Text Field    replaceNullField
    Type Into Text Field    replaceNullField    LLUN
    ${expected_content}=    Catenate    SEPARATOR=\n    Carol;Nordstrom;420;1991-10-02T00:00    Luke;Leung;3;1992-02-18T00:00    Sue Anne;O''Brien;877;1992-03-23T00:00    Jennifer M.;Burbank;289;1992-04-15T00:00    Claudia;Sutherland;LLUN;1992-04-20T00:00    Dana;Bishop;290;1992-06-01T00:00    ${EMPTY}
    Check content    ${export_path}    ${expected_content}

test_unuse_replace_endl
    Lock Employee
    Execute Immediate    UPDATE EMPLOYEE SET LAST_NAME = 'Nord\nstrom' where LAST_NAME = 'Nordstrom' 
    Setup before export data
    ${export_path}=    Init CSV
    ${expected_content}=    Catenate    SEPARATOR=\n    Carol;Nord    strom;420;1991-10-02T00:00    Luke;Leung;3;1992-02-18T00:00    Sue Anne;O''Brien;877;1992-03-23T00:00    Jennifer M.;Burbank;289;1992-04-15T00:00    Claudia;Sutherland;;1992-04-20T00:00    Dana;Bishop;290;1992-06-01T00:00    ${EMPTY}
    Check content    ${export_path}    ${expected_content}

test_replace_endl
    Lock Employee
    Execute Immediate    UPDATE EMPLOYEE SET LAST_NAME = 'Nord\nstrom' where LAST_NAME = 'Nordstrom' 
    Setup before export data
    ${export_path}=    Init CSV
    Check Check Box    replaceEndlCheck
    Clear Text Field    replaceEndlCombo    #replace "Combo" to "Field"
    Type Into Text Field    replaceEndlCombo    endl

    ${expected_content}=    Catenate    SEPARATOR=\n    Carol;Nordendlstrom;420;1991-10-02T00:00    Luke;Leung;3;1992-02-18T00:00    Sue Anne;O''Brien;877;1992-03-23T00:00    Jennifer M.;Burbank;289;1992-04-15T00:00    Claudia;Sutherland;;1992-04-20T00:00    Dana;Bishop;290;1992-06-01T00:00    ${EMPTY}
    Check content    ${export_path}    ${expected_content}

test_select_delimiter
    Setup before export data
    ${export_path}=    Init CSV
    Select From Combo Box    columnDelimiterCombo    |

    ${expected_content}=    Catenate    SEPARATOR=\n    Carol|Nordstrom|420|1991-10-02T00:00    Luke|Leung|3|1992-02-18T00:00    Sue Anne|O''Brien|877|1992-03-23T00:00    Jennifer M.|Burbank|289|1992-04-15T00:00    Claudia|Sutherland||1992-04-20T00:00    Dana|Bishop|290|1992-06-01T00:00    ${EMPTY}
    Check content    ${export_path}    ${expected_content}

test_type_delimiter
    Setup before export data
    ${export_path}=    Init CSV
    Type Into Combobox    columnDelimiterCombo    123

    Check Check Box    replaceNullCheck
    Clear Text Field    replaceNullField
    Type Into Text Field    replaceNullField    LLUN
    
    ${expected_content}=    Catenate    SEPARATOR=\n    Carol123Nordstrom1234201231991-10-02T00:00    Luke123Leung12331231992-02-18T00:00    Sue Anne123O''Brien1238771231992-03-23T00:00    Jennifer M.123Burbank1232891231992-04-15T00:00    Claudia123Sutherland123LLUN1231992-04-20T00:00    Dana123Bishop1232901231992-06-01T00:00    ${EMPTY}
    Check content    ${export_path}    ${expected_content}

test_execute_to_file
    Open connection
    Clear Text Field    0
    Insert Into Text Field    0    SELECT * FROM COUNTRY
    Push Button    editor-execute-to-file-command
    Push Button    execute-script-command
    Sleep    1s  
    Select Dialog    Export Data
    ${export_path}=    Init CSV
    Select From Combo Box    columnDelimiterCombo    ;
    Check Check Box    addColumnHeadersCheck
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    ${ser_ver}=    Set Variable    ${info}[2]
    IF    ${{$ver == '2.6'}}
        ${expected_content}=    Catenate    SEPARATOR=\n    COUNTRY;CURRENCY    USA;Dollar    England;Pound    Canada;CdnDlr    Switzerland;SFranc    Japan;Yen    Italy;Lira    France;FFranc    Germany;D-Mark    Australia;ADollar    Hong Kong;HKDollar    Netherlands;Guilder    Belgium;BFranc    Austria;Schilling    Fiji;FDollar    ${EMPTY}
    ELSE IF    ${{$ser_ver == 'Firebird' or ($ser_ver == 'RedDatabase' and $ver == '3.0')}}
        ${expected_content}=    Catenate    SEPARATOR=\n    COUNTRY;CURRENCY    USA;Dollar    England;Pound    Canada;CdnDlr    Switzerland;SFranc    Japan;Yen    Italy;Euro    France;Euro    Germany;Euro    Australia;ADollar    Hong Kong;HKDollar    Netherlands;Euro    Belgium;Euro    Austria;Euro    Fiji;FDollar    Russia;Ruble    Romania;RLeu    Ukraine;Hryvnia    Czechia;CzKoruna    Brazil;Real    Chile;ChPeso    Spain;Euro    Hungary;Forint    Sweden;SKrona    Greece;Euro    Slovakia;Euro    Portugal;Euro    ${EMPTY}
    ELSE
        ${expected_content}=    Catenate    SEPARATOR=\n    COUNTRY;CURRENCY    USA;Dollar    England;Pound    Canada;CdnDlr    Switzerland;SFranc    Japan;Yen    Italy;Euro    France;Euro    Germany;Euro    Australia;ADollar    Hong Kong;HKDollar    Netherlands;Euro    Belgium;Euro    Austria;Euro    Fiji;FDollar    Russia;Ruble    Romania;RLeu    ${EMPTY}
    END
    Check content    ${export_path}    ${expected_content}

    
*** Keywords ***
Init CSV
    Select From Combo Box    typeCombo    CSV
    ${export_path}=    Catenate    SEPARATOR=    ${TEMPDIR}    /export.csv
    Remove Files    ${export_path}
    Clear Text Field    filePathField
    Type Into Text Field    filePathField    ${export_path}
    Uncheck All Checkboxes
    RETURN    ${export_path}

Check content
    [Arguments]   ${export_path}    ${expected_content}
    Push Button    exportButton
    Sleep    5s
    Close Dialog    Message
    File Should Exist    ${export_path}
    ${content}=    Get File    ${export_path}
    Should Be Equal As Strings    ${content}    ${expected_content}