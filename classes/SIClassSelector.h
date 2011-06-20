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
@interface SIClassSelector : NSObject {
	@private
	SEL selector;
	Class class;
}

@property (nonatomic, assign) SEL selector;
@property (nonatomic, assign) Class class;

@end
