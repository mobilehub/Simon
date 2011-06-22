
#import <GHUnitIOS/GHUnit.h>
#import <dUsefulStuff/DCCommon.h>
#import "SIStoryRunner.h"
#import "SIRuntime.h"
#import "SIStepMapping.h"

@interface SIRuntimeTests : GHTestCase {
@private
}
@end

@implementation SIRuntimeTests

-(void) testFindsAllMappings {
	
	SIRuntime * runtime = [[[SIRuntime alloc] init] autorelease];
	NSArray * mappings = [runtime allMappingMethodsInRuntime];

	GHAssertEquals([mappings count], (NSUInteger)3, @"incorrect number of classes returned");

	SIStepMapping * mapping = [mappings objectAtIndex:0];
	GHAssertEquals(mapping.selector, @selector(stepAs:), @"Incorrect selector returned");
	GHAssertEqualStrings(NSStringFromClass(mapping.class), @"SIStoryRunnerTests", @"Incorrect class returned");
	GHAssertEqualStrings(mapping.regex.pattern, @"As ([A-Z][a-z]+)", @"Incorrect regex returned");

	mapping = [mappings objectAtIndex:1];
	GHAssertEquals(mapping.selector, @selector(stepGivenThisFileExists), @"Incorrect selector returned");
	GHAssertEqualStrings(NSStringFromClass(mapping.class), @"SIStoryRunnerTests", @"Incorrect class returned");
	GHAssertEqualStrings(mapping.regex.pattern, @"Given this file exists", @"Incorrect regex returned");

	mapping = [mappings objectAtIndex:2];
	GHAssertEquals(mapping.selector, @selector(stepThenIShouldBeAbleToRead:and:), @"Incorrect selector returned");
	GHAssertEqualStrings(NSStringFromClass(mapping.class), @"SIStoryRunnerTests", @"Incorrect class returned");
	GHAssertEqualStrings(mapping.regex.pattern, @"then I should be able to read (\\d+) and ([a-z]+) from it", @"Incorrect regex returned");

}

-(void) testFindsSpecific {
	
	
}

@end