![](https://raw.github.com/PaulWagener/Pass-Creator/master/Icon@2x.png)

Pass Creator
============

iPhone app to design and test passes right on the iPhone itself.

Instructions
==========================

1. Go to the [Pass Type IDs](https://developer.apple.com/ios/manage/passtypeids/index.action) Provisioning Portal and
follow the instructions to create a new pass type identifier.
   Be sure to re-download your provisioning profiles after you enabled passes on your app id.

2. Export your newly created private key as a p12 file from the OS X Keychain.
   Convert it to a certificate.pem and key.pem file on the command line:

   ```
   openssl pkcs12 -in "Certificates.p12" -clcerts -nokeys -out certificate.pem 
   openssl pkcs12 -in "Certificates.p12" -nocerts -out key.pem
   ```
   Be sure to provide a PEM passphrase with atleast four characters in it, otherwise it won't work.
   
   Copy both files to the root of the Pass Creator project.

3. Change the bundle identifier of the app to the app id you chose for the Pass Type ID in step 1

4. Start the app and design some pretty passes. You can preview them on the phone itself
   and get the passes by e-mailing them to yourself.
