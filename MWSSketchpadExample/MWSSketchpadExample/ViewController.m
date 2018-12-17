//
//  ViewController.m
//  MWSSketchpadExample
//
//  Created by 马文帅 on 2018/12/17.
//  Copyright © 2018年 mawenshuai. All rights reserved.
//

#import "ViewController.h"
#import "MWSSketchpadView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor redColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [[MWSSketchpadView shareInstance] showWithID:234];
    
    [MWSSketchpadView shareInstance].horizontalPage = 5;
    [MWSSketchpadView shareInstance].verticalPage = 5;

}

@end
