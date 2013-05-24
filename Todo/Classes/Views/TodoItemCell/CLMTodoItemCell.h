//
//  CLMTodoItemCell.h
//  Todo
//
//  Created by Andrew Hulsizer on 5/23/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLMTodoItemCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UITextField *titleField;
- (NSInteger)cellHeight;
@end
