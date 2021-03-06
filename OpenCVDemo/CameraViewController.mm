//
//  ViewController.m
//  OpenCVDemo
//
//  Created by Di on 2019/4/2.
//  Copyright © 2019 chouheiwa. All rights reserved.
//
#import <opencv2/opencv.hpp>
#import <opencv2/imgproc/types_c.h>
#import <opencv2/imgcodecs/ios.h>
#import <opencv2/videoio/cap_ios.h>
#import "CameraViewController.h"

#import "OpenCVHelper.h"
#import "CVAnimateStringModel.h"
@interface CameraViewController () <CvVideoCameraDelegate>
@property (weak, nonatomic) IBOutlet UILabel *label;

@property (strong, nonatomic) CvVideoCamera *videoCamera;
@property (weak, nonatomic) IBOutlet UIView *cameraView;

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 我们需要一个等宽字体才能满足我们的需求，而系统标准字体是非等宽的，
    // 非等宽字体无法实现我们的想法
    self.label.font = [OpenCVHelper defaultFont];

    CvVideoCamera *videoCamera = [[CvVideoCamera alloc] initWithParentView:self.cameraView];
    videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
    videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset640x480;
    videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    videoCamera.defaultFPS = 30;
    videoCamera.grayscaleMode = NO;
    videoCamera.delegate = self;
    videoCamera.useAVCaptureVideoPreviewLayer = NO;

    _videoCamera = videoCamera;

    [videoCamera start];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

- (void)processImage:(cv::Mat &)image {
    dispatch_async(dispatch_get_main_queue(), ^{
        SizeT size;
        size.width = 64;
        size.height = 48;

        self.label.text = [[OpenCVHelper shareInstance] getStringImageFromMat:image withSize:size].animateString;
    });
}

@end
