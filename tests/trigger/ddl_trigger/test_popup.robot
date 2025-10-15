*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../../files/keywords.resource
Resource    ../keys.resource
Resource    key.resource
Test Setup       Setup
Test Teardown    Teardown after every tests

*** Test Cases ***
test_active
    Popup Active    CREATE OR ALTER TRIGGER NEW_TRIGGER ACTIVE BEFORE ANY DDL STATEMENT POSITION 0 AS BEGIN END    DDL Triggers (1)
