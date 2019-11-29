#import "FlutterSharePlugin.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "ShareActivity.h"

@implementation FlutterSharePlugin


+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_share"
            binaryMessenger:[registrar messenger]];
  FlutterSharePlugin* instance = [[FlutterSharePlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];

}


- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if([@"getPlatformVersion" isEqualToString:call.method]){
        result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    } else if([@"share" isEqualToString:call.method]){
        NSString *src = call.arguments[@"src"];
        UIImage * shareImage;
       if (!src) {
//            NSURL *url = [NSURL fileURLWithPath:src];
            shareImage = [UIImage imageWithContentsOfFile:src];
       }else{
        FlutterStandardTypedData *data = call.arguments[@"image"];
        if (data) {
            NSData *image = data.data;
            shareImage =  [UIImage imageWithData:image];
        }
       }
        if (!shareImage) {
            NSLog(@" share image is nil");
            return;
        }
        // 1、设置分享的内容，并将内容添加到数组中
        NSString *shareText = call.arguments[@"title"];
        NSString *url = call.arguments[@"url"];
        NSURL *shareUrl = [NSURL URLWithString:url];
        NSArray *activityItemsArray = @[shareText,shareImage,shareUrl];

        // ShareActivity，继承自UIActivity
        ShareActivity *shareActivity = [[ShareActivity alloc]initWithTitle:shareText ActivityImage:shareImage URL:shareUrl ActivityType:@"Custom"];
        NSArray *activityArray = @[shareActivity];

        UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItemsArray applicationActivities:activityArray];
        activityVC.modalInPopover = YES;
        
        UIViewController *vc = [[UIApplication sharedApplication] keyWindow].rootViewController;
        activityVC.popoverPresentationController.sourceView = vc.view;
        activityVC.popoverPresentationController.sourceRect = CGRectMake(0,0,100,100);
        [vc presentViewController:activityVC animated:YES completion:nil];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

@end
