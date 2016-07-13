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

@property (nonatomic, assign) NSTimeInterval durationTime;

@property (nonatomic, weak) id<ZYTransportDelegate>delegate;

/**
 *  设置当前播放的时间点
 *
 *  @param time     当前播放时间
 *  @param duration 视频总时长
 */
- (void)setCurrentPlayTime:(NSTimeInterval)time duration:(NSTimeInterval)duration;

/**
 *  设置当前缓冲的时间点
 *
 *  @param time     缓冲时间
 *  @param duration 视频总时长
 */
- (void)setCurrentBufferTime:(NSTimeInterval)time duration:(NSTimeInterval)duration;

/**
 *  视频播放完毕
 */
- (void)playbackComplete;


@end