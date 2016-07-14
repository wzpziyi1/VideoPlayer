//
//  ZYTransport.h
//  VideoPlayer
//
//  Created by 王志盼 on 16/7/6.
//  Copyright © 2016年 王志盼. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol ZYTransportDelegate <NSObject>

- (void)play;

- (void)pause;

- (void)stop;

/**
 *  跳转到某个时间点播放
 *
 */
- (void)jumpedToTime:(NSTimeInterval)time;


/**
 *  视频横屏
 *
 *  @param flag YES为是
 */
- (void)fullScreenOrNormalSizeWithFlag:(BOOL)flag;
@end

@protocol ZYTransport <NSObject>

/**
 *  是否正在缓冲
 */
@property (nonatomic, assign) BOOL isBuffering;

/**
 *  是否完成跳转
 */
@property (nonatomic, assign) BOOL isFinishedJump;

@property (nonatomic, assign) NSTimeInterval durationTime;

@property (nonatomic, weak) id<ZYTransportDelegate>delegate;

/**
 *  设置当前播放的时间点
 */
@property (nonatomic, assign) NSTimeInterval currentPlayTime;

/**
 *  设置当前缓冲的时间点
 */
@property (nonatomic, assign) NSTimeInterval currentBufferTime;

/**
 *  视频播放完毕
 */
- (void)playbackComplete;


@end