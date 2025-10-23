*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../files/keywords.resource


*** Keywords ***
Init Grant Manager
    Setup before every tests
    Open connection
    Select From Menu        Tools|Grant Manager
    Sleep    1s
    