//
//  Step.m
//  Simon
//
//  Created by Derek Clarkson on 5/30/11.
//  Copyright 2011 Sensis. All rights reserved.
//

#import "SIStep.h"
#import <dUsefulStuff/DCCommon.h>

@implementation SIStep

@synthesize keyword;
@synthesize words;

-(id) initWithKeyword:(SIKeyword) aKeyword {
	self = [super init];
	if (self) {
		keyword = aKeyword;
		words = [[NSMutableArray alloc] init];
	}
	return self;
}

-(void) addWord:(NSString *) word {
	[self.words addObject:word];
}

-(void) dealloc {
	DC_DEALLOC(words);
	[super dealloc];
}

@end
