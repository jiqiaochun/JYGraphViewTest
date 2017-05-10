//
//  ViewController.m
//  JYGraphTest
//
//  Created by 姬巧春 on 16/8/15.
//  Copyright © 2016年 姬巧春. All rights reserved.
//

#import "ViewController.h"

#import "JYGraphView.h"

@interface ViewController () <JYGraphViewDelagate>
{
    JYGraphView *lineView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    lineView = [[JYGraphView alloc]initWithFrame:CGRectMake(0, 150, self.view.bounds.size.width, 294)];
    lineView.backgroundColor = [UIColor clearColor];
    lineView.delegate = self;
    
    lineView.monthLeftDateArr = @[@"07-30",@"08-01",@"08-02",@"08-03",@"08-04",@"08-05",@"08-06",@"08-07",@"08-08"];
    lineView.leftDataArr =  @[@"90",@"80",@"70",@"75",@"65",@"56",@"58",@"57",@"55"];
    
    [self.view addSubview:lineView];
}

- (void)hasSwipeToLeftDate:(NSArray *)recodeDateArray AndDataArray:(NSArray *)dataArray{
    NSLog(@"swipe left");
    recodeDateArray = @[@"08-08",@"08-09",@"08-10"];
    dataArray =  @[@"150",@"150",@"150"];
    
    lineView.monthLeftDateArr = recodeDateArray;
    lineView.leftDataArr = dataArray;
    
    [lineView reloadData];
    
}
- (void)hasSwipeToRightDate:(NSArray *)recodeDateArray AndDataArray:(NSArray *)dataArray{
    NSLog(@"swipe right");
    recodeDateArray = @[@"07-30",@"08-01",@"08-02",@"08-03",@"08-04"];
    dataArray =  @[@"67",@"64",@"56",@"55",@"56"];
    
    lineView.monthLeftDateArr = recodeDateArray;
    lineView.leftDataArr = dataArray;
    
    [lineView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
