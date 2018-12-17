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

@property (nonatomic, strong) MWSSketchpadView *sketchpadView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor cyanColor];
    
    self.sketchpadView = [MWSSketchpadView shareInstance];
    self.sketchpadView.horizontalPage = 5;
    self.sketchpadView.verticalPage = 5;
}

- (IBAction)click1:(UIButton *)sender {
    [self.sketchpadView showWithID:123];
}

- (IBAction)click2:(UIButton *)sender {
    [self.sketchpadView showWithID:1234];
}

- (IBAction)click3:(UIButton *)sender {
    [self.sketchpadView showWithID:12345];
}

@end
