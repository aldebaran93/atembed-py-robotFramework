*** Settings ***
Library     SerialLibrary
Library     String
Library     ../../Atemb_Keywords_Library/python_library/FirmwareCustomLibrary.py    WITH NAME    pyBaseFirmware

*** Variables ***
${PORT}     COM3    #/dev/ttyUSB0 for Linux
${FIRMWARE_FILE}    ../../firmware.bin

*** Test Cases ***
CONNECT_TO_TARGET_WITH_OCD
    [Documentation]    Connect to the target with OCD
    ...    This keyword will log in to the target with the OCD interface.
    ...    @Author: Atemb
    ...    @Date: 2025-02-01
    ...    @Version: 1.0
    ...    @TestID: TCASE_TEST_OCD_000
    ...    @TestType: Setup
    ...    @TestPriority: High
    ...    @TestStatus: Ready
    ...    copyright: Atemb
    [Tags]    OCD
    [Setup]    SerialLibrary.Com Port Should Exist Regexp    ${PORT}
    ${CONNECTION}    pyBaseFirmware.Connect To Target
    Should Contain    ${CONNECTION}    Connected to target
    [Teardown]    local_teardown

PERFORM_FIRMWARE_UPDATE
    [Documentation]    Perform a firmware update
    ...    This keyword will perform a firmware update on the target.
    ...    we will use the firmware file provided in the variable ${FIRMWARE_FILE}
    ...    @Author: Atemb
    ...    @Date: 2025-02-01
    ...    @Version: 1.0
    ...    @TestID: TCASE_TEST_OCD_001
    ...    @TestType: Functional
    ...    @TestPriority: High
    ...    @TestStatus: Ready
    ...    @TestPreconditions: The target should be connected with OCD
    ...    @TestSteps:
    ...    1. Perform a firmware update
    ...    @TestExpectedResults:
    ...    1. The firmware update should be successful
    [Tags]    OCD
    [Setup]    pyBaseFirmware.Connect To Target
    ${UPDATE_STATUS}    pyBaseFirmware.Load Binary File    ${FIRMWARE_FILE}
    Should Contain    ${UPDATE_STATUS}    Binary file loaded
    [Teardown]    local_teardown

PERFORM_FLASH_ERASE
    [Documentation]    Perform a flash erase
    ...    This keyword will erase the flash memory on the target.
    ...    @Author: Atemb
    ...    @Date: 2025-02-01
    ...    @Version: 1.0
    ...    @TestID: TCASE_TEST_OCD_002
    ...    @TestType: Functional
    ...    @TestPriority: High
    ...    @TestStatus: Ready
    ...    @TestPreconditions: The target should be connected with OCD
    ...    @TestSteps:
    ...    1. Perform a flash erase
    ...    @TestExpectedResults:
    ...    1. The flash erase should be successful
    [Tags]    OCD
    [Setup]    pyBaseFirmware.Connect To Target
    ${ERASE_STATUS}    pyBaseFirmware.Erase Target
    Should Contain    ${ERASE_STATUS}    Erase successful
    [Teardown]    local_teardown

READ_REGISTER_FROM_TARGET
    [Documentation]    Read a register
    ...    This keyword will read a register from the target.
    ...    the register address will be provided as an argument.
    ...    @Author: Atemb
    ...    @Date: 2025-02-01
    ...    @Version: 1.0
    ...    @TestID: TCASE_TEST_OCD_003
    ...    @TestType: Functional
    ...    @TestPriority: High
    ...    @TestStatus: Ready
    ...    @TestPreconditions: The target should be connected with OCD
    ...    @TestSteps:
    ...    1. Read a register
    ...    @TestExpectedResults:
    ...    1. The register value should be read successfully
    [Tags]    OCD
    [Setup]    pyBaseFirmware.Connect To Target
    ${REGISTER_VALUE}    pyBaseFirmware.Read Register    0x1234
    Should Not Be Empty    ${REGISTER_VALUE}
    [Teardown]    local_teardown

*** Keywords ***
local_teardown
    ${CONNECTION}    pyBaseFirmware.Disconnect From Target
    Should Contain    ${CONNECTION}    Disconnected from target