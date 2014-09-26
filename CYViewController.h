//
//  CYViewController.h
//  mySnake
//
//  Created by cy on 14-9-26.
//  Copyright (c) 2014年 cy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYViewController : UIViewController
{
    NSTimer *_myTimer;
    NSMutableArray *_bodyArry;
    NSInteger _changeX;
    NSInteger _changeY;
    CGPoint _foodPoint;
}
- (IBAction)start:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (retain, nonatomic)  UILabel *head;
@property (retain, nonatomic)  UILabel *food;

@end
