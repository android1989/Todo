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
@property (nonatomic, assign) MenuState state;
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
    [self configureTapGesture];
    self.state = MenuStateClosed;
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
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureRecognizer:)];
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
}

#pragma mark - Menu Animations

- (void)animateMenuOpen
{
    self.state = MenuStateOpen;
    [self animateMenuToCGPoint:CGPointMake(230, 470)];
}

- (void)animateMenuClose
{
    self.state = MenuStateClosed;
    [self animateMenuToCGPoint:CGPointMake(305, 546)];
}

- (void)animateMenuToCGPoint:(CGPoint)endPoint
{
    CGFloat distance = [self getMenuDistanceFromCGPoint:self.menuView.center];
    CGFloat finalDistance = [self getMenuDistanceFromCGPoint:endPoint];
    NSInteger bounceFactor = (finalDistance-distance)/10;
    [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.menuView.center = CGPointMake(endPoint.x-bounceFactor, endPoint.y-bounceFactor);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.menuView.center = CGPointMake(endPoint.x, endPoint.y);
        } completion:^(BOOL finished) {
            
        }];
    }];
}
#pragma mark - UITapGestureRecognizer

- (void)handleTapGestureRecognizer:(UITapGestureRecognizer *)tapGestureRecognizer
{
    switch (self.state)
    {
        case MenuStateClosed:
            [self animateMenuOpen];
            break;
        case MenuStateOpen:
            [self animateMenuClose];
            break;
    }
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
    
    if (translation.x < 0 && translation.y > 0)
    {
        translationValue = 0;
    }
    translationValue *= 0.35;
    
    CGPoint newCenter = self.menuView.center;
    newCenter.x += translationValue;
    newCenter.y += translationValue;
    CGPoint bottomCorner = CGPointMake(305, 546);
    CGFloat totalDistance = sqrt(pow(bottomCorner.x-newCenter.x, 2)+pow(bottomCorner.y-newCenter.y, 2));
    
    switch (panGestureRecognizer.state)
    {
        case UIGestureRecognizerStateBegan:
            
            break;
        case UIGestureRecognizerStateEnded:
        {
            CGFloat finalDistance = [self getMenuDistanceFromCGPoint:CGPointMake(230, 470)];
            if (totalDistance > finalDistance/2.0f)
            {
                [self animateMenuOpen];
            }else{
                [self animateMenuClose];
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            if (totalDistance < 120)
            {
                self.menuView.center = newCenter;
            }
            
            if (newCenter.x > 305)
            {
                self.menuView.center = bottomCorner;
            }
        }
        default:
            break;
    }
    
    [panGestureRecognizer setTranslation:CGPointZero inView:self.view];
}

#pragma mark - Helpers
- (CGFloat)getMenuDistanceFromCGPoint:(CGPoint)origin;
{
    CGPoint bottomCorner = CGPointMake(305, 546);
    return sqrt(pow(bottomCorner.x-origin.x, 2)+pow(bottomCorner.y-origin.y, 2));
}
@end
