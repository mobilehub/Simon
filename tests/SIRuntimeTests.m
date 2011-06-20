
#import <GHUnitIOS/GHUnit.h>
#import <dUsefulStuff/DCCommon.h>
#import "SIStoryRunner.h"
#import "SIRuntime.h"

@interface SIRuntimeTests : GHTestCase {
@private
}
@end

@interface SIRuntime(internal)
-(NSArray *) allMappingMethodsInRuntime;
-(void) addMappingMethodsFromClass:(Class) class toArray:(NSMutableArray *) array;
@end

@implementation SIRuntimeTests

-(void) testFindsImplementationClasses {
	SIRuntime * runtime = [[[SIRuntime alloc] init] autorelease];
	NSArray * classSelectors = [runtime allMappingMethodsInRuntime];
	GHAssertEquals([classSelectors count], (NSUInteger)3, @"incorrect number of classes returned");
}

-(void) testInit {
//	SISimon * simon = [[[SISimon alloc] init] autorelease];
}

@end