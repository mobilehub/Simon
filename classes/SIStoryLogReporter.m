//
//  SIStoryLogReporter.m
//  Simon
//
//  Created by Derek Clarkson on 6/28/11.
//  Copyright 2011 Sensis. All rights reserved.
//

#import "SIStoryLogReporter.h"
#import "SIStory.h"
#import "SIStep.h"

@interface SIStoryLogReporter()
-(void) reportStory:(SIStory *) story;
@end

@implementation SIStoryLogReporter

-(void) reportOnStories:(NSArray *) stories {
	
	NSLog(@"Simon's run report");
	NSLog(@"====================================================");

	// Count result types.
	int successes = 0;
	int notMapped = 0;
	int failures = 0;
	int ignored = 0;
	int notRun = 0;
	for (SIStory * story in stories) {
		
		[self reportStory:story];
		
		switch (story.status) {
			case SIStoryStatusSuccess:
				successes++;
				break;
			case SIStoryStatusNotMapped:
				notMapped++;
				break;
			case SIStoryStatusError:
				failures++;
				break;
			case SIStoryStatusIgnored:
				ignored++;
				break;
			default:
				notRun++;
				break;
		}
	}
	
	NSLog(@" ");
	NSLog(@"Total stories    : %u", [stories count]);
	NSLog(@"Not run          : %i", notRun);
	NSLog(@"Not fully mapped : %i", notMapped);
	NSLog(@"Successfully run : %i", successes);
	NSLog(@"Ignored          : %i", ignored);
	NSLog(@"Failures         : %u", [stories count]);
	
}

-(void) reportStory:(SIStory *) story {
 
	NSLog(@" ");
	NSLog(@"Story");
	
	NSString *status;
	switch (story.status) {
		case SIStoryStatusSuccess:
			status = @"Success";
			break;
		case SIStoryStatusNotMapped:
			status = @"Not mapped";
			break;
		case SIStoryStatusError:
			status = [NSString stringWithFormat:@"Failed: %@", story.error.localizedFailureReason];
			break;
		case SIStoryStatusIgnored:
			status = @"Ignored";
			break;
		default:
			status = @"Not run";
			break;
	}
	
	NSLog(@"Final status: %@", status);
	NSLog(@"Step report:");
	
	for (SIStep * step in story.steps) {
		if ([step isMapped]) {
			NSLog(@"Step: %@, mapped to %@::%@", step.command, 
					NSStringFromClass(step.stepMapping.targetClass),
					NSStringFromSelector(step.stepMapping.selector));
		} else {
			NSLog(@"Step: %@, NOT MAPPED", step.command);
		}
	}
	
	
	
	
}

@end
