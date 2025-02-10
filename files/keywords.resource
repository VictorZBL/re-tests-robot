*** Settings ***
Library    RemoteSwingLibrary
Library    help_func.py


*** Keywords ***
Setup before every tests
    ${path_to_exe}=    Get Path
    Log    ${path_to_exe}    console=True
    TRY
        Start Application    rdb_expert    ${path_to_exe}    timeout=20   
        # Start Application    rdb_expert     java -javaagent:D:/re-tests-robot/lib/jacocoagent.jar=destfile=D:/re-tests-robot/results/jacoco.exec,output=file -jar D:/projects/rdbExpert/RDBExpert.jar -exe_path=D:/projects/RedExpert/bin/RDBExpert.exe    timeout=20
    EXCEPT    RemoteSwingLibraryTimeoutError: Agent port not received before timeout
        Log    RDBExpert failed to launch    console=True
        Kill Rdbexpert
    END

    Select Window    regexp=^RDB.*

Teardown after every tests
    System Exit    0
    Unlock Employee
    Clear History Files        

Open connection
    Click On Tree Node    0    New Connection    2
