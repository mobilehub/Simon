//
//  StoryRunner.h
//  Simon
//
//  Created by Derek Clarkson on 6/17/11.
//  Copyright 2011 Sensis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SIStoryFileReader.h"

@interface SIStoryRunner : NSObject {
	@private 
	SIStoryFileReader * reader;
}

@property (retain, nonatomic) SIStoryFileReader * reader;

-(void) runStories:(NSError **) error;

@end
