//
//  SIStepStories.m
//  Simon
//
//  Created by Derek Clarkson on 6/14/11.
//  Copyright 2011 Sensis. All rights reserved.
//


#import <GHUnitIOS/GHUnit.h>
#import <dUsefulStuff/DCCommon.h>
#import "SIStep.h"

@interface SIStepTests : GHTestCase {
@private
	BOOL stepGivenCalled;
	BOOL stepGivenValueCalled;
	BOOL stepGivenValueAndNumberCalled;
}
-(void) stepGiven;
@end

@implementation SIStepTests

-(void) setUp {
	stepGivenCalled = NO;
	stepGivenValueCalled = NO;
	stepGivenValueAndNumberCalled = NO;
}


-(void) testStoresKeyword {
	SIStep * step = [[[SIStep alloc] initWithKeyword:SIKeywordGiven] autorelease];
	GHAssertEquals(step.keyword, SIKeywordGiven, @"Keyword not returned");
}

-(void) testWordIsAdded {
	SIStep * step = [[[SIStep alloc] initWithKeyword:SIKeywordGiven] autorelease];
	[step addWord:@"word"];
	SEL selector = [step selector];
	GHAssertEqualStrings(NSStringFromSelector(selector), @"stepGivenWord", @"Word not stored");
}

-(void) testCanGenerateSimpleSelector {
	SIStep * step = [[[SIStep alloc] initWithKeyword:SIKeywordGiven] autorelease];
	SEL selector = [step selector];
	GHAssertEqualStrings(NSStringFromSelector(selector), @"stepGiven", @"Incorrect selector returned");
}

-(void) testCanGenerateMultiwordSelector {
	SIStep * step = [[[SIStep alloc] initWithKeyword:SIKeywordGiven] autorelease];
	[step addWord:@"I"];
	[step addWord:@"am"];
	[step addWord:@"Sam"];
	SEL selector = [step selector];
	GHAssertEqualStrings(NSStringFromSelector(selector), @"stepGivenIAmSam", @"Incorrect selector returned");
}

-(void) testCanGenerateSimpleSelectorWithOneStringParameter {
	SIStep * step = [[[SIStep alloc] initWithKeyword:SIKeywordGiven] autorelease];
	[step addParameter:@"abc"];
	SEL selector = [step selector];
	GHAssertEqualStrings(NSStringFromSelector(selector), @"stepGiven:", @"Incorrect selector returned");
}

-(void) testCanGenerateSelectorWhenAndPassedAsWordWithParameter {
	SIStep * step = [[[SIStep alloc] initWithKeyword:SIKeywordGiven] autorelease];
	[step addWord:@"abc"];
	[step addParameter:@"parm1"];
	[step addWord:@"and"];
	[step addWord:@"def"];
	[step addParameter:@"parm2"];
	SEL selector = [step selector];
	GHAssertEqualStrings(NSStringFromSelector(selector), @"stepGivenAbc:andDef:", @"Incorrect selector returned");
}

-(void) testCanGenerateSelectorWithTwoStringParameters {
	SIStep * step = [[[SIStep alloc] initWithKeyword:SIKeywordGiven] autorelease];
	[step addWord:@"I"];
	[step addWord:@"am"];
	[step addParameter:@"Fred"];
	[step addWord:@"from"];
	[step addParameter:@"A Company"];
	SEL selector = [step selector];
	GHAssertEqualStrings(NSStringFromSelector(selector), @"stepGivenIAm:andFrom:", @"Incorrect selector returned");
}

-(void) testReturnsValidInvocationSimpleMethod {
	SIStep * step = [[[SIStep alloc] initWithKeyword:SIKeywordGiven] autorelease];
	NSInvocation * invocation = [step invocation];
	GHAssertNotNil(invocation, @"Invocation not returned.");
	if ([self respondsToSelector:[invocation selector]]) {
		[invocation invokeWithTarget:self];
	}
	GHAssertTrue(stepGivenCalled, @"stepGiven message not sent");
}

-(void) testReturnsValidInvocationMethodWithString {
	SIStep * step = [[[SIStep alloc] initWithKeyword:SIKeywordGiven] autorelease];
	[step addWord:@"value"];
	[step addParameter:@"abc"];
	NSInvocation * invocation = [step invocation];
	GHAssertNotNil(invocation, @"Invocation not returned.");
	if ([self respondsToSelector:[invocation selector]]) {
		[invocation invokeWithTarget:self];
	}
	GHAssertTrue(stepGivenValueCalled, @"stepGivenValue: message not sent");
}

-(void) testReturnsValidInvocationMethodWithStringAndNumber {
	SIStep * step = [[[SIStep alloc] initWithKeyword:SIKeywordGiven] autorelease];
	[step addWord:@"value"];
	[step addParameter:@"abc"];
	[step addWord:@"and"];
	[step addWord:@"number"];
	[step addParameter:[NSNumber numberWithFloat:12.0]];
	NSInvocation * invocation = [step invocation];
	GHAssertNotNil(invocation, @"Invocation not returned.");
	if ([self respondsToSelector:[invocation selector]]) {
		[invocation invokeWithTarget:self];
	}
	GHAssertTrue(stepGivenValueAndNumberCalled, @"stepGivenValue:andNumber: message not sent");
}

-(void) stepGiven {
	DC_LOG(@"Simple method called.");
	stepGivenCalled = YES;
}

-(void) stepGivenValue:(NSString *) value {
	DC_LOG(@"Method called with %@", value);
	stepGivenValueCalled = YES;
}

-(void) stepGivenValue:(NSString *) value andNumber:(NSNumber *) number {
	DC_LOG(@"Method called with %@ and %@", value, number);
	stepGivenValueAndNumberCalled = YES;
}

@end
