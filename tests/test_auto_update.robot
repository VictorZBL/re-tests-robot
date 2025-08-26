*** Settings ***
Library    RemoteSwingLibrary
Library    OperatingSystem
Resource    ../files/keywords.resource
Test Teardown    Teardown   

*** Test Cases ***    
no_reload
    ${path_to_exe}=    Test Api    \nupdate.use.https=false\nupdate.check.url=http\://localhost/?project=redexpert&version=9999.98\nupdate.check.rc.url=http\://localhost/?project=redexpert&version=9999.98&showrc=true
    No Reload    ${path_to_exe}

auto_reload
    [Timeout]
    ${path_to_exe}=    Test Api    \nupdate.use.https=false\nupdate.check.url=http\://localhost/?project=redexpert&version=9999.98\nupdate.check.rc.url=http\://localhost/?project=redexpert&version=9999.98&showrc=true
    Auto Reload

skip_version
    Start Red Expert    \nupdate.use.https=false\nupdate.check.url=http\://localhost/?project=redexpert&version=9999.98\nupdate.check.rc.url=http\://localhost/?project=redexpert&version=9999.98&showrc=true
    Push Button    skipVersionButton
    ${home_dir}=	Normalize Path    ~
    VAR    ${skipped_version_file_path}    ${home_dir}${/}.redexpert${/}skipped-version.re
    File Should Exist    ${skipped_version_file_path}
    ${content}=    Get File    ${skipped_version_file_path}
    Should Be Equal As Strings    ${content}    9999.98

    Teardown
    Start Red Expert    \nupdate.use.https=false\nupdate.check.url=http\://localhost/?project=redexpert&version=9999.99\nupdate.check.rc.url=http\://localhost/?project=redexpert&version=9999.99&showrc=true
    Remove File    ${skipped_version_file_path}

remind_later
    ${path_to_exe}=    Start Red Expert    \nupdate.use.https=false\nupdate.check.url=http\://localhost/?project=redexpert&version=9999.98\nupdate.check.rc.url=http\://localhost/?project=redexpert&version=9999.98&showrc=true
    Push Button    remindLaterButton
    System Exit    0
    Sleep    1s
    Start Application    red_expert    ${path_to_exe}    timeout=30    remote_port=60900
    Select Main Window
    Sleep    0.5s
    Select Dialog    Red Expert Update

*** Keywords ***
Start Red Expert
    [Arguments]    ${urls}
    Run Server
    Backup User Properties
    Set Urls   urls=${urls}
    ${path_to_exe}=    Copy Dist Path
    # Log    ${path_to_exe}    console=True
    Start Application    red_expert    ${path_to_exe}    timeout=30    remote_port=60900
    Select Main Window
    Sleep    0.5s
    Select Dialog    Red Expert Update
    RETURN    ${path_to_exe}

Stop Red Expert
    System Exit    0

Teardown
    Stop Server
    Kill Redexpert
    Teardown after every tests
    Restore User Properties

Test Api
    [Arguments]    ${urls}
    ${path_to_exe}=    Start Red Expert    ${urls}
    Push Button      startUpdateButton
    Sleep       10s    
    Select Dialog    Update downloaded
    Copy Updater
    RETURN   ${path_to_exe}

Copy Updater   
    ${dist}=    Get Environment Variable    DIST    C:/Program Files/RedExpert
    Copy File    ${dist}${/}Updater.jar    ${TEMPDIR}${/}RedExpert${/}Updater.jar

No Reload
    [Arguments]    ${path_to_exe}
    Push Button      No
    Select Dialog    Message
    Push Button      OK
    System Exit    0
    Sleep       10s
    Start Application    red_expert    ${path_to_exe}    timeout=30    remote_port=60900
    Select Window    regexp=^Red Expert - 2025\.06.*

Auto Reload
    Push Button      Yes
    Sleep    10s
    TRY
        Application Started    red_expert    timeout=30    remote_port=60900
        Select Window    regexp=^Red Expert - 2025\.06
    EXCEPT  
        Kill Redexpert
        Fail    Red Expert run without JAVA_TOOL_OPTIONS
    END