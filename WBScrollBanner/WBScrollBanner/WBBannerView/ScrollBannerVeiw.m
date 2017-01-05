//
//  ScrollBannerVeiw.m
//  WBScrollBanner
//
//  Created by Apple on 2017/1/5.
//  Copyright © 2017年 mgjr. All rights reserved.
//

#define width  self.frame.size.width
#define height self.frame.size.height

#import "ScrollBannerVeiw.h"
#import "UIImageView+WebCache.h"


@interface ScrollBannerVeiw ()<UIScrollViewDelegate>

@property (strong, nonatomic) NSTimer     *timer;
@property (assign, nonatomic) NSInteger    currentIndex;//当前显示的图片
@property (assign, nonatomic) NSInteger    maxCount;//图片总数量
@property (weak, nonatomic) UIImageView   *leftView;
@property (weak, nonatomic) UIImageView   *centView;
@property (nonatomic, weak) UIImageView   *righView;
@property (nonatomic, weak) UIScrollView  *scrollView;
@property (nonatomic, weak) UIPageControl *pageControl;
@property (nonatomic, copy) NSArray       *imageData;

@end

@implementation ScrollBannerVeiw

- (instancetype)initWithFrame:(CGRect)frame
                       Images:(NSArray *)images
                         Time:(NSTimeInterval)time
                   PlaceImage:(UIImage *)placeImage
           SelectImageAtIndex:(SelectImageAtIndex)selectImageAtindex {
    
    
    if (self = [super initWithFrame:frame]) {
        _placeImage = placeImage;
        _selectImageAtIndex = selectImageAtindex;
        _time = time;
        
        [self createScrollView];
        [self setImageData:images];
        [self maxCount:_imageData.count];
        [self removeTimer];
        [self createTimer];
        
        
        self.backgroundColor = [UIColor cyanColor];
    }
    return self;
}

#pragma mark - 设置图片数量
- (void)maxCount:(NSInteger)count {
    _maxCount = count;
    [self createImageView];
    [self createPageControl];
    [self createTimer];
    [self changeLeft:_maxCount - 1 Center:0 Right:1];
}

#pragma mark - 初始化scrollview
- (void)createScrollView {
    UIScrollView *scrollView   = [[UIScrollView alloc] initWithFrame:self.bounds];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.pagingEnabled   = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate        = self;
    scrollView.contentSize     = CGSizeMake(width * 3, 0);//复用创建3个
    [self addSubview:_scrollView = scrollView];
    
    _currentIndex = 0; //开始显示的第一个 前一个是最后一个 后一个是第二张
}

#pragma mark - 图片数组
- (void)setImageData:(NSArray *)imageData {
    _imageData = [imageData copy];
}

#pragma mark - 复用imageView初始化
- (void)createImageView {
    UIImageView *leftView  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    UIImageView *centView  = [[UIImageView alloc] initWithFrame:CGRectMake(width, 0, width, height)];
    UIImageView *rightView = [[UIImageView alloc] initWithFrame:CGRectMake(width*2, 0, width, height)];
    centView.userInteractionEnabled = YES;
    [centView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageChangeAction:)]];
    
    [_scrollView addSubview:_leftView = leftView];
    [_scrollView addSubview:_centView = centView];
    [_scrollView addSubview:_righView = rightView];
}

#pragma mark - 设置pageControl
- (void)createPageControl {
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, height-16, width, 7)];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    pageControl.numberOfPages = _maxCount;
    pageControl.currentPage = 0;
    [self addSubview:_pageControl = pageControl];
}

#pragma mark - 创建定时器
- (void)createTimer {
  
    _timer = [NSTimer timerWithTimeInterval:_time target:self selector:@selector(imageTimer) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

#pragma mark - 复用的图片赋值
- (void)changeLeft:(NSInteger)left Center:(NSInteger)center Right:(NSInteger)right {
    NSString *letfString   = [_imageData objectAtIndex:left];
    NSString *centerString = [_imageData objectAtIndex:center];
    NSString *rightString  = [_imageData objectAtIndex:right];
    [_leftView sd_setImageWithURL:[NSURL URLWithString:letfString] placeholderImage:_placeImage];
    [_centView sd_setImageWithURL:[NSURL URLWithString:centerString] placeholderImage:_placeImage];
    [_righView sd_setImageWithURL:[NSURL URLWithString:rightString] placeholderImage:_placeImage];
    [_scrollView setContentOffset:CGPointMake(width, 0)];
}

#pragma mark -- 手势和定时器事件
- (void)imageChangeAction:(UITapGestureRecognizer *) sender {
    if (self.selectImageAtIndex) {
        self.selectImageAtIndex(_currentIndex);
    }
}

- (void)imageTimer {
    [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.y + width, 0) animated:YES];
}

#pragma mark - 滚动代理
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self createTimer];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    [self removeTimer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self changeOffset:scrollView.contentOffset.x];
}

- (void)changeOffset:(CGFloat)offset {
    
    if (offset >= width * 2) {//正向
        _currentIndex ++;
        
        if (_currentIndex == _maxCount - 1) {
            
            [self changeLeft:_currentIndex - 1 Center:_currentIndex Right:0];
            
        } else if (_currentIndex == _maxCount) {
            
            _currentIndex = 0;
            [self changeLeft:_maxCount - 1 Center:0 Right:1];
            
        } else {
            
            [self changeLeft:_currentIndex - 1 Center:_currentIndex Right:_currentIndex + 1];
            
        }
        
        _pageControl.currentPage = _currentIndex;
    }
    if (offset <= 0) {//反向
        _currentIndex --;
        
        if (_currentIndex == 0) {
            
            [self changeLeft:_maxCount - 1 Center:0 Right:1];
            
        } else if (_currentIndex == -1) {
            
            _currentIndex = _maxCount - 1;
            [self changeLeft:_currentIndex - 1 Center:_currentIndex Right:0];
            
        } else {
            
            [self changeLeft:_currentIndex - 1 Center:_currentIndex Right:_currentIndex + 1];
            
        }
        
        _pageControl.currentPage = _currentIndex;
    }
}

- (void) removeTimer {
    if (_timer == nil) {
        return;
    }
    [_timer invalidate];
    _timer = nil;
}

- (void)dealloc {
    [self removeTimer];
}

@end
