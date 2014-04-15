//
//  DownloadFile.m
//
//  Created by Bruno Capezzali on 22/07/13.
//  Copyright (c) 2012 Bruno Capezzali. All rights reserved.
//

#import "DownloadFile.h"

@implementation DownloadFile

// Method for creating the LoadingTitle programmatically
- (void)createLoadingDialogWithTitle:(NSString *)title {
    
    SimpleGUIFactory *gui = [SimpleGUIFactory sharedInstance];
    CGSize winSize = [gui screenSize];
    _view = [gui viewFullscreen];
    
    // Create an ActivityIndicator and a button for aborting the download operation
    [_view addSubview:[gui activityIndicator]];
    [_view addSubview:[gui closeButtonWithTarget:self andSelector:@selector(cancel)]];
    
    // Create the loading bar
    _progressBar = [gui progressView];
    [_view addSubview:_progressBar];

    // Creating a label for describing the actual operation
    UILabel *label = [gui labelWithText:title];
    [label setFrame:CGRectMake(0, winSize.height*0.3f, winSize.width, 60)];
    [label setCenter:CGPointMake(winSize.width*0.5f, winSize.height*0.9f)];
    [_view addSubview:label];
    
    // Adding the loadingDialog to the root view
    [[gui rootView] addSubview:_view];
}

- (void)startDownloadFile:(NSURL *)url
              outputName:(NSString *)name
            loadingTitle:(NSString *)title
      withFinishCallback:(void(^)(DownloadFileStatus status, NSError *error))callback {
    
    [self createLoadingDialogWithTitle:title];
    
    _callback = [callback copy];
    
    // Creating the AFNetworking request
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    _request = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    // Creating the output stream for the file
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:name];
    _request.outputStream = [NSOutputStream outputStreamToFileAtPath:filePath append:NO];

    // Here we update the UIProgressView
    __weak UIProgressView *weakProgress = _progressBar;
    [_request setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        float percentDone = ((float)((int)totalBytesRead) / (float)((int)totalBytesExpectedToRead));
        weakProgress.progress = percentDone;
    }];
    
    // The core of this class, based on AFHTTPRequestOperation
    __strong DownloadFile *strongSelf = self;
    [_request setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        callback(kDownloadFileStatusSuccess, nil);
        [strongSelf operationEnded];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        callback(kDownloadFileStatusError, error);
        [strongSelf operationEnded];
    }];
    
    [_request start];
}

- (void)cancel {
    
    [_request cancel];
    _callback(kDownloadFileStatusUserCancel, nil);
    [self operationEnded];
}

/* Method called every time the operation ends (ok, error, user abortion).
 * This is particular useful to do some cleanup operations.
 */
- (void)operationEnded {
    
    _callback = nil;
    _request = nil;
    
    [[SimpleGUIFactory sharedInstance] removeView:_view];
    _view = nil;
    _progressBar = nil;
}

@end
