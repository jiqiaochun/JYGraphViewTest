//
//  JYGraphView.m
//  JYGraphTest
//
//  Created by 姬巧春 on 16/8/15.
//  Copyright © 2016年 姬巧春. All rights reserved.
//

#import "JYGraphView.h"

@interface JYGraphView (){
    CGFloat Xmargin;//X轴方向的偏移
    CGFloat Ymargin;//Y轴方向的偏移
    CGPoint lastPoint;//最后一个坐标点
}

@property (nonatomic,strong)NSMutableArray *leftPointArr;//左边的数据源位置
@property (nonatomic,strong)NSMutableArray *leftBtnArr;//圆圈按钮
@property (nonatomic,strong)NSMutableArray *leftdataLabelArr;//数字lable
@property (nonatomic,strong)NSMutableArray *leftLableArr; // 日期lable

//@property (nonatomic,strong) UIBezierPath *linPath;
@property (nonatomic,strong) CAShapeLayer *shapeLayer;
@property (nonatomic,strong) CALayer *baseLayer;

@property (nonatomic,strong) UIView *graphView;
@property (nonatomic,strong) UIView *graphdateView;

@end

@implementation JYGraphView

-(UIView *)graphView{
    if (!_graphView) {
        _graphView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height-60)];
    }
    return _graphView;
}

-(UIView *)graphdateView{
    if (!_graphdateView) {
        _graphdateView.backgroundColor = [UIColor whiteColor];
        _graphdateView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.graphView.frame), self.bounds.size.width, 60)];
    }
    return _graphdateView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.leftPointArr = [NSMutableArray array];
        self.leftBtnArr = [NSMutableArray array];
        self.leftdataLabelArr = [NSMutableArray array];
        self.leftLableArr = [NSMutableArray array];
        
        //        [self addLinesWith:self];
        [self addSubview:self.graphView];
        [self addSubview:self.graphdateView];
        
        UISwipeGestureRecognizer *recognizerRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
        [recognizerRight setDirection:(UISwipeGestureRecognizerDirectionRight)];
        [self addGestureRecognizer:recognizerRight];
        
        UISwipeGestureRecognizer *recognizerLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
        [recognizerLeft setDirection:(UISwipeGestureRecognizerDirectionLeft)];
        [self addGestureRecognizer:recognizerLeft];
        
    }
    
    return self;
    
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionLeft) {
        //执行程序
        if ([self.delegate respondsToSelector:@selector(hasSwipeToLeftDate:AndDataArray:)]) {
            [self.delegate hasSwipeToLeftDate:self.monthLeftDateArr AndDataArray:self.leftDataArr];
        }
    }
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionRight) {
        //执行程序
        if ([self.delegate respondsToSelector:@selector(hasSwipeToRightDate:AndDataArray:)]) {
            [self.delegate hasSwipeToRightDate:self.monthLeftDateArr AndDataArray:self.leftDataArr];
        }
    }
}

//*******************数据源************************//
-(void)setLeftDataArr:(NSArray *)leftDataArr{
    
    _leftDataArr = leftDataArr;
    
    [self addLinesWith:self.graphView];
    
    //添加显示日期
    [self addBottomViewsWith:self andmontnDateArray:self.monthLeftDateArr];
    
    for (UIButton *btn in self.leftBtnArr){
        [btn removeFromSuperview];
    }
    for (UILabel *lable in self.leftdataLabelArr) {
        [lable removeFromSuperview];
    }
    [self.shapeLayer removeFromSuperlayer];
    [self.baseLayer removeFromSuperlayer];
    
    [self addDataPointWith:self.graphView andArr:leftDataArr];//添加点
}

- (void)setMonthLeftDateArr:(NSArray *)monthLeftDateArr{
    _monthLeftDateArr = monthLeftDateArr;
    
    for (UILabel *lable in self.leftLableArr){
        [lable removeFromSuperview];
    }
    
    //添加显示日期
    //    [self addBottomViewsWith:self andmontnDateArray:monthLeftDateArr];
}

