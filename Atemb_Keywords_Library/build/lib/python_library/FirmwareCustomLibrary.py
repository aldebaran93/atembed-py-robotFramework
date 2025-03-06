import serial
import time
from pyocd.core.helpers import ConnectHelper
from pyocd.flash.file_programmer import FileProgrammer
import logging
import io

class FirmwareCustomLibrary(object):
    ROBOT_LIBRARY_SCOPE = 'SUITE'

    def __init__(self, port="COM3", baudrate=9600, timeout=1):
        self.port = port
        self.baudrate = baudrate
        self.timeout = timeout
        self.ser = None
        self.target = None
        self.board = None
        self.flash = None
        self.log_capture = io.StringIO()  # Buffer to capture logs
        self.setup_logging()

    def open_serial_port(self):
        """Opens the serial port."""
        try:
            self.ser = serial.Serial(self.port, self.baudrate, timeout=self.timeout)
            time.sleep(2)  # Allow time for the connection
            return f"Serial port {self.port} opened successfully."
        except Exception as e:
            return f"Error opening serial port: {str(e)}"

    def write_serial(self, message):
        """Writes data to the serial port."""
        if self.ser and self.ser.is_open:
            self.ser.write(message.encode())
            return "Message sent"
        return "Serial port not open."

    def read_serial(self):
        """Reads data from the serial port."""
        if self.ser and self.ser.is_open:
            return self.ser.readline().decode().strip()
        return "Serial port not open."

    def close_serial_port(self):
        """Closes the serial port."""
        if self.ser and self.ser.is_open:
            self.ser.close()
            return f"Serial port {self.port} closed"
        return "Serial port was not open."
    
    def set_serial_gpios(self, gpio, value):
        """Sets the GPIO value."""
        if self.ser and self.ser.is_open:
            self.ser.write(value.encode())  # b'1' or b'0'
            self.ser.write(f"gpio set {gpio} {value}\n".encode())
            return "GPIO set"
        return "Serial port not open."
    
    def serial_gpios_status(self, status):
        """Gets the GPIO value."""
        """
        Reads the pin status from the STM32 over serial and returns a boolean value.
        - Returns True if the pin is HIGH.
        - Returns False if the pin is LOW.
        """
        if self.ser.in_waiting > 0:
            status = self.ser.readline().decode('utf-8').strip()  # Read and decode data
            if "HIGH" in status:
                status = "HIGH"
            elif "LOW" in status:
                status = "LOW"
        return status
    
    def get_serial_gpios_status(self, gpio):
        """Gets the GPIO value."""
        print(f"Listening for {gpio} status...")
        while True:
            pin_status = self.serial_gpios_status()
            if pin_status is not None:
                if pin_status:
                    print(f"{gpio} is HIGH")
                else:
                    print(f"{gpio} is LOW")

    def connect_to_target(self):
        """Establish a connection to the STM32 microcontroller."""
        self.session = ConnectHelper.session_with_chosen_probe()
        self.session.open()
        self.board = self.session.board
        self.target = self.board.target
        self.flash = self.target.memory_map.get_boot_memory()
        logging.info("Connected to the STM32 microcontroller.")
        logging.getLogger().handlers[0].flush()  # Flush the logs

    def erase_firmware_from_target(self):
        """Erase the flash memory of the STM32 microcontroller."""
        if not self.session:
            raise RuntimeError("Not connected to the STM32 microcontroller.")
        self.flash.erase_all()
        logging.info("Flash memory erased.")

    def flash_firmware_to_target(self, firmware_path):
        """Flash firmware to the STM32 microcontroller."""
        if not self.session:
            raise RuntimeError("Not connected to the STM32 microcontroller.")
        FileProgrammer(self.session).program(firmware_path)
        logging.info(f"Firmware flashed from {firmware_path}.")
        self.reset_target()
        
    def reset_target(self):
        """Reset the STM32 microcontroller."""
        if not self.session:
            raise RuntimeError("Not connected to the STM32 microcontroller.")
        self.target.reset()
        logging.info("STM32 microcontroller reset.")

    def read_register(self, register_name):
        """Read a core register from the STM32 microcontroller."""
        values = []
        if not self.session:
            raise RuntimeError("Not connected to the STM32 microcontroller.")
        self.target.reset_and_halt()
        value1 = self.target.read_core_register(register_name)
        logging.info(f"Register {register_name}: 0x{value1:X}")
        self.target.step()
        value2 = self.target.read_core_register(register_name)
        logging.info(f"Register {register_name}: 0x{value2:X}")
        self.target.resume()
        time.sleep(0.2)
        self.target.halt()
        value3 = self.target.read_core_register(register_name)
        logging.info(f"Register {register_name}: 0x{value3:X}")
        values.extend([value1, value2, value3])
        registers_values = set(values)
        if len(registers_values) == len(values):
            logging.info(f"Register {register_name} has different value.")
        else:
            logging.warning(f"Register {register_name} has same values.")
        self.target.resume()
        return values

    def write_register(self, register_name, value):
        """Write a value to a core register of the STM32 microcontroller."""
        if not self.session:
            raise RuntimeError("Not connected to the STM32 microcontroller.")
        self.target.write_core_register(register_name, value)
        logging.info(f"Register {register_name} set to 0x{value:X}.")

    def reset_and_halt_target(self):
        """Reset the STM32 microcontroller."""
        if not self.session:
            raise RuntimeError("Not connected to the STM32 microcontroller.")
        self.target.reset_and_halt()
        logging.info("STM32 microcontroller reset.")

    def disconnect_from_target(self):
        """Close the connection to the STM32 microcontroller."""
        if self.session:
            self.session.close()
            logging.info("Connection closed.")
        else:
            logging.info("No active connection to close.")
    
    def write_memory(self, address, data):
        '''Writes data to the target memory.'''
        self.flash.program(address, data)
        return "Memory written."
    
    def read_memory(self, address, length):
        '''Reads data from the target memory.'''
        return self.flash.read(address, length)
    
    def read_memory_as_hex(self, address, length):
        '''Reads data from the target memory and returns it as a hex string.'''
        return self.flash.read(address, length).hex()
    
    def read_memory_as_string(self, address, length):
        '''Reads data from the target memory and returns it as a string.'''
        return self.flash.read(address, length).decode()
    
    def read_memory_as_int(self, address, length):
        '''Reads data from the target memory and returns it as an integer.'''
        return int.from_bytes(self.flash.read(address, length), byteorder='big')
    
    def setup_logging(self):
        """Set up logging to capture logs into a buffer."""
        self.log_capture = io.StringIO()  # Reinitialize the buffer
        logging.basicConfig(
            level=logging.INFO,
            handlers=[logging.StreamHandler(self.log_capture)],
            force=True  # Override any existing logging configuration
        )

    def get_function_logs(self):
        """Return the captured logs as a string."""
        logs = self.log_capture.getvalue()
        self.log_capture.seek(0)  # Reset the buffer position
        self.log_capture.truncate(0)  # Clear the buffer
        return logs
    
    def read_core_registers(self, register):
        board = self.session.board
        target = board.target
        value = hex(target.read_core_register(register))
        if value is None:
            return None
        else:
            return value
        #print(f"{reg}: 0x{value:08X}")
    
    def write_core_registers(self, registers):
        board = self.session.board
        target = board.target

        # Write core registers
        target.write_core_registers(registers)
        return "Core registers written."
    
    def read_memory_block(self, address, length):
        '''Reads a block of memory.'''
        board = self.session.board
        target = board.target
        data = target.read_memory_block8(address, length)
        return data
    
    def write_memory_block(self, address, data):
        # Convert address to integer if it's a string
        if isinstance(address, str):
            address = int(address, 16)
        if data < 0 or data > 0xFF:
            raise ValueError(f"Value 0x{data:02X} is not a valid byte.")
        word_address = address & ~0x3  # Mask lower 2 bits to get the word-aligned address
        offset = address & 0x3         # Byte offset within the word
        existing_word = self.target.read32(word_address)
        modified_word = (existing_word & ~(0xFF << (offset * 8))) | (data << (offset * 8))
        self.target.write32(word_address, modified_word)
        logging.info(f"Memory block written at address 0x{address:08X}.")
    
    def read_memory_block_as_hex(self, address, length):
        '''Reads a block of memory and returns it as a hex string.'''
        data = self.read_memory_block(address, length)
        return data.hex()
    
    def read_memory_block_as_string(self, address, length):
        '''Reads a block of memory and returns it as a string.'''
        data = self.read_memory_block(address, length)
        return data.decode()
    
    def read_memory_block_as_int(self, address, length):
        '''Reads a block of memory and returns it as an integer.'''
        data = self.read_memory_block(address, length)
        return int.from_bytes(data, byteorder='big')
    
    def write_memory_block_as_hex(self, address, data):
        '''Writes a block of memory from a hex string.'''
        if isinstance(data, str):
            data = bytes.fromhex(data)
        elif isinstance(data, int):
            data = data.to_bytes((data.bit_length() + 7) // 8, byteorder='big')
        self.write_memory_block(address, data)
        return "Memory block written."
    
    def write_memory_block_as_string(self, address, data):
        '''Writes a block of memory from a string.'''
        data = data.encode()
        self.write_memory_block(address, data)
        return "Memory block written."
    
    def write_memory_block_as_int(self, address, data):
        '''Writes a block of memory from an integer.'''
        data = data.to_bytes((data.bit_length() + 7) // 8, byteorder='big')
        self.write_memory_block(address, data)
        return "Memory block written."