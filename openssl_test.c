
#include <stdio.h>

#include "openssl/pem.h"
#include "openssl/pkcs7.h"
#include "openssl/err.h"


unsigned char output_buf[5000];
int output_buf_len;

int openssl_spul(const char *key_pem, const char *certificate_pem, unsigned char *thing_to_sign_data, unsigned int thing_to_sign_length)
{
	const int flags = PKCS7_DETACHED | PKCS7_BINARY;
    
	OpenSSL_add_all_algorithms();
	ERR_load_crypto_strings();
    
	/* Read in signer certificate and private key */
	BIO *certificate_pem_bio = BIO_new_file(certificate_pem, "r");
    BIO *key_pem_io = BIO_new_file(key_pem, "r");
    BIO *in = BIO_new_mem_buf(thing_to_sign_data, thing_to_sign_length);
    
	X509 *scert = PEM_read_bio_X509(certificate_pem_bio, NULL, 0, NULL);
    EVP_PKEY *skey = PEM_read_bio_PrivateKey(key_pem_io, NULL, 0, "HPYEj7xS");
    
    /* Sign content */
	PKCS7 *p7 = PKCS7_sign(scert, skey, NULL, in, flags);
    
	BIO *out = BIO_new(BIO_s_mem());
    
    BIO_reset(in);
    
    unsigned char *g = &output_buf[0];
    output_buf_len = i2d_PKCS7(p7, &g);

	int ret = 0;
    
err:
    
	if (ret)
    {
		fprintf(stderr, "Error Signing Data\n");
		ERR_print_errors_fp(stderr);
    }
    
	if (p7)
		PKCS7_free(p7);
	if (scert)
		X509_free(scert);
	if (skey)
		EVP_PKEY_free(skey);
    
	if (in)
		BIO_free(in);
	if (out)
		BIO_free(out);
	if (certificate_pem_bio)
		BIO_free(certificate_pem_bio);
    
    return 0;
}