- (void)drawRect:(CGRect)rect {
    
    //取得起始点
    CGPoint p1 = [[self.leftPointArr objectAtIndex:0] CGPointValue];
    //    NSLog(@"%f %f",p1.x,p1.y);
    
    //直线的连线
    UIBezierPath *beizer = [UIBezierPath bezierPath];
    [beizer moveToPoint:p1];
    
    
    //遮罩层的形状
    UIBezierPath *bezier1 = [UIBezierPath bezierPath];
    bezier1.lineCapStyle = kCGLineCapRound;
    bezier1.lineJoinStyle = kCGLineJoinMiter;
    [bezier1 moveToPoint:p1];
    
    CGFloat bgViewHeight = self.graphView.bounds.size.height;
    
    for (int i = 0;i<self.leftPointArr.count;i++ ) {
        
        if (i==0) {
            lastPoint = [self.leftPointArr[0] CGPointValue];
        }else{
            CGPoint NowPoint = [self.leftPointArr[i] CGPointValue];
            
            [beizer addCurveToPoint:NowPoint controlPoint1:CGPointMake((lastPoint.x+NowPoint.x)/2, lastPoint.y) controlPoint2:CGPointMake((lastPoint.x+NowPoint.x)/2, NowPoint.y)];//三次曲线
            //            [beizer addQuadCurveToPoint:NowPoint controlPoint:CGPointMake((lastPoint.x+NowPoint.x)/2, NowPoint.y)]; // 二次曲线
            
            [bezier1 addCurveToPoint:NowPoint controlPoint1:CGPointMake((lastPoint.x+NowPoint.x)/2, lastPoint.y) controlPoint2:CGPointMake((lastPoint.x+NowPoint.x)/2, NowPoint.y)];//三次曲线
            //            [bezier1 addQuadCurveToPoint:NowPoint controlPoint:CGPointMake((lastPoint.x+NowPoint.x)/2, NowPoint.y)]; //二次曲线
            
            lastPoint = NowPoint;
        }
        
        //        直线
        //        if (i != 0) {
        //
        //            CGPoint point = [[self.leftPointArr objectAtIndex:i] CGPointValue];
        //            [beizer addLineToPoint:point];
        //
        //            [bezier1 addLineToPoint:point];
        //
        //            if (i == self.leftPointArr.count-1) {
        //                [beizer moveToPoint:point];//添加连线
        //                lastPoint = point;
        //            }
        //        }
    }
    
    //获取最后一个点的X值
    CGFloat lastPointX = lastPoint.x;
    
    //最后一个点对应的X轴的值
    
    CGPoint lastPointX1 = CGPointMake(lastPointX, bgViewHeight);
    
    [bezier1 addLineToPoint:lastPointX1];
    
    //回到原点
    
    [bezier1 addLineToPoint:CGPointMake(p1.x, bgViewHeight)];
    
    [bezier1 addLineToPoint:p1];
    
    //遮罩层
    CAShapeLayer *shadeLayer = [CAShapeLayer layer];
    shadeLayer.path = bezier1.CGPath;
    shadeLayer.fillColor = [UIColor greenColor].CGColor;
    
    //渐变图层
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, 0, self.graphView.bounds.size.height);
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    gradientLayer.cornerRadius = 5;
    gradientLayer.masksToBounds = YES;
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:87/255.0 green:217/255.0 blue:189/255.0 alpha:0.4].CGColor,(__bridge id)[UIColor colorWithRed:254/255.0 green:254/255.0 blue:254/255.0 alpha:0.3].CGColor];
    gradientLayer.locations = @[@(0.0f),@(1.0f)];
    
    self.baseLayer = [CALayer layer];
    [self.baseLayer addSublayer:gradientLayer];
    [self.baseLayer setMask:shadeLayer];
    
    [self.graphView.layer addSublayer:self.baseLayer];
    
    CABasicAnimation *anmi1 = [CABasicAnimation animation];
    anmi1.keyPath = @"bounds";
    anmi1.duration = 2;
    anmi1.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 2*lastPoint.x, self.graphView.bounds.size.height)];
    anmi1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anmi1.fillMode = kCAFillModeForwards;
    anmi1.autoreverses = NO;
    anmi1.removedOnCompletion = NO;
    
    [gradientLayer addAnimation:anmi1 forKey:@"bounds"];
    
    
    //*****************添加动画连线******************//
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.path = beizer.CGPath;
    self.shapeLayer.fillColor = [UIColor clearColor].CGColor;
    self.shapeLayer.strokeColor = [UIColor greenColor].CGColor;
    self.shapeLayer.lineWidth = 2;
    [self.graphView.layer addSublayer:self.shapeLayer];
    
    
    CABasicAnimation *anmi = [CABasicAnimation animation];
    anmi.keyPath = @"strokeEnd";
    anmi.fromValue = [NSNumber numberWithFloat:0];
    anmi.toValue = [NSNumber numberWithFloat:1.0f];
    anmi.duration = 2;
    anmi.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anmi.autoreverses = NO;
    
    [self.shapeLayer addAnimation:anmi forKey:@"stroke"];
    
    for (UIButton *btn in self.leftBtnArr) {
        [self.graphView addSubview:btn];
    }
    for (UILabel *lable in self.leftdataLabelArr) {
        [self.graphView addSubview:lable];
    }
    
}

