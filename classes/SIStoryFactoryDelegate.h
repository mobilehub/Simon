//
//  SIStoryFactoryDelegate.h
//  Simon
//
//  Created by Derek Clarkson on 6/7/11.
//  Copyright 2011 Sensis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SIStory.h"

/**
 * Implement to receive notifications that a story is ready.
 */
@protocol SIStoryFactoryDelegate <NSObject>

-(void) didReadStory:(SIStory *) aStory;

@end
