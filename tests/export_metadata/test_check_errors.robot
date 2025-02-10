*** Settings ***
Library    RemoteSwingLibrary
Resource   ../../files/keywords.resource 
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests
Test Timeout    60s

*** Test Cases ***
test_1
    Open connection
    Select From Tree Node Popup Menu    0    New Connection    Extract Metadata
    Select Tab As Context    SQL    
    Push Button    saveScriptButton
    Select Dialog    Warning
    Push Button    OK

    Select Window    regexp=^RDB.*
    Select Tab As Context    SQL
    Push Button    executeScriptButton
    Select Dialog    Warning
    Push Button    OK
    
    Select Window    regexp=^RDB.*
    Push Button    selectAllExtractAttributesButton
    Push Button    executeScriptButton
    Select Dialog    Warning
    Push Button    OK