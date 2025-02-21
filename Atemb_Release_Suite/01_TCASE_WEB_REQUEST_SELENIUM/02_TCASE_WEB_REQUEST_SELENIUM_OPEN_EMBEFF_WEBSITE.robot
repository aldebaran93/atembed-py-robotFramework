*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${URL}    https://www.embeff.com/

*** Test Cases ***
TCASE_WEB_REQUEST_SELENIUM_OPEN_EMBEFF_WEBSITE
    [Documentation]    
    ...    Copyright details, 2025 Atembedd
    ...    TCASE_WEB_REQUEST_SELENIUM_OPEN_EMBEFF_WEBSITE
    ...    Open the Embeff website
    ...    and take a screenshot
    ...    and close the browser
    ...    and save the screenshot to the output folder
    ...    @author: Atembedd
    ...    @version: 1.0
    ...    @last_updated: 2025-01-01
    [Tags]    web    request    selenium    embeff
    [Setup]    Open Browser    ${URL}    edge
    Maximize Browser Window
    Capture Page Screenshot
    [Teardown]    Close Browser