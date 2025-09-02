*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../files/keywords.resource

*** Keywords ***
Teardown  
    Teardown after every tests
    Restore Audit Profiles
