# batch-caesar-en-de-crypter
Encrypting and decrypting a txt file in batch, using Caesars cipher method

##cipher.bat file
This is where the encrypting and decrypting happens.
    1) Checking the file to encrypt or decrypt and counts the total lines to calculate and draw the progress bar.
    2) Checking if there is a decripted or encrypted file.
      A) If a decrypted file exists, then it is encrypted.
      B) If an encrypted file exists, then it is decrypted.
    3) During the either encryption or decryption loops, a progress bar is drawn based on the lines that are encrypted or decrypted.
    4) When finished, the old file is deleted
  
##Reader.bat file
This is where the encrypted file is temporarily decripted for read purposes
    1) Checking if an encrypted file exists and exits if it does not.
    2) Counting the total lines to calculate and draw the progress bar.
    3) Decrypting the encrypted file while drawing the progress bar.
    4) Saving the decrypted file for reading for some seconds.
    5) Showing a message that the decrypted file is ready for reading and it will be deleted after a few seconds.
    6) After a few seconds or after user-confirmation, the decrypted file is deleted.
