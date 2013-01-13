
#include <stdio.h>

#include "openssl/pem.h"
#include "openssl/pkcs7.h"
#include "openssl/err.h"

#include "PassBundleSign.h"
#include "Config.h"

/**
 * Load certificates
 */
PassBundleSign::PassBundleSign(const char *key_pem, const char *certificate_pem, const char *wwdr_cer) {
    OpenSSL_add_all_algorithms();
	ERR_load_crypto_strings();
    
	/* Read in signer certificate and private key */
	BIO *certificate_pem_bio = BIO_new_file(certificate_pem, "r");
    BIO *key_pem_io = BIO_new_file(key_pem, "r");
    BIO *wwdr_cer_io = BIO_new_file(wwdr_cer, "r");
    
	scert = PEM_read_bio_X509(certificate_pem_bio, NULL, 0, NULL);
    skey = PEM_read_bio_PrivateKey(key_pem_io, NULL, 0, (void*)KEY_PEM_PASSPHRASE);
    wwdrcert = d2i_X509_bio(wwdr_cer_io, NULL);
    
    BIO_free(certificate_pem_bio);
    BIO_free(key_pem_io);
    BIO_free(wwdr_cer_io);
}

PassBundleSign::~PassBundleSign() {
    X509_free(scert);
    EVP_PKEY_free(skey);
    X509_free(wwdrcert);
}

/**
 * Sign the provided data with the certificates
 * Returns a vector containing the binary signature in DER format
 */
std::vector<unsigned char> PassBundleSign::signature(unsigned char* data, int data_length) {
    
	const int flags = PKCS7_DETACHED | PKCS7_BINARY;
    
    // Chain
    STACK_OF(X509) *chain = sk_X509_new_null();
    sk_X509_push(chain, wwdrcert);
    
    BIO *in = BIO_new_mem_buf(data, data_length);
	PKCS7 *p7 = PKCS7_sign(scert, skey, chain, in, flags);
    
    sk_X509_free(chain);
	
    int signature_size = i2d_PKCS7(p7, NULL);
    std::vector<unsigned char> signature(signature_size);
    
    unsigned char *data_pointer = &signature[0];
    i2d_PKCS7(p7, &data_pointer);
    
    BIO_free(in);
    PKCS7_free(p7);
    
    return signature;
}