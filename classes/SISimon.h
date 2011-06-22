//
//  Simon.h
//  Simon
//
//  Created by Derek Clarkson on 6/18/11.
//  Copyright 2011 Sensis. All rights reserved.
//
#import <dUsefulStuff/DCCommon.h>
#import "SIStepMapping.h"

#define STEP_METHOD_PREFIX __stepMap

/**
 * Converts a sequence of chars to a string constant. Again we need that extra level of indirection 
 * to fix the translation of the parameter when stringification is involved.
 */
#define _toNSString(chars) @#chars
#define toNSString(chars) _toNSString(chars)

/**
 * Macro which is used in test code implementations to map selectors to BDD Steps.
 */
#define SIMapStep(theRegex, aSelector) \
+(SIStepMapping *) DC_CONCATINATE(STEP_METHOD_PREFIX, __LINE__):(Class) class { \
	DC_LOG(@"Creating mapping \"%@\" -> %@::%@", theRegex, NSStringFromClass(class), toNSString(aSelector)); \
	return [[[SIStepMapping alloc] initWithClass:class selector:@selector(aSelector) regex:theRegex] autorelease]; \
}

@interface SISimon : NSObject {
@private
}
@end



