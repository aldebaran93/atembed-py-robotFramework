*** Settings ***
Library     SerialLibrary
Library     String
Library     OperatingSystem
Library     ../../Atemb_Keywords_Library/python_library/FirmwareCustomLibrary.py    WITH NAME    pyBaseFirmware

*** Variables ***
${PORT}     COM3    #/dev/ttyUSB0 for Linux
${FIRMWARE_FILE}    ${CURDIR}${/}atemb_stm32f401re.bin

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
    pyBaseFirmware.Connect To Target
    ${CONNECTION}    get_function_logs
    Should Contain    ${CONNECTION}    Connected to the STM32 microcontroller.
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
    pyBaseFirmware.Flash Firmware To Target    ${FIRMWARE_FILE}
    ${UPDATE_STATUS}    get_function_logs
    Should Contain    ${UPDATE_STATUS}    Firmware flashed from ${FIRMWARE_FILE}
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
    pyBaseFirmware.Erase Firmware From Target
    ${ERASE_STATUS}    get_function_logs
    Should Contain    ${ERASE_STATUS}    Flash memory erased.
    [Teardown]    local_teardown

LIST_AVAILABLE_REGISTERS
    [Documentation]    List available registers
    ...    This keyword will list all the available registers on the target.
    ...    @Author: Atemb
    ...    @Date: 2025-02-01
    ...    @Version: 1.0
    ...    @TestID: TCASE_TEST_OCD_003
    ...    @TestType: Functional
    ...    @TestPriority: High
    ...    @TestStatus: Ready
    ...    @TestPreconditions: The target should be connected with OCD
    ...    @TestSteps:
    ...    1. List available registers
    ...    @TestExpectedResults:
    ...    1. The registers should be listed successfully
    [Tags]    OCD
    [Setup]    pyBaseFirmware.Connect To Target
    ${REGISTERS}    pyBaseFirmware.List Core Registers
    Should Not Be Empty    ${REGISTERS}
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
    ${REGISTER_VALUE}    pyBaseFirmware.Read Register    r0    # Example register address
    Should Not Be Empty    ${REGISTER_VALUE}
    [Teardown]    local_teardown

*** Keywords ***
local_teardown
    pyBaseFirmware.Disconnect From Target
    ${CONNECTION}    get_function_logs
    Should Contain    ${CONNECTION}    Connection closed.