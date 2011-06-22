//
//  Story.m
//  Simon
//
//  Created by Derek Clarkson on 5/30/11.
//  Copyright 2011 Sensis. All rights reserved.
//

#import <dUsefulStuff/DCCommon.h>

#import "SIStory.h"
#import "SIStep.h"

@implementation SIStory

-(id) init {
	self = [super init];
	if (self) {
		steps = [[NSMutableArray alloc] init];
	}
	return self;
}

-(void) newStepWithKeyword:(SIKeyword) keyword command:(NSString *) theCommand {
	SIStep * step = [[SIStep alloc] initWithKeyword:keyword command:theCommand];
	DC_LOG(@"Adding new step with keyword %i and command \"%@\"", keyword, theCommand);
	[steps addObject:step];
	[step release];
}

-(SIStep *) stepAtIndex:(NSUInteger) index {
	return [steps objectAtIndex:index];
}

-(NSUInteger) numberOfSteps {
	return [steps count];
}

-(void) execute {
	DC_LOG(@"Executing steps");
	//NSInvocation * invocation;
	for (SIStep *step in steps) {
		//invocation = [step invocation];
		//DC_LOG(@"Looking for selector %@", NSStringFromSelector([invocation selector]));
	}
}

-(void) mapSteps:(NSArray *) mappings {
	
}

-(void) dealloc {
	DC_DEALLOC(steps);
	[super dealloc];
}

@end
