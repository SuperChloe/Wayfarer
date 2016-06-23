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
    self.swapButton.layer.borderColor = [UIColor blackColor].CGColor;
    [self addDoneToolBarToKeyboard:self.textView];
    self.textView.delegate = self;
    self.textView.editable = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - Text View

- (void)textViewDidChange:(UITextView *)textView {
    self.photo.location = textView.text;
}

-(void)addDoneToolBarToKeyboard:(UITextView *)textView {
    UIToolbar* doneToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    doneToolbar.barStyle = UIBarStyleDefault;
    UIBarButtonItem *done = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonClickedDismissKeyboard)];
    done.tintColor = [UIColor blackColor];
    doneToolbar.items = [NSArray arrayWithObjects:
                         [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], done, nil];
    [doneToolbar sizeToFit];
    textView.inputAccessoryView = doneToolbar;
}

-(void)doneButtonClickedDismissKeyboard {
    [self.textView resignFirstResponder];
}



@end
