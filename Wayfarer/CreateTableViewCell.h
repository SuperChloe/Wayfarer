//
//  CreateTableViewCell.h
//  Wayfarer
//
//  Created by Chloe on 2016-02-09.
//  Copyright © 2016 Chloe Horgan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"

@interface CreateTableViewCell : UITableViewCell <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) Photo *photo;

@end
