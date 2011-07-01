//
//  CommsASteps.m
//  Simon
//
//  Created by Derek Clarkson on 7/1/11.
//  Copyright 2011 Sensis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SISimon.h"
#import <GHUnitIOS/GHUnit.h>


@interface CommsBSteps : GHTestCase

@end

@implementation CommsBSteps

SIMapStepToSelector(@"then this class should be able to retrieve (.*) from storage with key (.*)", retrieveString:withKey:)
-(void) retrieveString:(NSString *) aString withKey:(NSString *) key{
	NSString *value = SIRetrieveFromStory(key);
	GHAssertEqualStrings(value, aString, @"Strings do not match");
}

@end
