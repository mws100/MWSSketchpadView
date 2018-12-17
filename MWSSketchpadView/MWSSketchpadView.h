//
//  MWSSketchpadView.h
//
//  Created by 马文帅 on 2018/12/15.
//  Copyright © 2018年 mawenshuai. All rights reserved.
//  https://github.com/mws100/MWSSketchpadView

#import <UIKit/UIKit.h>

@interface MWSSketchpadView : UIView

+ (instancetype)shareInstance;

/** 横向滚动页数 默认3页 */
@property (nonatomic, assign) NSUInteger horizontalPage;
/** 纵向滚动页数 默认3页 */
@property (nonatomic, assign) NSUInteger verticalPage;

/** 显示无缓存路径的画板 */
- (void)show;
/** 加载这个id的缓存, id不能是0 */
- (void)showWithID:(NSInteger)ID;

@end
