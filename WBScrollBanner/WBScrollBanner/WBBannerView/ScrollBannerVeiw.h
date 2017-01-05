//
//  ScrollBannerVeiw.h
//  WBScrollBanner
//
//  Created by Apple on 2017/1/5.
//  Copyright © 2017年 mgjr. All rights reserved.
//

#import <UIKit/UIKit.h>

//选取图片回调块
typedef void (^SelectImageAtIndex)(NSInteger index);

@interface ScrollBannerVeiw : UIView

@property (strong, nonatomic) UIImage     *placeImage;//默认图片

@property (assign, nonatomic) NSTimeInterval   time;//滚动时间

@property (copy, nonatomic) SelectImageAtIndex selectImageAtIndex;

/* 加载网络图片
 *
 * @param frame 位置大小
 *
 * @param images 图片数组
 *
 * @param time 滚动时间
 *
 * @param selectImageAtIndex 图片点击
 *
 * @return
 */
- (instancetype) initWithFrame:(CGRect)frame
                        Images:(NSArray *)images
                          Time:(NSTimeInterval)time
                    PlaceImage:(UIImage *)placeImage
            SelectImageAtIndex:(SelectImageAtIndex)selectImageAtindex;

@end
