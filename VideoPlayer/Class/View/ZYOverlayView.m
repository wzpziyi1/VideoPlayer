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

/**
 *  总进度
 */
@property (weak, nonatomic) IBOutlet UIView *totalProgressView;

/**
 *  进度上面的显示时间
 */
@property (weak, nonatomic) IBOutlet UIButton *progressTimeBtn;

/**
 *  当前播放时间VIew
 */
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;

/**
 *  总进度View
 */
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;

/**
 *  滑块
 */
@property (weak, nonatomic) IBOutlet UIImageView *sliderView;

/**
 *  当前缓冲进度的宽度
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *currentProgressConW;

/**
 *  是否为横屏
 */
@property (nonatomic, assign) BOOL isfullScreen;
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
        
        [self commitInit];
    }
    return self;
}

- (void)commitInit
{
    self.sliderView.userInteractionEnabled = YES;
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(draggingSlider:)];
    [self.sliderView addGestureRecognizer:panRecognizer];
    
    self.isfullScreen = NO;
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


- (IBAction)clickFinishBtn:(id)sender
{
    
}

- (IBAction)clickFillScreenBtn:(id)sender
{
    self.isfullScreen = !self.isfullScreen;
    
    if ([self.delegate respondsToSelector:@selector(fullScreenOrNormalSizeWithFlag:)])
    {
        [self.delegate fullScreenOrNormalSizeWithFlag:self.isfullScreen];
    }
}

- (IBAction)clickPlayOrPauseBtn:(id)sender
{
    
}

/**
 *  拖动滑块的时候
 *
 */
- (void)draggingSlider:(UIPanGestureRecognizer *)recognizer
{
    
}

@end
