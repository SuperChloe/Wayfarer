//
//  Photo.h
//  Wayfarer
//
//  Created by Chloe on 2016-02-08.
//  Copyright © 2016 Chloe Horgan. All rights reserved.
//

#import <Realm/Realm.h>
@class Entry;

@interface Photo : RLMObject

@property NSData *photo;
@property NSString *location;
@property Entry *entry;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<Photo>
RLM_ARRAY_TYPE(Photo)
