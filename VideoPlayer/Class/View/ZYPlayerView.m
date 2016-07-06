//
//  ZYPlayerView.m
//  AVPlayDemo
//
//  Created by 王志盼 on 16/6/29.
//  Copyright © 2016年 王志盼. All rights reserved.
//

#import "ZYPlayerView.h"

@interface ZYPlayerView ()

@end


@implementation ZYPlayerView

+ (Class)layerClass
{
    return [AVPlayerLayer class];
}

- (AVPlayer *)player
{
    return [(AVPlayerLayer *)[self layer] player];
}

- (void)setPlayer:(AVPlayer *)player
{
    [(AVPlayerLayer *)[self layer] setPlayer:player];
}

@end
