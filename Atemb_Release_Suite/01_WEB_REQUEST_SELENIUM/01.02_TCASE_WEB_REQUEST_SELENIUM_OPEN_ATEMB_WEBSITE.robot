*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${URL}    https://atemb-website.vercel.app/

*** Test Cases ***
TCASE_WEB_REQUEST_SELENIUM_OPEN_ATEMB_WEBSITE
    [Documentation]    
    ...    Copyright details, 2025 Atemb
    ...    TCASE_WEB_REQUEST_SELENIUM_OPEN_EMBEFF_WEBSITE
    ...    Open the Atemb website
    ...    and take a screenshot
    ...    and close the browser
    ...    and save the screenshot to the output folder
    ...    @author: Atembedd
    ...    @version: 1.0
    ...    @last_updated: 2025-01-01
    [Tags]    web    request    selenium    atemb
    [Setup]    Open Browser    ${URL}    edge
    Maximize Browser Window
    Capture Page Screenshot
    [Teardown]    Close Browser