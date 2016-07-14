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

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseBtn;


@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewConTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewConBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sliderConLeft;


/**
 *  是否为横屏
 */
@property (nonatomic, assign) BOOL isfullScreen;

/**
 *  控制top\bottom View的隐藏定时器
 */
@property (nonatomic, strong) NSTimer *timer;

/**
 *  判断是否需要控制top/bottom View隐藏
 */
@property (nonatomic, assign) BOOL isControlHidden;

/**
 *  top\bottom View是否正在展示
 */
@property (nonatomic, assign) BOOL isShowing;

/**
 *  不是由于缓冲或者拖动滑块导致的暂停（也就是必然的暂停，交互时的暂停）
 */
@property (nonatomic, assign) BOOL isCertainPause;
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
    self.isfullScreen = NO;
    self.isControlHidden = YES;
    self.isShowing = YES;
    self.indicatorView.hidden = YES;
    self.isCertainPause = NO;
    [self.indicatorView startAnimating];
    
    self.layer.masksToBounds = YES;
    self.sliderView.userInteractionEnabled = YES;
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(draggingSlider:)];
    [self.sliderView addGestureRecognizer:panRecognizer];
    
    [self resetTimer];
}

- (void)setDurationTime:(NSTimeInterval)durationTime
{
    _durationTime = durationTime;
    
    self.totalTimeLabel.text = [self converTimeToStringWithTime:durationTime];
}

- (void)setIsBuffering:(BOOL)isBuffering
{
    _isBuffering = isBuffering;
    
    if (self.isCertainPause) return;
    self.isCertainPause = NO;
    
    //由btn的tag来判断此次事件是交互的暂停，还是缓冲导致的暂停
    self.playOrPauseBtn.tag = 1;
    if (isBuffering)
    {
        self.indicatorView.hidden = NO;
        self.playOrPauseBtn.enabled = NO;
        
        
        if (self.playOrPauseBtn.selected)
        {
            
            [self clickPlayOrPauseBtn:self.playOrPauseBtn];
        }
    }
    else
    {
        self.indicatorView.hidden = YES;
        self.playOrPauseBtn.enabled = YES;
        
        if (!self.playOrPauseBtn.selected)
        {
            [self clickPlayOrPauseBtn:self.playOrPauseBtn];
        }
    }
    self.playOrPauseBtn.tag = 0;
}

- (void)setCurrentPlayTime:(NSTimeInterval)currentPlayTime
{
    _currentPlayTime = currentPlayTime;
    
    
    self.currentTimeLabel.text = [self converTimeToStringWithTime:currentPlayTime];
    
    self.sliderView.centerX =  (currentPlayTime / _durationTime) * self.totalProgressView.width;
    
    _sliderConLeft.constant = self.totalProgressView.x + self.sliderView.centerX - self.sliderView.width / 2;
    
}

- (void)setCurrentBufferTime:(NSTimeInterval)currentBufferTime
{
    _currentBufferTime = currentBufferTime;
    
    self.currentProgressConW.constant = self.totalProgressView.width * currentBufferTime / _durationTime;
}

- (void)playbackComplete
{
    
}


- (IBAction)clickFinishBtn:(id)sender
{
    [self.timer invalidate];
    
    if ([self.delegate respondsToSelector:@selector(stop)])
    {
        [self.delegate stop];
    }
    
    [self resetTimer];
}

- (IBAction)clickFillScreenBtn:(id)sender
{
    [self.timer invalidate];
    self.isfullScreen = !self.isfullScreen;
    
    if ([self.delegate respondsToSelector:@selector(fullScreenOrNormalSizeWithFlag:)])
    {
        [self.delegate fullScreenOrNormalSizeWithFlag:self.isfullScreen];
    }
    
    [self resetTimer];
}

- (IBAction)clickPlayOrPauseBtn:(UIButton *)sender
{
    [self.timer invalidate];
    [self resetTimer];
    
    if (!sender.tag && sender.selected)
    {
        self.isCertainPause = YES;
    }
    else
    {
        self.isCertainPause = NO;
    }
    
    sender.selected = !sender.selected;
    
    if (sender.selected)
    {
        if ([self.delegate respondsToSelector:@selector(play)])
        {
            [self.delegate play];
        }
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(pause)])
        {
            [self.delegate pause];
        }
    }
    
    
}

/**
 *  拖动滑块的时候
 *
 */
- (void)draggingSlider:(UIPanGestureRecognizer *)recognizer
{
    [self.timer invalidate];
    
    CGPoint point = [recognizer translationInView:self.bottomView];
    
    [recognizer setTranslation:CGPointZero inView:self.bottomView];
    
    CGFloat x = point.x;
    
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        [self resetTimer];
        self.progressTimeBtn.hidden = YES;
        
    }
    else
    {
        self.progressTimeBtn.hidden = NO;
        self.sliderView.centerX  += x;
        CGPoint point = [self.bottomView convertPoint:self.sliderView.center toView:self];
        
        self.progressTimeBtn.centerY = point.y - 40;
        self.progressTimeBtn.centerX = point.x;
        
        if (self.sliderView.centerX > self.totalProgressView.x + self.totalProgressView.width)
        {
            self.sliderView.centerX = self.totalProgressView.x + self.totalProgressView.width;
        }
        
        if (self.sliderView.centerX < self.totalProgressView.x)
        {
            self.sliderView.centerX = self.totalProgressView.x;
        }
        
        _sliderConLeft.constant = self.sliderView.centerX - self.sliderView.width / 2;
        
    }
}

#pragma mark ----NSTimer相关操作

- (void)resetTimer
{
    [self.timer invalidate];
    self.timer = nil;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(updateTimer) userInfo:nil repeats:NO];
}

- (void)updateTimer
{
    if (!self.timer.isValid || !self.timer || !self.isControlHidden) return;
    
    [self hideTopAndBottomView];
}

#pragma mark ----控制top\bottom 隐藏or显示相关逻辑

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self showTopAndBottomView];
}

- (void)showTopAndBottomView
{
    [self.timer invalidate];
    
    if (!self.isShowing)
    {
        self.topView.hidden = NO;
        self.bottomView.hidden = NO;
        self.topViewConTop.constant = 0;
        self.bottomViewConBottom.constant = 0;
        [UIView animateWithDuration:0.3 animations:^{
            [self layoutIfNeeded];
        }completion:^(BOOL finished) {
            self.isShowing = YES;
            self.isControlHidden = YES;
        }];
    }
    [self resetTimer];
}

- (void)hideTopAndBottomView
{
    [self.timer invalidate];
    
    if (self.isShowing)
    {
        self.topViewConTop.constant = -50;
        self.bottomViewConBottom.constant = -50;
        [UIView animateWithDuration:0.3 animations:^{
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.topView.hidden = YES;
            self.bottomView.hidden = YES;
            self.isShowing = NO;
            self.isControlHidden = NO;
        }];
    }
    
}

#pragma mark ----other

- (NSString *)converTimeToStringWithTime:(NSTimeInterval)time
{
    int hour = time / 60 / 60;
    int minute = (time - hour * 60 * 60) / 60;
    int second = (int)time % 60;
    
    if (hour)
    {
        return [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minute, second];
    }
    else
    {
        return [NSString stringWithFormat:@"%02d:%02d", minute, second];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

@end
