//
//  SIStoryRunnerTests.m
//  Simon
//
//  Created by Derek Clarkson on 6/17/11.
//  Copyright 2011 Sensis. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import <dUsefulStuff/DCCommon.h>
#import "SIStoryRunner.h"

@interface SIStoryRunnerTests : GHTestCase {}

@end

@implementation SIStoryRunnerTests

-(void) testRunsBasicStory {
	SIStoryRunner * runner = [[[SIStoryRunner alloc] init] autorelease];
	SIStoryFileReader *reader = [[[SIStoryFileReader alloc] initWithFileName:@"Story files"] autorelease];
	runner.reader.fileReader = reader;
}

@end
