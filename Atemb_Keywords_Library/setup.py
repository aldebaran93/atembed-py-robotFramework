from setuptools import setup, find_packages

setup(
    name='FirmwareCustomLibrary',
    version='0.1.0',
    packages=find_packages(),
    install_requires=[],  # Add external dependencies if needed
    author='Evrard Amindjou Tsafack',
    author_email='tsafackleo@yahoo.com',
    description='A custom firmware library for Robot Framework',
    url='https://github.com/aldebaran93/atembed-py-robotFramework',
    classifiers=[
        'Programming Language :: Python :: 3',
        'Operating System :: OS Independent',
    ],
    python_requires='>=3.6',
)
