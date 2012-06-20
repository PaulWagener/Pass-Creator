
#import "PassBundle.h"
#import <CommonCrypto/CommonDigest.h>


@implementation PassFile
@end

@implementation PassBundle

- (id) init {
    self = [super init];
    self->archive = [[ZKDataArchive alloc] init];
    
    const char *key_pem = [[NSBundle mainBundle] pathForResource:@"key" ofType:@"pem"].UTF8String;
    const char *certificate_pem = [[NSBundle mainBundle] pathForResource:@"certificate" ofType:@"pem"].UTF8String;
    
    
    return self;
}

- (void) addFile:(NSString*)filename :(NSData*)data {
    [archive deflateData:data withFilename:filename andAttributes:nil];
    
    PassFile *file = [[PassFile alloc] init];
    file->filename = filename;
    file->sha1 = [PassBundle sha1digest:data];
    [passFiles addObject:file];
}

- (NSData*) data {
    
    return nil;
}


+(NSString*) sha1digest:(NSData*)data
{
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
    
}

@end
