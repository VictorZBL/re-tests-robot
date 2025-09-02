*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../files/keywords.resource


*** Keywords ***
Setup before export data
    Open connection
    Clear Text Field    0
    Insert Into Text Field    0    SELECT * FROM EMPLOYEE
    Push Button    execute-script-command
    Sleep    1s
    Select Table Cell Area    0    1    4    19    24    
    Select From Table Cell Popup Menu On Selected Cells    0    Export|Selection
    Select Dialog    Export Data

Set blobs
    Execute Immediate    UPDATE "PROJECT" SET PROJ_DESC = 'Design a video data base management system for\ncontrolling on-demand video distribution.\n' WHERE PROJ_ID = 'VBASE'
    Execute Immediate    UPDATE "PROJECT" SET PROJ_DESC = 'Develop second generation digital pizza maker\nwith flash-bake heating element and\ndigital ingredient measuring system.\n' WHERE PROJ_ID = 'DGPII'
    Execute Immediate    UPDATE "PROJECT" SET PROJ_DESC = 'Develop a prototype for the automobile version of\nthe hand-held map browsing device.\n' WHERE PROJ_ID = 'GUIDE'
    Execute Immediate    UPDATE "PROJECT" SET PROJ_DESC = 'Port the map browsing database software to run\non the automobile model.\n' WHERE PROJ_ID = 'MAPDB'
    Execute Immediate    UPDATE "PROJECT" SET PROJ_DESC = 'Integrate the hand-writing recognition module into the\nuniversal language translator.\n' WHERE PROJ_ID = 'HWRII'
    Execute Immediate    UPDATE "PROJECT" SET PROJ_DESC = 'Expand marketing and sales in the Pacific Rim.\nSet up a field office in Australia and Singapore.\n' WHERE PROJ_ID = 'MKTPR'