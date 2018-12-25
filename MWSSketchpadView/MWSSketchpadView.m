//
//  MWSSketchpadView.m
//
//  Created by 马文帅 on 2018/12/15.
//  Copyright © 2018年 mawenshuai. All rights reserved.
//

#import "MWSSketchpadView.h"
#import "MWSSketchpadScrollView.h"

#define MWSSketchpadPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"MWSSketchpadView.data"]
#define MWSSketchpadImagePath(imgName) [@"MWSSketchpadView.bundle" stringByAppendingPathComponent:imgName]

static NSString *const allPathsArray = @"allPathsArray";
static NSString *const undoPathsArray = @"undoPathsArray";

static const CGFloat animationDuration = 0.25;

@interface MWSSketchpadView()

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (nonatomic, strong) MWSSketchpadScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *undoButton;
@property (weak, nonatomic) IBOutlet UIButton *forwardButton;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;
/** 缓存id */
@property (nonatomic, assign) NSInteger ID;
/** 导航视图的高度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
/** 存储原来的StatusBarStyle */
@property (nonatomic, assign) UIStatusBarStyle originalStatusBarStyle;

@end

@implementation MWSSketchpadView

+ (instancetype)shareInstance {
    static MWSSketchpadView *obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [MWSSketchpadView sketchpadView];
    });
    return obj;
}

+ (instancetype)sketchpadView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}

- (void)setLineWidth:(CGFloat)lineWidth lineStrokeColor:(UIColor *)lineStrokeColor autoChangeStatusBarStyle:(BOOL)autoChangeStatusBarStyle {
    self.lineWidth = lineWidth;
    self.lineStrokeColor = lineStrokeColor;
    self.autoChangeStatusBarStyle = autoChangeStatusBarStyle;
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    self.scrollView.lineWidth = lineWidth;
}

- (void)setLineStrokeColor:(UIColor *)lineStrokeColor {
    _lineStrokeColor = lineStrokeColor;
    self.scrollView.lineStrokeColor = lineStrokeColor;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    [self.closeButton setImage:[UIImage imageNamed:MWSSketchpadImagePath(@"sketchpad_close")] forState:UIControlStateNormal];
    [self.undoButton setImage:[UIImage imageNamed:MWSSketchpadImagePath(@"sketchpad_back")] forState:UIControlStateNormal];
    [self.clearButton setImage:[UIImage imageNamed:MWSSketchpadImagePath(@"sketchpad_clear")] forState:UIControlStateNormal];
    [self.forwardButton setImage:[UIImage imageNamed:MWSSketchpadImagePath(@"sketchpad_forward")] forState:UIControlStateNormal];

    self.topViewHeight.constant = [UIApplication sharedApplication].statusBarFrame.size.height + 44;
    [self addSubview:self.scrollView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.scrollView.frame = CGRectMake(0, CGRectGetMaxY(self.topView.frame), self.bounds.size.width, self.bounds.size.height-CGRectGetHeight(self.topView.frame));
    _horizontalPage = _horizontalPage > 0 ? : 3;
    _verticalPage = _verticalPage > 0 ? : 3;

    self.scrollView.contentSize = CGSizeMake(self.bounds.size.width*_horizontalPage, self.bounds.size.height*_verticalPage);
}

- (IBAction)toolButtonClick:(UIButton *)sender {
    if (sender == self.undoButton) {
        //撤销
        [self.scrollView undo];
    } else if (sender == self.forwardButton) {
        //反撤销
        [self.scrollView forward];
    } else if (sender == self.clearButton) {
        //清空
        [self.scrollView clear];
    } else {
        //关闭
        [self disappear];
    }
}

- (void)show {
    [self showWithID:0];
}

- (void)showWithID:(NSInteger)ID {
    if (ID != 0) {
        _ID = ID;
        NSMutableDictionary *dataDic = [NSKeyedUnarchiver unarchiveObjectWithFile:MWSSketchpadPath];
        if (dataDic) {
            NSMutableDictionary *contentDic = dataDic[[NSString stringWithFormat:@"%zd", _ID]];
            if (contentDic) {
                NSMutableArray *allPaths = contentDic[allPathsArray];
                NSMutableArray *undoPaths = contentDic[undoPathsArray];
                [self.scrollView showAllPaths:allPaths undoPaths:undoPaths];
            } else {
                [self.scrollView clear];
            }
        } else {
            [self.scrollView clear];
        }
    } else {
        [self.scrollView clear];
    }
    
    self.alpha = 0;
    UIView *rootView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    [rootView addSubview:self];
    self.frame = rootView.bounds;
    
    [UIView transitionWithView:self duration:animationDuration options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    
    if (self.autoChangeStatusBarStyle) {
        self.originalStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
        if (self.originalStatusBarStyle == UIStatusBarStyleLightContent) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        }
    }
}

- (void)disappear {
    if (_ID != 0) {
        NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
        contentDic[allPathsArray] = self.scrollView.allPathsArray;
        contentDic[undoPathsArray] = self.scrollView.undoPathsArray;
        NSMutableDictionary *dataDic = [NSKeyedUnarchiver unarchiveObjectWithFile:MWSSketchpadPath];
        if (!dataDic) {
            dataDic = [NSMutableDictionary dictionary];
        }
        dataDic[[NSString stringWithFormat:@"%zd", _ID]] = contentDic;
        [NSKeyedArchiver archiveRootObject:dataDic toFile:MWSSketchpadPath];
    }
    
    [UIView transitionWithView:self duration:animationDuration options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
    if (self.autoChangeStatusBarStyle) {
        if ([UIApplication sharedApplication].statusBarStyle == UIStatusBarStyleDefault && self.originalStatusBarStyle == UIStatusBarStyleLightContent) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        }
    }
}

#pragma mark - lazy loading
- (MWSSketchpadScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[MWSSketchpadScrollView alloc] init];
        __weak typeof(self) wself = self;
        _scrollView.pathsChangeHandle = ^(BOOL isUndo, BOOL isForward) {
            wself.undoButton.enabled = isUndo;
            wself.forwardButton.enabled = isForward;
            wself.clearButton.enabled = isUndo;
        };
    }
    return _scrollView;
}

@end
