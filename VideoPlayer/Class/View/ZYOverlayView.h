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

@property (nonatomic, assign) NSTimeInterval durationTime;

@property (nonatomic, weak) id<ZYTransportDelegate>delegate;

/**
 *  是否正在缓冲
 */
@property (nonatomic, assign) BOOL isBuffering;

@property (nonatomic, assign) BOOL isFinishedJump;

@property (nonatomic, assign) NSTimeInterval currentPlayTime;

@property (nonatomic, assign) NSTimeInterval currentBufferTime;

+ (instancetype)overlayView;

@end
