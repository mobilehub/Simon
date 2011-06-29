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
-(SIKeyword) priorKeyword;
-(void) mainInit;
@end

@implementation SIStoryFileReader
@synthesize files;

-(id) init {
	self = [super init];
	if (self) {
		[self mainInit];
		self.files = [[NSBundle mainBundle] pathsForResourcesOfType:STORY_EXTENSION inDirectory:nil];
	}
	return self;
}

-(id) initWithFileName:(NSString *) fileName {
	self = [super init];
	if (self) {
		[self mainInit];
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

-(void) mainInit {
	trimChars = [[NSMutableCharacterSet whitespaceCharacterSet] retain];
	[(NSMutableCharacterSet *)trimChars formUnionWithCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@".,;:!?"]];
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
	NSString *cleanLine = [line stringByTrimmingCharactersInSet:trimChars];
	
	// If there is nothing left or it starts with a comment char then ignore it.
	if ([cleanLine length] == 0 || [cleanLine hasPrefix:@"#"]) {
		return YES;
	}
	
	// Attempt to figure out what the keyword is.
	SIKeyword keyword = [self keywordFromLine:cleanLine error:error];
	if (keyword == SIKeywordUnknown) {
		*error = [self errorForCode:SIErrorInvalidKeyword 
		  shortDescription:@"Story syntax error, unknown keyword" 
			  failureReason:[NSString stringWithFormat:@"Story syntax error, unknown keyword on step %@", cleanLine]];
		return NO;
	}

	// Validate the order of keywords.
	SIKeyword priorKeyword = [self priorKeyword];
	switch (priorKeyword) {
		case SIKeywordGiven:
			break;

		case SIKeywordAs:
			break;

		case SIKeywordThen:
			if (keyword == SIKeywordThen) {
				*error = [self errorForCode:SIErrorInvalidStorySyntax 
							  shortDescription:@"Incorrect keyword order" 
								  failureReason:[NSString stringWithFormat:@"Incorrect keyword order, %@ cannot appear after Then", [self stringFromKeyword:keyword]]];
				return NO;
			}

			// Create a new story.
			if ((keyword == SIKeywordGiven) || keyword == SIKeywordAs) {
				[self createNewStory];
			}
			
			break;

		default: // SIKeywordUnknown so no prior.
			if (keyword == SIKeywordAnd || keyword == SIKeywordThen) {
				*error = [self errorForCode:SIErrorInvalidStorySyntax 
							  shortDescription:@"Incorrect keyword order" 
								  failureReason:[NSString stringWithFormat:@"Incorrect keyword order, %@ appears before Given or As", [self stringFromKeyword:keyword]]];
				return NO;
			}

			// Create a new story.
			if ((keyword == SIKeywordGiven) || keyword == SIKeywordAs) {
				[self createNewStory];
			}

			break;
	}
	
	// Now add the step to the current story.
	DC_LOG(@"Adding step: %@", cleanLine);
	[story newStepWithKeyword:keyword command:cleanLine];
	
	return YES;
}

/**
 * Searches backwards through the steps, ignoring And steps to find the previous keyword.
 * Returns SIKeywordUnknown if it doesn't find anything.
 */
-(SIKeyword) priorKeyword {
	// Go backwards to find the prior keyword.
	for (int i = [story.steps count] - 1; i >= 0; i--) {
		SIStep * step = [story.steps objectAtIndex:i]; 
		if (step.keyword == SIKeywordAnd) {
			continue;
		}
		return step.keyword;
	}
	return SIKeywordUnknown;
}


-(SIKeyword) keywordFromLine:(NSString *) line error:(NSError **) error {
	NSString *firstWord = nil;
	BOOL foundWord = [[NSScanner scannerWithString:line] 
							scanCharactersFromSet:[NSCharacterSet alphanumericCharacterSet] 
							intoString:&firstWord];
	if (!foundWord) {
		*error = [self errorForCode:SIErrorInvalidStorySyntax 
					  shortDescription:@"Story syntax error, step does not begin with a word" 
						  failureReason:@"Each line of a story must start with a valid keyword (Given, Then, As or And) or a comment."];
		return SIKeywordUnknown;
	}
	SIKeyword keyword = [self keywordFromString:firstWord];
	if (keyword == SIKeywordUnknown) {
		*error = [self errorForCode:SIErrorInvalidStorySyntax 
					  shortDescription:[NSString stringWithFormat:@"Story syntax error, unknown keyword %@", firstWord] 
						  failureReason:[NSString stringWithFormat:@"Each line of a story must start with a valid keyword (Given, Then, As or And) or a comment. %@ is not a keyword.", firstWord]];
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
	DC_DEALLOC(trimChars);
	self.files = nil;
	DC_DEALLOC(story);
	[super dealloc];
}

@end
