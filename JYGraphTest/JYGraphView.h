//
//  JYGraphView.h
//  JYGraphTest
//
//  Created by 姬巧春 on 16/8/15.
//  Copyright © 2016年 姬巧春. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JYGraphViewDelagate <NSObject>

- (void)hasSwipeToLeftDate:(NSArray *)recodeDateArray AndDataArray:(NSArray *)dataArray;
- (void)hasSwipeToRightDate:(NSArray *)recodeDateArray AndDataArray:(NSArray *)dataArray;

@end

@interface JYGraphView : UIView

@property ( nonatomic,assign) id<JYGraphViewDelagate> delegate;

@property (nonatomic,strong) NSArray *leftDataArr;//左边数据
@property (nonatomic,strong) NSArray *monthLeftDateArr;// 对应日期

- (void)reloadData;

@end
