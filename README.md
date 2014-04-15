DownloaderWithProgression
==================

Super small library based on AFNetworking that shows up a downloading dialog with progress view, with < 10 line of code.

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
1. First drag & drop inside your project the following files
	- SimpleGUIFactory
	- DownloadFile
2. Add to your project the awesome framework AFNetworking [Link](https://github.com/AFNetworking/AFNetworking)
3. That's all!