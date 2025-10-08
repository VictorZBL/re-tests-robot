*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../../files/keywords.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_1
    Open connection
    Click On Tree Node   0    New Connection|Procedures (10)|SHOW_LANGS    2
    Select Tab As Context    Dependencies
    Expand All Tree Nodes    0
    Expand All Tree Nodes    1
    @{tree1}=     Get Tree Node Child Names    0
    @{tree12}=    Get Tree Node Child Names    0    New Connection|Procedures (1)
    @{tree2}=     Get Tree Node Child Names    1
    @{tree22}=    Get Tree Node Child Names    1    New Connection|Tables (1)
    
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    ${srv_ver} =    Set Variable    ${info}[2]
    IF  ${{$ver == '5' and $srv_ver == 'RedDatabase'}}
        Should Be Equal As Strings    ${tree1}     ['Domains', 'Tables', 'Global Temporary Tables', 'Views', 'Procedures (1)', 'Functions', 'Packages', 'Table Triggers', 'DDL Triggers', 'DB Triggers', 'Sequences', 'Exceptions', 'UDFs', 'Users', 'Roles', 'Indices', 'Tablespaces', 'Jobs']
        Should Be Equal As Strings    ${tree2}     ['Domains', 'Tables (1)', 'Global Temporary Tables', 'Views', 'Procedures', 'Functions', 'Packages', 'Table Triggers', 'DDL Triggers', 'DB Triggers', 'Sequences', 'Exceptions', 'UDFs', 'Users', 'Roles', 'Indices', 'Tablespaces', 'Jobs']
    ELSE IF    ${{$ver == '2.6'}}
        Should Be Equal As Strings    ${tree1}     ['Domains', 'Tables', 'Global Temporary Tables', 'Views', 'Procedures (1)', 'Table Triggers', 'DB Triggers', 'Sequences', 'Exceptions', 'UDFs', 'Roles', 'Indices']
        Should Be Equal As Strings    ${tree2}     ['Domains', 'Tables (1)', 'Global Temporary Tables', 'Views', 'Procedures', 'Table Triggers', 'DB Triggers', 'Sequences', 'Exceptions', 'UDFs', 'Roles', 'Indices']
    ELSE
        Should Be Equal As Strings    ${tree1}     ['Domains', 'Tables', 'Global Temporary Tables', 'Views', 'Procedures (1)', 'Functions', 'Packages', 'Table Triggers', 'DDL Triggers', 'DB Triggers', 'Sequences', 'Exceptions', 'UDFs', 'Users', 'Roles', 'Indices']
        Should Be Equal As Strings    ${tree2}     ['Domains', 'Tables (1)', 'Global Temporary Tables', 'Views', 'Procedures', 'Functions', 'Packages', 'Table Triggers', 'DDL Triggers', 'DB Triggers', 'Sequences', 'Exceptions', 'UDFs', 'Users', 'Roles', 'Indices']
    END

    Should Be Equal As Strings    ${tree12}    ['ALL_LANGS']
    Should Be Equal As Strings    ${tree22}    ['JOB']