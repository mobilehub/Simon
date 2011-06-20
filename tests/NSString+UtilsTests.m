//
//  NSString_UtilsTests.m
//  Simon
//
//  Created by Derek Clarkson on 6/18/11.
//  Copyright 2011 Sensis. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import <dUsefulStuff/DCCommon.h>
#import "NSString+Utils.h"

@interface NSString_UtilsTests : GHTestCase {}

@end

@implementation NSString_UtilsTests

-(void) testStripsSingleQuotes {
	GHAssertEqualStrings([@"'abc'" stringByRemovingQuotes], @"abc", @"Quotes not removed");
}

-(void) testStripsDoubleQuotes {
	GHAssertEqualStrings([@"\"abc\"" stringByRemovingQuotes], @"abc", @"Quotes not removed");
}

-(void) testLeavesNonQuotedStringAlone {
	GHAssertEqualStrings([@"abc" stringByRemovingQuotes], @"abc", @"Quotes not removed");
}

-(void) testStripsDoubleQuotesButLeavesEmbeddedQuotes {
	GHAssertEqualStrings([@"\"a\"b\"c\"" stringByRemovingQuotes], @"a\"b\"c", @"Quotes not removed");
}

@end
