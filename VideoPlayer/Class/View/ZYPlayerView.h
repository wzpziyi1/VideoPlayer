//
//  ZYPlayView.h
//  AVPlayDemo
//
//  Created by 王志盼 on 16/6/29.
//  Copyright © 2016年 王志盼. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ZYTransport.h"


@interface ZYPlayerView : UIView
@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, weak) id<ZYTransport>transport;

@end
