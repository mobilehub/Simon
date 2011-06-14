//
//  StoryFactory.m
//  Simon
//
//  Created by Derek Clarkson on 5/31/11.
//  Copyright 2011 Sensis. All rights reserved.
//

#import "SIStoryFactory.h"
#import <dUsefulStuff/DCCommon.h>
#import "SIEnums.h"
#import "NSObject+Utils.h"

@interface SIStoryFactory()
-(void) endCurrentStory;
-(void) createNewStory;
-(SIKeyword) getKeywordFrom:(NSString *) word;
-(void) didReadKeyword:(SIKeyword) keyword error:(NSError **) error;
@end

@implementation SIStoryFactory

@synthesize delegate;

-(void) didReadURL:(NSString *) url error:(NSError **) error {
	
}

-(void) didReadDelimitedString:(NSString *) delimitedString error:(NSError **) error {
	
}

-(void) didReadEmail:(NSString *) email error:(NSError **) error {
	
}

-(void) didReadWord:(NSString *) word error:(NSError **) error {

	// If it's a keyword then call the keyword processing instead.
	SIKeyword keyword = [self getKeywordFrom:word];
	if (keyword != SIKeywordUnknown) {
		[self didReadKeyword:keyword error:error];
		return;
	}
	
	// It's just a word so pass it to the story.
	[[story lastStep] addWord:word];

}

-(void) didReadNumber:(CGFloat) number error:(NSError **) error {
	
}

-(void) didReadQuotedString:(NSString *) quotedString error:(NSError **) error {
	
}

-(void) didReadSymbol:(NSString *) symbol error:(NSError **) error{
	
}

-(void) didReadEndOfInput {
	[self endCurrentStory];
}

-(void) endCurrentStory {
	if (story != nil) {
		[delegate didReadStory:story];
		DC_DEALLOC(story);
	}
}

-(void) createNewStory {
	story = [[SIStory alloc] init];
}

-(SIKeyword) getKeywordFrom:(NSString *) word {
	NSString * upper = [word uppercaseString];
	if ([@"GIVEN" isEqualToString:upper]) {
		return SIKeywordGiven;
	} else if ([@"THEN" isEqualToString:upper]) {
		return SIKeywordThen;
	} else if ([@"AS" isEqualToString:upper]) {
		return SIKeywordAs;
	} else if ([@"AND" isEqualToString:upper]) {
		return SIKeywordAnd;
	}
	return SIKeywordUnknown;
}

-(void) didReadKeyword:(SIKeyword) keyword error:(NSError **) error {
	switch (keyword) {
		case SIKeywordGiven:
			[self endCurrentStory];
			[self createNewStory];
			[story newStepWithKeyword:SIKeywordGiven];
			break;

		case SIKeywordThen:
			if ([story numberOfSteps] == 0) {
				*error = [self errorForCode:SIErrorInvalidStorySyntax shortDescription:@"Invalid Story syntax" description:@"Cannot start a story with the keyword \"Then\"."];
				return;
			}
			break;
		
		case SIKeywordAs:
			break;
		
		case SIKeywordAnd:
			if ([story numberOfSteps] == 0) {
				*error = [self errorForCode:SIErrorInvalidStorySyntax shortDescription:@"Invalid Story syntax" description:@"Cannot start a story with the keyword \"And\"."];
				return;
			}
			break;
			
		default:
			break;
	}
	
}

-(void) dealloc {
	DC_DEALLOC(story);
	[super dealloc];
}

@end
