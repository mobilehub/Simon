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
	NSMutableArray * steps;
}

-(void) newStepWithKeyword:(SIKeyword) keyword;
-(SIStep *) stepAtIndex:(NSUInteger) index;
-(NSUInteger) numberOfSteps;
-(SIStep *) lastStep;
-(void) execute;
@end
