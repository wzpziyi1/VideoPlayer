//
//  ZYOverlayView.m
//  AVPlayDemo
//
//  Created by 王志盼 on 16/6/30.
//  Copyright © 2016年 王志盼. All rights reserved.
//

#import "ZYOverlayView.h"

@interface ZYOverlayView ()
/**
 *  时长
 */
@property (nonatomic, assign) NSTimeInterval totalDuration;
@end

@implementation ZYOverlayView

+ (instancetype)overlayView
{
    return [[self alloc] init];
}

- (instancetype)init
{
    if (self = [super init])
    {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ZYOverlayView" owner:nil options:nil] lastObject];
    }
    return self;
}

- (void)setCurrentPlayTime:(NSTimeInterval)time duration:(NSTimeInterval)duration
{
    
}

- (void)setCurrentBufferTime:(NSTimeInterval)time duration:(NSTimeInterval)duration
{
    
}

- (void)playbackComplete
{
    
}






@end
