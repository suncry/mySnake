//
//  CYViewController.m
//  mySnake
//
//  Created by cy on 14-9-26.
//  Copyright (c) 2014年 cy. All rights reserved.
//

#import "CYViewController.h"
#define changeValueX _head.frame.size.width
#define changeValueY _head.frame.size.height

@interface CYViewController ()

@end

@implementation CYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self reSetGame];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
- (IBAction)start:(id)sender
{
    if ([_myTimer isValid])
    {
        [self reSetGame];
        [_startBtn setTitle:@"开始" forState:UIControlStateNormal];
    }
    else
    {
        _myTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(snaking) userInfo:nil repeats:YES];
        [_startBtn setTitle:@"重来" forState:UIControlStateNormal];
    }
}
- (void)snaking
{
    CGPoint tempPoint = _head.center;
    //移动蛇头
    _head.center = CGPointMake(_head.center.x + _changeX, _head.center.y + _changeY);
    //移动蛇身
//    NSMutableArray *tempBodyArray = [[NSMutableArray alloc]init];
    for (int i = _bodyArry.count;i>0;i--)
    {
        UILabel *bodyLabel = _bodyArry[i-1];
        if (i - 1 == 0)
        {
            bodyLabel.center = tempPoint;
        }
        else
        {
            UILabel *preBodyLabel = _bodyArry[i-2];
            bodyLabel.center = CGPointMake(preBodyLabel.center.x, preBodyLabel.center.y);
        }

    }
    
    //判断是否吃到东西
    if ([self rectOne:_head.frame inTheRectTwo:_food.frame])
    {
        //重设food位置
        [self setFoodPoint];
        //body + 1
        [self bodyLongger];
    }
    //判断是否 撞到墙
    [self isBeyoundBounds];
    //判断是否 撞到自己
    [self isGameOver];
}
//判断一个点是否在一个rect里面
- (BOOL)isPoint:(CGPoint)point
      inTheRect:(CGRect)rect
{
    if (point.x > rect.origin.x && point.x < rect.origin.x + rect.size.width && point.y > rect.origin.y && point.y < rect.origin.y + rect.size.height)
    {
        return YES;
    }
    return NO;
}
//检测两个rect是否交互，判断蛇是否吃到东西
- (BOOL)rectOne:(CGRect)rectOne
      inTheRectTwo:(CGRect)rectTwo
{
    for (int x = rectOne.origin.x; x < rectOne.origin.x + rectOne.size.width; x++)
    {
        for (int y = rectOne.origin.y; y < rectOne.origin.y + rectOne.size.height; y++)
        {
            CGPoint point = CGPointMake(x, y);
            if ([self isPoint:point inTheRect:rectTwo])
            {
                return YES;
            }
        }
    }
    return NO;
}
- (void)setFoodPoint
{
    _foodPoint = CGPointMake(rand()%260 + 20, rand()%400 +50);
    _food.center = _foodPoint;
}
- (void)bodyLongger
{
    if (_bodyArry.count == 0)
    {
        UILabel *bodyLabel = [[UILabel alloc]initWithFrame:CGRectMake(_head.frame.origin.x - _changeX,
                                                                      _head.frame.origin.y - _changeY,
                                                                      _head.frame.size.width,
                                                                      _head.frame.size.height)];
        bodyLabel.backgroundColor = [UIColor blackColor];
        bodyLabel.tag = 1000;
        [self.view addSubview:bodyLabel];
        [_bodyArry addObject:bodyLabel];
    }
    else
    {
        UILabel *preBodyLabel = _bodyArry[_bodyArry.count - 1];
        UILabel *bodyLabel = [[UILabel alloc]initWithFrame:CGRectMake(preBodyLabel.frame.origin.x - _changeX,
                                                                      preBodyLabel.frame.origin.y - _changeY,
                                                                      preBodyLabel.frame.size.width,
                                                                      preBodyLabel.frame.size.height)];
//        bodyLabel.backgroundColor = [UIColor blackColor];
        
        bodyLabel.backgroundColor = [UIColor colorWithRed:rand()%255/255.0f green:rand()%255/255.0f blue:rand()%255/255.0f alpha:1.0f];
        bodyLabel.tag = 1000;
        [self.view addSubview:bodyLabel];
        [_bodyArry addObject:bodyLabel];

    }
    NSLog(@"_bodyArry.count == %d",_bodyArry.count);
    for (UILabel *label in _bodyArry)
    {
        NSLog(@"label.center.x == %f,label.center.y == %f",label.center.x,label.center.y);
    }

}
//获取点击的点
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    [self changeSnakeDirection:point];
}
//根据点击的点 控制蛇的方向
- (void)changeSnakeDirection:(CGPoint)point
{
    //目前竖向移动
    if (_changeX == 0)
    {
        _changeY = 0;
        if (point.x > _head.center.x)
        {
            //右转
            _changeX = changeValueX;
        }
        else
        {
            //左转
            _changeX = -changeValueX;
        }
    }
    //目前横向移动
    else if(_changeY == 0)
    {
        _changeX = 0;
        if (point.y > _head.center.y)
        {
            //下转
            _changeY = changeValueY;
        }
        else
        {
            //上转
            _changeY = -changeValueY;
        }

    }
}
- (void)isBeyoundBounds
{
    if (_head.center.x > self.view.bounds.size.width)
    {
        _head.center = CGPointMake(0, _head.center.y);
    }
    else if (_head.frame.origin.y > self.view.bounds.size.height)
    {
        _head.center = CGPointMake(_head.center.x, 0);
    }
    else if (_head.center.x < 0)
    {
        _head.center = CGPointMake(self.view.bounds.size.width, _head.center.y);
    }
    else if (_head.frame.origin.y < 0)
    {
        _head.center = CGPointMake(_head.center.x, self.view.bounds.size.height);
    }
}
- (void)isGameOver
{
    //碰到自己游戏结束
    for (UILabel *label in _bodyArry)
    {
        if ([self rectOne:label.frame inTheRectTwo:_head.frame])
        {
            [self reSetGame];
            break;
        }
    }
}
- (void)reSetGame
{
    for (UIView *view in self.view.subviews)
    {
        if (view.tag == 1000)
        {
            [view removeFromSuperview];
        }
    }
    [_head removeFromSuperview];
    [_food removeFromSuperview];
    [_bodyArry removeAllObjects];
    _head = [[UILabel alloc]initWithFrame:CGRectMake(120,200,20,20)];
    _head.backgroundColor = [UIColor redColor];
    [self.view addSubview:_head];
    
    _food = [[UILabel alloc]initWithFrame:CGRectMake(180,260,20,20)];
    _food.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_food];
    
    //初始化蛇的移动变量   最开始 向右移动
    _changeX = changeValueX;
    _changeY = 0;
    _bodyArry = [[NSMutableArray alloc]init];
    [_myTimer invalidate];
}
@end
