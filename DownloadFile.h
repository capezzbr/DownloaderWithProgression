//
//  DownloadFile.h
//
//  Created by Bruno Capezzali on 22/07/13.
//  Copyright (c) 2012 Bruno Capezzali. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "SimpleGUIFactory.h"

typedef enum {
    kDownloadFileStatusSuccess      = 1,
    kDownloadFileStatusError        = 2,
    kDownloadFileStatusUserAborted  = 3
} DownloadFileStatus;

@interface DownloadFile : NSObject {
    AFHTTPRequestOperation *_request;
    UIView *_view;
    UIProgressView *_progressBar;
    void(^_callback)(DownloadFileStatus status, NSError *error);
}

- (void)startDownloadFile:(NSURL *)url
               outputName:(NSString *)name
             loadingTitle:(NSString *)title
       withFinishCallback:(void(^)(DownloadFileStatus status, NSError *error))callback;

@end
