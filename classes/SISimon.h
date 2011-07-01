//
//  Simon.h
//  Simon
//
//  Created by Derek Clarkson on 6/18/11.
//  Copyright 2011 Sensis. All rights reserved.
//
#import <dUsefulStuff/DCCommon.h>
#import "SIStepMapping.h"
#import "SIStory.h"
#import "SIInternal.h"

/**
 * This macro maps a regex to a selector in the current class. Simon expects that the order and type of any groups in the regex will
 * match the order and types of arguments in the selector. So we recommend that the this is used before the selector like this
 * `
 * SIMapStepToSelector(@"", thisIsMyMethod:)
 * -(void) thisIsMyMethod:(NSString *) stringValue {
 *    ...
 * }
 * `
 */
#define SIMapStepToSelector(theRegex, aSelector) \
+(SIStepMapping *) DC_CONCATINATE(SISTEP_METHOD_PREFIX, __LINE__):(Class) class { \
	DC_LOG(@"Creating mapping \"%@\" -> %@::%@", theRegex, NSStringFromClass(class), toNSString(aSelector)); \
	NSError *error = nil; \
	SIStepMapping *mapping = [SIStepMapping stepMappingWithClass:class selector:@selector(aSelector) regex:theRegex error:&error]; \
	if (mapping == nil) { \
		@throw [NSException exceptionWithName:@"SIMappingException" reason:error.localizedDescription userInfo:error.userInfo]; \
	} \
   return mapping; \
}

/**
 * Macro which stores data in the story so it can be passed between implmentation classes. 
 */
#define SIStoreInStory(key, value) [(SIStory *) objc_getAssociatedObject(self, SIINSTANCE_STORY_REF_KEY) storeObject:value withKey:key]

/**
 * The opposite of SISToreInStory(key, value) this macro retrieves a previously stored value.
 */
#define SIRetrieveFromStory(key) [(SIStory *) objc_getAssociatedObject(self, SIINSTANCE_STORY_REF_KEY) retrieveObjectWithKey:key]





