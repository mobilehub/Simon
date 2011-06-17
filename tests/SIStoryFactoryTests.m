//
//  StoryFactoryTests.m
//  Simon
//
//  Created by Derek Clarkson on 5/31/11.
//  Copyright 2011 Sensis. All rights reserved.
//


#import <GHUnitIOS/GHUnit.h>
#import <dUsefulStuff/DCCommon.h>
#import "SIStory.h"
#import "SIStoryFactory.h"
#import "SIStoryFactoryDelegate.h"

@interface SIStoryFactoryTests : GHTestCase<SIStoryFactoryDelegate> {
@private
	SIStory * story;
	SIStoryFactory * factory;
	NSError * error;
}
@end

@implementation SIStoryFactoryTests

-(void) setUp {
	factory = [[SIStoryFactory alloc] init];
	story = nil;
	error = nil;
	factory.delegate = self;
}

-(void) tearDown {
	factory.delegate = nil;
	DC_DEALLOC(story);
	DC_DEALLOC(factory);
}

-(void) testWithSimpleStory {
	
	[factory didReadWord:@"Given" error:&error];
	[factory didReadEndOfInput];

	GHAssertNil(error, @"Error returned %@", error.localizedDescription);
	GHAssertNotNil(story, @"Story should be present");
	GHAssertEquals([story stepAtIndex:0].keyword, SIKeywordGiven, @"Step does not have the given keyword");

}

-(void) testWithInvalidStartOfStoryWithAnd {
	
	[factory didReadWord:@"And" error:&error];
	[factory didReadEndOfInput];
	
	GHAssertNotNil(error, @"Error not returned");
	GHAssertEquals(error.code, SIErrorInvalidStorySyntax, @"Incorrect error code.");
	GHAssertEqualStrings(error.localizedDescription, @"Cannot start a story with the keyword \"And\".", @"Incorrect error text.");
	
}

-(void) testThenStartsANewStep {
	
	[factory didReadWord:@"Given" error:&error];
	[factory didReadNewLine];
	[factory didReadWord:@"then" error:&error];
	[factory didReadEndOfInput];
	
	GHAssertNil(error, @"Error returned %@", error.localizedDescription);
	GHAssertNotNil(story, @"Story should be present");
	GHAssertEquals([story numberOfSteps], (NSUInteger) 2, @"Incorrect number of steps");
	GHAssertEquals([story stepAtIndex:0].keyword, SIKeywordGiven, @"Given Step does not have the given keyword");
	GHAssertEquals([story stepAtIndex:1].keyword, SIKeywordThen, @"Then Step does not have the given keyword");
}

-(void) testWithInvalidStartOfStoryWithThen {
	
	[factory didReadWord:@"Then" error:&error];
	[factory didReadEndOfInput];
	
	GHAssertNotNil(error, @"Error not returned");
	GHAssertEquals(error.code, SIErrorInvalidStorySyntax, @"Incorrect error code.");
	GHAssertEqualStrings(error.localizedDescription, @"Cannot start a story with the keyword \"Then\".", @"Incorrect error text.");
	
}

-(void) testWordsArePassedToStory {
	
	[factory didReadWord:@"Given" error:&error];
	[factory didReadWord:@"that" error:&error];
	[factory didReadWord:@"I" error:&error];
	[factory didReadEndOfInput];

	SEL selector = [[story stepAtIndex:0] selector];
	GHAssertEqualStrings(NSStringFromSelector(selector), @"stepGivenThatI", @"Word not stored correctly");
}

-(void) testWithKeywordInMiddleOfSentenceIsTreatedAsWord {
	
	[factory didReadWord:@"Given" error:&error];
	[factory didReadWord:@"x" error:&error];
	[factory didReadWord:@"and" error:&error];
	[factory didReadWord:@"y" error:&error];
	[factory didReadEndOfInput];
	
	GHAssertNil(error, @"Error returned %@", error.localizedDescription);
	GHAssertNotNil(story, @"Story should be present");
	GHAssertEqualStrings(NSStringFromSelector([[story stepAtIndex:0] selector]), @"stepGivenXAndY", @"selector not correct");
	
}


// Delegate methods.
-(void) didReadStory:(SIStory *)aStory {
	story = [aStory retain];
}

@end
