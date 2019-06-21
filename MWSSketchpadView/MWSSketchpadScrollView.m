//
//  MWSSketchpadScrollView.m
//
//  Created by 马文帅 on 2018/12/15.
//  Copyright © 2018年 mawenshuai. All rights reserved.
//

#import "MWSSketchpadScrollView.h"

static CGPoint MidPoint(CGPoint p0, CGPoint p1) {
    return (CGPoint) {
        (p0.x + p1.x) / 2.0,
        (p0.y + p1.y) / 2.0
    };
}

@interface MWSSketchpadScrollView()

@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@property (nonatomic, strong) UIBezierPath *path;
/** 上一个触摸点 */
@property (nonatomic, assign) CGPoint previousPoint;
/** 当前在显示的路径 */
@property (nonatomic, strong) NSMutableArray *allPathsArray;
/** 保存已经撤销的路径 */
@property (nonatomic, strong) NSMutableArray *undoPathsArray;

@end

@implementation MWSSketchpadScrollView

- (instancetype)init {
    if (self = [super init]) {
        _lineWidth = 3;
        _lineStrokeColor = [UIColor blackColor];
        _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        _pan.maximumNumberOfTouches = 1;
        [self addGestureRecognizer:_pan];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    }
    return self;
}

/** 显示路径 */
- (void)showAllPaths:(NSMutableArray *)allPaths undoPaths:(NSMutableArray *)undoPaths {
    self.allPathsArray = allPaths;
    self.undoPathsArray = undoPaths;
    [self setNeedsDisplay];
}

/** 撤销 */
- (void)undo {
    [self.undoPathsArray addObject:self.allPathsArray.lastObject];
    [self.allPathsArray removeLastObject];
    [self setNeedsDisplay];
}

/** 反撤销 */
- (void)forward {
    [self.allPathsArray addObject:self.undoPathsArray.lastObject];
    [self.undoPathsArray removeLastObject];
    [self setNeedsDisplay];
}

/** 清屏 */
- (void)clear {
    [self.allPathsArray removeAllObjects];
    [self.undoPathsArray removeAllObjects];
    [self setNeedsDisplay];
}

/** 滑动手势响应 */
- (void)pan:(UIPanGestureRecognizer *)pan {
    CGPoint curLocation = [pan locationInView:self];
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.previousPoint = curLocation;
        UIBezierPath *path = [[UIBezierPath alloc] init];
        [path setLineWidth:self.lineWidth];
        [path setLineCapStyle:kCGLineCapRound];
        [path moveToPoint:curLocation];
        self.path = path;
        [self.allPathsArray addObject:path];
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        CGPoint midPoint = MidPoint(self.previousPoint, curLocation);
        [self.path addQuadCurveToPoint:midPoint controlPoint:self.previousPoint];
        [self setNeedsDisplay];
    }
    self.previousPoint = curLocation;
}

- (void)setContentOffset:(CGPoint)contentOffset {
    [super setContentOffset:contentOffset];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), self.lineStrokeColor.CGColor);
    
    for (UIBezierPath *path in self.allPathsArray) {
        [path setLineWidth:self.lineWidth];
        [path stroke];
    }
    if (self.pathsChangeHandle) {
        self.pathsChangeHandle(self.allPathsArray.count, self.undoPathsArray.count);
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == _pan) {
        return YES;
    }
    return gestureRecognizer.numberOfTouches >= 2;
}

- (NSMutableArray *)allPathsArray {
    if (!_allPathsArray) {
        _allPathsArray = [NSMutableArray array];
    }
    return _allPathsArray;
}

- (NSMutableArray *)undoPathsArray {
    if (!_undoPathsArray) {
        _undoPathsArray = [NSMutableArray array];
    }
    return _undoPathsArray;
}

@end
