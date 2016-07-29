//
//  ViewController.m
//  QCDownloadManagerExample
//
//  Created by UntilYou-QC on 16/7/21.
//  Copyright © 2016年 UntilYou-QC. All rights reserved.
//

#import "ViewController.h"
#import "DownloadManager.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIProgressView *progressView1;
@property (strong, nonatomic) IBOutlet UILabel *progressLable1;
@property (strong, nonatomic) IBOutlet UIButton *downloadButton1;

@end

@implementation ViewController
NSString * const downloadUrl1 = @"http://120.25.226.186:32812/resources/videos/minion_01.mp4";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@", [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]);
    [self refreshDataWithState:DownloadStateSuspended];
}

- (void)refreshDataWithState:(DownloadState)state {
    self.progressLable1.text = [NSString stringWithFormat:@"%.f%%", [[DownloadManager sharedInstance] progress:downloadUrl1] * 100];
    self.progressView1.progress = [[DownloadManager sharedInstance] progress:downloadUrl1];
    [self.downloadButton1 setTitle:[self getTitleWithDownloadState:state] forState:(UIControlStateNormal)];
}

- (NSString *)getTitleWithDownloadState:(DownloadState)state {
    switch (state) {
        case DownloadStateStart: return @"暂停";
        case DownloadStateSuspended:
        case DownloadStateFailed: return @"开始";
        case DownloadStateCompleted: return @"完成";
        default: break;
    }
}

- (IBAction)download1:(UIButton *)sender {
    [[DownloadManager sharedInstance] download:downloadUrl1 progress:^(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.progressView1.progress = progress;
            self.progressLable1.text = [NSString stringWithFormat:@"%.f%%", progress * 100];
        });
    } state:^(DownloadState state) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.downloadButton1 setTitle:[self getTitleWithDownloadState:state] forState:(UIControlStateNormal)];
        });
    }];
}

- (IBAction)deleteFile1:(UIButton *)sender {
    [[DownloadManager sharedInstance] deleteFile:downloadUrl1];
    self.progressLable1.text = [NSString stringWithFormat:@"%.f%%", [[DownloadManager sharedInstance] progress:downloadUrl1] * 100];
    self.progressView1.progress = [[DownloadManager sharedInstance] progress:downloadUrl1];
    [self.downloadButton1 setTitle:[self getTitleWithDownloadState:DownloadStateSuspended] forState:(UIControlStateNormal)];
}

- (IBAction)deletaAll:(UIButton *)sender {
    [[DownloadManager sharedInstance] deleteAllFile];
    [self refreshDataWithState:DownloadStateSuspended];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
