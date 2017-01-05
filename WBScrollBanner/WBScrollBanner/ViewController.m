//
//  ViewController.m
//  WBScrollBanner
//
//  Created by Apple on 2017/1/5.
//  Copyright © 2017年 mgjr. All rights reserved.
//

#import "ViewController.h"
#import "ScrollBannerVeiw.h"
#import "WebViewController.h"

#define WB_NEWSURLBAN @"http://113.108.222.107:80/TexmanAppServer/ad/advert.spr"
#define S_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define R_ImageNamed(_pointer) [UIImage imageNamed:_pointer]

@interface ViewController ()
@property (nonatomic, strong) NSMutableArray * urls;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _urls = [NSMutableArray array];
    [_urls addObject:@"http://app.transuner.com/TexmanAppServer/ad/download.spr?filename=4444.png"];
    [_urls addObject:@"http://app.transuner.com/TexmanAppServer/ad/download.spr?filename=1422650613897.png"];
    [_urls addObject:@"http://app.transuner.com/TexmanAppServer/ad/download.spr?filename=1422650613897.png"];
    [_urls addObject:@"http://app.transuner.com/TexmanAppServer/ad/download.spr?filename=1422650786883.png"];
    [_urls addObject:@"http://app.transuner.com/TexmanAppServer/ad/download.spr?filename=1422650794806.png"];
    [_urls addObject:@"http://app.transuner.com/TexmanAppServer/ad/download.spr?filename=3333.png"];
    [_urls addObject:@"http://app.transuner.com/TexmanAppServer/ad/download.spr?filename=4444.png"];
    [_urls addObject:@"http://app.transuner.com/TexmanAppServer/ad/download.spr?filename=1422650613897.png"];
    [_urls addObject:@"http://app.transuner.com/TexmanAppServer/ad/download.spr?filename=1422650771156.png"];
    [self postNewsAdvert];
}

- (void)postNewsAdvert {
        ScrollBannerVeiw *scrollBanner = [[ScrollBannerVeiw alloc] initWithFrame:CGRectMake(0, 0, S_SCREEN_WIDTH, 200) Images:self.urls Time:2.0 PlaceImage:R_ImageNamed(@"WBBAN") SelectImageAtIndex:^(NSInteger index) {
            
            WebViewController *webViewController = [[WebViewController alloc] init];
            [self.navigationController pushViewController:webViewController animated:YES];
            
        }];
        [self.view addSubview:scrollBanner];
    
}

@end
