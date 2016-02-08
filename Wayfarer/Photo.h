//
//  Photo.h
//  Wayfarer
//
//  Created by Chloe on 2016-02-08.
//  Copyright © 2016 Chloe Horgan. All rights reserved.
//

#import <Realm/Realm.h>

@interface Photo : RLMObject
<# Add properties here to define the model #>
@end

// This protocol enables typed collections. i.e.:
// RLMArray<Photo>
RLM_ARRAY_TYPE(Photo)
