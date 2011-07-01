//
//  SIStoryReporter.h
//  Simon
//
//  Created by Derek Clarkson on 6/28/11.
//  Copyright 2011 Sensis. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SIStoryReporter <NSObject>

-(void) reportOnStories:(NSArray *) stories andMappings:(NSArray *) mappings;

@end
