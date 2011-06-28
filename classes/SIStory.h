//
//  Story.h
//  Simon
//
//  Created by Derek Clarkson on 5/30/11.
//  Copyright 2011 Sensis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SIEnums.h"
#import "SIStep.h"

@interface SIStory : NSObject {
	@private
	NSMutableArray *steps;
	NSMutableDictionary *instanceCache;
	SIStoryStatus status;
}

@property (nonatomic, readonly) SIStoryStatus status;

-(SIStep *) newStepWithKeyword:(SIKeyword) keyword command:(NSString *) theCommand;
-(SIStep *) stepAtIndex:(NSUInteger) index;
-(NSUInteger) numberOfSteps;
-(BOOL) invoke:(NSError **) error;
-(void) mapSteps:(NSArray *) mappings;
@end
