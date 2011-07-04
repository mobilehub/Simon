//
//  Story.h
//  Simon
//
//  Created by Derek Clarkson on 5/30/11.
//  Copyright 2011 Sensis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SIEnums.h"
#import "SIStep.h"

/**
 The story is the heart of BDD. This class encapsulates the information for one specific story. It stores a list of the steps that 
 the story has and also provides functionality for communicating between steps. SISteps can map to a single class or several classes which means you can have a clean seperation between step methods that are specific to you story and methods that are more generic. Because the classes which contain the step methods are actually instantiated, it amkes it possible to pass values from one step method to another by using a class property. However SIStory also provides methods that access a story based object cache so it's possible to pass objects between methods on completely different classes.
 
 When a SIStoryRunner executes a story, it sources a list of SIStepMapping instances from the SIRuntime class. it then passes these to the story and:
 
 - Loops through each SIStep and passes it the list of mappings to see if any match.
 - If all steps are mapped, then loop through again:
	- Checks a local cache to see if we have an instance of the class that has been mapped to the step. If not creates one and stores it.
	- Passes the instance of the mapping class to the step and asks it to invoke the step method on it.
 - Returns the fial status to the SIStoryRunner.
 
 
 Steps implementations which have been mapped by the SIStepMapping class
 can come from more than just one class. Therefore this class also provides a cache in which you can store objects which you want to use across more than one instance.
 */
@interface SIStory : NSObject {
	@private
	NSMutableArray *steps;
	NSMutableDictionary *instanceCache;
	NSMutableDictionary *storyCache;
	SIStoryStatus status;
	NSError *error;
	NSString *title;
}

/// @name Properties

/**
 This array stores references to the SIStep objects that represent the steps of the story.
 */
@property (nonatomic, readonly) NSArray * steps;

/**
 Gives the final status of the story after all steps have been run. Also may contains statuss that indicate that a story was not run. For example
 if one or more steps where not mapped.
 */
@property (nonatomic, readonly) SIStoryStatus status;

/**
 This error instance is initially `nil`. it is set if there is an error ecountered or if any error is returned from a SIStep.
 */
@property (nonatomic, readonly) NSError *error;

/**
 This is the title of the story as read from the story file. It contains all the text after the "Story" keword.
 */
@property (nonatomic, retain) NSString *title;

/// @name Steps

/**
 Adds a new SIStep to the steps array with the passed keyword and command.
 
 @param keyword a value from the SIkeyword enum which designates the keyword type at the start of the command.
 @param theCommand the full text (including keyword) of the step line.
 @return a new SIStep instance.
 @return the newly created SIStep instance.
 */
-(SIStep *) newStepWithKeyword:(SIKeyword) keyword command:(NSString *) theCommand;

/**
 Returns the SIStep at the specified index. 
 
 @param index the integer index to the step you want. The first step will be stored under index 0.
 @return the SIStep instance. 
 */
-(SIStep *) stepAtIndex:(NSUInteger) index;

/**
 Called during the mapping process. Loops through each SIStep in the steps array and passes it the mappings so the step can try and match against them.
 
 @param mappings an instance of NSArray containing all the known SIStepMappings.
 */
-(void) mapSteps:(NSArray *) mappings;

/// @name Executing

/**
 Invokes the story. In turn, tells each SIStep in the steps array to invoke using the [SIStep invokeWithObject:error:] method.
 Before invoking, it first retrieves or creates a matching instance of the [SIStepMapping targetClass] and stores it in the instanceCache. This cache is used only for storying references to classes that contain implementations of steps.
 */
-(BOOL) invoke;

/// @name Data access

/**
 Stores a value in the story. Because this is stored in the story rather than an instance of a class that has step methods, it is available to all classes that are instantiated as part of running it. Store data here if you wish to save and retrieve it across a number of classes. 
 
 @param object the oject ou want to store.
 @param key the key you want it stored under. Given this is for accessing something rom another class, make sure the key is something that works across both. Strings are probably best.
 */
-(void) storeObject:(id) object withKey:(id) key;

/**
 Retrieves a value from the story. 
 
 @see store:withKey:
 @param key the key that the value you want has been previously stored under. 
 @return the value or `nil` if the value was not found.
 */
-(id) retrieveObjectWithKey:(id) key;

@end