// 添加点
-(void)addDataPointWith:(UIView *)view andArr:(NSArray *)leftData{
    
    [self.leftPointArr removeAllObjects];
    [self.leftBtnArr removeAllObjects];
    [self.leftdataLabelArr removeAllObjects];
    
    //初始点
    NSMutableArray *arr = [NSMutableArray arrayWithArray:leftData];
    
    CGFloat height = self.graphView.bounds.size.height-30;
    
    //2.获取目标值点坐标
    NSMutableArray *sortArray = [NSMutableArray arrayWithArray:[arr sortedArrayUsingSelector:@selector(compare:)]];
    for (int i = 0; i < sortArray.count * 0.5; i++) {
        [sortArray exchangeObjectAtIndex:i withObjectAtIndex:sortArray.count-i-1];
    }
    for (int i=0; i<arr.count; i++) {
        //        CGFloat doubleValue = 2*[arr[i] floatValue]; //目标值放大两倍
        CGFloat X = (Xmargin)*i;
        //        CGFloat Y = height-Xmargin-doubleValue;
        //        CGFloat Y = [arr[i] floatValue] / 100 * height;
        CGFloat Y = 0;
        for (int j = 0; j < sortArray.count; j++) {
            if (arr[i] == sortArray[j]) {
                Y = height/(arr.count-1) * j+15;
                break;
            }
        }
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(X, Y, 15, 15)];
        btn.backgroundColor = [UIColor whiteColor];
        btn.layer.borderColor = [UIColor greenColor].CGColor;
        btn.layer.borderWidth = 1;
        btn.layer.cornerRadius = 7.5;
        btn.layer.masksToBounds = YES;
        btn.tag = i;
        
        UILabel *dataLabel = [[UILabel alloc] initWithFrame:CGRectMake(X, Y-25, 50, 20)];
        dataLabel.textColor = [UIColor lightGrayColor];
        dataLabel.font = [UIFont systemFontOfSize:12];
        dataLabel.text = arr[i];
        dataLabel.textAlignment = NSTextAlignmentCenter;
        
        
        if (i != 0 && i != arr.count-1) {
            btn.hidden = NO;
            dataLabel.hidden = NO;
            [btn addTarget:self action:@selector(clickTopBtn:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            btn.hidden = YES;
            dataLabel.hidden = YES;
        }
        [self.leftBtnArr addObject:btn];
        [self.leftdataLabelArr addObject:dataLabel];
        
        NSValue *point = [NSValue valueWithCGPoint:btn.center];
        if (i == 0 || i == arr.count-1) {
            point = [NSValue valueWithCGPoint:CGPointMake(btn.frame.origin.x, btn.center.y)];
        }
        
        [self.leftPointArr addObject:point];
        
    }
}


-(void)addBottomViewsWith:(UIView *)UIView andmontnDateArray:(NSArray *)monthDateArray{
    
    [self.leftLableArr removeAllObjects];
    for (int i = 0;i<monthDateArray.count ;i++ ) {
        
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(i*Xmargin-12, 15, 50, 30)];
        leftLabel.textColor = [UIColor lightGrayColor];
        leftLabel.font = [UIFont systemFontOfSize:12];
        leftLabel.text = monthDateArray[i];
        leftLabel.textAlignment = 0;
        
        [self.leftLableArr addObject:leftLabel];
        
        if (i != 0 && i != self.monthLeftDateArr.count-1) {
            [self.graphdateView addSubview:leftLabel];
        }
    }
}


-(void)addLinesWith:(UIView *)view{
    
    CGFloat magrginHeight = (view.bounds.size.height)/5;
    CGFloat labelWith = view.bounds.size.width;
    Ymargin = magrginHeight;
    
    for (int i = 0;i<4 ;i++ ) {
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, magrginHeight+magrginHeight*i, labelWith, 1)];
        
        label.backgroundColor = [UIColor clearColor];
        [view addSubview:label];
    }
    
    CGFloat marginWidth = view.bounds.size.width/(self.leftDataArr.count-1);
    Xmargin = marginWidth;
    CGFloat labelHeight = view.bounds.size.height;
    
    for (int i = 0;i<self.leftDataArr.count ;i++ ) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(marginWidth*i, 0, 1, labelHeight)];
        label.backgroundColor = [UIColor clearColor];
        [view addSubview:label];
    }
}

- (void)reloadData{
    [self setNeedsDisplay];
}

- (void)clickTopBtn:(UIButton *)btn{
    
}

@end
