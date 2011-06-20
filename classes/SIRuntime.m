//
//  SIRuntime.m
//  Simon
//
//  Created by Derek Clarkson on 6/20/11.
//  Copyright 2011 Sensis. All rights reserved.
//

#import "SIRuntime.h"
#import <dUsefulStuff/DCCommon.h>
#import "SIClassSelector.h"
#import "SISimon.h"

@interface SIRuntime()
-(NSArray *) allMappingMethodsInRuntime;
-(void) addMappingMethodsFromClass:(Class) class toArray:(NSMutableArray *) array;
@end

@implementation SIRuntime

-(id) init {
	self = [super init];
	if (self) {
		NSArray * mappings = [self allMappingMethodsInRuntime];
		for(SIClassSelector * classSelector in mappings) {
			DC_LOG(@"Calling selector");
			id instance = [[[classSelector.class alloc] init] autorelease];
			[instance performSelector:classSelector.selector];
		}
	}
	return self;
}

-(NSArray *) allMappingMethodsInRuntime {
	
	int numClasses = objc_getClassList(NULL, 0);
	DC_LOG(@"Found %i classes in runtime", numClasses);
	
	NSMutableArray * classSelectors = [[[NSMutableArray alloc] init] autorelease];
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
			
			// Include if the class has step methods.
			[self addMappingMethodsFromClass:nextClass toArray:classSelectors];
			
		}
		
		free(classes);
	}
	
	return classSelectors;
	
}

-(void) addMappingMethodsFromClass:(Class) class toArray:(NSMutableArray *) array {
	
	unsigned int methodCount;
	Method *methods = class_copyMethodList(class, &methodCount);
	
	// This handles disposing of the method memory for us even if an exception is thrown. 
	[NSData dataWithBytesNoCopy:methods
								length:sizeof(Method) * methodCount];
	
	NSString  * prefix = toNSString(STEP_METHOD_PREFIX);
	for (size_t j = 0; j < methodCount; ++j) {
		
		Method currMethod = methods[j];
		SEL sel = method_getName(currMethod);	

		if ([NSStringFromSelector(sel) hasPrefix:prefix]) {
			DC_LOG(@"\tStep method found %@ %@", NSStringFromClass(class), NSStringFromSelector(sel));
			SIClassSelector * classSelector = [[SIClassSelector alloc] init];
			classSelector.selector = sel;
			classSelector.class = class;
			[array addObject:classSelector];
			[classSelector release];
		}
	}
}

@end
