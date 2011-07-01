//
//  CommsASteps.m
//  Simon
//
//  Created by Derek Clarkson on 7/1/11.
//  Copyright 2011 Sensis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SISimon.h"


@interface CommsASteps : NSObject

@end

@implementation CommsASteps

SIMapStepToSelector(@"Given this class stores (.*) in the story storage using key (.*)", storesString:withKey:)
-(void) storesString:(NSString *) aString withKey:(NSString *) key{
	SIStoreInStory(key, aString);
}

@end
