//
//  SIClassSelector.h
//  Simon
//
//  Created by Derek Clarkson on 6/19/11.
//  Copyright 2011 Sensis. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Used to store a cross reference between a step mapping method and the class that contains it. The mapping is tested by using a regular expression. If the text of a step is matched by this regular expression, then the SIStepMapping instance is mapped to the step. Any given SIStep can only map to a single SIStepMapping. but a SIStepMapping instance can execute with data from any number of steps from any number of stories. This provides a way to centralise the code across multiple stories.
 */
@interface SIStepMapping : NSObject {
	@private
	NSRegularExpression *regex;
	SEL selector;
	Class targetClass;
	BOOL executed;
	NSString *command;
}

/// @name Properties

/**
 The regular expression object used to test each mapping. 
 */
@property (nonatomic, retain) NSRegularExpression *regex;

/**
 I the SIStepMapping matches via the regex, this is the selector that will be executed.
 */
@property (nonatomic, assign) SEL selector;

/**
 This is the target class that contains the selector to be executed. This class will be instantiated just once for each story that is executed.
 */
@property (nonatomic, assign) Class targetClass;

/**
 Indicates whether the maping was exexcuted. Mainly used for reporting mappings that are not being used. Returns `YES` if the mapping was executed at least once.
 */
@property (nonatomic, assign, readonly) BOOL executed;

/**
 This is the entire text of the step as read from the story file. This is populated by the story when it executes the steps just before invokeWithObject:error: is called.
 */
@property (nonatomic, retain) NSString *command;

/// @name Initialisers

/**
 Factory method for creating an instance of the mapping. 
 
 @param theClass the class that the mapping applies to.
 @param aSelector the selector to be executed.
 @param theRegex the regular expression used to match the text from a step.
 @param error a pointer to a reference to an NSError. This is populated if there is an error.
 @return the newly created, autoreleased instance.
 */
+(SIStepMapping *) stepMappingWithClass:(Class) theClass selector:(SEL) aSelector regex:(NSString *) theRegex error:(NSError **) error;

/**
 Checks whether this instance can be applied to the passed SIStep. This executes the regular expression against the step and return whether it matched.
 
 @param step the step to check.
 @return `YES` if the regular expression matches. `NO` otherwise.
 */
-(BOOL) canMapToStep:(NSString *) step;

/**
 Called by the SIStep to invoke the implementaton that is mapped to the step.
 
 @param object the instantiated targetClass which contains the implementation code.
 @param error a pointer to a reference to an NSError that will be populated if there is a problem.
 @return `YES` if the invocation was successful. `NO` if there was an error.
 */
-(BOOL) invokeWithObject:(id) object error:(NSError **) error;

@end
