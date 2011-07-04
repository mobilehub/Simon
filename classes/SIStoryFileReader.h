//
//  FileSystemStoryReader.h
//  Simon
//
//  Created by Derek Clarkson on 5/30/11.
//  Copyright 2011 Sensis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SIStory.h"

/**
 This class is used to read story files from the application. Each file must has the extension *.story*.
 */
@interface SIStoryFileReader : NSObject {
	@private
	NSArray * files;
	NSMutableArray *stories;
	SIStory *story;
	NSCharacterSet *trimChars;
}

/// @name Properties

/**
 List of the files found in the file system which will be processed to produce stories. Multi stories can be stored in any given file.
 */
@property (retain, nonatomic) NSArray * files;

/// @name Initialisation

/**
 Used to load tests from just one file out of many.
 
 @param fileName the name of the file without the extension.
 */
-(id) initWithFileName:(NSString *) fileName;

// @name Stories

/**
 Reads the files and returns a list of SIStory objects.
 
 @param error a pointer to a reference where any errors will be stored.
 */
-(NSArray *) readStories:(NSError **) error;

@end
