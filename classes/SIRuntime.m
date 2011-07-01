//
//  SIRuntime.m
//  Simon
//
//  Created by Derek Clarkson on 6/20/11.
//  Copyright 2011 Sensis. All rights reserved.
//

#import "SIRuntime.h"
#import <dUsefulStuff/DCCommon.h>
#import "SIStepMapping.h"
#import "SIInternal.h"
#import <objc/message.h>

@interface SIRuntime()
-(BOOL) addMappingMethodsFromClass:(Class) class toArray:(NSMutableArray *) array;
@end

@implementation SIRuntime

-(NSArray *) allMappingMethodsInRuntime {
	
	int numClasses = objc_getClassList(NULL, 0);
	DC_LOG(@"Found %i classes in runtime", numClasses);
	
	NSMutableArray * stepMappings = [[[NSMutableArray alloc] init] autorelease];
	if (numClasses > 0 ) {
		
		Class * classes = malloc(sizeof(Class) * numClasses);
		numClasses = objc_getClassList(classes, numClasses);
		
		for (int index = 0; index < numClasses; index++) {
			
			Class nextClass = classes[index];
			
			// Ignore if the class does not belong to the application bundle.
			NSBundle * classBundle = [NSBundle bundleForClass:nextClass];
			if ([NSBundle mainBundle] != classBundle) {
				continue;
			}
			
			// Now locate the mapping methods.
			[self addMappingMethodsFromClass:nextClass toArray:stepMappings];
			
		}
		
		free(classes);
	}
	
	return stepMappings;
	
}

-(BOOL) addMappingMethodsFromClass:(Class) class toArray:(NSMutableArray *) array {

	DC_LOG(@"Checking %@", NSStringFromClass(class));

	// Get the class methods. To get instance methods, drop the object_getClass function.
	unsigned int methodCount;
	Method *methods = class_copyMethodList(object_getClass(class), &methodCount);
	
	// This handles disposing of the method memory for us even if an exception is thrown. 
	[NSData dataWithBytesNoCopy:methods
								length:sizeof(Method) * methodCount];
	
	// Search the methods for mapping methods. If found, execute them to retrieve the 
	// mapping objects and add to the return array.
	NSString  * prefix = toNSString(SISTEP_METHOD_PREFIX);
	BOOL methodsFound = NO;
	for (size_t j = 0; j < methodCount; ++j) {
		
		Method currMethod = methods[j];
		SEL sel = method_getName(currMethod);	

		if ([NSStringFromSelector(sel) hasPrefix:prefix]) {
			DC_LOG(@"\tStep method found %@ %@", NSStringFromClass(class), NSStringFromSelector(sel));
			id returnValue = objc_msgSend(class, sel, class);
			[array addObject:returnValue];
			methodsFound = YES;
		}
	}
	
	return methodsFound;
}

@end
