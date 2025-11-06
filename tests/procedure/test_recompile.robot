*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../files/keywords.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_1
    Open connection
    Recompile
    Recompile
    

*** Keywords ***
Recompile
    Run Keyword In Separate Thread    Select From Tree Node Popup Menu    0    New Connection|Procedures (10)    Recompile all procedures
    Select Dialog    Confirmation
    Label Text Should Be    0    All Procedures will be recompiled. Continue?
    Push Button    Yes
    Select Dialog    Commiting changes
    FOR    ${row_proc}    IN RANGE    10
        Click On Table Cell    0    ${row_proc}    Name operation
        ${status}=    Get Table Cell Value    0    ${row_proc}    Status
        Should Be Equal As Strings    ${status}    Success
    END
    Push Button    OK
    Select Main Window