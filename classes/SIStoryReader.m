//
//  StoryReader.m
//  Simon
//
//  Created by Derek Clarkson on 6/1/11.
//  Copyright 2011 Sensis. All rights reserved.
//
#import <dUsefulStuff/DCCommon.h>
#import "SIStoryReader.h"
#import <CoreGraphics/CGBase.h>

#import <ParseKit/PKTokenizer.h>
#import <ParseKit/PKToken.h>

@interface SIStoryReader()
-(void) readStoryLinesFromFile:(NSString *) file error:(NSError **) error;
@end


@implementation SIStoryReader

-(id) initWithStoryFileReader:(SIStoryFileReader *) storyFileReader storyFactory:(SIStoryFactory *) aStoryFactory {
	self = [super init];
	if (self) {
		fileReader = [storyFileReader retain];
		storyFactory = [aStoryFactory retain];
	}
	return self;
}

-(NSArray *) readStories:(NSError **) error {
	NSMutableArray * stories = [[[NSMutableArray alloc] init] autorelease];
	
	for (NSString * file in fileReader.files) {
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
	
	// process the lines of text in the file.
	PKTokenizer *t = [PKTokenizer tokenizerWithString:contents];
	
	PKToken *eof = [PKToken EOFToken];
	PKToken *tok = nil;
	
	while ((tok = [t nextToken]) != eof) {
		DC_LOG(@"(%@) (%.1f) : %@", tok.stringValue, tok.floatValue, [tok debugDescription]);
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
			default:
				DC_LOG(@"Don't know how to handle %@", tok);
				// Swollow everything else.
				break;
		}
	}
	[storyFactory didReadEndOfInput];
	
}


-(void) dealloc {
	DC_DEALLOC(fileReader);
	DC_DEALLOC(storyFactory);
	[super dealloc];
}

@end
