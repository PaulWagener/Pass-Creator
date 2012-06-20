#include <vector>

class PassBundleSign {
public:
    PassBundleSign(const char *key_pem, const char *certificate_pem);
    ~PassBundleSign();
    
    std::vector<unsigned char> signature(unsigned char* data, int data_length);
};

