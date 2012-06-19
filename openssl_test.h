//
//  openssl_test.h
//  Pass Creator
//
//  Created by Paul Wagener on 18-06-12.
//  Copyright (c) 2012 Paul Wagener. All rights reserved.
//

#ifndef Pass_Creator_openssl_test_h
#define Pass_Creator_openssl_test_h

extern unsigned char output_buf[5000];
extern int output_buf_len;

int openssl_spul(const char *key_pem, const char *certificate_pem, unsigned char *thing_to_sign_data, unsigned int thing_to_sign_length);

#endif
