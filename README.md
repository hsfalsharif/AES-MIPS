# AES-MIPS

An implementation of Advanced Encryption Standard (AES) in MIPS assembly language. The project was done by a team of KFUPM students: Hamza Alsharif, Adnan Aldajani, Saleh Aldameqh, Mohammed Aloraifi, Yousef Alamri, Mohtdi Abdelrhman, and Yousef Almushayqih under the supervision of Mr Saleh Al Saleh.

# Files

The repository includes the encrypt and decrypt functions, the Mars MIPS assembler as well as an example pgm image. any other suitably small pgm image can be used and for encryption and decryption as well.

# Running the Code

To run the code the Mars assembler is included in the repository and should be used to open the encryption and decryption files. Note that the assembler must be in the same directory as the assembly and image files for the code to work, otherwise the mars assembler will be unable to find the required files and will produce an error. Next press F3 to assemble the file (or the spanner and screwdriver icon in the toolbar). After assembling the file run it by pressing F5 or the green play button. It will take a while to finish all of the encryption. After it finishes a new "encrypted" .pgm file will show up in the directory. It can be viewed using a pgm image viewer such as Irfanview. Next run the decrypt procedure in the same way as for the encrypt procedure. A new "decrypted" pgm file will show up and it should be exactly the same as the original image.
