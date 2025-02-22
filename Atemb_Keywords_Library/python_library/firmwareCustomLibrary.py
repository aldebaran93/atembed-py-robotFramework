import os
import sys
import paramiko

class FirmwareCustomLibrary(object):
    ROBOT_LIBRARY_SCOPE = 'GLOBAL'

    def __init__(self):
        self.path = os.path.abspath(os.path.join(os.path.dirname(__file__), os.pardir))
        sys.path.append(self.path)
        print(self.path)

    def get_path(self):
        return self.path
        
    def ssh_connect(self, host, username, password):
        self.ssh = paramiko.SSHClient()
        self.ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        self.ssh.connect(host, username=username, password=password)
        return self.ssh
    
    