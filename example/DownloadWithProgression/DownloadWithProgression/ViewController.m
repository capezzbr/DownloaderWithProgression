//
//  ViewController.m
//  DownloadWithProgression
//
//  Created by Bruno Capezzali on 15/04/14.
//  Copyright (c) 2014 Bruno Capezzali. All rights reserved.
//

#import "ViewController.h"
#import "DownloadFile.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)startDownload:(id)sender {
    
    NSString *file = @"http://www.cocos2d-iphone.org/blog/wp-content/uploads/2014/02/Cocos2D-3.0.rc2_.dmg";
//    NSString *file = @"https://github.global.ssl.fastly.net/images/modules/logos_page/Octocat.png";
    DownloadFile *operation = [[DownloadFile alloc] init];
    [operation startDownloadFile:[NSURL URLWithString:file]
                      outputName:@"myDownload"
                    loadingTitle:@"Downloading file ..."
            withFinishCallback:^(DownloadFileStatus status, NSError *error) {
                
                switch (status) {
                    case kDownloadFileStatusUserAborted:
                        NSLog(@"User aborted");
                        break;
                        
                    case kDownloadFileStatusError:
                        NSLog(@"Download error: %@", error);
                        break;
                        
                    default:
                        NSLog(@"Download OK");
                        break;
                }
            }];
}

@end
