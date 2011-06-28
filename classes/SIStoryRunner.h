//
//  StoryRunner.h
//  Simon
//
//  Created by Derek Clarkson on 6/17/11.
//  Copyright 2011 Sensis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SIStoryFileReader.h"
#import "SIRuntime.h"

@interface SIStoryRunner : NSObject {
	@private 
	SIStoryFileReader * reader;
	SIRuntime *runtime;
}

@property (retain, nonatomic) SIStoryFileReader * reader;
@property (retain, readonly) SIRuntime *runtime;

-(BOOL) runStories:(NSError **) error;

@end
