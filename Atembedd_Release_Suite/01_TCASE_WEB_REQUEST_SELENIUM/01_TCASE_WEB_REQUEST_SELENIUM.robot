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
    [Documentation]    TCASE_WEB_REQUEST_SELENIUM
    Open Browser    ${URL}    edge
    Maximize Browser Window
    Input Text    name=q    Selenium
    #Click Button    name=btnK
    Capture Page Screenshot
    Close Browser