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
#import "SIStepMapping.h"
#import "NSObject+Utils.h"

@interface SIStoryRunner()
@end

@implementation SIStoryRunner

@synthesize reader;
@synthesize runtime;

- (id)init
{
    self = [super init];
    if (self) {
		 reader = [[SIStoryFileReader alloc] init];
		 runtime = [[SIRuntime alloc] init];
    }
    
    return self;
}

-(BOOL) runStories:(NSError **) error {
	
	// Read the runtime to local all mappings. 
	NSArray * mappings = [runtime allMappingMethodsInRuntime];
	
	// Read the stories.
	DC_LOG(@"Reading stories");
	NSArray *stories = [reader readStories: error];
	if (stories == nil || [stories count] == 0) {
		*error = [self errorForCode:SIErrorNoStoriesFound 
					  shortDescription:@"No stories read" 
						  failureReason:@"No stories where read from the files."];
		return NO;
	}
	
	// Find the mapping for each story.
	DC_LOG(@"Mappin steps to story steps");
	for (SIStory *story in stories) {
		[story mapSteps:(NSArray *) mappings];
	}

	// Now execute the stories.
	DC_LOG(@"Running %lu stories", [stories count]);
	for (SIStory *story in stories) {
		if (![story invoke:error]) {

			// If it's a step that is not mapped then skip the story.
			if (story.status == SIStoryStatusNotMapped) {
				DC_LOG(@"Story not fully mapped");
				continue;
			}
			
			// It's something else so exit the run.
			DC_LOG(@"Error %@", [*error localizedFailureReason]);
			return NO;
		}
	}

	DC_LOG(@"Done.");
	return YES;
}


-(void) dealloc {
	self.reader = nil;
	DC_DEALLOC(runtime);
	[super dealloc];
}

@end
