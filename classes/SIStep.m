//
//  Step.m
//  Simon
//
//  Created by Derek Clarkson on 5/30/11.
//  Copyright 2011 Sensis. All rights reserved.
//

#import "SIStep.h"
#import <dUsefulStuff/DCCommon.h>
#import "NSObject+Utils.h"

@implementation SIStep

@synthesize keyword;
@synthesize command;
@synthesize stepMapping;

-(id) initWithKeyword:(SIKeyword) aKeyword command:(NSString *) theCommand {
	self = [super init];
	if (self) {
		keyword = aKeyword;
		self.command = theCommand;
	}
	return self;
}

-(void) findMappingInList:(NSArray *) mappings {
	for (SIStepMapping * mapping in mappings) {
		if ([mapping canMapToStep:self.command]) {
			self.stepMapping = mapping;
			return;
		}
	}
}

-(BOOL) isMapped {
	return self.stepMapping != nil;
}


-(void) dealloc {
	self.command = nil;
	[super dealloc];
}

@end
