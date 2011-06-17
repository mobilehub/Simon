//
//  StoryRunner.m
//  Simon
//
//  Created by Derek Clarkson on 6/17/11.
//  Copyright 2011 Sensis. All rights reserved.
//

#import "SIStoryRunner.h"

@implementation SIStoryRunner

@synthesize reader;

- (id)init
{
    self = [super init];
    if (self) {
		 reader = [[SIStoryReader alloc] init];
    }
    
    return self;
}

-(void) dealloc {
	self.reader = nil;
	[super dealloc];
}

@end
