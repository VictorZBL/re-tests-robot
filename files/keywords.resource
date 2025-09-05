*** Settings ***
Library    RemoteSwingLibrary
Library    help_func.py


*** Keywords ***
Setup before every tests
    Backup Savedconnections File
    ${path_to_exe}=    Get Path
    # Log    ${path_to_exe}    console=True
    TRY
        Start Application    rdb_expert    ${path_to_exe}    timeout=20   
        # Start Application    rdb_expert     java -javaagent:D:/re-tests-robot/lib/jacocoagent.jar=destfile=D:/re-tests-robot/results/jacoco.exec,output=file -jar D:/projects/rdbExpert/rdbexpert.jar -exe_path=D:/projects/RedExpert/bin/RDBExpert.exe    timeout=20
    EXCEPT    RemoteSwingLibraryTimeoutError: Agent port not received before timeout
        Log    RDBExpert failed to launch    console=True
        Kill Rdbexpert
    END

    Select Main Window

Teardown after every tests
    System Exit    0
    Unlock Employee
    Clear History Files
    Restore Savedconnections File        

Open connection
    Click On Tree Node    0    New Connection    2

Connect To RDBExpert
    Application Started    rdb_expert    timeout=20    remote_port=60900
    Select Main Window