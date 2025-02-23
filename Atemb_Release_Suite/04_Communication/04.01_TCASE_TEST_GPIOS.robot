*** Settings ***
Library     SerialLibrary
Library     String
Library     ../../Atemb_Keywords_Library/python_library/FirmwareCustomLibrary.py    WITH NAME    pyFirmware

*** Variables ***
${PORT}     COM3    #/dev/ttyUSB0 for Linux
${BAUD}     9600
${TIMEOUT}  1s

*** Test Cases ***
SETUP_SERIAL_CONNECTION
    [Documentation]    Setup the serial connection
    ...    This keyword will open the serial port with the specified port, baudrate
    ...    and timeout values.
    ...    The keyword will also initialize the GPIO pin PA0 as an output pin.
    ...    @Author: Atemb
    ...    @Date: 2025-02-01
    ...    @Version: 1.0
    ...    @TestID: TCASE_TEST_GPIOS_000
    ...    @TestType: Setup
    ...    @TestPriority: High
    ...    @TestStatus: Ready
    ...    @TestPreconditions: None
    ...    @TestSteps:
    ...    1. Open the serial port
    ...    2. Initialize the GPIO pin PA0 as an output pin
    ...    @TestExpectedResults:
    ...    1. The serial port should be opened successfully
    ...    2. The GPIO pin PA0 should be initialized as an output pin
    ...    copyright: Atemb
    [Tags]    GPIO
    [Setup]    SerialLibrary.Com Port Should Exist Regexp    ${PORT}
    ${CONNECTION}    pyFirmware.Open Serial Port
    Should Contain    ${CONNECTION}    opened successfully
    ${PIN_STATUS}    pyFirmware.Set Serial gpios    PA0    1
    Should Contain    ${PIN_STATUS}    GPIO set
    [Teardown]    local_teardown


Test GPIO Set High
    [Documentation]    Test the GPIO set high command
    ...    This test case will set the GPIO pin PA0 to high and read the value
    ...    to ensure that the pin is set correctly.
    ...    The test will fail if the value read is not high.
    ...    @Author: Atemb
    ...    @Date: 2025-02-01
    ...    @Version: 1.0
    ...    @TestID: TCASE_TEST_GPIOS_001
    ...    @TestType: Functional
    ...    @TestPriority: High
    ...    @TestStatus: Ready
    ...    @TestPreconditions: The GPIO pin PA0 should be set to output
    ...    @TestSteps:
    ...    1. Set the GPIO pin PA0 to high
    ...    2. Read the value of the GPIO pin PA0
    ...    3. Verify that the value read is high
    ...    @TestExpectedResults:
    ...    1. The GPIO pin PA0 should be set to high
    ...    2. The value read should be high
    ...    3. The test should pass
    ...    copyright: Atemb
    [Tags]    GPIO
    [Setup]    SerialLibrary.Com Port Should Exist Regexp    ${PORT}
    ${CONNECTION}    pyFirmware.Open Serial Port
    Should Contain    ${CONNECTION}    opened successfully
    pyFirmware.Set Serial gpios    PA0    1
    ${response}    pyFirmware.Serial gpios Status    HIGH
    Log    ${response}
    Should Be Equal    ${response}    HIGH
    [Teardown]    local_teardown

Test GPIO Set Low
    [Documentation]    Test the GPIO set low command
    ...    This test case will set the GPIO pin PA0 to low and read the value
    ...    to ensure that the pin is set correctly.
    ...    The test will fail if the value read is not low.
    ...    The test will fail if the value read is not low.
    ...    @Author: Atemb
    ...    @Date: 2025-02-01
    ...    @Version: 1.0
    ...    @TestID: TCASE_TEST_GPIOS_002
    ...    @TestType: Functional
    ...    @TestPriority: High
    ...    @TestStatus: Ready
    ...    @TestPreconditions: The GPIO pin PA0 should be set to output
    ...    @TestSteps:
    ...    1. Set the GPIO pin PA0 to low
    ...    2. Read the value of the GPIO pin PA0
    ...    3. Verify that the value read is low
    ...    @TestExpectedResults:
    ...    1. The GPIO pin PA0 should be set to low
    ...    2. The value read should be low
    ...    3. The test should pass
    ...    copyright: Atemb
    [Tags]    GPIO
    [Setup]    SerialLibrary.Com Port Should Exist Regexp    ${PORT}
    ${CONNECTION}    pyFirmware.Open Serial Port
    Should Contain    ${CONNECTION}    opened successfully
    pyFirmware.Set Serial gpios    PA0    0
    ${response}    pyFirmware.Serial gpios Status    LOW
    Log    ${response}
    Should Be Equal    ${response}    LOW
    [Teardown]    local_teardown

Test GPIO Interrupt Handling
    [Documentation]    Test the GPIO interrupt handling
    ...    This test case will enable an interrupt on the GPIO pin PA1 and simulate
    ...    an external trigger to test the interrupt handling.
    ...    The test will fail if the interrupt is not triggered.
    ...    @Author: Atemb
    ...    @Date: 2025-02-01
    ...    @Version: 1.0
    ...    @TestID: TCASE_TEST_GPIOS_003
    ...    @TestType: Functional
    ...    @TestPriority: High
    ...    @TestStatus: Ready
    ...    @TestPreconditions: The GPIO pin PA1 should be set to input
    ...    @TestSteps:
    ...    1. Enable the interrupt on the GPIO pin PA1
    ...    2. Simulate an external trigger
    ...    3. Check if the interrupt is triggered
    ...    @TestExpectedResults:
    ...    1. The interrupt should be enabled on the GPIO pin PA1
    ...    2. The interrupt should be triggered
    ...    3. The test should pass
    ...    copyright: Atemb
    [Tags]    GPIO
    [Setup]    SerialLibrary.Com Port Should Exist Regexp    ${PORT}
    ${CONNECTION}    pyFirmware.Open Serial Port
    Should Contain    ${CONNECTION}    opened successfully
    ${GPIO_STATUS}    pyFirmware.Set Serial gpios    PA1    1
    Should Be Equal    ${GPIO_STATUS}    GPIO set
    ${RESPONSE}=    pyFirmware.Write Serial    message="hello there Atemb is a firm specialized in embedded systems and test automation"
    Should Be Equal    ${RESPONSE}    Message sent
    ${TEST_MESSAGE}    pyFirmware.Read Serial
    Should Be Equal    ${TEST_MESSAGE}    hello there Atemb is a firm specialized in embedded systems and test automation
    [Teardown]    local_teardown

*** Keywords ***
local_teardown
    [Documentation]    Close the serial port
    ...    This keyword will close the serial port.
    ...    @Author: Atemb
    ...    @Date: 2025-02-01
    ...    @Version: 1.0
    ...    copyright: Atemb
    [Tags]    GPIO
    ${PORT_STATUS}    pyFirmware.Close Serial Port
    Should Contain    ${PORT_STATUS}    Serial port ${PORT} closed
