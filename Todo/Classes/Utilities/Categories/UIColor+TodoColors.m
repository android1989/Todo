//
//  UIColor+TodoColors.m
//  Todo
//
//  Created by Andrew Hulsizer on 5/23/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import "UIColor+TodoColors.h"

float cf(float number)
{
    return number/255.0f;
}

@implementation UIColor (TodoColors)

+ (UIColor *)creamColor
{
    return [UIColor colorWithRed:cf(244) green:cf(245) blue:cf(188) alpha:1.0];
}

+ (UIColor *)tanColor1
{
    return [UIColor colorWithRed:cf(243) green:cf(228) blue:cf(151) alpha:1.0];
}

+ (UIColor *)tanColor2
{
    return [UIColor colorWithRed:cf(210) green:cf(178) blue:cf(84) alpha:1.0];
}

+ (UIColor *)tealColor
{
    return [UIColor colorWithRed:cf(99) green:cf(172) blue:cf(160) alpha:1.0];
}

+ (UIColor *)fireColor
{
    return [UIColor colorWithRed:cf(224) green:cf(74) blue:cf(43) alpha:1.0];
}
@end
