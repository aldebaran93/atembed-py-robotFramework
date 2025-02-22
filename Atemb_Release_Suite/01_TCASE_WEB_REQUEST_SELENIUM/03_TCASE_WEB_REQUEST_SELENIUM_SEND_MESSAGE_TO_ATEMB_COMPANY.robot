*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem

*** Variables ***
${URL}    https://atemb-website.vercel.app/
${SURNAME_FIELD}  xpath=//input[@name="surname"]  # Update locator if needed
${NAME_FIELD}  xpath=//input[@name="name"]
${EMAIL_FIELD}  xpath=//input[@name="email"]
${MESSAGE_FIELD}  xpath=//textarea[@name="message"]
${SEND_BUTTON}  xpath=//button[contains(text(),'Send Message')]
${OUTPUT_FOLDER}    ${CURDIR}\\output\\
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
    Input Text    ${SURNAME_FIELD}    BETE
    Input Text    ${NAME_FIELD}    Sylvie
    Input Text    ${EMAIL_FIELD}    sylviebete2706@yahoo.com
    Input Text    ${MESSAGE_FIELD}    Hello Atemb! I am Sylvie BETE. I would like to know more about your services.
    Click Button    ${SEND_BUTTON}
    
    #Capture Page Screenshot    filename=${screenshot_file}
    IF    $OUTPUT_FOLDER
        Capture Page Screenshot    ${SCREENSHOT_FILE}
    ELSE
        Log    Output folder is not set
        Create Dictionary    ${OUTPUT_FOLDER}
        Capture Page Screenshot    ${SCREENSHOT_FILE}
    END
    [Teardown]    Close Browser