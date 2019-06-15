//
//  WQCodeScanner.m
//  CodeScanner
//
//  Created by wangyuxiang on 2017/3/27.
//  Copyright © 2017年 wangyuxiang. All rights reserved.
//

#import "WQCodeScanner.h"
#import "CodeInput.h"
#import <AVFoundation/AVFoundation.h>

@interface WQCodeScanner ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, assign) BOOL isReading;

@property (nonatomic, assign) UIStatusBarStyle originStatusBarStyle;

@property (nonatomic, strong) UIImageView *lineImageView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, strong) UIButton *light;

@end

@implementation WQCodeScanner

- (void)dealloc {
    _session = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadCustomView];
    
    //判断权限
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) {
                [self loadScanView];
            } else {
                NSString *title = @"请在iPhone的”设置-隐私-相机“选项中，允许App访问你的相机";
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:@"" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
                [alertView show];
            }
        });
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.originStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarStyle:self.originStatusBarStyle animated:YES];
    [self stopRunning];
    [super viewWillDisappear:animated];
}

- (void)loadScanView {
    //获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建输出流
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc]init];
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //初始化链接对象
    self.session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    
    [self.session addInput:input];
    [self.session addOutput:output];
    //设置扫码支持的编码格式
    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,
                                 AVMetadataObjectTypeEAN13Code,
                                 AVMetadataObjectTypeEAN8Code,
                                 AVMetadataObjectTypeUPCECode,
                                 AVMetadataObjectTypeCode39Code,
                                 AVMetadataObjectTypeCode39Mod43Code,
                                 AVMetadataObjectTypeCode93Code,
                                 AVMetadataObjectTypeCode128Code,
                                 AVMetadataObjectTypePDF417Code];
    
//    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode];
//    output.metadataObjectTypes=@[AVMetadataObjectTypeEAN13Code,
//                                 AVMetadataObjectTypeEAN8Code,
//                                 AVMetadataObjectTypeUPCECode,
//                                 AVMetadataObjectTypeCode39Code,
//                                 AVMetadataObjectTypeCode39Mod43Code,
//                                 AVMetadataObjectTypeCode93Code,
//                                 AVMetadataObjectTypeCode128Code,
//                                 AVMetadataObjectTypePDF417Code];
    
    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.frame = self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    [self startRunning];
}

- (void)loadCustomView {
    CGRect rc = [[UIScreen mainScreen] bounds];
    
    _width = rc.size.width * 0.16;
    _height = (rc.size.height - (rc.size.width - _width * 2))/2 - 80;
    
    CGFloat picWidth = 30;
    CGFloat picHeight = 30;
    CGFloat mins = 3;
    CGFloat alpha = 0.5;
    
    //最上部view
    UIView* upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rc.size.width, _height)];
    upView.alpha = alpha;
    upView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:upView];
    
    //左侧的view
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, _height, _width, rc.size.height - _height * 2 - 160)];
    leftView.alpha = alpha;
    leftView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:leftView];
    
    //右侧的view
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(rc.size.width - _width, _height, _width, rc.size.height - _height * 2 - 160)];
    rightView.alpha = alpha;
    rightView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:rightView];
    
    //底部view
    UIView *downView = [[UIView alloc] initWithFrame:CGRectMake(0, rc.size.height - _height - 160, rc.size.width, _height + 160)];
    downView.alpha = alpha;
    downView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:downView];
    
    //用于说明的label
    UILabel *topLabel= [[UILabel alloc] initWithFrame:(CGRect)CGRectMake(0, _height - 40, rc.size.width, 40)];
    topLabel.backgroundColor = [UIColor clearColor];
    topLabel.numberOfLines=0;
    topLabel.textColor=[UIColor whiteColor];
    topLabel.textAlignment = NSTextAlignmentCenter;
    topLabel.font = [UIFont systemFontOfSize:18];
    [topLabel setText:@"请对准二维码扫描"];
    [self.view addSubview:topLabel];
    
    UIImageView *left_up = [[UIImageView alloc] initWithFrame:CGRectMake(_width - mins, _height - mins, picWidth, picHeight)];
    [left_up setImage:[UIImage imageNamed:@"left_up"]];
    [self.view addSubview:left_up];
    
    UIImageView *right_up = [[UIImageView alloc] initWithFrame:CGRectMake(rc.size.width - _width - picWidth + mins, _height - mins, picWidth, picHeight)];
    [right_up setImage:[UIImage imageNamed:@"right_up"]];
    [self.view addSubview:right_up];
    
    UIImageView *left_down = [[UIImageView alloc] initWithFrame:CGRectMake(_width - mins, rc.size.height - _height - picHeight - 160 + mins, picWidth, picHeight)];
    [left_down setImage:[UIImage imageNamed:@"left_down"]];
    [self.view addSubview:left_down];
    
    UIImageView *right_down = [[UIImageView alloc] initWithFrame:CGRectMake(rc.size.width - _width - picWidth + mins, rc.size.height - _height - picHeight - 160 + mins, picWidth, picHeight)];
    [right_down setImage:[UIImage imageNamed:@"right_down"]];
    [self.view addSubview:right_down];
    
    _light = [[UIButton alloc] initWithFrame:CGRectMake(rc.size.width - 50 - _width, downView.frame.origin.y + 20, 40, 40)];
    [_light addTarget:self action:@selector(lightController) forControlEvents:UIControlEventTouchUpInside];
    [_light setImage:[UIImage imageNamed:@"shoudian"] forState:UIControlStateNormal];
    [_light setImage:[UIImage imageNamed:@"shoudian_on"] forState:UIControlStateSelected];
    [_light setContentMode:UIViewContentModeScaleAspectFill];
    [_light setBackgroundColor:[UIColor blackColor]];
    [_light.layer setMasksToBounds:YES];
    [_light.layer setCornerRadius:20];
    [self.view addSubview:_light];
    
    UIButton *input = [[UIButton alloc] initWithFrame:CGRectMake(rc.size.width / 2 - 30, _light.frame.origin.y + _light.frame.size.height + 80, 60, 60)];
    [input addTarget:self action:@selector(inputText) forControlEvents:UIControlEventTouchUpInside];
    [input setImage:[UIImage imageNamed:@"jianpan"] forState:UIControlStateNormal];
    [input setContentMode:UIViewContentModeScaleAspectFill];
    [input setBackgroundColor:[UIColor blackColor]];
    [input.layer setMasksToBounds:YES];
    [input.layer setCornerRadius:30];
    [self.view addSubview:input];
    
    
    UILabel *tipLabel= [[UILabel alloc] initWithFrame:CGRectMake(0, input.frame.origin.y + input.frame.size.height, rc.size.width, 40)];
    tipLabel.numberOfLines=0;
    tipLabel.textColor=[UIColor whiteColor];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.font = [UIFont systemFontOfSize:15];
    [tipLabel setText:@"请输入充电桩编号"];
    [self.view addSubview:tipLabel];
    
    //画中间的基准线
    self.lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake (_width, _height, rc.size.width - 2 * _width, 5)];
    self.lineImageView.image = [UIImage imageNamed:@"wq_code_scanner_line"];
    [self.view addSubview:self.lineImageView];
    
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 20, rc.size.width - 50 - 50, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel setText:@"扫描二维码"];
    [self.view addSubview:titleLabel];
    
    //返回
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 50, 44)];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(pressBackButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
//    UILabel *backTitle = [[UILabel alloc] initWithFrame:CGRectMake(70, 20, 50, 50)];
//    [backTitle setText:@"返回"];
//    [backTitle setTextColor:[UIColor whiteColor]];
//    [backTitle setTextAlignment:NSTextAlignmentCenter];
//    [self.view addSubview:backTitle];
}

