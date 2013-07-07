//
//  CLMMenuViewController.m
//  Todo
//
//  Created by Andrew Hulsizer on 7/6/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import "CLMMenuViewController.h"

typedef NS_ENUM(NSInteger, MenuState)
{
    MenuStateOpen,
    MenuStateClosed
};

@interface CLMMenuViewController ()

@property (nonatomic, weak) IBOutlet UIView *menuView;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@end

@implementation CLMMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configurePanGesture];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configurePanGesture
{
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestureRecognizer:)];
    [self.view addGestureRecognizer:self.panGestureRecognizer];
}

- (void)configureTapGesture
{
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    
}
#pragma mark - UIPanGestureRecognizer
- (void)handlePanGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer
{
    CGPoint translation = [panGestureRecognizer translationInView:self.view];
    NSInteger yDirection = translation.y > 0 ? 1 : -1;
    NSInteger xDirection = translation.x > 0 ? 1 : -1;
    NSInteger direction = (yDirection < 0) && (xDirection < 0) ? -1 : 1;
    CGFloat translationValue = 0;
    
    if (abs(translation.x) > abs(translation.y))
    {
        translationValue = translation.x;
    }else{
        translationValue = translation.y;
    }
   
    CGPoint newCenter = self.menuView.center;
    newCenter.x += translationValue;
    newCenter.y += translationValue;
    
    CGPoint bottomCorner = CGPointMake(305, 546);
    CGFloat totalDistance = sqrt(pow(bottomCorner.x-newCenter.x, 2)+pow(bottomCorner.y-newCenter.y, 2));
    if (totalDistance < 100)
    {
        self.menuView.center = newCenter;
    }
    
    if (newCenter.x > 305)
    {
        self.menuView.center = bottomCorner;
    }
    
    
    [panGestureRecognizer setTranslation:CGPointZero inView:self.view];
}
@end
