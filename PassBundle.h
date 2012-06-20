#import "ZipKit/ZKDataArchive.h"

@interface PassFile : NSObject {
    @public
    NSString *filename;
    NSString *sha1;
}

@end

@interface PassBundle : NSObject {
    ZKDataArchive *archive;
    NSMutableArray *passFiles;
}

- (id) init;
- (void) addFile:(NSString*)filename :(NSData*)data;


@end
