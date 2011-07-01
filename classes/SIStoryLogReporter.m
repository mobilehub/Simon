//
//  SIStoryLogReporter.m
//  Simon
//
//  Created by Derek Clarkson on 6/28/11.
//  Copyright 2011 Sensis. All rights reserved.
//

#import <dUsefulStuff/DCCommon.h>

#import "SIStoryLogReporter.h"
#import "SIStory.h"
#import "SIStep.h"
#import "SIStepMapping.h"

@interface SIStoryLogReporter()
-(void) reportStory:(SIStory *) story
			 successes:(NSMutableArray *) successes
			 notMapped:(NSMutableArray *) notMapped
			  failures:(NSMutableArray *) failures
				ignored:(NSMutableArray *) ignored
				 notRun:(NSMutableArray *) notRun;
-(void) reportUnusedMappings:(NSArray *) mappings;
@end

@implementation SIStoryLogReporter

-(void) reportOnStories:(NSArray *) stories andMappings:(NSArray *) mappings {
	
	NSLog(@"Simon's run report");
	NSLog(@"====================================================");
	
	// Count result types.
	NSMutableArray * successes = [[NSMutableArray alloc] init];
	NSMutableArray * notMapped = [[NSMutableArray alloc] init];
	NSMutableArray * failures = [[NSMutableArray alloc] init];
	NSMutableArray * ignored = [[NSMutableArray alloc] init];
	NSMutableArray * notRun = [[NSMutableArray alloc] init];
	
	for (SIStory * story in stories) {
		[self reportStory:story successes:successes notMapped:notMapped failures:failures ignored:ignored notRun:notRun];
	}
	
	NSLog(@" ");
	NSLog(@"Total stories    : %u", [stories count]);
	NSLog(@"Not run          : %u", [notRun count]);
	NSLog(@"Not fully mapped : %u", [notMapped count]);
	NSLog(@"Successfully run : %u", [successes count]);
	NSLog(@"Ignored          : %u", [ignored count]);
	NSLog(@"Failures         : %u", [failures count]);
	
	for (SIStory *story in failures) {
		NSLog(@"Failed story: %@", story.title);
	}

	[self reportUnusedMappings:mappings];
	
	DC_DEALLOC(successes);
	DC_DEALLOC(notRun);
	DC_DEALLOC(notMapped);
	DC_DEALLOC(successes);
	DC_DEALLOC(ignored);
	
}

-(void) reportStory:(SIStory *) story
			 successes:(NSMutableArray *) successes
			 notMapped:(NSMutableArray *) notMapped
			  failures:(NSMutableArray *) failures
				ignored:(NSMutableArray *) ignored
				 notRun:(NSMutableArray *) notRun {
	
	NSLog(@" ");
	NSLog(@"Story: %@", story.title);
	
	NSString *status;
	switch (story.status) {
		case SIStoryStatusSuccess:
			status = @"Success";
			[successes addObject:story];
			break;
		case SIStoryStatusNotMapped:
			status = @"Not mapped";
			[notMapped addObject:story];
			break;
		case SIStoryStatusError:
			status = [NSString stringWithFormat:@"Failed: %@", story.error.localizedFailureReason];
			[failures addObject:story];
			break;
		case SIStoryStatusIgnored:
			status = @"Ignored";
			[ignored addObject:story];
			break;
		default:
			status = @"Not run";
			[notRun addObject:story];
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

-(void) reportUnusedMappings:(NSArray *) mappings {
	NSLog(@" ");
	NSLog(@"Unused step to selector mappings");
	int count = 0;
	for (SIStepMapping * mapping in mappings) {
		if (!mapping.executed) {
			count++;
			NSLog(@"\tMapping \"%@\" -> %@::%@", mapping.regex.pattern, NSStringFromClass(mapping.targetClass), NSStringFromSelector(mapping.selector));
		}
	}
	if (count == 0) {
		NSLog(@"All step mappings where executed during the tests.");
	}
}


@end
