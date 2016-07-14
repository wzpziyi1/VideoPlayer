//
//  ZYPlayerView.m
//  AVPlayDemo
//
//  Created by 王志盼 on 16/6/29.
//  Copyright © 2016年 王志盼. All rights reserved.
//

#import "ZYPlayerView.h"
#import "ZYOverlayView.h"

@interface ZYPlayerView ()
@property (nonatomic, strong) ZYOverlayView *overlayView;
@end


@implementation ZYPlayerView

+ (Class)layerClass
{
    return [AVPlayerLayer class];
}

- (instancetype)init
{
    if (self = [super init])
    {
        [self commitInit];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self commitInit];
}


- (void)commitInit
{
    self.overlayView = [ZYOverlayView overlayView];
    
    [self addSubview:self.overlayView];
    
    [self.overlayView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
}

- (AVPlayer *)player
{
    return [(AVPlayerLayer *)[self layer] player];
}

- (void)setPlayer:(AVPlayer *)player
{
    [(AVPlayerLayer *)[self layer] setPlayer:player];
}

- (id<ZYTransport>)transport
{
    return self.overlayView;
}


@end
