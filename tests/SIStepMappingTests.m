//
//  SIStepMappingTests.m
//  Simon
//
//  Created by Derek Clarkson on 6/23/11.
//  Copyright 2011 Sensis. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import <dUsefulStuff/DCCommon.h>
#import "SIStepMapping.h"

@interface SIStepMappingTests : GHTestCase {
@private
}
@end


@implementation SIStepMappingTests

-(void) testMapsStep {
	SIStepMapping * mapping = [[SIStepMapping alloc] initWithClass:[self class] selector:nil regex:@"abc"];
	GHAssertTrue([mapping canMapToStep:@"abc"], @"Did not map the step");
}

-(void) testDoesNotMapStep {
	SIStepMapping * mapping = [[SIStepMapping alloc] initWithClass:[self class] selector:nil regex:@"abc"];
	GHAssertFalse([mapping canMapToStep:@"xyz"], @"Should not have mapped the step.");
}

@end
