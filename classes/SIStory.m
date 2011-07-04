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
#import "NSObject+Utils.h"
#import "SISimon.h"

@interface SIStory()
-(id) instanceForTargetClass:(Class) targetClass;
@end

@implementation SIStory

@synthesize status;
@synthesize error;
@synthesize steps;
@synthesize title;

-(id) init {
	self = [super init];
	if (self) {
		steps = [[NSMutableArray alloc] init];
		instanceCache = [[NSMutableDictionary alloc] init];
		storyCache = [[NSMutableDictionary alloc] init];
		status = SIStoryStatusNotRun;
		error = nil;
	}
	return self;
}

-(SIStep *) newStepWithKeyword:(SIKeyword) keyword command:(NSString *) theCommand {
	SIStep * step = [[[SIStep alloc] initWithKeyword:keyword command:theCommand] autorelease];
	DC_LOG(@"Adding new step with keyword %i and command \"%@\"", keyword, theCommand);
	[steps addObject:step];
	return step;
}

-(SIStep *) stepAtIndex:(NSUInteger) index {
	return [steps objectAtIndex:index];
}

-(BOOL) invoke {
	
	// If the story is not fully mapped then exit because we cannot run it.
	for (SIStep *step in steps) {
		if (![step isMapped]) {
			DC_LOG(@"Story is not fully mapped. Cannot execute step %@", step.command);
			status = SIStoryStatusNotMapped;
			return NO;
		}
	}
	
	DC_LOG(@"Executing steps");
	for (SIStep *step in steps) {
		
		// First check the cache for an instance of the class. 
		// Create an instance of the class if we don't have one.
		id instance = [self instanceForTargetClass:step.stepMapping.targetClass];
		
		// Now invoke the step on the class.
		if (![step invokeWithObject:instance error:&error]) {
			[error retain];
			status = SIStoryStatusError;
			return NO;
		}
	}
	
	status = SIStoryStatusSuccess;
	return YES;
}

-(id) instanceForTargetClass:(Class) targetClass {
	
	NSString *cacheKey = NSStringFromClass(targetClass);
	
	id instance = [instanceCache objectForKey:cacheKey];
	if (instance != nil) {
		return instance;
	}
	
	// Create one.
	DC_LOG(@"Creating instance of %@", NSStringFromClass(targetClass));
	instance = [[[targetClass alloc] init] autorelease];
	[instanceCache setObject:instance forKey:cacheKey];

	// Inject a reference to the story so it can be accessed for data.
	objc_setAssociatedObject(instance, SIINSTANCE_STORY_REF_KEY, self, OBJC_ASSOCIATION_ASSIGN);
	
	return instance;
}

-(void) mapSteps:(NSArray *) mappings {
	for (SIStep *step in steps) {
		[step findMappingInList:mappings];
	}
}

-(void) storeObject:(id) object withKey:(id) key {
	[storyCache setObject:object forKey:key];
}

-(id) retrieveObjectWithKey:(id) key {
	return [storyCache objectForKey:key];
}

-(void) dealloc {
	DC_DEALLOC(steps);
	DC_DEALLOC(instanceCache);
	DC_DEALLOC(storyCache);
	DC_DEALLOC(error);
	self.title = nil;
	[super dealloc];
}

@end
