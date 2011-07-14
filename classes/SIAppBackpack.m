//
//  SIAppBackpack.m
//  Simon
//
//  Created by Derek Clarkson on 7/13/11.
//  Copyright 2011 Sensis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SIAppBackpack.h"
#import <dUsefulStuff/DCCommon.h>
#import <dUsefulStuff/DCDialogs.h>
#import <dUsefulStuff/DCBackgroundThread.h>
#import "SIStoryRunner.h"


@interface SIAppBackpack()
-(void) startUp:(NSNotification *) notification;
@end

@implementation SIAppBackpack

- (id)init
{
	self = [super init];
	if (self) {

		// Hook into the app startup.
		DC_LOG(@"Applying program hooks to notification center: %@", [NSNotificationCenter defaultCenter]);
		[[NSNotificationCenter defaultCenter] addObserver:self 
															  selector:@selector(startUp:) 
																	name:UIApplicationDidBecomeActiveNotification 
																 object:nil];
	}
	
	return self;
}

-(id) initWithStoryFile:(NSString *) aFileName {
	id me = [self init];
	fileName = [aFileName retain];
	return me;
}


// From DCBackgroundTask
-(void) start {
	
	DC_LOG(@"Simon's background task starting");
	[NSThread currentThread].name = @"Simon";

	SIStoryRunner *runner = [[SIStoryRunner alloc] init];
	
	// Now tell it to use just the passed story file is present.
	if (fileName != nil) {
		SIStoryFileReader *reader = [[SIStoryFileReader alloc] initWithFileName:fileName];
		runner.reader = reader;
		[reader release];
	}
	
	NSError *error = nil;
	DC_LOG(@"Calling story runner");
	if (![runner runStories:&error]) {
		[DCDialogs displayMessage:[error localizedFailureReason] title:[error localizedDescription]]; 
	}
}

// Callbacks.
-(void) startUp:(NSNotification *) notification {
	DC_LOG(@"App is up so starting Simon's background thread");
	DCBackgroundThread *simonsThread = [[DCBackgroundThread alloc] initWithTask:self];
	[simonsThread start];
}

-(void) dealloc {
	DC_LOG(@"Freeing memory and exiting");
	[super dealloc];
}

@end
