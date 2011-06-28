//
//  FileSystemStoryReader.m
//  Simon
//
//  Created by Derek Clarkson on 5/30/11.
//  Copyright 2011 Sensis. All rights reserved.
//

#import <dUsefulStuff/DCCommon.h>

#import "SIStoryFileReader.h"
#import "SIEnums.h"
#import "NSObject+Utils.h"

@interface SIStoryFileReader()
-(BOOL) processNextLine:(NSString *) line error:(NSError **) error;
-(void) createNewStory;
-(SIKeyword) keywordFromLine:(NSString *) line error:(NSError **) error;
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
		
		// Read the file.
		NSString *contents = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:error];
		if (contents == nil) {
			DC_LOG(@"Failed to read file %@", file);
			return nil;
		}
		
		// Break it up and process the lines.
		for (NSString * line in [contents componentsSeparatedByString:@"\n"]) {
			if (![self processNextLine: line error:error]) {
				return nil;
			}
		}
	}

	return stories;
}

-(BOOL) processNextLine:(NSString *) line error:(NSError **) error {
	
	// Trim whitespace and trailing punctuation.
	NSMutableCharacterSet *chars = [NSMutableCharacterSet whitespaceCharacterSet];
	[chars formUnionWithCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@".,;:!?"]];
	NSString *cleanLine = [line stringByTrimmingCharactersInSet:chars];
	
	// If there is nothing left or it starts with a comment char then ignore it.
	if ([cleanLine length] == 0 || [cleanLine hasPrefix:@"#"]) {
		return YES;
	}

	// Attempt to figure out what the keyword is.
	SIKeyword keyword = [self keywordFromLine:cleanLine error:error];
	if (keyword == SIKeywordUnknown) {
		return NO;
	}
	
	// If the keyword is one that starts a story then do so.
	// Given continues a story if the preceeding step is an "As" step.
	BOOL givenContinues = [story stepAtIndex:[story.steps count] -1].keyword == SIKeywordAs;
	if ((keyword == SIKeywordGiven && !givenContinues) || keyword == SIKeywordAs) {
		[self createNewStory];
	}
	
	// Now add the step to the current story.
	DC_LOG(@"Adding step: %@", cleanLine);
	[story newStepWithKeyword:keyword command:cleanLine];
	
	return YES;
}

-(SIKeyword) keywordFromLine:(NSString *) line error:(NSError **) error {
	NSString *firstWord = nil;
	BOOL foundWord = [[NSScanner scannerWithString:line] scanCharactersFromSet:[NSCharacterSet alphanumericCharacterSet] intoString:&firstWord];
	if (!foundWord) {
		*error = [self errorForCode:SIErrorInvalidStorySyntax shortDescription:@"Story syntax error" failureReason:@"Each line of a story must start with a valid keyword (Given, Then, As or And) or a comment."];
		return SIKeywordUnknown;
	}
	SIKeyword keyword = [self keywordFromString:firstWord];
	if (keyword == SIKeywordUnknown) {
		*error = [self errorForCode:SIErrorInvalidStorySyntax shortDescription:@"Story syntax error" failureReason:@"Each line of a story must start with a valid keyword (Given, Then, As or And) or a comment."];
	}
	return keyword;
}


-(void) createNewStory {
	// Free the old story.
	DC_DEALLOC(story);
	
	// Create the new one and store it in the return array.
	DC_LOG(@"Creating new story");
	story = [[SIStory alloc] init];
	[stories addObject:story];
}


-(void) dealloc {
	self.files = nil;
	DC_DEALLOC(story);
	[super dealloc];
}

@end
