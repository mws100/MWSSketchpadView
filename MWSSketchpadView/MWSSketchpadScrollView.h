//
//  MWSSketchpadScrollView.h
//
//  Created by 马文帅 on 2018/12/15.
//  Copyright © 2018年 mawenshuai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MWSSketchpadScrollView : UIScrollView

/** 撤销 */
- (void)undo;
/** 反撤销 */
- (void)forward;
/** 清屏 */
- (void)clear;

/** 路径改变的回调
 *  isUndo     YES:可以撤销  NO：不可以撤销
 *  isForward  YES:可以反撤销  NO：不可以反撤销
 */
@property (nonatomic, copy) void(^pathsChangeHandle)(BOOL isUndo, BOOL isForward);

/** 显示路径 */
- (void)showAllPaths:(NSMutableArray *)allPaths undoPaths:(NSMutableArray *)undoPaths;
/** 当前在显示的路径 */
@property (nonatomic, strong, readonly) NSMutableArray *allPathsArray;
/** 保存已经撤销的路径 */
@property (nonatomic, strong, readonly) NSMutableArray *undoPathsArray;

@end
