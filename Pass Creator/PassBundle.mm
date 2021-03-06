
#import "PassBundle.h"
#import <CommonCrypto/CommonDigest.h>
#import "JSONKit.h"
#include "PassBundleSign.h"


@implementation PassFile
@end

@implementation PassBundle

- (id) init {
    self = [super init];
    self->archive = [[ZKDataArchive alloc] init];
    self->passFiles = [[NSMutableArray alloc] init];

    return self;
}

- (void) addFile:(NSString*)filename :(NSData*)data {
    [archive deflateData:data withFilename:filename andAttributes:nil];
    
    PassFile *file = [[PassFile alloc] init];
    file->filename = filename;
    file->sha1 = [PassBundle sha1digest:data];
    [passFiles addObject:file];
}

/**
 * Bundle all the files in a zip and add a manifest.json and signature file to it
 */
- (NSData*) data {
    ZKDataArchive *finalArchive = [ZKDataArchive archiveWithArchiveData:archive.data];
    
    // Create the manifest
    NSMutableDictionary *manifestDictionary = [NSMutableDictionary dictionary];

    for(PassFile *file in passFiles) {
        [manifestDictionary setObject:file->sha1 forKey:file->filename];
    }
    
    NSData *manifestJson = manifestDictionary.JSONData;

    // Add the manifest to the zip
    [finalArchive deflateData:manifestJson withFilename:@"manifest.json" andAttributes:nil];
    
    // Sign the manifest
    const char *key_pem = [[NSBundle mainBundle] pathForResource:@"key" ofType:@"pem"].UTF8String;
    const char *certificate_pem = [[NSBundle mainBundle] pathForResource:@"certificate" ofType:@"pem"].UTF8String;
    const char *wwdr_cer =[[NSBundle mainBundle] pathForResource:@"AppleWWDRCA" ofType:@"cer"].UTF8String;

    PassBundleSign signer(key_pem, certificate_pem, wwdr_cer);
    
    unsigned char *manifest_pointer = (unsigned char*)manifestJson.bytes;
    int manifest_length = manifestJson.length;

    std::vector<unsigned char> signature = signer.signature(manifest_pointer, manifest_length);
    NSData *signatureData = [NSData dataWithBytes:&signature[0] length:signature.size()];
    
    // Add the signature to the zip
    [finalArchive deflateData:signatureData withFilename:@"signature" andAttributes:nil];

    return finalArchive.data;
}

/**
 * Create a SHA1 digest of some data as a hexidecimal string
 */
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
