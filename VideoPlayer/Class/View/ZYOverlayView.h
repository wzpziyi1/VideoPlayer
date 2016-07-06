//
//  ZYOverlayView.h
//  AVPlayDemo
//
//  Created by 王志盼 on 16/6/30.
//  Copyright © 2016年 王志盼. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYTransport.h"

@interface ZYOverlayView : UIView <ZYTransport>

@property (nonatomic, assign) CMTime durationTime;

@property (nonatomic, weak) id<ZYTransportDelegate>delegate;

+ (instancetype)overlayView;

- (void)setCurrentPlayTime:(NSTimeInterval)time duration:(NSTimeInterval)duration;

- (void)setCurrentBufferTime:(NSTimeInterval)time duration:(NSTimeInterval)duration;

- (void)playbackComplete;

@end