- (void)startRunning {
    if (self.session) {
        _isReading = YES;
        
        [self.session startRunning];
        
        _timer=[NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(moveUpAndDownLine) userInfo:nil repeats: YES];
    }
}

- (void)stopRunning {
    if ([_timer isValid]) {
        [_timer invalidate];
        _timer = nil ;
    }
    [self.session stopRunning];
}

- (void)pressBackButton {
    [self changeFlash:false];
    UINavigationController *nvc = self.navigationController;
    if (nvc) {
        if (nvc.viewControllers.count == 1) {
            [nvc dismissViewControllerAnimated:YES completion:nil];
        } else {
            [nvc popViewControllerAnimated:NO];
        }
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)lightController {
    [_light setSelected:![_light isSelected]];
    [self changeFlash:_light.selected];
}

- (void)inputText{
    CodeInput *input = [[CodeInput alloc] init];
    [self presentViewController:input animated:YES completion:nil];
    [input setResultBlock:^(NSString * _Nonnull value) {
        if (self.resultBlock) {
            self.resultBlock(value?:@"");
        }
//        [self performSelector:@selector(pressBackButton) withObject:nil afterDelay:0.1];
    }];
}

- (void)changeFlash:(BOOL)open {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (![device hasFlash]) return;
    
    [device lockForConfiguration:nil];
    if (open) {
        device.flashMode = AVCaptureFlashModeOn;
        device.torchMode = AVCaptureTorchModeOn;
    } else {
        device.flashMode = AVCaptureFlashModeOff;
        device.torchMode = AVCaptureTorchModeOff;
    }
    [device unlockForConfiguration];
}


//二维码的横线移动
- (void)moveUpAndDownLine {
    CGFloat Y = self.lineImageView.frame.origin.y;
    if (_height + self.lineImageView.frame.size.width - 5 == Y) {
        [UIView beginAnimations: @"asa" context:nil];
        [UIView setAnimationDuration:1.5];
        CGRect frame = self.lineImageView.frame;
        frame.origin.y = _height;
        self.lineImageView.frame = frame;
        [UIView commitAnimations];
    } else if (_height == Y){
        [UIView beginAnimations: @"asa" context:nil];
        [UIView setAnimationDuration:1.5];
        CGRect frame = self.lineImageView.frame;
        frame.origin.y = _height + self.lineImageView.frame.size.width - 5;
        self.lineImageView.frame = frame;
        [UIView commitAnimations];
    }
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (!_isReading) {
        return;
    }
    if (metadataObjects.count > 0) {
        _isReading = NO;
        AVMetadataMachineReadableCodeObject *metadataObject = metadataObjects[0];
        NSString *result = metadataObject.stringValue;
        if (self.resultBlock) {
            self.resultBlock(result?:@"");
        }
        [self pressBackButton];
    }
}

@end
