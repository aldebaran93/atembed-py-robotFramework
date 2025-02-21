*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Library    String
Library    DateTime
Library    Collections
Library    Screenshot
Library    Process

*** Variables ***
${URL}    https://www.bing.com/

*** Test Cases ***
TCASE_WEB_REQUEST_SELENIUM
    [Documentation]    
    ...    TCASE_WEB_REQUEST_SELENIUM
    ...    Open the Bing website
    ...    and search for "Selenium"
    ...    and take a screenshot
    ...    and close the browser
    ...    and save the screenshot to the output folder
    ...    @author: Atembedd
    ...    @version: 1.0
    ...    @last_updated: 2025-01-01
    [Tags]    web    request    selenium    bing
    [Setup]    Open Browser    ${URL}    edge
    Maximize Browser Window
    Input Text    name=q    Selenium
    Press Keys    name=q    \\13
    Capture Page Screenshot
    [Teardown]    Close Browser