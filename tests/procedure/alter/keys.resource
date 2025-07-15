*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../../files/keywords.resource

*** Keywords ***
Setup
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    Skip If    ${{$ver == '2.6'}}
    Setup before every tests
