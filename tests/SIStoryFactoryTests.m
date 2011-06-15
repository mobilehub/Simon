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

-(void) testWithInvalidStartOfStoryWithThen {
	
	[factory didReadWord:@"Then" error:&error];
	[factory didReadEndOfInput];
	
	GHAssertNotNil(error, @"Error not returned");
	GHAssertEquals(error.code, SIErrorInvalidStorySyntax, @"Incorrect error code.");
	GHAssertEqualStrings(error.localizedDescription, @"Cannot start a story with the keyword \"Then\".", @"Incorrect error text.");
	
}

-(void) testWordsArePassedToStory {
	
	[factory didReadWord:@"Given" error:&error];
	GHAssertNil(error, @"Error returned %@", error.localizedDescription);
	[factory didReadWord:@"that" error:&error];
	GHAssertNil(error, @"Error returned %@", error.localizedDescription);
	[factory didReadWord:@"I" error:&error];
	GHAssertNil(error, @"Error returned %@", error.localizedDescription);
	[factory didReadEndOfInput];

	SEL selector = [[story stepAtIndex:0] selector];
	GHAssertEqualStrings(NSStringFromSelector(selector), @"stepGivenThatI", @"Word not stored correctly");
}

// Delegate methods.
-(void) didReadStory:(SIStory *)aStory {
	story = [aStory retain];
}

@end
