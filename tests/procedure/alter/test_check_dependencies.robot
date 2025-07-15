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
    IF  ${{$ver == '5.0' and $srv_ver == 'RedDatabase'}}
        Should Be Equal As Strings    ${tree1}     ['Domains (0)', 'Tables (0)', 'Global Temporary Tables (0)', 'Views (0)', 'Procedures (1)', 'Functions (0)', 'Packages (0)', 'Table Triggers (0)', 'DDL Triggers (0)', 'DB Triggers (0)', 'Sequences (0)', 'Exceptions (0)', 'UDFs (0)', 'Users (0)', 'Roles (0)', 'Indices (0)', 'Tablespaces (0)', 'Jobs (0)']
        Should Be Equal As Strings    ${tree2}     ['Domains (0)', 'Tables (1)', 'Global Temporary Tables (0)', 'Views (0)', 'Procedures (0)', 'Functions (0)', 'Packages (0)', 'Table Triggers (0)', 'DDL Triggers (0)', 'DB Triggers (0)', 'Sequences (0)', 'Exceptions (0)', 'UDFs (0)', 'Users (0)', 'Roles (0)', 'Indices (0)', 'Tablespaces (0)', 'Jobs (0)']
    ELSE IF    ${{$ver == '2.6'}}
        Should Be Equal As Strings    ${tree1}     ['Domains (0)', 'Tables (0)', 'Global Temporary Tables (0)', 'Views (0)', 'Procedures (1)', 'Table Triggers (0)', 'DB Triggers (0)', 'Sequences (0)', 'Exceptions (0)', 'UDFs (0)', 'Roles (0)', 'Indices (0)']
        Should Be Equal As Strings    ${tree2}     ['Domains (0)', 'Tables (1)', 'Global Temporary Tables (0)', 'Views (0)', 'Procedures (0)', 'Table Triggers (0)', 'DB Triggers (0)', 'Sequences (0)', 'Exceptions (0)', 'UDFs (0)', 'Roles (0)', 'Indices (0)']
    ELSE
        Should Be Equal As Strings    ${tree1}     ['Domains (0)', 'Tables (0)', 'Global Temporary Tables (0)', 'Views (0)', 'Procedures (1)', 'Functions (0)', 'Packages (0)', 'Table Triggers (0)', 'DDL Triggers (0)', 'DB Triggers (0)', 'Sequences (0)', 'Exceptions (0)', 'UDFs (0)', 'Users (0)', 'Roles (0)', 'Indices (0)']
        Should Be Equal As Strings    ${tree2}     ['Domains (0)', 'Tables (1)', 'Global Temporary Tables (0)', 'Views (0)', 'Procedures (0)', 'Functions (0)', 'Packages (0)', 'Table Triggers (0)', 'DDL Triggers (0)', 'DB Triggers (0)', 'Sequences (0)', 'Exceptions (0)', 'UDFs (0)', 'Users (0)', 'Roles (0)', 'Indices (0)']
    END

    Should Be Equal As Strings    ${tree12}    ['ALL_LANGS']
    Should Be Equal As Strings    ${tree22}    ['JOB']