//
//  NSObject+UtilsTests.m
//  Simon
//
//  Created by Derek Clarkson on 6/15/11.
//  Copyright 2011 Sensis. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import <dUsefulStuff/DCCommon.h>
#import "SIEnums.h"
#import "NSObject+Utils.h"

@interface NSObject_UtilsTests : GHTestCase {}

@end

@implementation NSObject_UtilsTests

-(void) testStringToKeywordGivenWrongCase {
	GHAssertEquals([self keywordFromString:@"GiVeN"] , SIKeywordGiven, @"Unexpected keyword returned");
}

-(void) testStringToKeywordGiven {
	GHAssertEquals([self keywordFromString:@"Given"] , SIKeywordGiven, @"Unexpected keyword returned");
}

-(void) testStringToKeywordThen {
	GHAssertEquals([self keywordFromString:@"Then"] , SIKeywordThen, @"Unexpected keyword returned");
}

-(void) testStringToKeywordAs {
	GHAssertEquals([self keywordFromString:@"As"] , SIKeywordAs, @"Unexpected keyword returned");
}

-(void) testStringToKeywordAnd {
	GHAssertEquals([self keywordFromString:@"And"] , SIKeywordAnd, @"Unexpected keyword returned");
}

-(void) testStringToKeywordNonKeyword {
	GHAssertEquals([self keywordFromString:@"abc"] , SIKeywordUnknown, @"Unexpected keyword returned");
}

-(void) testKeywordToStringGiven {
	GHAssertEqualStrings([self stringFromKeyword:SIKeywordGiven], @"Given", @"Incorrect String returned");
}

-(void) testKeywordToStringThen {
	GHAssertEqualStrings([self stringFromKeyword:SIKeywordThen], @"Then", @"Incorrect String returned");
}

-(void) testKeywordToStringAs {
	GHAssertEqualStrings([self stringFromKeyword:SIKeywordAs], @"As", @"Incorrect String returned");
}

-(void) testKeywordToStringAnd {
	GHAssertEqualStrings([self stringFromKeyword:SIKeywordAnd], @"And", @"Incorrect String returned");
}

-(void) testKeywordToStringUnknown {
	GHAssertEqualStrings([self stringFromKeyword:SIKeywordUnknown], @"Unknown", @"Incorrect String returned");
}

@end
