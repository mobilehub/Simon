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
	NSError *error;
}

@property (nonatomic, readonly) NSArray * steps;
@property (nonatomic, readonly) SIStoryStatus status;
@property (nonatomic, readonly) NSError *error;

-(SIStep *) newStepWithKeyword:(SIKeyword) keyword command:(NSString *) theCommand;
-(SIStep *) stepAtIndex:(NSUInteger) index;
-(BOOL) invoke;
-(void) mapSteps:(NSArray *) mappings;
@end
