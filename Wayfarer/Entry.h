//
//  Entry.h
//  Wayfarer
//
//  Created by Chloe on 2016-02-08.
//  Copyright © 2016 Chloe Horgan. All rights reserved.
//

#import <Realm/Realm.h>
#import "Photo.h"

@interface Entry : RLMObject
@property NSDate *date;
@property RLMArray<Photo *><Photo> *photos;
@end

// This protocol enables typed collections. i.e.:
// RLMArray<Entry>
RLM_ARRAY_TYPE(Entry)
