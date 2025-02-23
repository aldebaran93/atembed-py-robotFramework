import os
import sys
import paramiko
import serial
import time

class FirmwareCustomLibrary(object):
    ROBOT_LIBRARY_SCOPE = 'SUITE'

    def __init__(self, port="COM3", baudrate=9600, timeout=1):
        self.port = port
        self.baudrate = baudrate
        self.timeout = timeout
        self.ser = None

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