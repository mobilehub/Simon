//
//  SIClassSelector.h
//  Simon
//
//  Created by Derek Clarkson on 6/19/11.
//  Copyright 2011 Sensis. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Used to store a cross reference between a step mapping method and the class that contains it.
 */
@interface SIStepMapping : NSObject {
	@private
	NSRegularExpression *regex;
	SEL selector;
	Class targetClass;
	BOOL executed;
	NSString *command;
}

@property (nonatomic, retain) NSRegularExpression *regex;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, assign) Class targetClass;
@property (nonatomic, assign, readonly) BOOL executed;
@property (nonatomic, retain) NSString *command;

+(SIStepMapping *) stepMappingWithClass:(Class) theClass selector:(SEL) aSelector regex:(NSString *) theRegex error:(NSError **) error;
-(BOOL) canMapToStep:(NSString *) step;
-(BOOL) invokeWithObject:(id) object error:(NSError **) error;

@end
