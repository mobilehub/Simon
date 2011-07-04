//
//  SIRuntime.h
//  Simon
//
//  Created by Derek Clarkson on 6/20/11.
//  Copyright 2011 Sensis. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 This class provides the SIStepMappings that provide the methods that are mapped to the stories. These are mapped using the SIMapStepToSelector(regex, selector) macro.
 */
@interface SIRuntime : NSObject {
	@private
}

/// @name Mappings

/**
 Returns an NSArray of the SIStepMappings that are found. This is done by scanning all the classes in the application bundle and looking for methods created by the SIMapStepToSelector macros.
 */
-(NSArray *) allMappingMethodsInRuntime;

@end
