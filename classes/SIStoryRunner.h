//
//  StoryRunner.h
//  Simon
//
//  Created by Derek Clarkson on 6/17/11.
//  Copyright 2011 Sensis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SIStoryFileReader.h"
#import "SIRuntime.h"
#import "SIStoryReporter.h"

/**
 SIStoryRunner is the main class used to run stories. It makes use of a SIStoryFileReader to locate and read in the stories to run, and an instance of a SIRuntime instance to which is used to locate the SIStepMapping instances which provide implmentations for the story steps. Finally it uses a SIStoryReporter instance to provide a report on the results of the run.
 */
@interface SIStoryRunner : NSObject {
	@private 
	SIStoryFileReader * reader;
	SIRuntime *runtime;
	NSObject<SIStoryReporter> * reporter;
}

/// @name Properties

/**
 The reader to source stories from.
 */
@property (retain, nonatomic) SIStoryFileReader * reader;

/**
 The runtime to source mappings from. This is read only.
 */
@property (retain, readonly, nonatomic) SIRuntime *runtime;

/**
 The NSObject<SIStoryReporter> instance which will report on the run. If `nil`, (the default) then no reporting is done. In other words to get a report a reporter must be set explicitly.
 */
@property (retain, nonatomic) NSObject<SIStoryReporter> * reporter;

/// @name Stories

/**
 Executes the stories. See SIStory for details on hwo this happens.
 
 @see SIStory
 @param error a pointer to a reference which is populated with a NSError instance if there is an error.
 @return `YES` if the run was successful. `NO` if an error occured. Unmapped stories or steps are not considered an error.
 */
-(BOOL) runStories:(NSError **) error;

@end
