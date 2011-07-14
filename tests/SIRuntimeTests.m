
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

	GHAssertEquals([mappings count], (NSUInteger)5, @"incorrect number of classes returned");

	for (SIStepMapping * mapping in mappings) {
		if ([NSStringFromSelector(@selector(stepAs:)) isEqualToString:NSStringFromSelector(mapping.selector)]) {
			GHAssertEqualStrings(NSStringFromClass(mapping.targetClass), @"SIStoryRunnerTests", @"Incorrect class returned");
			GHAssertEqualStrings(mapping.regex.pattern, @"As ([A-Z][a-z]+)", @"Incorrect regex returned");
			break;
		}
	}
}

@end