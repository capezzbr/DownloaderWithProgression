//
//  DownloadWithProgressionTests.m
//  DownloadWithProgressionTests
//
//  Created by Network 1 on 15/04/14.
//  Copyright (c) 2014 Bruno Capezzali. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DownloadFile.h"

static NSString *kWrongFile = @"http:/wwwerror.url/problem";
static NSString *kSmallFile = @"https://github.global.ssl.fastly.net/images/modules/logos_page/Octocat.png";
static NSString *kBigFile = @"https://central.github.com/mac/latest";
static NSString *kFilename = @"testFilename";

// Set the flag for a block completion handler
#define StartBlock() __block BOOL waitingForBlock = YES

// Set the flag to stop the loop
#define EndBlock() waitingForBlock = NO

// Wait and loop until flag is set
#define WaitUntilBlockCompletes() WaitWhile(waitingForBlock)

// Macro - Wait for condition to be NO/false in blocks and asynchronous calls
#define WaitWhile(condition) \
do { \
    while(condition) { \
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.1]]; \
    } \
} while(0)

@interface DownloadWithProgressionTests : XCTestCase {
}

@end

@implementation DownloadWithProgressionTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (BOOL)fileRemove:(NSString *)filename {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:filename];
    return [[NSFileManager defaultManager] removeItemAtPath:filePath error:NULL];
}

- (BOOL)fileExist:(NSString *)filename {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:filename];
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}

- (void)testWrongURL {
    StartBlock();
    
    DownloadFile *download = [[DownloadFile alloc] init];
    [download startDownloadFile:[NSURL URLWithString:kWrongFile]
                     outputName:kFilename
                   loadingTitle:@"Loading Title"
             withFinishCallback:
     ^(DownloadFileStatus status, NSError *error) {
         EndBlock();
         XCTAssertNotNil(error, @"Error not occurred with wrong URL");
         XCTAssertEqual(status, kDownloadFileStatusError, @"Not returned kDownloadFileStatusError");
     }];
    WaitUntilBlockCompletes();
}

- (void)testRightURL {
    StartBlock();
    [self fileRemove:kFilename]; // first cleanup older files
    
    DownloadFile *download = [[DownloadFile alloc] init];
    [download startDownloadFile:[NSURL URLWithString:kSmallFile]
                     outputName:kFilename
                   loadingTitle:@"Loading Title"
             withFinishCallback:
     ^(DownloadFileStatus status, NSError *error) {
         EndBlock();
         XCTAssertNil(error, @"Error occurred %@", error);
         XCTAssertEqual(status, kDownloadFileStatusSuccess, @"Not returned kDownloadFileStatusSuccess");
         XCTAssert([self fileExist:kFilename], @"File %@ non exists", kFilename);
     }];
    WaitUntilBlockCompletes();
}


- (void)testUserCancel {
    StartBlock();

    DownloadFile *download = [[DownloadFile alloc] init];
    [download startDownloadFile:[NSURL URLWithString:kBigFile]
                     outputName:kFilename
                   loadingTitle:@"Loading Title"
             withFinishCallback:
     ^(DownloadFileStatus status, NSError *error) {
         EndBlock();
         XCTAssertNil(error, @"Error occurred %@", error);
         XCTAssertEqual(status, kDownloadFileStatusUserCancel, @"Not returned kDownloadFileStatusUserCancel");
     }];
    
    // simulate a user cancel
    [NSTimer scheduledTimerWithTimeInterval:0.5f target:download selector:@selector(cancel) userInfo:nil repeats:NO];
    WaitUntilBlockCompletes();
}

@end
