//
//  CLMListCell.m
//  Todo
//
//  Created by Andrew Hulsizer on 5/25/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import "CLMListCell.h"

@interface CLMListCell () 
@property (nonatomic, weak) IBOutlet UIImageView *backgroundImageView;
@end

@implementation CLMListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
        [self.contentView addSubview:view];
        
        [self configureFont];
    }
    return self;
}

- (void)configureFont
{
    [_titleLabel setFont:[UIFont fontWithName:@"OpenSans-SemiboldItalic" size:14]];
}

@end
