#include <vector>

#include "openssl/pkcs7.h"
class PassBundleSign {
private:
    X509 *scert;
    EVP_PKEY *skey;
public:
    PassBundleSign(const char *key_pem, const char *certificate_pem);
    ~PassBundleSign();
    
    std::vector<unsigned char> signature(unsigned char* data, int data_length);
};

