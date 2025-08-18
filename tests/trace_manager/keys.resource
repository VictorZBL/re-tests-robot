*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../files/keywords.resource

*** Keywords ***
Setup
    Backup Audit Profiles
    Setup before every tests

Teardown  
    Teardown after every tests
    Restore Audit Profiles
