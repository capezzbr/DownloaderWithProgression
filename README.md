DownloaderWithProgression
==================

Tiny iOS library based on AFNetworking that helps the developer to create a downloading dialog with progress view, with less then 10 lines of code.
How to use it
---------
```objective-c
DownloadFile *operation = [[DownloadFile alloc] init];
[operation startDownloadFile:[NSURL URLWithString:@"http:// ..."]
                  outputName:@"downloadedFile"
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
```

And the result is
---------
![ScreenShot](screen.PNG)

How to install 
---------
1. Drag & drop inside your project the folder named DownloaderWithProgression
2. Add to your project the awesome framework [AFNetworking](https://github.com/AFNetworking/AFNetworking)
3. That's all!

License 
---------
DownloaderWithProgression is available under the MIT license. See the LICENSE file for more info.