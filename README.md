Pass-Creator
============

iPhone app to locally design and test passes

Instructions
==========================

1. Go to the [Pass Type IDs](https://developer.apple.com/ios/manage/passtypeids/index.action) Provisioning Portal and
follow the instructions.

2. Export your newly created private key as a p12 file from the OS X Keychain.
   Convert it to a certificate.pem and key.pem file on the command line:

   ```
   openssl pkcs12 -in "Certificates.p12" -clcerts -nokeys -out certificate.pem 
   openssl pkcs12 -in "Certificates.p12" -nocerts -out key.pem
   ```
   
   Copy these files to the Pass Creator project.

