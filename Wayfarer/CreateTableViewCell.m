//
//  CreateTableViewCell.m
//  Wayfarer
//
//  Created by Chloe on 2016-02-09.
//  Copyright © 2016 Chloe Horgan. All rights reserved.
//

#import "CreateTableViewCell.h"

@implementation CreateTableViewCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - Text View

- (void)textViewDidChange:(UITextView *)textView {
    self.photo.location = textView.text;
}

@end
