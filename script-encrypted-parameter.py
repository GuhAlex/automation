from cryptography.fernet import Fernet
import sys
from pathlib import Path

def write_key():
    """
    Generates a key and save it into a file
    """
    key = Fernet.generate_key()
    with open("private.key", "wb") as key_file:
        key_file.write(key)

def load_key(file):
    """
    Loads the key from the current directory named `key.key`
    """
    return open(str(file), "rb").read()

def encrypt(filename, key):
    """
    Given a filename (str) and key (bytes), it encrypts the file and write it
    """
    f = Fernet(key)
    with open(filename, "rb") as file:
        # read all file data
        file_data = file.read()
     # encrypt data
    encrypted_data = f.encrypt(file_data)
    # write the encrypted file
    with open(filename, "wb") as file:
        file.write(encrypted_data)

def decrypt(filename, key):
    """
    Given a filename (str) and key (bytes), it decrypts the file and write it
    """
    f = Fernet(key)
    with open(filename, "rb") as file:
        # read the encrypted data
        encrypted_data = file.read()
    # decrypt data
    decrypted_data = f.decrypt(encrypted_data)
    # write the original file
    with open(filename, "wb") as file:
        file.write(decrypted_data)

if __name__ == "__main__":
    #write_key()
    fileToConvert = "main.tf"
    privateKey = load_key(str(sys.argv[1]))
    if sys.argv[2] == "decrypt":
      #  for fileToConvert in Path('.').rglob('parameter.tf'):
         decrypt(fileToConvert, privateKey)
       #     print("Decripted:", str(fileToConvert))
    elif  sys.argv[2] == "encrypt":
      #  for fileToConvert in Path('.').rglob('parameter.tf'):
        encrypt(fileToConvert, privateKey)
        #    print("Encripted:", str(fileToConvert))
    else:
        print("Choose a valid option!")
        print("py main.py <privateKeyFile> <Conversion Option>")
        print("Conversion Options: decrypt or encrypt")
        
    
