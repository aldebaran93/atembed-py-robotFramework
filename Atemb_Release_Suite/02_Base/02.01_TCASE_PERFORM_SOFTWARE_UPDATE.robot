*** Settings ***
Library     SerialLibrary
Library     String
Library     OperatingSystem
Library     ../../Atemb_Keywords_Library/python_library/FirmwareCustomLibrary.py    WITH NAME    pyBaseFirmware

*** Variables ***
${PORT}     COM3    #/dev/ttyUSB0 for Linux
${FIRMWARE_FILE}    ${CURDIR}${/}atemb_stm32f401re.bin
${REGISTER}    pc

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
    Sleep    30s
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
    Should Contain    ${ERASE_STATUS}    Flash memory erased
    [Teardown]    local_teardown

READ_REGISTERS_VALUES
    [Documentation]    read registers values
    ...    This keyword will read registers values on the target.
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
    ${REGISTERS}    pyBaseFirmware.Read Register    ${REGISTER}
    Should Not Be Empty   ${REGISTERS}
    Log    ${REGISTERS}
    ${LOG_OUTPUT}    get_function_logs
    Should Contain    ${LOG_OUTPUT}    Register ${REGISTER} has different value.
    [Teardown]    local_teardown

WRITE_MEMORY_BLOCK_VALUES
    [Documentation]    write memory block values
    ...    This keyword will write memory block values on the target.
    ...    here we will write the memory block values to the target.
    ...    @Author: Atemb
    ...    @Date: 2025-02-01
    ...    @Version: 1.0
    ...    @TestType: Functional
    ...    @TestPriority: High
    ...    @TestStatus: Ready
    ...    @TestPreconditions: The target should be connected with OCD
    ...    @TestSteps:
    ...    1. Write memory block values
    ...    @TestExpectedResults:
    ...    1. The memory block values should be written successfully
    [Tags]    OCD
    [Setup]    pyBaseFirmware.Connect To Target
    pyBaseFirmware.Write Memory Block   0x08000000    ${0x0A}
    ${MEMORY_BLOCK}    pyBaseFirmware.Get Function Logs
    Should Contain    ${MEMORY_BLOCK}    Memory block written at address
    Log    ${MEMORY_BLOCK} is the memory block values
    [Teardown]    local_teardown

READ_MEMORY_BLOCK_VALUES
    [Documentation]    read memory block values
    ...    This keyword will read memory block values on the target.
    ...    here we will read the memory block values from the target.
    ...    @author: Atemb
    ...    @date: 2025-02-01
    ...    @version: 1.0   
    ...    @testType: Functional
    ...    @testPriority: High
    ...    @testStatus: Ready
    ...    @testPreconditions: The target should be connected with OCD
    ...    @testSteps:
    ...    1. Read memory block values
    ...    @testExpectedResults:
    ...    1. The memory block values should be read successfully
    [Tags]    OCD
    [Setup]    pyBaseFirmware.Connect To Target
    ${MEMORY_BLOCK}    pyBaseFirmware.Read Memory Block    ${0x08000000}    ${0x0A}
    Should Not Be Empty    ${MEMORY_BLOCK}
    Log    ${MEMORY_BLOCK} is the memory block values
    [Teardown]    local_teardown


*** Keywords ***
local_teardown
    [Documentation]    Disconnect from the target
    ...    This keyword will disconnect from the target.
    pyBaseFirmware.Reset Target
    pyBaseFirmware.Disconnect From Target
    ${CONNECTION}    get_function_logs
    Should Contain    ${CONNECTION}    Connection closed.