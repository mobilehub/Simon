//
//  FileSystemStoryReader.m
//  Simon
//
//  Created by Derek Clarkson on 5/30/11.
//  Copyright 2011 Sensis. All rights reserved.
//

#import <dUsefulStuff/DCCommon.h>

#import "SIStoryFileReader.h"
#import <CoreGraphics/CGBase.h>

#import <ParseKit/PKTokenizer.h>
#import <ParseKit/PKToken.h>
#import <ParseKit/PKWhitespaceState.h>

@interface SIStoryFileReader()
-(void) readStoryLinesFromFile:(NSString *) file error:(NSError **) error;
@end

@implementation SIStoryFileReader
@synthesize files;
@synthesize storyFactory;

-(id) init {
	self = [super init];
	if (self) {
		self.files = [[NSBundle mainBundle] pathsForResourcesOfType:STORY_EXTENSION inDirectory:nil];
		self.storyFactory = [[SIStoryFactory alloc] init];
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
		self.storyFactory = [[SIStoryFactory alloc] init];
	}
	return self;
}

-(NSArray *) readStories:(NSError **) error {
	
	stories = [[[NSMutableArray alloc] init] autorelease];
	
	self.storyFactory.delegate = self;
	
	for (NSString * file in self.files) {
		[self readStoryLinesFromFile:file error:error];
	}

	self.storyFactory.delegate = nil;

	return stories;
}


-(void) readStoryLinesFromFile:(NSString *) file error:(NSError **) error {
	
	DC_LOG(@"Reading file: %@", file);
	NSString * contents = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:error];
	if (contents == nil) {
		DC_LOG(@"Error reading file at %@\n%@", file, [*error localizedDescription]);
		return;
	}
	
	// process the lines of text in the file.
	PKTokenizer *t = [PKTokenizer tokenizerWithString:contents];
	t.whitespaceState.reportsWhitespaceTokens = YES;
	
	PKToken *eof = [PKToken EOFToken];
	PKToken *tok = nil;
	
	DC_LOG(@"Processing tokens");
	while ((tok = [t nextToken]) != eof) {
		switch (tok.tokenType) {
			case PKTokenTypeWord:
				[storyFactory didReadWord:tok.stringValue error:error];
				break;
			case PKTokenTypeEmail:
				[storyFactory didReadEmail:tok.stringValue error:error];
				break;
			case PKTokenTypeDelimitedString:
				[storyFactory didReadDelimitedString:tok.stringValue error:error];
				break;
			case PKTokenTypeURL:
				[storyFactory didReadURL:tok.stringValue error:error];
				break;
			case PKTokenTypeNumber:
				[storyFactory didReadNumber: tok.floatValue error:error];
				break;
			case PKTokenTypeQuotedString:
				[storyFactory didReadQuotedString:tok.stringValue error:error];
				break;
			case PKTokenTypeSymbol:
				[storyFactory didReadSymbol:tok.stringValue error:error];
				break;
			case PKTokenTypeWhitespace:
				if ([tok.stringValue isEqualToString:@"\n"]) {
					[storyFactory didReadNewLine];
				}
				// Swallow other white space.
				break;
			default:
				DC_LOG(@"Don't know how to handle %@", tok);
				// Swollow everything else.
				break;
		}
	}
	[storyFactory didReadEndOfInput];
	DC_LOG(@"Finished reading file");
	
}

-(void) didReadStory:(SIStory *) aStory {
	DC_LOG(@"Received story from factory");
	[stories addObject:aStory];
}


-(void) dealloc {
	self.files = nil;
	self.storyFactory = nil;
	[super dealloc];
}

@end
