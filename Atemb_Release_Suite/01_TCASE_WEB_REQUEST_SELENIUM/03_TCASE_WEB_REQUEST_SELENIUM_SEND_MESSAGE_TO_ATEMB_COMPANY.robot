*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem

*** Variables ***
${URL}    https://atemb-website.vercel.app/
${COMPANY_NAME}    Atemb
${COMPANY_EMAIL}    info@atemb.com
${COMPANY_MESSAGE}    Hello, ${COMPANY_NAME}! I am interested in your services. Please contact me at ${COMPANY_EMAIL}.
${OUTPUT_FOLDER}    ${CURDIR}${/}output${/}
${SCREENSHOT_FILE}    ${OUTPUT_FOLDER}Atemb_Website.png

*** Test Cases ***
TCASE_WEB_REQUEST_SELENIUM_SEND_MESSAGE_TO_ATEMB_COMPANY
    [Documentation]    
    ...    Copyright details, 2025 Atemb
    ...    TCASE_WEB_REQUEST_SELENIUM_SEND_MESSAGE_TO_ATEMB_COMPANY
    ...    Send a message to the Atemb company
    ...    and take a screenshot
    ...    and close the browser
    ...    and save the screenshot to the output folder

    [Tags]    web    request    selenium    atemb
    [Setup]    Open Browser    ${URL}    edge
    Maximize Browser Window
    Input Text    id=company_name    ${COMPANY_NAME}    clear=1
    Input Text    id=company_email    ${COMPANY_EMAIL}    clear=1
    Input Text    id=company_message    ${COMPANY_MESSAGE}    clear=1
    
    Run Keyword If    '${OUTPUT_FOLDER}' != ''    Run Keyword    SAVE_SCREENSHOT    ${SCREENSHOT_FILE}
    [Teardown]    Close Browser

*** Keywords ***
SAVE_SCREENSHOT
    [Arguments]    ${file_path}
    Capture Page Screenshot
    Run Keyword If    '${file_path}' != ''    Save Screenshot    ${file_path}