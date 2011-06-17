//
//  StoryRunner.m
//  Simon
//
//  Created by Derek Clarkson on 6/17/11.
//  Copyright 2011 Sensis. All rights reserved.
//

#import <dUsefulStuff/DCCommon.h>
#import "SIStoryRunner.h"
#import "SIStory.h"

@implementation SIStoryRunner

@synthesize reader;

- (id)init
{
    self = [super init];
    if (self) {
		 reader = [[SIStoryFileReader alloc] init];
    }
    
    return self;
}

-(void) runStories:(NSError **) error {
	
	
	// Read the stories.
	DC_LOG(@"Reading stories");
	NSArray *stories = [reader readStories: error];
	if (stories == nil) {
		return;
	}

	// Now execute the stories.
	DC_LOG(@"Running %lu stories", [stories count]);
	for (SIStory *story in stories) {
		[story execute];
	}
	
	DC_LOG(@"Done.");
}


-(void) dealloc {
	self.reader = nil;
	[super dealloc];
}

@end
