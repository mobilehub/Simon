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
}

@property (nonatomic, retain, readonly) NSRegularExpression *regex;
@property (nonatomic, assign, readonly) SEL selector;
@property (nonatomic, assign, readonly) Class class;
@property (nonatomic, assign, readonly) BOOL executed;

-(id) initWithClass:(Class) theClass selector:(SEL) aSelector regex:(NSString *) theRegex;

@end
