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
	Class class;
	BOOL executed;
	NSString *command;
	id target;
}

@property (nonatomic, retain) NSRegularExpression *regex;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, assign) Class class;
@property (nonatomic, assign, readonly) BOOL executed;
@property (nonatomic, retain) NSString *command;
@property (nonatomic, retain) id target;

+(SIStepMapping *) stepMappingWithClass:(Class) theClass selector:(SEL) aSelector regex:(NSString *) theRegex error:(NSError **) error;
-(BOOL) canMapToStep:(NSString *) step;
-(BOOL) invoke:(NSError **) error;

@end
