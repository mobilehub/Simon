//
//  FileSystemStoryReader.m
//  Simon
//
//  Created by Derek Clarkson on 5/30/11.
//  Copyright 2011 Sensis. All rights reserved.
//

#import <dUsefulStuff/DCCommon.h>

#import "SIStoryFileReader.h"

@interface SIStoryFileReader()
-(void) readStoryLinesFromFile:(NSString *) file error:(NSError **) error;
@end

@implementation SIStoryFileReader
@synthesize files;

-(id) init {
	self = [super init];
	if (self) {
		self.files = [[NSBundle mainBundle] pathsForResourcesOfType:STORY_EXTENSION inDirectory:nil];
	}
	return self;
}

-(id) initWithFileName:(NSString *) fileName {
	self = [super init];
	if (self) {
		NSString * file = [[NSBundle mainBundle] pathForResource:fileName ofType:STORY_EXTENSION];
		DC_LOG(@"Found file %@", file);
		if (file == nil) {
			NSException* myException = [NSException
												 exceptionWithName:@"FileNotFoundException"
												 reason:@"File Not Found on System"
												 userInfo:nil];
			@throw myException;
		}
		self.files = [NSArray arrayWithObject:file];
	}
	return self;
}

-(NSArray *) readStories:(NSError **) error {
	
	stories = [[[NSMutableArray alloc] init] autorelease];
	
	for (NSString * file in self.files) {
		[self readStoryLinesFromFile:file error:error];
	}

	return stories;
}


-(void) readStoryLinesFromFile:(NSString *) file error:(NSError **) error {
	
	DC_LOG(@"Reading file: %@", file);
	NSString * contents = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:error];
	if (contents == nil) {
		DC_LOG(@"Error reading file at %@\n%@", file, [*error localizedDescription]);
		return;
	}
	
	DC_LOG(@"Finished reading file");
	
}

-(void) dealloc {
	self.files = nil;
	[super dealloc];
}

@end
